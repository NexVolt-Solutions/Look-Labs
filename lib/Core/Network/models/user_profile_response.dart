/// Response from GET users/me (requires auth).
class UserProfileResponse {
  final int? id;
  final String? email;
  final String? name;
  final int? age;
  final String? gender;
  final String? profileImage;
  final bool notificationsEnabled;
  final String? createdAt;
  final String? updatedAt;
  final SubscriptionSummary? subscription;

  const UserProfileResponse({
    this.id,
    this.email,
    this.name,
    this.age,
    this.gender,
    this.profileImage,
    this.notificationsEnabled = false,
    this.createdAt,
    this.updatedAt,
    this.subscription,
  });

  factory UserProfileResponse.fromJson(Map<String, dynamic> json) {
    final sub = json['subscription'];
    return UserProfileResponse(
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id']?.toString() ?? ''),
      email: json['email']?.toString(),
      name: json['name']?.toString(),
      age: json['age'] is int ? json['age'] as int : int.tryParse(json['age']?.toString() ?? ''),
      gender: json['gender']?.toString(),
      profileImage: json['profile_image']?.toString(),
      notificationsEnabled: json['notifications_enabled'] == true,
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
      subscription: sub is Map ? SubscriptionSummary.fromJson(Map<String, dynamic>.from(sub)) : null,
    );
  }
}

class SubscriptionSummary {
  final int? id;
  final int? userId;
  final String? plan;
  final String? status;
  final String? startDate;
  final String? endDate;
  final String? paymentId;

  const SubscriptionSummary({
    this.id,
    this.userId,
    this.plan,
    this.status,
    this.startDate,
    this.endDate,
    this.paymentId,
  });

  factory SubscriptionSummary.fromJson(Map<String, dynamic> json) {
    return SubscriptionSummary(
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id']?.toString() ?? ''),
      userId: json['user_id'] is int ? json['user_id'] as int : int.tryParse(json['user_id']?.toString() ?? ''),
      plan: json['plan']?.toString(),
      status: json['status']?.toString(),
      startDate: json['start_date']?.toString(),
      endDate: json['end_date']?.toString(),
      paymentId: json['payment_id']?.toString(),
    );
  }
}
