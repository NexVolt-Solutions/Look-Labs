/// Response from POST domains/{domain}/answers when status is "completed".
/// Contains ai_attributes, ai_exercises, ai_message, ai_progress from the API.
class WorkoutResultResponse {
  final String? status;
  final String? redirect;
  final WorkoutAiAttributes? aiAttributes;
  final WorkoutAiExercises? aiExercises;
  final String? aiMessage;
  final WorkoutAiProgress? aiProgress;

  const WorkoutResultResponse({
    this.status,
    this.redirect,
    this.aiAttributes,
    this.aiExercises,
    this.aiMessage,
    this.aiProgress,
  });

  factory WorkoutResultResponse.fromJson(Map<String, dynamic> json) {
    final attrs = json['ai_attributes'];
    final ex = json['ai_exercises'];
    final prog = json['ai_progress'];
    return WorkoutResultResponse(
      status: json['status']?.toString(),
      redirect: json['redirect']?.toString(),
      aiAttributes: attrs is Map ? WorkoutAiAttributes.fromJson(Map<String, dynamic>.from(attrs)) : null,
      aiExercises: ex is Map ? WorkoutAiExercises.fromJson(Map<String, dynamic>.from(ex)) : null,
      aiMessage: json['ai_message']?.toString(),
      aiProgress: prog is Map ? WorkoutAiProgress.fromJson(Map<String, dynamic>.from(prog)) : null,
    );
  }
}

class WorkoutAiAttributes {
  final String? intensity;
  final String? activity;
  final String? goal;
  final String? dietType;
  final List<String> todayFocus;
  final String? postureInsight;
  final WorkoutAiSummary? workoutSummary;

  const WorkoutAiAttributes({
    this.intensity,
    this.activity,
    this.goal,
    this.dietType,
    this.todayFocus = const [],
    this.postureInsight,
    this.workoutSummary,
  });

  factory WorkoutAiAttributes.fromJson(Map<String, dynamic> json) {
    List<String> focus = [];
    if (json['today_focus'] is List) {
      for (final e in json['today_focus'] as List) {
        if (e != null && e.toString().trim().isNotEmpty) {
          focus.add(e.toString().trim());
        }
      }
    }
    final ws = json['workout_summary'];
    return WorkoutAiAttributes(
      intensity: json['intensity']?.toString(),
      activity: json['activity']?.toString(),
      goal: json['goal']?.toString(),
      dietType: json['diet_type']?.toString(),
      todayFocus: focus,
      postureInsight: json['posture_insight']?.toString(),
      workoutSummary: ws is Map ? WorkoutAiSummary.fromJson(Map<String, dynamic>.from(ws)) : null,
    );
  }
}

class WorkoutAiSummary {
  final int? totalExercises;
  final int? totalDurationMin;

  WorkoutAiSummary({this.totalExercises, this.totalDurationMin});

  factory WorkoutAiSummary.fromJson(Map<String, dynamic> json) {
    return WorkoutAiSummary(
      totalExercises: json['total_exercises'] is int
          ? json['total_exercises'] as int
          : int.tryParse(json['total_exercises']?.toString() ?? ''),
      totalDurationMin: json['total_duration_min'] is int
          ? json['total_duration_min'] as int
          : int.tryParse(json['total_duration_min']?.toString() ?? ''),
    );
  }
}

class WorkoutAiExercises {
  final List<WorkoutExercise> morning;
  final List<WorkoutExercise> evening;

  const WorkoutAiExercises({
    this.morning = const [],
    this.evening = const [],
  });

  factory WorkoutAiExercises.fromJson(Map<String, dynamic> json) {
    final m = json['morning'];
    final e = json['evening'];
    return WorkoutAiExercises(
      morning: _parseExercises(m),
      evening: _parseExercises(e),
    );
  }

  static List<WorkoutExercise> _parseExercises(dynamic list) {
    if (list is! List) return [];
    final result = <WorkoutExercise>[];
    for (final e in list) {
      if (e is Map) {
        try {
          result.add(WorkoutExercise.fromJson(Map<String, dynamic>.from(e)));
        } catch (_) {}
      }
    }
    return result;
  }
}

class WorkoutExercise {
  final int seq;
  final String title;
  final String duration;
  final List<String> steps;

  const WorkoutExercise({
    this.seq = 0,
    this.title = '',
    this.duration = '',
    this.steps = const [],
  });

  factory WorkoutExercise.fromJson(Map<String, dynamic> json) {
    List<String> stepsList = [];
    if (json['steps'] is List) {
      for (final s in json['steps'] as List) {
        if (s != null && s.toString().trim().isNotEmpty) {
          stepsList.add(s.toString().trim());
        }
      }
    }
    return WorkoutExercise(
      seq: json['seq'] is int ? json['seq'] as int : int.tryParse(json['seq']?.toString() ?? '0') ?? 0,
      title: json['title']?.toString() ?? '',
      duration: json['duration']?.toString() ?? '',
      steps: stepsList,
    );
  }
}

class WorkoutAiProgress {
  final String? weeklyCalories;
  final String? consistency;
  final String? strengthGain;
  final String? fitnessConsistency;
  final List<String> recoveryChecklist;

  const WorkoutAiProgress({
    this.weeklyCalories,
    this.consistency,
    this.strengthGain,
    this.fitnessConsistency,
    this.recoveryChecklist = const [],
  });

  factory WorkoutAiProgress.fromJson(Map<String, dynamic> json) {
    List<String> checklist = [];
    if (json['recovery_checklist'] is List) {
      for (final e in json['recovery_checklist'] as List) {
        if (e != null && e.toString().trim().isNotEmpty) {
          checklist.add(e.toString().trim());
        }
      }
    }
    return WorkoutAiProgress(
      weeklyCalories: json['weekly_calories']?.toString(),
      consistency: json['consistency']?.toString(),
      strengthGain: json['strength_gain']?.toString(),
      fitnessConsistency: json['fitness_consistency']?.toString(),
      recoveryChecklist: checklist,
    );
  }
}
