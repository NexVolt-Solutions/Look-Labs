class SkinCareModel {
  final String id;
  final String name;
  final String? description;
  final String? category;
  final String? imageUrl;
  final List<String>? tips;

  SkinCareModel({
    required this.id,
    required this.name,
    this.description,
    this.category,
    this.imageUrl,
    this.tips,
  });

  factory SkinCareModel.fromJson(Map<String, dynamic> json) {
    return SkinCareModel(
      id: json['id'] as String? ?? json['_id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String?,
      category: json['category'] as String? ?? json['type'] as String?,
      imageUrl: json['imageUrl'] as String? ?? json['image_url'] as String?,
      tips: json['tips'] != null
          ? List<String>.from(json['tips'] as List)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      if (description != null) 'description': description,
      if (category != null) 'category': category,
      if (imageUrl != null) 'imageUrl': imageUrl,
      if (tips != null) 'tips': tips,
    };
  }
}

class SkinRoutineModel {
  final String id;
  final String skinCareId;
  final String day;
  final int? order;
  final SkinCareModel? skinCare;

  SkinRoutineModel({
    required this.id,
    required this.skinCareId,
    required this.day,
    this.order,
    this.skinCare,
  });

  factory SkinRoutineModel.fromJson(Map<String, dynamic> json) {
    return SkinRoutineModel(
      id: json['id'] as String? ?? json['_id'] as String? ?? '',
      skinCareId: json['skinCareId'] as String? ??
          json['skin_care_id'] as String? ??
          json['skinCare_id'] as String? ??
          '',
      day: json['day'] as String? ?? json['dayOfWeek'] as String? ?? '',
      order: json['order'] as int?,
      skinCare: json['skinCare'] != null
          ? SkinCareModel.fromJson(
              json['skinCare'] as Map<String, dynamic>,
            )
          : json['skin_care'] != null
              ? SkinCareModel.fromJson(
                  json['skin_care'] as Map<String, dynamic>,
                )
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'skinCareId': skinCareId,
      'day': day,
      if (order != null) 'order': order,
      if (skinCare != null) 'skinCare': skinCare!.toJson(),
    };
  }
}
