import 'package:flutter/foundation.dart';
import 'package:looklabs/Core/Network/api_error_handler.dart';
import 'package:looklabs/Core/Network/models/onboarding_flow_response.dart';
import 'package:looklabs/Repository/domain_questions_repository.dart';

/// ViewModel for domain question screen. Loads questions and submits answers via API.
class DomainQuestionViewModel extends ChangeNotifier {
  DomainQuestionViewModel({required this.domain});

  final String domain;
  bool _disposed = false;

  List<FlowQuestion> _questions = [];
  bool _loading = false;
  String? _error;

  bool _submitting = false;
  String? _submitError;

  bool get submitting => _submitting;
  String? get submitError => _submitError;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  void _notifyIfNotDisposed() {
    if (!_disposed) notifyListeners();
  }

  List<FlowQuestion> get questions => List.unmodifiable(_questions);
  bool get loading => _loading;
  String? get error => _error;
  bool get hasQuestions => _questions.isNotEmpty;

  /// Current step index for stepper (0-based). Used for Next/Complete flow like onboarding.
  int _currentStepIndex = 0;
  int get currentStepIndex => _currentStepIndex;

  List<String> get stepLabels {
    return steps.map((s) => _stepLabel(s.step)).toList();
  }

  static String _stepLabel(String step) {
    if (step.isEmpty || step == 'default') return 'Step';
    final lower = step.toLowerCase().replaceAll('_', ' ');
    if (lower.length <= 1) return step.toUpperCase();
    return '${lower[0].toUpperCase()}${lower.substring(1)}';
  }

  /// Questions for the current step only (for stepper UI).
  List<FlowQuestion> get currentStepQuestions {
    final s = steps;
    if (s.isEmpty || _currentStepIndex < 0 || _currentStepIndex >= s.length) {
      return [];
    }
    return s[_currentStepIndex].questions;
  }

  /// Title for the current step (for app bar / header).
  String get currentStepTitle {
    final s = steps;
    if (s.isEmpty || _currentStepIndex >= s.length) return '';
    return _stepLabel(s[_currentStepIndex].step);
  }

  /// True if we're on the last step (show Complete instead of Next).
  bool get isLastStep {
    final s = steps;
    return s.isEmpty || _currentStepIndex >= s.length - 1;
  }

  /// True if all questions in the current step are answered.
  bool get isCurrentStepComplete {
    for (final q in currentStepQuestions) {
      if (q.type == 'text' || q.type == 'number' || q.type == 'numeric') {
        final v = _flowTextAnswers[q.id]?.trim() ?? '';
        if (v.isEmpty) return false;
      } else if (q.type == 'multi_choice' || q.type == 'multi-choice') {
        final list = _flowMultiAnswers[q.id];
        if (list == null || list.isEmpty) return false;
      } else {
        if (!_flowAnswers.containsKey(q.id)) return false;
      }
    }
    return true;
  }

  void nextStep() {
    if (_currentStepIndex < steps.length - 1) {
      _currentStepIndex++;
      _notifyIfNotDisposed();
    }
  }

  /// Questions grouped by step (same structure as onboarding). Steps keep API order.
  List<FlowStepItem> get steps {
    if (_questions.isEmpty) return [];
    final map = <String, List<FlowQuestion>>{};
    for (final q in _questions) {
      final key = q.step.trim().isEmpty ? 'default' : q.step;
      map.putIfAbsent(key, () => []).add(q);
    }
    // Preserve order of first occurrence of each step
    final order = <String>[];
    for (final q in _questions) {
      final key = q.step.trim().isEmpty ? 'default' : q.step;
      if (!order.contains(key)) order.add(key);
    }
    return order
        .map((step) => FlowStepItem(step: step, questions: map[step] ?? []))
        .toList();
  }

  final Map<int, int> _flowAnswers = {};
  final Map<int, String> _flowTextAnswers = {};
  final Map<int, List<int>> _flowMultiAnswers = {};

  void setFlowTextAnswer(int questionId, String value) {
    _flowTextAnswers[questionId] = value;
    _notifyIfNotDisposed();
  }

  /// Parse stored height answer "current,desired" into (currentCm, desiredCm).
  (int?, int?) getFlowHeightValues(int questionId) {
    final s = _flowTextAnswers[questionId]?.trim() ?? '';
    if (s.isEmpty) return (null, null);
    final parts = s.split(',');
    if (parts.length < 2) return (null, null);
    final c = int.tryParse(parts[0].trim());
    final d = int.tryParse(parts[1].trim());
    return (c, d);
  }

  void setFlowHeightAnswer(int questionId, int currentCm, int desiredCm) {
    _flowTextAnswers[questionId] = '$currentCm,$desiredCm';
    _notifyIfNotDisposed();
  }

  void selectFlowOption(int questionId, int optionIndex) {
    _flowAnswers[questionId] = optionIndex;
    _notifyIfNotDisposed();
  }

  bool isFlowOptionSelected(int questionId, int optionIndex) {
    return _flowAnswers[questionId] == optionIndex;
  }

  void toggleFlowMultiOption(int questionId, int optionIndex) {
    final list = _flowMultiAnswers.putIfAbsent(questionId, () => []);
    if (list.contains(optionIndex)) {
      list.remove(optionIndex);
    } else {
      list.add(optionIndex);
    }
    _notifyIfNotDisposed();
  }

  bool isFlowMultiOptionSelected(int questionId, int optionIndex) {
    return _flowMultiAnswers[questionId]?.contains(optionIndex) ?? false;
  }

  Future<void> loadQuestions() async {
    if (_loading) return;
    _loading = true;
    _error = null;
    _notifyIfNotDisposed();

    final response = await DomainQuestionsRepository.instance
        .getDomainQuestions(domain);

    if (_disposed) return;

    _loading = false;

    if (response.success && response.data is List) {
      _questions = List<FlowQuestion>.from(response.data as List);
      _currentStepIndex = 0;
      _error = null;
    } else {
      _questions = [];
      _error = response.userMessageOrFallback('Could not load questions');
    }
    _notifyIfNotDisposed();
  }

  bool get allAnswered {
    for (final q in _questions) {
      if (q.type == 'text' || q.type == 'number' || q.type == 'numeric') {
        final v = _flowTextAnswers[q.id]?.trim() ?? '';
        if (v.isEmpty) return false;
      } else if (q.type == 'multi_choice' || q.type == 'multi-choice') {
        final list = _flowMultiAnswers[q.id];
        if (list == null || list.isEmpty) return false;
      } else {
        if (!_flowAnswers.containsKey(q.id)) return false;
      }
    }
    return true;
  }

  /// Builds API payload for each answered question (choice → option text, multi → comma-separated, text/number → value).
  List<DomainAnswerPayload> _buildAnswerPayloads() {
    final list = <DomainAnswerPayload>[];
    for (final q in _questions) {
      final String answer;
      if (q.type == 'text' || q.type == 'number' || q.type == 'numeric') {
        answer = _flowTextAnswers[q.id]?.trim() ?? '';
      } else if (q.type == 'multi_choice' || q.type == 'multi-choice') {
        final indices = _flowMultiAnswers[q.id];
        if (indices == null || indices.isEmpty) continue;
        final options = q.optionsAsStrings;
        answer = indices
            .map((i) => i < options.length ? options[i] : '')
            .where((s) => s.isNotEmpty)
            .join(', ');
      } else {
        final idx = _flowAnswers[q.id];
        if (idx == null) continue;
        final options = q.optionsAsStrings;
        answer = idx < options.length ? options[idx] : idx.toString();
      }
      if (answer.isEmpty) continue;
      list.add(DomainAnswerPayload(questionId: q.id, answer: answer));
    }
    return list;
  }

  Future<(bool success, Map<String, dynamic>? responseData)>
  submitAnswers() async {
    if (_submitting || _disposed) return (false, null);
    if (!allAnswered) return (false, null);

    final payloads = _buildAnswerPayloads();
    if (payloads.length != _questions.length) return (false, null);

    _submitting = true;
    _submitError = null;
    _notifyIfNotDisposed();

    final response = await DomainQuestionsRepository.instance
        .submitDomainAnswers(domain, payloads);

    if (_disposed) return (false, null);

    _submitting = false;
    if (response.success) {
      _submitError = null;
      _notifyIfNotDisposed();
      final data = response.data is Map
          ? Map<String, dynamic>.from(response.data as Map)
          : null;
      return (true, data);
    }
    _submitError = response.userMessageOrFallback('Failed to submit answers');
    _notifyIfNotDisposed();
    return (false, null);
  }
}
