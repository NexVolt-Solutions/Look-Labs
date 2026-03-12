import 'package:flutter/foundation.dart';
import 'package:looklabs/Core/Network/api_error_handler.dart';
import 'package:looklabs/Core/Network/models/domain_answers_response.dart';
import 'package:looklabs/Core/Network/models/onboarding_flow_response.dart';
import 'package:looklabs/Repository/domain_questions_repository.dart';

/// ViewModel for domain question screen. Step-by-step flow: one question at a time,
/// submit each answer to API, use response.current as next question.
class DomainQuestionViewModel extends ChangeNotifier {
  DomainQuestionViewModel({required this.domain});

  final String domain;
  bool _disposed = false;

  /// Current question to show (from API: initial from GET, then from POST response.current).
  FlowQuestion? _currentQuestion;
  DomainProgressInfo? _progress;

  /// Total question count from initial load (for stepper before progress is available).
  int _totalQuestionCount = 0;
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

  FlowQuestion? get currentQuestion => _currentQuestion;
  DomainProgressInfo? get progress => _progress;
  bool get loading => _loading;
  String? get error => _error;
  bool get hasQuestion => _currentQuestion != null;

  /// For compatibility with DomainFlowQuestionContent – single question as list.
  List<FlowQuestion> get currentStepQuestions {
    final q = _currentQuestion;
    return q != null ? [q] : [];
  }

  /// Step title from current question.
  String get currentStepTitle {
    final q = _currentQuestion;
    if (q == null || q.step.isEmpty) return '';
    final lower = q.step.toLowerCase().replaceAll('_', ' ');
    if (lower.length <= 1) return q.step.toUpperCase();
    return '${lower[0].toUpperCase()}${lower.substring(1)}';
  }

  /// Progress percent (0–100) for stepper/indicator.
  double get progressPercent => _progress?.progressPercent ?? 0;

  /// Total questions for progress display.
  int get totalQuestions => _progress?.total ?? _totalQuestionCount;

  /// Answered count for progress display.
  int get answeredCount => _progress?.answered ?? 0;

  /// True if current question is fully answered.
  bool get isCurrentStepComplete {
    final q = _currentQuestion;
    if (q == null) return false;
    if (q.type == 'text' || q.type == 'number' || q.type == 'numeric') {
      final v = _flowTextAnswers[q.id]?.trim() ?? '';
      return v.isNotEmpty;
    }
    if (q.type == 'multi_choice' || q.type == 'multi-choice') {
      final list = _flowMultiAnswers[q.id];
      return list != null && list.isNotEmpty;
    }
    return _flowAnswers.containsKey(q.id);
  }

  final Map<int, int> _flowAnswers = {};
  final Map<int, String> _flowTextAnswers = {};
  final Map<int, List<int>> _flowMultiAnswers = {};

  void setFlowTextAnswer(int questionId, String value) {
    _flowTextAnswers[questionId] = value;
    _notifyIfNotDisposed();
  }

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

  /// Build answer string for current question (for API submit).
  String? _buildAnswerForQuestion(FlowQuestion q) {
    if (q.type == 'text' || q.type == 'number' || q.type == 'numeric') {
      return _flowTextAnswers[q.id]?.trim();
    }
    if (q.type == 'multi_choice' || q.type == 'multi-choice') {
      final indices = _flowMultiAnswers[q.id];
      if (indices == null || indices.isEmpty) return null;
      final options = q.optionsAsStrings;
      return indices
          .map((i) => i < options.length ? options[i] : '')
          .where((s) => s.isNotEmpty)
          .join(', ');
    }
    final idx = _flowAnswers[q.id];
    if (idx == null) return null;
    final options = q.optionsAsStrings;
    return idx < options.length ? options[idx] : idx.toString();
  }

  /// Load first question from API (GET domains/{domain}/questions, take first).
  Future<void> loadQuestions() async {
    if (_loading) return;
    _loading = true;
    _error = null;
    _currentQuestion = null;
    _progress = null;
    _flowAnswers.clear();
    _flowTextAnswers.clear();
    _flowMultiAnswers.clear();
    _notifyIfNotDisposed();

    final response = await DomainQuestionsRepository.instance
        .getDomainFirstQuestion(domain);

    if (_disposed) return;

    _loading = false;
    if (response.success && response.data is Map) {
      final map = response.data as Map;
      _currentQuestion = map['question'] is FlowQuestion
          ? map['question'] as FlowQuestion
          : FlowQuestion.fromJson(
              Map<String, dynamic>.from(map['question'] as Map),
            );
      _totalQuestionCount = (map['totalCount'] as int?) ?? 0;
      _error = null;
    } else {
      _currentQuestion = null;
      _totalQuestionCount = 0;
      _error = response.userMessageOrFallback('Could not load questions');
    }
    _notifyIfNotDisposed();
  }

  /// Submit current answer to API. Body: { question_id, domain, answer }.
  /// On success: updates current question from response.current, progress from response.progress.
  /// Returns (success, rawResponseData) – rawResponseData for result screen when done.
  Future<(bool success, Map<String, dynamic>? responseData)>
  submitCurrentAnswer() async {
    final q = _currentQuestion;
    if (q == null || _submitting || _disposed) return (false, null);

    final answer = _buildAnswerForQuestion(q);
    if (answer == null || answer.isEmpty) return (false, null);

    _submitting = true;
    _submitError = null;
    _notifyIfNotDisposed();

    final response = await DomainQuestionsRepository.instance
        .submitSingleAnswer(domain, q.id, answer);

    if (_disposed) return (false, null);

    _submitting = false;

    if (!response.success) {
      _submitError = response.userMessageOrFallback('Failed to submit answer');
      _notifyIfNotDisposed();
      return (false, null);
    }

    final data = response.data;
    if (data is DomainAnswersResponse) {
      _progress = data.progress;
      // Clear answer for current question before moving to next
      _flowAnswers.remove(q.id);
      _flowTextAnswers.remove(q.id);
      _flowMultiAnswers.remove(q.id);

      // Next question: response.current is the next question to show
      _currentQuestion = data.questionToShow;
      _submitError = null;
      _notifyIfNotDisposed();

      // Done when no more question (status processing/completed, redirect)
      if (_currentQuestion == null) {
        return (true, data.raw);
      }
      return (true, null); // More questions – caller stays on screen
    }

    _submitError = 'Invalid response';
    _notifyIfNotDisposed();
    return (false, null);
  }
}
