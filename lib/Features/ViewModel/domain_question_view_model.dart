import 'package:flutter/foundation.dart';
import 'package:looklabs/Core/Network/api_error_handler.dart';
import 'package:looklabs/Core/Network/models/domain_answers_response.dart';
import 'package:looklabs/Core/Network/models/onboarding_flow_response.dart';
import 'package:looklabs/Repository/domain_questions_repository.dart';

 
class DomainQuestionViewModel extends ChangeNotifier {
  DomainQuestionViewModel({required this.domain});

  final String domain;
  bool _disposed = false;

  FlowQuestion? _currentQuestion;
  DomainProgressInfo? _progress;

  int _totalQuestionCount = 0;

  List<String> _stepperStepKeys = [];

  List<int> _questionIdsInOrder = [];
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

  List<FlowQuestion> get currentStepQuestions {
    final q = _currentQuestion;
    return q != null ? [q] : [];
  }

  String get currentStepTitle {
    final q = _currentQuestion;
    if (q == null || q.step.isEmpty) return '';
    return _humanizeStepKey(q.step);
  }

  List<String> get stepperLabels =>
      _stepperStepKeys.map(_humanizeStepKey).toList();

  int get stepperCurrentStepIndex {
    final q = _currentQuestion;
    if (q == null || _stepperStepKeys.isEmpty) return 0;
    final idx = _stepperStepKeys.indexOf(q.step);
    return idx >= 0 ? idx : 0;
  }

  static String _humanizeStepKey(String step) {
    if (step.isEmpty) return '';
    final lower = step.toLowerCase().replaceAll('_', ' ');
    if (lower.length <= 1) return step.toUpperCase();
    return '${lower[0].toUpperCase()}${lower.substring(1)}';
  }

  static List<String> _orderedUniqueStepKeys(List<FlowQuestion> questions) {
    final seen = <String>{};
    final keys = <String>[];
    for (final q in questions) {
      final s = q.step.trim();
      if (s.isEmpty) continue;
      if (seen.add(s)) keys.add(s);
    }
    return keys;
  }

  double get progressPercent => _progress?.progressPercent ?? 0;

  int get totalQuestions => _progress?.total ?? _totalQuestionCount;

  int get answeredCount => _progress?.answered ?? 0;

  bool get isOnLastQuestion {
    final q = _currentQuestion;
    if (q == null) return false;
    if (_questionIdsInOrder.isNotEmpty) {
      return q.id == _questionIdsInOrder.last;
    }
    final t = totalQuestions;
    if (t <= 1) return true;
    return answeredCount >= t - 1;
  }

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

  Future<void> loadQuestions() async {
    if (_loading) return;
    _loading = true;
    _error = null;
    _currentQuestion = null;
    _progress = null;
    _stepperStepKeys = [];
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
      final allRaw = map['allQuestions'];
      final parsedAll = <FlowQuestion>[];
      if (allRaw is List<FlowQuestion> && allRaw.isNotEmpty) {
        parsedAll.addAll(allRaw);
      } else if (allRaw is List && allRaw.isNotEmpty) {
        for (final e in allRaw) {
          if (e is FlowQuestion) {
            parsedAll.add(e);
          } else if (e is Map) {
            try {
              parsedAll.add(
                FlowQuestion.fromJson(Map<String, dynamic>.from(e)),
              );
            } catch (_) {}
          }
        }
      }
      _stepperStepKeys =
          parsedAll.isEmpty ? [] : _orderedUniqueStepKeys(parsedAll);
      _questionIdsInOrder = parsedAll.map((q) => q.id).toList();
      _error = null;
    } else {
      _currentQuestion = null;
      _totalQuestionCount = 0;
      _error = response.userMessageOrFallback('Could not load questions');
    }
    _notifyIfNotDisposed();
  }

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
       _flowAnswers.remove(q.id);
      _flowTextAnswers.remove(q.id);
      _flowMultiAnswers.remove(q.id);

       _currentQuestion = data.questionToShow;
      _submitError = null;
      _notifyIfNotDisposed();

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
