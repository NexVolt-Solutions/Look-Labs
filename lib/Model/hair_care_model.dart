class HairCareModel {
  final String id;
  final String name;
  final String? description;
  final String? category;
  final String? imageUrl;
  final List<String>? products;

  HairCareModel({
    required this.id,
    required this.name,
    this.description,
    this.category,
    this.imageUrl,
    this.products,
  });

  factory HairCareModel.fromJson(Map<String, dynamic> json) {
    return HairCareModel(
      id: json['id'] as String? ?? json['_id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String?,
      category: json['category'] as String? ?? json['type'] as String?,
      imageUrl: json['imageUrl'] as String? ?? json['image_url'] as String?,
      products: json['products'] != null
          ? List<String>.from(json['products'] as List)
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
      if (products != null) 'products': products,
    };
  }
}

class HairRoutineModel {
  final String id;
  final String hairCareId;
  final String day;
  final int? order;
  final HairCareModel? hairCare;

  HairRoutineModel({
    required this.id,
    required this.hairCareId,
    required this.day,
    this.order,
    this.hairCare,
  });

  factory HairRoutineModel.fromJson(Map<String, dynamic> json) {
    return HairRoutineModel(
      id: json['id'] as String? ?? json['_id'] as String? ?? '',
      hairCareId: json['hairCareId'] as String? ??
          json['hair_care_id'] as String? ??
          json['hairCare_id'] as String? ??
          '',
      day: json['day'] as String? ?? json['dayOfWeek'] as String? ?? '',
      order: json['order'] as int?,
      hairCare: json['hairCare'] != null
          ? HairCareModel.fromJson(
              json['hairCare'] as Map<String, dynamic>,
            )
          : json['hair_care'] != null
              ? HairCareModel.fromJson(
                  json['hair_care'] as Map<String, dynamic>,
                )
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hairCareId': hairCareId,
      'day': day,
      if (order != null) 'order': order,
      if (hairCare != null) 'hairCare': hairCare!.toJson(),
    };
  }
}
