class FashionModel {
  final String id;
  final String name;
  final String? description;
  final String? style;
  final String? imageUrl;
  final List<String>? items;

  FashionModel({
    required this.id,
    required this.name,
    this.description,
    this.style,
    this.imageUrl,
    this.items,
  });

  factory FashionModel.fromJson(Map<String, dynamic> json) {
    return FashionModel(
      id: json['id'] as String? ?? json['_id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String?,
      style: json['style'] as String? ?? json['type'] as String?,
      imageUrl: json['imageUrl'] as String? ?? json['image_url'] as String?,
      items: json['items'] != null
          ? List<String>.from(json['items'] as List)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      if (description != null) 'description': description,
      if (style != null) 'style': style,
      if (imageUrl != null) 'imageUrl': imageUrl,
      if (items != null) 'items': items,
    };
  }
}

class WeeklyPlanModel {
  final String id;
  final String userId;
  final int weekNumber;
  final List<DailyOutfitModel>? outfits;
  final DateTime? startDate;

  WeeklyPlanModel({
    required this.id,
    required this.userId,
    required this.weekNumber,
    this.outfits,
    this.startDate,
  });

  factory WeeklyPlanModel.fromJson(Map<String, dynamic> json) {
    return WeeklyPlanModel(
      id: json['id'] as String? ?? json['_id'] as String? ?? '',
      userId: json['userId'] as String? ?? json['user_id'] as String? ?? '',
      weekNumber: json['weekNumber'] as int? ??
          json['week_number'] as int? ??
          json['week'] as int? ??
          0,
      outfits: json['outfits'] != null
          ? (json['outfits'] as List)
              .map((e) => DailyOutfitModel.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
      startDate: json['startDate'] != null
          ? DateTime.tryParse(json['startDate'] as String)
          : json['start_date'] != null
              ? DateTime.tryParse(json['start_date'] as String)
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'weekNumber': weekNumber,
      if (outfits != null)
        'outfits': outfits!.map((e) => e.toJson()).toList(),
      if (startDate != null) 'startDate': startDate!.toIso8601String(),
    };
  }
}

class DailyOutfitModel {
  final String day;
  final String? outfitId;
  final FashionModel? outfit;
  final List<String>? itemIds;

  DailyOutfitModel({
    required this.day,
    this.outfitId,
    this.outfit,
    this.itemIds,
  });

  factory DailyOutfitModel.fromJson(Map<String, dynamic> json) {
    return DailyOutfitModel(
      day: json['day'] as String? ?? json['dayOfWeek'] as String? ?? '',
      outfitId: json['outfitId'] as String? ?? json['outfit_id'] as String?,
      outfit: json['outfit'] != null
          ? FashionModel.fromJson(json['outfit'] as Map<String, dynamic>)
          : null,
      itemIds: json['itemIds'] != null
          ? List<String>.from(json['itemIds'] as List)
          : json['items'] != null
              ? List<String>.from(json['items'] as List)
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'day': day,
      if (outfitId != null) 'outfitId': outfitId,
      if (outfit != null) 'outfit': outfit!.toJson(),
      if (itemIds != null) 'itemIds': itemIds,
    };
  }
}
