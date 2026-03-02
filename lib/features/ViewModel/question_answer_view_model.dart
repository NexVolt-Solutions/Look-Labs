import 'package:flutter/material.dart';
import 'package:looklabs/Core/Network/models/onboarding_flow_response.dart';
import 'package:looklabs/Repository/auth_repository.dart';
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

  /// When backend returns a "steps" list, we cache by step name so Next/Back don't need more API calls.
  final Map<String, List<FlowQuestion>> _stepsCache = {};

  bool get hasFlowQuestions => currentStepQuestions.isNotEmpty;
  FlowProgress? get flowProgress => flowResponse?.progress;

  /// Set when user completed the last step and we navigated to Goal. Avoids showing Planning again if they re-enter the flow.
  bool onboardingComplete = false;

  /// Complete = we're on the last step (Planning); button shows "Complete" and navigates.
  bool get isFlowComplete => currentStepIndex >= flowStepperLabels.length - 1;

  void markOnboardingComplete() {
    onboardingComplete = true;
    notifyListeners();
  }

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
    if (isLoadingFlow) return;

    final sessionId = OnboardingRepository.sessionId;
    if (sessionId == null || sessionId.isEmpty) {
      flowError = 'No session';
      _flowLoadedOnce = true;
      currentStepQuestions = [];
      notifyListeners();
      return;
    }

    final step = flowStep;

    // Use cached questions when we already have them (e.g. from GET onboarding/questions)
    if (_stepsCache.containsKey(step)) {
      _flowLoadedOnce = true;
      currentStepQuestions = _stepsCache[step]!;
      flowError = currentStepQuestions.isEmpty
          ? 'No questions for this step'
          : null;
      notifyListeners();
      return;
    }

    isLoadingFlow = true;
    flowError = null;
    notifyListeners();

    final repo = OnboardingRepository.instance;

    // Prefer new API: GET onboarding/questions (all steps in one call)
    final questionsResponse = await repo.getOnboardingQuestions(
      sessionId: sessionId,
    );
    if (questionsResponse.success &&
        questionsResponse.data is OnboardingFlowResponse) {
      final flow = questionsResponse.data as OnboardingFlowResponse;
      flowResponse = flow;
      if (flow.steps != null && flow.steps!.isNotEmpty) {
        for (final s in flow.steps!) {
          if (s.step.isNotEmpty) {
            _stepsCache[s.step] = s.questions;
          }
        }
        final cached = _stepsCache[step];
        _flowLoadedOnce = true;
        isLoadingFlow = false;
        currentStepQuestions = cached ?? [];
        flowError = currentStepQuestions.isEmpty
            ? 'No questions for this step'
            : null;
        notifyListeners();
        return;
      }
      // Backend returned top-level "questions" array (no "steps") – treat as profile_setup
      if (flow.questions != null && flow.questions!.isNotEmpty) {
        _stepsCache['profile_setup'] = flow.questions!;
        final cached = _stepsCache[step];
        _flowLoadedOnce = true;
        isLoadingFlow = false;
        currentStepQuestions = cached ?? [];
        flowError = currentStepQuestions.isEmpty
            ? 'No questions for this step'
            : null;
        notifyListeners();
        return;
      }
    }

    _flowLoadedOnce = true;
    isLoadingFlow = false;
    flowError = _extractFlowLoadError(questionsResponse);
    currentStepQuestions = [];
    flowResponse = null;
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
        step: flowStep,
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

    // If this was profile_setup, try to sync name/age/gender to user profile (when logged in).
    if (flowStep == 'profile_setup') {
      _syncProfileSetupToUser();
    }
    return true;
  }

  /// Build profile payload from profile_setup answers and PATCH users/me (no-op if not logged in).
  void _syncProfileSetupToUser() {
    final payload = <String, dynamic>{};
    final qLower = (String s) => s.toLowerCase();
    for (final q in currentStepQuestions) {
      final question = q.question;
      if (qLower(question).contains('name') && (q.type == 'text' || q.type == 'number')) {
        final v = flowTextAnswers[q.id]?.trim();
        if (v != null && v.isNotEmpty) payload['name'] = v;
      } else if (qLower(question).contains('age') && (q.type == 'text' || q.type == 'number')) {
        final v = flowTextAnswers[q.id]?.trim();
        if (v != null && v.isNotEmpty) {
          final n = int.tryParse(v);
          if (n != null) payload['age'] = n;
        }
      } else if (qLower(question).contains('gender') && q.type == 'choice') {
        if (flowAnswers.containsKey(q.id)) {
          final idx = flowAnswers[q.id]!;
          final opts = q.optionsAsStrings;
          if (idx >= 0 && idx < opts.length) payload['gender'] = opts[idx];
        }
      }
    }
    if (payload.isEmpty) return;
    AuthRepository.instance.updateProfile(payload);
  }

  /// Extract user-facing error when GET flow fails (e.g. 500 server error).
  String _extractFlowLoadError(dynamic response) {
    final msg = response.message?.toString().trim();
    if (msg != null && msg.isNotEmpty) return msg;
    final data = response.data;
    if (data is Map<String, dynamic>) {
      final apiMsg = data['message']?.toString().trim();
      if (apiMsg != null && apiMsg.isNotEmpty) return apiMsg;
      final detail = data['detail']?.toString().trim();
      if (detail != null && detail.isNotEmpty) return detail;
    }
    return response.statusCode >= 500
        ? 'Server error. Please try again in a moment.'
        : 'Failed to load questions. Please try again.';
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
