/// Response model for POST {{base_url}}/api/v1/onboarding/sessions (anonymous).
class OnboardingSession {
  final String id;
  final String? userId;
  final String createdAt;
  final String updatedAt;
  final String? selectedDomain;
  final bool isPaid;
  final String? paymentConfirmedAt;

  const OnboardingSession({
    required this.id,
    this.userId,
    required this.createdAt,
    required this.updatedAt,
    this.selectedDomain,
    this.isPaid = false,
    this.paymentConfirmedAt,
  });

  factory OnboardingSession.fromJson(Map<String, dynamic> json) {
    return OnboardingSession(
      id: json['id'] as String? ?? '',
      userId: json['user_id'] as String?,
      createdAt: json['created_at'] as String? ?? '',
      updatedAt: json['updated_at'] as String? ?? '',
      selectedDomain: json['selected_domain'] as String?,
      isPaid: json['is_paid'] as bool? ?? false,
      paymentConfirmedAt: json['payment_confirmed_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'selected_domain': selectedDomain,
        'is_paid': isPaid,
        'payment_confirmed_at': paymentConfirmedAt,
      };
}
