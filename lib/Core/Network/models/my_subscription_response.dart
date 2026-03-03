/// Response from GET subscriptions/me. Adjust fields to match backend.
class MySubscriptionResponse {
  final MySubscription? subscription;

  const MySubscriptionResponse({this.subscription});

  factory MySubscriptionResponse.fromJson(Map<String, dynamic> json) {
    final sub = json['subscription'] ?? json['data'];
    if (sub is! Map) return const MySubscriptionResponse();
    return MySubscriptionResponse(
      subscription: MySubscription.fromJson(Map<String, dynamic>.from(sub)),
    );
  }
}

class MySubscription {
  final String id;
  final String? planId;
  final String status;
  final String? expiresAt;
  final String? productId;

  const MySubscription({
    this.id = '',
    this.planId,
    this.status = '',
    this.expiresAt,
    this.productId,
  });

  factory MySubscription.fromJson(Map<String, dynamic> json) {
    return MySubscription(
      id: json['id']?.toString() ?? '',
      planId: json['plan_id']?.toString() ?? json['planId']?.toString(),
      status: json['status']?.toString() ?? '',
      expiresAt: json['expires_at']?.toString() ?? json['expiresAt']?.toString(),
      productId: json['product_id']?.toString() ?? json['productId']?.toString(),
    );
  }

  bool get isActive =>
      status.toLowerCase() == 'active' || status.toLowerCase() == 'trialing';
}
