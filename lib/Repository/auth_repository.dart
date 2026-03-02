import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:looklabs/Core/Network/api_endpoints.dart';
import 'package:looklabs/Core/Network/api_response.dart';
import 'package:looklabs/Core/Network/api_services.dart';
import 'package:looklabs/Core/Network/models/user_profile_response.dart';

const _kStorageKeyAuthToken = 'api_auth_token';

class AuthRepository {
  AuthRepository._();

  static final AuthRepository _instance = AuthRepository._();
  static AuthRepository get instance => _instance;

  static const FlutterSecureStorage _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  /// Restore API token from storage and set on [ApiServices]. Call at app start.
  /// Returns true if a token was restored.
  static Future<bool> restoreAuthToken() async {
    try {
      final token = await _storage.read(key: _kStorageKeyAuthToken);
      if (token == null || token.isEmpty) return false;
      ApiServices.setAuthToken(token);
      if (kDebugMode) {
        debugPrint('[Auth] restored token: $token');
      }
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<ApiResponse> signInWithGoogle({
    required String idToken,
    String? accessToken,
    String? name,
    String? profileImage,
  }) async {
    final response = await ApiServices.post(
      ApiEndpoints.googleSignIn,
      body: {
        'id_token': idToken,
        if (accessToken != null) 'access_token': accessToken,
        if (name != null && name.isNotEmpty) 'name': name,
        if (profileImage != null && profileImage.isNotEmpty) 'profile_image': profileImage,
      },
    );
    if (response.success && response.data != null) {
      final token = _extractToken(response.data);
      if (token != null) {
        ApiServices.setAuthToken(token);
        await _storage.write(key: _kStorageKeyAuthToken, value: token);
      }
    }
    return response;
  }

  Future<ApiResponse> logout() async {
    final response = await ApiServices.post(ApiEndpoints.logout);
    ApiServices.setAuthToken(null);
    try {
      await _storage.delete(key: _kStorageKeyAuthToken);
    } catch (_) {}
    return response;
  }

  Future<ApiResponse> refreshToken() async {
    final response = await ApiServices.post(ApiEndpoints.refreshToken);
    if (response.success && response.data != null) {
      final token = _extractToken(response.data);
      if (token != null) {
        ApiServices.setAuthToken(token);
        await _storage.write(key: _kStorageKeyAuthToken, value: token);
      }
    }
    return response;
  }

  /// GET users/me – current user profile (Bearer token).
  Future<ApiResponse> getMe() async {
    final response = await ApiServices.get(ApiEndpoints.usersMe);
    if (response.success && response.data != null && response.data is Map) {
      final raw = Map<String, dynamic>.from(response.data as Map);
      final json = raw.containsKey('data') && raw['data'] is Map
          ? Map<String, dynamic>.from(raw['data'] as Map)
          : raw;
      final profile = UserProfileResponse.fromJson(json);
      return ApiResponse(
        success: true,
        statusCode: response.statusCode,
        data: profile,
        message: response.message,
      );
    }
    return response;
  }

  Future<ApiResponse> getProfile() async {
    return getMe();
  }

  Future<ApiResponse> updateProfile(Map<String, dynamic> body) async {
    return ApiServices.put(ApiEndpoints.usersMe, body: body);
  }

  /// Extract token from API response (supports common formats)
  static String? _extractToken(dynamic data) {
    if (data == null) return null;
    if (data is Map) {
      return data['token'] as String? ??
          data['accessToken'] as String? ??
          data['access_token'] as String? ??
          (data['data'] is Map ? _extractToken(data['data']) : null);
    }
    return null;
  }
}
