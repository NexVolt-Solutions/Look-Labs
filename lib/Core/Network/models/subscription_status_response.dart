/// Response from GET subscriptions/me/status. Quick check for premium access.
class SubscriptionStatusResponse {
  final bool active;

  const SubscriptionStatusResponse({this.active = false});

  factory SubscriptionStatusResponse.fromJson(Map<String, dynamic> json) {
    final a = json['active'] ?? json['is_premium'] ?? json['isPremium'];
    if (a is bool) return SubscriptionStatusResponse(active: a);
    if (a != null) return SubscriptionStatusResponse(active: a == true);
    return SubscriptionStatusResponse();
  }
}
