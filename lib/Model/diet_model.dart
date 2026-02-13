class DietModel {
  final String id;
  final String name;
  final String? description;
  final String? category;
  final int? calories;
  final String? imageUrl;
  final List<String>? ingredients;

  DietModel({
    required this.id,
    required this.name,
    this.description,
    this.category,
    this.calories,
    this.imageUrl,
    this.ingredients,
  });

  factory DietModel.fromJson(Map<String, dynamic> json) {
    return DietModel(
      id: json['id'] as String? ?? json['_id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String?,
      category: json['category'] as String? ?? json['type'] as String?,
      calories: json['calories'] as int? ?? json['calorie'] as int?,
      imageUrl: json['imageUrl'] as String? ?? json['image_url'] as String?,
      ingredients: json['ingredients'] != null
          ? List<String>.from(json['ingredients'] as List)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      if (description != null) 'description': description,
      if (category != null) 'category': category,
      if (calories != null) 'calories': calories,
      if (imageUrl != null) 'imageUrl': imageUrl,
      if (ingredients != null) 'ingredients': ingredients,
    };
  }
}

class DietRoutineModel {
  final String id;
  final String dietId;
  final String day;
  final String mealType;
  final DietModel? diet;
  final int? order;

  DietRoutineModel({
    required this.id,
    required this.dietId,
    required this.day,
    required this.mealType,
    this.diet,
    this.order,
  });

  factory DietRoutineModel.fromJson(Map<String, dynamic> json) {
    return DietRoutineModel(
      id: json['id'] as String? ?? json['_id'] as String? ?? '',
      dietId: json['dietId'] as String? ?? json['diet_id'] as String? ?? '',
      day: json['day'] as String? ?? json['dayOfWeek'] as String? ?? '',
      mealType: json['mealType'] as String? ??
          json['meal_type'] as String? ??
          json['meal'] as String? ??
          'lunch',
      diet: json['diet'] != null
          ? DietModel.fromJson(json['diet'] as Map<String, dynamic>)
          : null,
      order: json['order'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dietId': dietId,
      'day': day,
      'mealType': mealType,
      if (diet != null) 'diet': diet!.toJson(),
      if (order != null) 'order': order,
    };
  }
}
