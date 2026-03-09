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

  final Map<int, int> _flowAnswers = {};
  final Map<int, String> _flowTextAnswers = {};
  final Map<int, List<int>> _flowMultiAnswers = {};

  void setFlowTextAnswer(int questionId, String value) {
    _flowTextAnswers[questionId] = value;
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

    final response =
        await DomainQuestionsRepository.instance.getDomainQuestions(domain);

    if (_disposed) return;

    _loading = false;

    if (response.success && response.data is List) {
      _questions = List<FlowQuestion>.from(response.data as List);
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

  /// Submits all answers to POST domains/{domain}/answers (one request per question). Returns true if all succeed.
  Future<bool> submitAnswers() async {
    if (_submitting || _disposed) return false;
    if (!allAnswered) return false;

    final payloads = _buildAnswerPayloads();
    if (payloads.length != _questions.length) return false;

    _submitting = true;
    _submitError = null;
    _notifyIfNotDisposed();

    final response = await DomainQuestionsRepository.instance.submitDomainAnswers(
      domain,
      payloads,
    );

    if (_disposed) return false;

    _submitting = false;
    if (response.success) {
      _submitError = null;
      _notifyIfNotDisposed();
      return true;
    }
    _submitError = response.userMessageOrFallback('Failed to submit answers');
    _notifyIfNotDisposed();
    return false;
  }
}
