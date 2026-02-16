class HeightModel {
  final String id;
  final String name;
  final String? description;
  final String? category;
  final int? durationMinutes;
  final String? imageUrl;

  HeightModel({
    required this.id,
    required this.name,
    this.description,
    this.category,
    this.durationMinutes,
    this.imageUrl,
  });

  factory HeightModel.fromJson(Map<String, dynamic> json) {
    return HeightModel(
      id: json['id'] as String? ?? json['_id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String?,
      category: json['category'] as String? ?? json['type'] as String?,
      durationMinutes: json['durationMinutes'] as int? ??
          json['duration_minutes'] as int? ??
          json['duration'] as int?,
      imageUrl: json['imageUrl'] as String? ?? json['image_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      if (description != null) 'description': description,
      if (category != null) 'category': category,
      if (durationMinutes != null) 'durationMinutes': durationMinutes,
      if (imageUrl != null) 'imageUrl': imageUrl,
    };
  }
}

class HeightRoutineModel {
  final String id;
  final String heightId;
  final String day;
  final int? order;
  final HeightModel? height;

  HeightRoutineModel({
    required this.id,
    required this.heightId,
    required this.day,
    this.order,
    this.height,
  });

  factory HeightRoutineModel.fromJson(Map<String, dynamic> json) {
    return HeightRoutineModel(
      id: json['id'] as String? ?? json['_id'] as String? ?? '',
      heightId: json['heightId'] as String? ??
          json['height_id'] as String? ??
          json['heightExercise_id'] as String? ??
          '',
      day: json['day'] as String? ?? json['dayOfWeek'] as String? ?? '',
      order: json['order'] as int?,
      height: json['height'] != null
          ? HeightModel.fromJson(json['height'] as Map<String, dynamic>)
          : json['heightExercise'] != null
              ? HeightModel.fromJson(
                  json['heightExercise'] as Map<String, dynamic>,
                )
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'heightId': heightId,
      'day': day,
      if (order != null) 'order': order,
      if (height != null) 'height': height!.toJson(),
    };
  }
}
