/// Response from POST domains/{domain}/answers (submit one answer).
/// Contains current question, next question, progress, and redirect.
import 'package:looklabs/Core/Network/models/onboarding_flow_response.dart';

class DomainAnswersResponse {
  final String status;
  final FlowQuestion? current;
  final FlowQuestion? next;
  final DomainProgressInfo? progress;
  final String? redirect;

  /// Full raw response (ai_attributes, ai_exercises, etc.) for result screens.
  final Map<String, dynamic> raw;

  const DomainAnswersResponse({
    required this.status,
    this.current,
    this.next,
    this.progress,
    this.redirect,
    this.raw = const {},
  });

  factory DomainAnswersResponse.fromJson(Map<String, dynamic> json) {
    FlowQuestion? currentQ;
    if (json['current'] != null && json['current'] is Map) {
      try {
        currentQ = FlowQuestion.fromJson(
          Map<String, dynamic>.from(json['current'] as Map),
        );
      } catch (_) {}
    }
    FlowQuestion? nextQ;
    if (json['next'] != null && json['next'] is Map) {
      try {
        nextQ = FlowQuestion.fromJson(
          Map<String, dynamic>.from(json['next'] as Map),
        );
      } catch (_) {}
    }
    DomainProgressInfo? progressInfo;
    if (json['progress'] != null && json['progress'] is Map) {
      try {
        progressInfo = DomainProgressInfo.fromJson(
          Map<String, dynamic>.from(json['progress'] as Map),
        );
      } catch (_) {}
    }
    return DomainAnswersResponse(
      status: json['status']?.toString() ?? 'ok',
      current: currentQ,
      next: nextQ,
      progress: progressInfo,
      redirect: json['redirect']?.toString(),
      raw: Map<String, dynamic>.from(json),
    );
  }

  /// Next question to show: current (the one to answer now) or next if current is null.
  FlowQuestion? get questionToShow => current ?? next;

  bool get isProcessing => status == 'processing';
  bool get isCompleted => status == 'completed' || status == 'ok';
}

/// Progress info from domain answers response.
class DomainProgressInfo {
  final int total;
  final int answered;
  final bool completed;
  final double progressPercent;
  final List<dynamic> answeredQuestions;

  const DomainProgressInfo({
    this.total = 0,
    this.answered = 0,
    this.completed = false,
    this.progressPercent = 0,
    this.answeredQuestions = const [],
  });

  factory DomainProgressInfo.fromJson(Map<String, dynamic> json) {
    // Nested progress: { "progress": { "total": 9, "answered": 2, "completed": false } }
    int total = 0;
    int answered = 0;
    bool completed = false;
    double percent = 0;

    final inner = json['progress'];
    if (inner is Map) {
      final m = Map<String, dynamic>.from(inner);
      total = m['total'] is int
          ? m['total'] as int
          : (m['total'] is num ? (m['total'] as num).toInt() : 0);
      answered = m['answered'] is int
          ? m['answered'] as int
          : (m['answered'] is num ? (m['answered'] as num).toInt() : 0);
      completed = m['completed'] == true;
    }
    if (json['progress_percent'] is num) {
      percent = (json['progress_percent'] as num).toDouble();
    } else if (json['progress_percent'] != null) {
      percent = double.tryParse(json['progress_percent'].toString()) ?? 0;
    }
    final aq = json['answered_questions'];
    final answeredList =
        aq is List ? List<dynamic>.from(aq) : <dynamic>[];
    final totalQ = json['total_questions'] is int
        ? json['total_questions'] as int
        : (json['total_questions'] is num
            ? (json['total_questions'] as num).toInt()
            : total);

    return DomainProgressInfo(
      total: total > 0 ? total : totalQ,
      answered: answered > 0 ? answered : answeredList.length,
      completed: completed,
      progressPercent: percent,
      answeredQuestions: answeredList,
    );
  }
}
