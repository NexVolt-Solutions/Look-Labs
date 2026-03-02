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
      id: _string(json['id']),
      userId: _stringOrNull(json['user_id']),
      createdAt: _string(json['created_at']),
      updatedAt: _string(json['updated_at']),
      selectedDomain: _stringOrNull(json['selected_domain']),
      isPaid: json['is_paid'] == true,
      paymentConfirmedAt: _stringOrNull(json['payment_confirmed_at']),
    );
  }

  static String _string(dynamic v) =>
      v == null ? '' : v is String ? v : v.toString();
  static String? _stringOrNull(dynamic v) =>
      v == null ? null : v is String ? v : v.toString();

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
