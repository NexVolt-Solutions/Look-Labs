class IapEntitlementResponse {
  final bool isActive;
  final String status;
  final String? planCode;
  final int maxDomainsAllowed;
  final List<String> unlockedDomainIds;
  final DateTime? expiresAt;
  final String? provider;

  const IapEntitlementResponse({
    this.isActive = false,
    this.status = '',
    this.planCode,
    this.maxDomainsAllowed = 0,
    this.unlockedDomainIds = const [],
    this.expiresAt,
    this.provider,
  });

  factory IapEntitlementResponse.fromJson(Map<String, dynamic> json) {
    final rawUnlocked = json['unlocked_domain_ids'];
    final unlocked = <String>[];
    if (rawUnlocked is List) {
      for (final item in rawUnlocked) {
        final key = item?.toString().trim().toLowerCase();
        if (key != null && key.isNotEmpty) unlocked.add(key);
      }
    }
    return IapEntitlementResponse(
      isActive:
          (json['is_active'] == true) ||
          (json['subscription_active'] == true) ||
          (json['active'] == true),
      status: json['status']?.toString() ?? '',
      planCode: json['plan_code']?.toString() ?? json['plan']?.toString(),
      maxDomainsAllowed:
          (json['max_domains_allowed'] is int)
          ? json['max_domains_allowed'] as int
          : int.tryParse(json['max_domains_allowed']?.toString() ?? '') ?? 0,
      unlockedDomainIds: unlocked,
      expiresAt: DateTime.tryParse(json['expires_at']?.toString() ?? ''),
      provider: json['provider']?.toString(),
    );
  }
}
