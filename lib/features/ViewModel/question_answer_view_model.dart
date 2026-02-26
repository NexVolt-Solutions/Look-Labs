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

  /// True when every question on the current step has a valid answer (required for Next/Complete).
  bool get isCurrentStepComplete {
    for (final q in currentStepQuestions) {
      if (q.type == 'text' || q.type == 'number') {
        if (flowTextAnswers[q.id]?.trim().isEmpty ?? true) return false;
      } else if (q.type == 'multi_choice') {
        final selected = flowMultiAnswers[q.id];
        if (selected == null || selected.isEmpty) return false;
      } else {
        if (!flowAnswers.containsKey(q.id)) return false;
      }
    }
    return true;
  }

  /// Flow API: questionId -> selected option index (single choice)
  final Map<int, int> flowAnswers = {};

  /// questionId -> answer text (for type text or number)
  final Map<int, String> flowTextAnswers = {};

  /// questionId -> list of selected option indices (multi_choice)
  final Map<int, List<int>> flowMultiAnswers = {};

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
    final list = <FlowQuestion>[];
    final seenIds = <int>{};
    int stepTotal = 15;
    const int maxCalls = 15;

    void addIfNew(FlowQuestion? q) {
      if (q == null || seenIds.contains(q.id)) return;
      if (q.step.isNotEmpty && q.step != step) return;
      seenIds.add(q.id);
      list.add(q);
    }

    for (int index = 0; index < maxCalls; index++) {
      final response = await repo.getFlow(
        sessionId: sessionId,
        step: step,
        index: index,
      );

      if (!response.success || response.data is! OnboardingFlowResponse) {
        if (list.isEmpty) {
          _flowLoadedOnce = true;
          isLoadingFlow = false;
          flowError = response.message ?? 'Failed to load questions';
          currentStepQuestions = [];
          flowResponse = null;
          notifyListeners();
        }
        break;
      }

      final flow = response.data as OnboardingFlowResponse;
      flowResponse = flow;

      if (flow.progress != null) {
        stepTotal = flow.progress!.totalQuestions;
        final section = flow.progress!.progress?.sections?[step];
        if (section is Map && section['total'] != null) {
          stepTotal = (section['total'] as num).toInt();
        }
      }

      final before = list.length;
      addIfNew(flow.current);
      addIfNew(flow.next);

      if (list.length >= stepTotal) break;
      if (list.length == before && index > 0) break;
    }

    _flowLoadedOnce = true;
    isLoadingFlow = false;
    currentStepQuestions = list;
    flowError = list.isEmpty ? 'No questions for this step' : null;
    notifyListeners();
  }

  /// Submit all answers for the current step to the API. Call before Next/Complete.
  /// Returns true if all submissions succeeded.
  Future<bool> submitCurrentStepAnswers() async {
    final sessionId = OnboardingRepository.sessionId;
    if (sessionId == null || sessionId.isEmpty) return false;

    isLoadingFlow = true;
    flowError = null;
    notifyListeners();

    final repo = OnboardingRepository.instance;
    for (final q in currentStepQuestions) {
      final body = _buildAnswerBody(q);
      if (body == null) continue;
      final response = await repo.submitAnswer(
        sessionId: sessionId,
        questionId: body['question_id'] as int,
        answer: body['answer'],
        questionType: body['question_type'] as String,
        questionOptions: body['question_options'] as List<dynamic>?,
        constraints: body['constraints'] as Map<String, dynamic>?,
      );
      if (!response.success) {
        isLoadingFlow = false;
        flowError = _extractSubmitError(response);
        notifyListeners();
        return false;
      }
      if (response.data is OnboardingFlowResponse) {
        flowResponse = response.data as OnboardingFlowResponse;
      }
    }
    isLoadingFlow = false;
    flowError = null;
    notifyListeners();
    return true;
  }

  /// Extract user-facing error from submit answer API response (e.g. 422 validation).
  String _extractSubmitError(dynamic response) {
    final data = response.data;
    if (data is Map<String, dynamic>) {
      final errors = data['errors'];
      if (errors is List && errors.isNotEmpty && errors.first is Map) {
        final first = errors.first as Map;
        final msg = first['message']?.toString();
        if (msg != null && msg.isNotEmpty) return msg;
      }
      final detail = data['detail']?.toString();
      if (detail != null && detail.isNotEmpty) return detail;
    }
    return response.message ?? 'Failed to submit answers. Please try again.';
  }

  Map<String, dynamic>? _buildAnswerBody(FlowQuestion q) {
    final questionType = q.type == 'number' ? 'numeric' : q.type;
    if (q.type == 'text' || q.type == 'number') {
      final text = flowTextAnswers[q.id]?.trim();
      if (text == null || text.isEmpty) return null;
      final answer = q.type == 'number' ? (num.tryParse(text) ?? 0) : text;
      return {
        'question_id': q.id,
        'answer': answer,
        'question_type': questionType,
        'question_options': null,
        'constraints': q.constraints,
      };
    }
    if (q.type == 'multi_choice') {
      final selected = flowMultiAnswers[q.id];
      if (selected == null || selected.isEmpty) return null;
      final optionStrings = q.optionsAsStrings;
      final answerList = selected
          .where((i) => i >= 0 && i < optionStrings.length)
          .map((i) => optionStrings[i])
          .toList();
      if (answerList.isEmpty) return null;
      return {
        'question_id': q.id,
        'answer': answerList,
        'question_type': questionType,
        'question_options': q.options,
        'constraints': q.constraints,
      };
    }
    if (!flowAnswers.containsKey(q.id)) return null;
    final optionIndex = flowAnswers[q.id]!;
    final optionStrings = q.optionsAsStrings;
    if (optionIndex < 0 || optionIndex >= optionStrings.length) return null;
    final answerText = optionStrings[optionIndex];
    return {
      'question_id': q.id,
      'answer': answerText,
      'question_type': questionType,
      'question_options': q.options,
      'constraints': q.constraints,
    };
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

  void setFlowTextAnswer(int questionId, String value) {
    flowTextAnswers[questionId] = value;
    notifyListeners();
  }

  void toggleFlowMultiOption(int questionId, int optionIndex) {
    final list = flowMultiAnswers.putIfAbsent(questionId, () => []);
    if (list.contains(optionIndex)) {
      list.remove(optionIndex);
    } else {
      list.add(optionIndex);
    }
    notifyListeners();
  }

  bool isFlowMultiOptionSelected(int questionId, int optionIndex) {
    return flowMultiAnswers[questionId]?.contains(optionIndex) ?? false;
  }
}
