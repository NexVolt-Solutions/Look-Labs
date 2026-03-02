/// One step in the flow (when backend returns "steps" list).
class FlowStepItem {
  final String step;
  final List<FlowQuestion> questions;

  const FlowStepItem({required this.step, required this.questions});

  factory FlowStepItem.fromJson(Map<String, dynamic> json) {
    List<FlowQuestion> list = [];
    final raw = json['questions'];
    if (raw is List) {
      for (final e in raw) {
        if (e is Map) {
          try {
            list.add(FlowQuestion.fromJson(Map<String, dynamic>.from(e)));
          } catch (_) {}
        }
      }
    }
    return FlowStepItem(step: json['step'] as String? ?? '', questions: list);
  }
}

class OnboardingFlowResponse {
  final String status;
  final FlowQuestion? current;
  final FlowQuestion? next;

  /// When present, backend returned all questions for the step in one call.
  final List<FlowQuestion>? questions;

  /// List of steps, each with its questions. Preferred format: one response for entire onboarding.
  final List<FlowStepItem>? steps;

  final FlowProgress? progress;
  final String? redirect;

  const OnboardingFlowResponse({
    required this.status,
    this.current,
    this.next,
    this.questions,
    this.steps,
    this.progress,
    this.redirect,
  });

  factory OnboardingFlowResponse.fromJson(Map<String, dynamic> json) {
    List<FlowQuestion>? questionsList;
    final rawQuestions = json['questions'];
    if (rawQuestions is List) {
      try {
        questionsList = rawQuestions
            .map(
              (e) => e is Map
                  ? FlowQuestion.fromJson(Map<String, dynamic>.from(e))
                  : null,
            )
            .whereType<FlowQuestion>()
            .toList();
      } catch (_) {
        questionsList = null;
      }
    }

    List<FlowStepItem>? stepsList;
    final rawSteps = json['steps'];
    if (rawSteps is List) {
      try {
        stepsList = rawSteps
            .map(
              (e) => e is Map
                  ? FlowStepItem.fromJson(Map<String, dynamic>.from(e))
                  : null,
            )
            .whereType<FlowStepItem>()
            .toList();
      } catch (_) {
        stepsList = null;
      }
    }

    return OnboardingFlowResponse(
      status: json['status'] as String? ?? 'ok',
      current: json['current'] != null && json['current'] is Map
          ? FlowQuestion.fromJson(
              Map<String, dynamic>.from(json['current'] as Map),
            )
          : null,
      next: json['next'] != null && json['next'] is Map
          ? FlowQuestion.fromJson(
              Map<String, dynamic>.from(json['next'] as Map),
            )
          : null,
      questions: questionsList,
      steps: stepsList,
      progress: json['progress'] != null && json['progress'] is Map
          ? FlowProgress.fromJson(
              Map<String, dynamic>.from(json['progress'] as Map),
            )
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
    if (json['options'] != null && json['options'] is List) {
      opts = List<dynamic>.from(json['options'] as List);
    }
    final idRaw = json['id'];
    final id = idRaw == null
        ? 0
        : idRaw is int
        ? idRaw
        : idRaw is num
        ? idRaw.toInt()
        : int.tryParse(idRaw.toString()) ?? 0;
    Map<String, dynamic>? constraints;
    if (json['constraints'] != null && json['constraints'] is Map) {
      constraints = Map<String, dynamic>.from(json['constraints'] as Map);
    }
    return FlowQuestion(
      id: id,
      step: json['step']?.toString() ?? '',
      question: json['question']?.toString() ?? '',
      type: json['type']?.toString() ?? 'text',
      options: opts,
      constraints: constraints,
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
    FlowProgressDetail? progressDetail;
    if (progressJson is Map<String, dynamic>) {
      try {
        progressDetail = FlowProgressDetail.fromJson(progressJson);
      } catch (_) {
        progressDetail = null;
      }
    } else if (progressJson is Map) {
      try {
        progressDetail = FlowProgressDetail.fromJson(
          Map<String, dynamic>.from(progressJson),
        );
      } catch (_) {
        progressDetail = null;
      }
    }
    int total = 0;
    if (json['total_questions'] is int) {
      total = json['total_questions'] as int;
    } else if (json['total_questions'] is num) {
      total = (json['total_questions'] as num).toInt();
    }
    return FlowProgress(
      sessionId: json['session_id'] as String? ?? '',
      step: json['step'] as String? ?? '',
      answeredQuestions: json['answered_questions'] is List
          ? List<dynamic>.from(json['answered_questions'] as List)
          : [],
      totalQuestions: total,
      progress: progressDetail,
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
