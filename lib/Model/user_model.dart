class UserModel {
  final String id;
  final String? email;
  final String? name;
  final String? profileImage;
  final String? phone;

  UserModel({
    required this.id,
    this.email,
    this.name,
    this.profileImage,
    this.phone,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final idVal = json['id'];
    final id = idVal is String
        ? idVal
        : idVal is int
            ? idVal.toString()
            : json['_id'] as String? ?? '';
    return UserModel(
      id: id.isNotEmpty ? id : (json['_id']?.toString() ?? ''),
      email: json['email'] as String?,
      name: json['name'] as String? ?? json['displayName'] as String?,
      profileImage: json['profileImage'] as String? ??
          json['profile_image'] as String? ??
          json['photoUrl'] as String? ??
          json['avatar'] as String?,
      phone: json['phone'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (email != null) 'email': email,
      if (name != null) 'name': name,
      if (profileImage != null) 'profileImage': profileImage,
      if (phone != null) 'phone': phone,
    };
  }
}
