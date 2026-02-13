class SubscriptionPlanModel {
  final String id;
  final String name;
  final String? description;
  final double price;
  final String? currency;
  final String? duration;
  final List<String>? features;
  final bool? isPopular;

  SubscriptionPlanModel({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    this.currency,
    this.duration,
    this.features,
    this.isPopular,
  });

  factory SubscriptionPlanModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlanModel(
      id: json['id'] as String? ?? json['_id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String?,
      price: (json['price'] ?? json['amount'] ?? 0).toDouble(),
      currency: json['currency'] as String? ?? 'USD',
      duration: json['duration'] as String? ?? json['period'] as String?,
      features: json['features'] != null
          ? List<String>.from(json['features'] as List)
          : null,
      isPopular: json['isPopular'] as bool? ?? json['is_popular'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      if (description != null) 'description': description,
      'price': price,
      if (currency != null) 'currency': currency,
      if (duration != null) 'duration': duration,
      if (features != null) 'features': features,
      if (isPopular != null) 'isPopular': isPopular,
    };
  }
}

class SubscriptionModel {
  final String id;
  final String userId;
  final String planId;
  final String status;
  final DateTime? startDate;
  final DateTime? endDate;
  final SubscriptionPlanModel? plan;

  SubscriptionModel({
    required this.id,
    required this.userId,
    required this.planId,
    required this.status,
    this.startDate,
    this.endDate,
    this.plan,
  });

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionModel(
      id: json['id'] as String? ?? json['_id'] as String? ?? '',
      userId: json['userId'] as String? ?? json['user_id'] as String? ?? '',
      planId: json['planId'] as String? ?? json['plan_id'] as String? ?? '',
      status: json['status'] as String? ?? 'active',
      startDate: json['startDate'] != null
          ? DateTime.tryParse(json['startDate'] as String)
          : json['start_date'] != null
              ? DateTime.tryParse(json['start_date'] as String)
              : null,
      endDate: json['endDate'] != null
          ? DateTime.tryParse(json['endDate'] as String)
          : json['end_date'] != null
              ? DateTime.tryParse(json['end_date'] as String)
              : null,
      plan: json['plan'] != null
          ? SubscriptionPlanModel.fromJson(
              json['plan'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'planId': planId,
      'status': status,
      if (startDate != null) 'startDate': startDate!.toIso8601String(),
      if (endDate != null) 'endDate': endDate!.toIso8601String(),
      if (plan != null) 'plan': plan!.toJson(),
    };
  }
}
