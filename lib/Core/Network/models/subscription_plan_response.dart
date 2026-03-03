/// Response from GET subscriptions/plans. Adjust fields to match backend.
class SubscriptionPlanResponse {
  final List<SubscriptionPlan> plans;

  const SubscriptionPlanResponse({this.plans = const []});

  factory SubscriptionPlanResponse.fromJson(Map<String, dynamic> json) {
    List<SubscriptionPlan> plans = [];
    final list = json['plans'] ?? json['data'];
    if (list is List) {
      for (final e in list) {
        if (e is Map<String, dynamic>) {
          plans.add(SubscriptionPlan.fromJson(e));
        } else if (e is Map) {
          plans.add(SubscriptionPlan.fromJson(Map<String, dynamic>.from(e)));
        }
      }
    }
    return SubscriptionPlanResponse(plans: plans);
  }
}

class SubscriptionPlan {
  final String id;
  final String name;
  /// Store product ID (Google Play / App Store) used for in_app_purchase.
  final String productId;
  final String? priceDisplay;
  final String? durationDisplay;
  final int? durationDays;
  final String? badge; // e.g. "Save 40%", "Best Value"

  const SubscriptionPlan({
    this.id = '',
    this.name = '',
    this.productId = '',
    this.priceDisplay,
    this.durationDisplay,
    this.durationDays,
    this.badge,
  });

  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlan(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      productId: json['product_id']?.toString() ?? json['productId']?.toString() ?? '',
      priceDisplay: json['price_display']?.toString() ?? json['priceDisplay']?.toString(),
      durationDisplay: json['duration_display']?.toString() ?? json['durationDisplay']?.toString(),
      durationDays: json['duration_days'] is int
          ? json['duration_days'] as int
          : int.tryParse(json['duration_days']?.toString() ?? ''),
      badge: json['badge']?.toString(),
    );
  }
}
