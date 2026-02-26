/// GET onboarding/sessions/{session_id}/flow response
class OnboardingFlowResponse {
  final String status;
  final FlowQuestion? current;
  final FlowQuestion? next;
  final FlowProgress? progress;
  final String? redirect;

  const OnboardingFlowResponse({
    required this.status,
    this.current,
    this.next,
    this.progress,
    this.redirect,
  });

  factory OnboardingFlowResponse.fromJson(Map<String, dynamic> json) {
    return OnboardingFlowResponse(
      status: json['status'] as String? ?? 'ok',
      current: json['current'] != null
          ? FlowQuestion.fromJson(
              Map<String, dynamic>.from(json['current'] as Map))
          : null,
      next: json['next'] != null
          ? FlowQuestion.fromJson(
              Map<String, dynamic>.from(json['next'] as Map))
          : null,
      progress: json['progress'] != null
          ? FlowProgress.fromJson(
              Map<String, dynamic>.from(json['progress'] as Map))
          : null,
      redirect: json['redirect'] as String?,
    );
  }
}

class FlowQuestion {
  final int id;
  final String step;
  final String question;
  final String type; // e.g. text, number, choice
  final List<dynamic>? options;
  final Map<String, dynamic>? constraints;

  const FlowQuestion({
    required this.id,
    required this.step,
    required this.question,
    required this.type,
    this.options,
    this.constraints,
  });

  factory FlowQuestion.fromJson(Map<String, dynamic> json) {
    List<dynamic>? opts;
    if (json['options'] != null) {
      opts = json['options'] is List
          ? List<dynamic>.from(json['options'] as List)
          : null;
    }
    return FlowQuestion(
      id: json['id'] as int? ?? 0,
      step: json['step'] as String? ?? '',
      question: json['question'] as String? ?? '',
      type: json['type'] as String? ?? 'text',
      options: opts,
      constraints: json['constraints'] != null
          ? Map<String, dynamic>.from(json['constraints'] as Map)
          : null,
    );
  }

  List<String> get optionsAsStrings {
    if (options == null) return [];
    return options!
        .map((e) => e?.toString() ?? '')
        .where((s) => s.isNotEmpty)
        .toList();
  }

  int? get minConstraint =>
      constraints != null ? constraints!['min'] as int? : null;
  int? get maxConstraint =>
      constraints != null ? constraints!['max'] as int? : null;
}

class FlowProgress {
  final String sessionId;
  final String step;
  final List<dynamic> answeredQuestions;
  final int totalQuestions;
  final FlowProgressDetail? progress;

  const FlowProgress({
    required this.sessionId,
    required this.step,
    required this.answeredQuestions,
    required this.totalQuestions,
    this.progress,
  });

  factory FlowProgress.fromJson(Map<String, dynamic> json) {
    final progressJson = json['progress'];
    return FlowProgress(
      sessionId: json['session_id'] as String? ?? '',
      step: json['step'] as String? ?? '',
      answeredQuestions: json['answered_questions'] is List
          ? List<dynamic>.from(json['answered_questions'] as List)
          : [],
      totalQuestions: json['total_questions'] as int? ?? 0,
      progress: progressJson != null
          ? FlowProgressDetail.fromJson(
              Map<String, dynamic>.from(progressJson as Map))
          : null,
    );
  }
}

class FlowProgressDetail {
  final Map<String, dynamic>? sections;
  final Map<String, dynamic>? overall;

  const FlowProgressDetail({this.sections, this.overall});

  factory FlowProgressDetail.fromJson(Map<String, dynamic> json) {
    return FlowProgressDetail(
      sections: json['sections'] != null
          ? Map<String, dynamic>.from(json['sections'] as Map)
          : null,
      overall: json['overall'] != null
          ? Map<String, dynamic>.from(json['overall'] as Map)
          : null,
    );
  }
}
