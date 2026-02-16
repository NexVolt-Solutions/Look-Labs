import 'package:looklabs/Model/user_model.dart';

class AuthResponseModel {
  final String? token;
  final String? accessToken;
  final String? refreshToken;
  final UserModel? user;
  final int? expiresIn;

  AuthResponseModel({
    this.token,
    this.accessToken,
    this.refreshToken,
    this.user,
    this.expiresIn,
  });

  String? get authToken => token ?? accessToken;

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    UserModel? user;
    if (json['user'] != null && json['user'] is Map) {
      user = UserModel.fromJson(json['user'] as Map<String, dynamic>);
    } else if (json['data'] != null &&
        json['data'] is Map &&
        (json['data'] as Map)['user'] != null) {
      user = UserModel.fromJson(
        (json['data'] as Map<String, dynamic>)['user'] as Map<String, dynamic>,
      );
    }
    return AuthResponseModel(
      token: json['token'] as String?,
      accessToken:
          json['accessToken'] as String? ?? json['access_token'] as String?,
      refreshToken:
          json['refreshToken'] as String? ?? json['refresh_token'] as String?,
      user: user,
      expiresIn: json['expiresIn'] as int? ?? json['expires_in'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (token != null) 'token': token,
      if (accessToken != null) 'accessToken': accessToken,
      if (refreshToken != null) 'refreshToken': refreshToken,
      if (user != null) 'user': user!.toJson(),
      if (expiresIn != null) 'expiresIn': expiresIn,
    };
  }
}
