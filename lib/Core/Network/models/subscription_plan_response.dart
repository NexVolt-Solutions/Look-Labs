/// Response from GET iap/plans.
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
  final String planCode;
  /// Store product ID (Google Play / App Store) used for in_app_purchase.
  final String productId;
  final String? appleProductId;
  final String? googleProductId;
  final String? priceDisplay;
  final String? durationDisplay;
  final int? durationDays;
  final int? maxDomainsAllowed;
  final String? badge; // e.g. "Save 40%", "Best Value"

  const SubscriptionPlan({
    this.id = '',
    this.name = '',
    this.planCode = '',
    this.productId = '',
    this.appleProductId,
    this.googleProductId,
    this.priceDisplay,
    this.durationDisplay,
    this.durationDays,
    this.maxDomainsAllowed,
    this.badge,
  });

  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlan(
      id: json['id']?.toString() ?? '',
      name:
          json['name']?.toString() ??
          json['plan_name']?.toString() ??
          json['planName']?.toString() ??
          '',
      planCode:
          json['plan_code']?.toString() ?? json['planCode']?.toString() ?? '',
      productId:
          json['product_id']?.toString() ?? json['productId']?.toString() ?? '',
      appleProductId:
          json['apple_product_id']?.toString() ??
          (json['products'] is Map ? json['products']['apple']?.toString() : null),
      googleProductId:
          json['google_product_id']?.toString() ??
          (json['products'] is Map ? json['products']['google']?.toString() : null),
      priceDisplay: json['price_display']?.toString() ?? json['priceDisplay']?.toString(),
      durationDisplay: json['duration_display']?.toString() ?? json['durationDisplay']?.toString(),
      durationDays: json['duration_days'] is int
          ? json['duration_days'] as int
          : int.tryParse(json['duration_days']?.toString() ?? ''),
      maxDomainsAllowed: json['max_domains_allowed'] is int
          ? json['max_domains_allowed'] as int
          : int.tryParse(json['max_domains_allowed']?.toString() ?? ''),
      badge: json['badge']?.toString(),
    );
  }

  String resolveProductId({required bool isIos}) {
    if (isIos && appleProductId != null && appleProductId!.isNotEmpty) {
      return appleProductId!;
    }
    if (!isIos && googleProductId != null && googleProductId!.isNotEmpty) {
      return googleProductId!;
    }
    return productId;
  }
}
