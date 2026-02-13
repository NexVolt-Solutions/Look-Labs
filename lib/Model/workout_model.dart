class WorkoutModel {
  final String id;
  final String name;
  final String? description;
  final String? type;
  final int? durationMinutes;
  final String? difficulty;
  final String? imageUrl;
  final List<String>? tags;

  WorkoutModel({
    required this.id,
    required this.name,
    this.description,
    this.type,
    this.durationMinutes,
    this.difficulty,
    this.imageUrl,
    this.tags,
  });

  factory WorkoutModel.fromJson(Map<String, dynamic> json) {
    return WorkoutModel(
      id: json['id'] as String? ?? json['_id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String?,
      type: json['type'] as String? ?? json['category'] as String?,
      durationMinutes: json['durationMinutes'] as int? ??
          json['duration_minutes'] as int? ??
          json['duration'] as int?,
      difficulty: json['difficulty'] as String?,
      imageUrl: json['imageUrl'] as String? ?? json['image_url'] as String?,
      tags: json['tags'] != null
          ? List<String>.from(json['tags'] as List)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      if (description != null) 'description': description,
      if (type != null) 'type': type,
      if (durationMinutes != null) 'durationMinutes': durationMinutes,
      if (difficulty != null) 'difficulty': difficulty,
      if (imageUrl != null) 'imageUrl': imageUrl,
      if (tags != null) 'tags': tags,
    };
  }
}

class WorkoutRoutineModel {
  final String id;
  final String workoutId;
  final String day;
  final List<WorkoutStepModel>? steps;
  final int? order;

  WorkoutRoutineModel({
    required this.id,
    required this.workoutId,
    required this.day,
    this.steps,
    this.order,
  });

  factory WorkoutRoutineModel.fromJson(Map<String, dynamic> json) {
    return WorkoutRoutineModel(
      id: json['id'] as String? ?? json['_id'] as String? ?? '',
      workoutId:
          json['workoutId'] as String? ?? json['workout_id'] as String? ?? '',
      day: json['day'] as String? ?? json['dayOfWeek'] as String? ?? '',
      steps: json['steps'] != null
          ? (json['steps'] as List)
              .map((e) => WorkoutStepModel.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
      order: json['order'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'workoutId': workoutId,
      'day': day,
      if (steps != null) 'steps': steps!.map((e) => e.toJson()).toList(),
      if (order != null) 'order': order,
    };
  }
}

class WorkoutStepModel {
  final String id;
  final String title;
  final String? description;
  final int? durationSeconds;
  final int? order;

  WorkoutStepModel({
    required this.id,
    required this.title,
    this.description,
    this.durationSeconds,
    this.order,
  });

  factory WorkoutStepModel.fromJson(Map<String, dynamic> json) {
    return WorkoutStepModel(
      id: json['id'] as String? ?? json['_id'] as String? ?? '',
      title: json['title'] as String? ?? json['name'] as String? ?? '',
      description: json['description'] as String?,
      durationSeconds: json['durationSeconds'] as int? ??
          json['duration_seconds'] as int? ??
          json['duration'] as int?,
      order: json['order'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      if (description != null) 'description': description,
      if (durationSeconds != null) 'durationSeconds': durationSeconds,
      if (order != null) 'order': order,
    };
  }
}
