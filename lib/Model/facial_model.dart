class FacialModel {
  final String id;
  final String name;
  final String? description;
  final String? type;
  final String? imageUrl;
  final List<String>? exercises;

  FacialModel({
    required this.id,
    required this.name,
    this.description,
    this.type,
    this.imageUrl,
    this.exercises,
  });

  factory FacialModel.fromJson(Map<String, dynamic> json) {
    return FacialModel(
      id: json['id'] as String? ?? json['_id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String?,
      type: json['type'] as String? ?? json['category'] as String?,
      imageUrl: json['imageUrl'] as String? ?? json['image_url'] as String?,
      exercises: json['exercises'] != null
          ? List<String>.from(json['exercises'] as List)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      if (description != null) 'description': description,
      if (type != null) 'type': type,
      if (imageUrl != null) 'imageUrl': imageUrl,
      if (exercises != null) 'exercises': exercises,
    };
  }
}

class FacialProgressModel {
  final String id;
  final String userId;
  final String facialId;
  final DateTime? completedAt;
  final int? durationSeconds;
  final FacialModel? facial;

  FacialProgressModel({
    required this.id,
    required this.userId,
    required this.facialId,
    this.completedAt,
    this.durationSeconds,
    this.facial,
  });

  factory FacialProgressModel.fromJson(Map<String, dynamic> json) {
    return FacialProgressModel(
      id: json['id'] as String? ?? json['_id'] as String? ?? '',
      userId: json['userId'] as String? ?? json['user_id'] as String? ?? '',
      facialId:
          json['facialId'] as String? ?? json['facial_id'] as String? ?? '',
      completedAt: json['completedAt'] != null
          ? DateTime.tryParse(json['completedAt'] as String)
          : json['completed_at'] != null
              ? DateTime.tryParse(json['completed_at'] as String)
              : null,
      durationSeconds: json['durationSeconds'] as int? ??
          json['duration_seconds'] as int? ??
          json['duration'] as int?,
      facial: json['facial'] != null
          ? FacialModel.fromJson(json['facial'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'facialId': facialId,
      if (completedAt != null) 'completedAt': completedAt!.toIso8601String(),
      if (durationSeconds != null) 'durationSeconds': durationSeconds,
      if (facial != null) 'facial': facial!.toJson(),
    };
  }
}
