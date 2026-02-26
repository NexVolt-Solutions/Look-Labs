import 'package:flutter/material.dart';
import 'package:looklabs/Core/Network/models/onboarding_flow_response.dart';
import 'package:looklabs/Repository/onboarding_repository.dart';

class QuestionAnswerViewModel extends ChangeNotifier {
  /// Which section we're on: 0=Profile, 1=LifeStyle, 2=Goals, 3=Motivations, 4=Planning
  int currentStepIndex = 0;

  /// All questions for the current step (loaded when entering that step)
  List<FlowQuestion> currentStepQuestions = [];

  OnboardingFlowResponse? flowResponse;
  bool isLoadingFlow = false;
  String? flowError;
  bool _flowLoadedOnce = false;

  bool get flowLoadAttempted => _flowLoadedOnce;
  bool get hasFlowQuestions => currentStepQuestions.isNotEmpty;
  FlowProgress? get flowProgress => flowResponse?.progress;

  /// Complete = we're on the last step (Planning); button shows "Complete" and navigates.
  bool get isFlowComplete => currentStepIndex >= flowStepperLabels.length - 1;

  /// Flow API: questionId -> selected option index
  final Map<int, int> flowAnswers = {};

  static const List<String> flowStepperLabels = [
    'Profile',
    'LifeStyle',
    'Goals',
    'Motivations',
    'Planning',
  ];

  static const List<String> flowStepKeys = [
    'profile_setup',
    'daily_lifestyle',
    'goals_focus',
    'motivation',
    'experience_planning',
  ];

  String get flowStep =>
      flowStepKeys[currentStepIndex.clamp(0, flowStepKeys.length - 1)];

  int get flowStepperIndex => currentStepIndex;

  String get flowStepTitle {
    if (currentStepIndex < 0 || currentStepIndex >= flowStepKeys.length) {
      return 'Onboarding';
    }
    const titles = {
      'profile_setup': 'Profile Setup',
      'daily_lifestyle': 'Daily Lifestyle',
      'goals_focus': 'Goals & Focus',
      'motivation': 'Motivation',
      'experience_planning': 'Planning',
    };
    return titles[flowStepKeys[currentStepIndex]] ?? 'Onboarding';
  }

  /// Load questions for the current step. Calls the flow API once (step + index=0).
  /// The backend returns one "current" (and optionally "next") per call; we do not loop
  /// to avoid infinite requests and rate limiting (429).
  Future<void> loadAllQuestionsForCurrentStep() async {
    final sessionId = OnboardingRepository.sessionId;
    if (sessionId == null || sessionId.isEmpty) {
      flowError = 'No session';
      _flowLoadedOnce = true;
      currentStepQuestions = [];
      notifyListeners();
      return;
    }

    final step = flowStep;
    isLoadingFlow = true;
    flowError = null;
    notifyListeners();

    final repo = OnboardingRepository.instance;
    final response = await repo.getFlow(
      sessionId: sessionId,
      step: step,
      index: 0,
    );

    _flowLoadedOnce = true;
    isLoadingFlow = false;

    if (!response.success || response.data is! OnboardingFlowResponse) {
      flowError = response.message ?? 'Failed to load questions';
      currentStepQuestions = [];
      flowResponse = null;
      notifyListeners();
      return;
    }

    final flow = response.data as OnboardingFlowResponse;
    flowResponse = flow;

    final list = <FlowQuestion>[];
    final seenIds = <int>{};
    void addIfNew(FlowQuestion? q) {
      if (q == null || q.step != step || seenIds.contains(q.id)) return;
      seenIds.add(q.id);
      list.add(q);
    }
    addIfNew(flow.current);
    addIfNew(flow.next);

    currentStepQuestions = list;
    flowError = list.isEmpty ? 'No questions for this step' : null;
    notifyListeners();
  }

  /// Go to next step (e.g. Profile → LifeStyle). Loads all questions for the new step.
  Future<void> nextStep() async {
    if (currentStepIndex >= flowStepperLabels.length - 1) {
      return; // Already on last step; caller should navigate.
    }
    currentStepIndex++;
    await loadAllQuestionsForCurrentStep();
  }

  /// Go back to previous step.
  Future<void> backStep() async {
    if (currentStepIndex <= 0) return;
    currentStepIndex--;
    await loadAllQuestionsForCurrentStep();
  }

  void selectFlowOption(int questionId, int optionIndex) {
    flowAnswers[questionId] = optionIndex;
    notifyListeners();
  }

  bool isFlowOptionSelected(int questionId, int optionIndex) {
    return flowAnswers[questionId] == optionIndex;
  }
}
