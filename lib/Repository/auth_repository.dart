import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:looklabs/Core/Network/api_endpoints.dart';
import 'package:looklabs/Core/Network/api_response.dart';
import 'package:looklabs/Core/Network/api_services.dart';
import 'package:looklabs/Core/Network/models/user_profile_response.dart';

const _kStorageKeyAuthToken = 'api_auth_token';
const _kStorageKeyRefreshToken = 'api_refresh_token';
const _kStorageKeyProfileCache = 'user_profile_cache';
const _kStorageKeySelectedDomain = 'user_selected_domain';

class AuthRepository {
  AuthRepository._();

  static final AuthRepository _instance = AuthRepository._();
  static AuthRepository get instance => _instance;

  static const FlutterSecureStorage _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

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
        if (profileImage != null && profileImage.isNotEmpty)
          'profile_image': profileImage,
      },
    );
    if (response.success && response.data != null) {
      final data = response.data is Map ? response.data as Map : null;
      final token = _extractToken(data);
      if (token != null) {
        ApiServices.setAuthToken(token);
        await _storage.write(key: _kStorageKeyAuthToken, value: token);
      }
      final refreshToken = _extractRefreshToken(data);
      if (refreshToken != null && refreshToken.isNotEmpty) {
        await _storage.write(
          key: _kStorageKeyRefreshToken,
          value: refreshToken,
        );
      }
    }
    return response;
  }

  /// Clear tokens locally without calling logout API. Use when refresh fails (expired/invalid).
  static Future<void> clearTokensLocally() async {
    ApiServices.setAuthToken(null);
    try {
      await _storage.delete(key: _kStorageKeyAuthToken);
      await _storage.delete(key: _kStorageKeyRefreshToken);
      await _storage.delete(key: _kStorageKeyProfileCache);
    } catch (_) {}
    if (kDebugMode) {
      debugPrint('[Auth] Cleared tokens locally (refresh failed or token expired)');
    }
  }

  /// POST /api/v1/auth/sign-out with body { "refresh_token": "..." }. Clears local tokens regardless of response.
  /// Selected domain is kept so same-account re-login still shows the correct plan as enabled.
  Future<ApiResponse> logout() async {
    String? refreshToken;
    try {
      refreshToken = await _storage.read(key: _kStorageKeyRefreshToken);
    } catch (_) {}

    final response = await ApiServices.post(
      ApiEndpoints.logout,
      body: {'refresh_token': refreshToken ?? ''},
    );

    ApiServices.setAuthToken(null);
    try {
      await _storage.delete(key: _kStorageKeyAuthToken);
      await _storage.delete(key: _kStorageKeyRefreshToken);
      await _storage.delete(key: _kStorageKeyProfileCache);
      // Do not clear _kStorageKeySelectedDomain so re-login with same account shows correct plan.
      // If backend adds selected_domain to GET users/me, we can clear here and restore from API.
    } catch (_) {}
    return response;
  }

  /// Persist the user's selected domain from onboarding (e.g. PATCH link response). Used for domains/questions and domains/answers.
  static Future<void> setSelectedDomain(String? domain) async {
    try {
      if (domain == null || domain.isEmpty) {
        await _storage.delete(key: _kStorageKeySelectedDomain);
      } else {
        await _storage.write(key: _kStorageKeySelectedDomain, value: domain.trim());
      }
    } catch (_) {}
  }

  /// Load the user's selected domain (from onboarding session link). Returns null if not set.
  static Future<String?> getSelectedDomain() async {
    try {
      return await _storage.read(key: _kStorageKeySelectedDomain);
    } catch (_) {
      return null;
    }
  }

  Future<ApiResponse> refreshToken() async {
    String? refreshToken;
    try {
      refreshToken = await _storage.read(key: _kStorageKeyRefreshToken);
    } catch (_) {}
    if (refreshToken == null || refreshToken.isEmpty) {
      return ApiResponse(
        success: false,
        statusCode: 401,
        message: 'No refresh token',
      );
    }

    ApiServices.setAuthToken(null);
    final response = await ApiServices.post(
      ApiEndpoints.refreshToken,
      body: {'refresh_token': refreshToken},
    );

    if (response.success && response.data != null) {
      final data = response.data is Map ? response.data as Map : null;
      final token = _extractToken(data);
      if (token != null) {
        ApiServices.setAuthToken(token);
        await _storage.write(key: _kStorageKeyAuthToken, value: token);
      }
      final newRefresh = _extractRefreshToken(data);
      if (newRefresh != null && newRefresh.isNotEmpty) {
        await _storage.write(key: _kStorageKeyRefreshToken, value: newRefresh);
      }
    }
    return response;
  }

  /// Loads cached profile from secure storage. Returns null if missing or invalid.
  static Future<UserProfileResponse?> loadCachedProfile() async {
    try {
      final jsonStr = await _storage.read(key: _kStorageKeyProfileCache);
      if (jsonStr == null || jsonStr.isEmpty) return null;
      final map = jsonDecode(jsonStr) as Map<String, dynamic>?;
      if (map == null) return null;
      return UserProfileResponse.fromJson(map);
    } catch (_) {
      return null;
    }
  }

  /// Clears profile cache. Call on logout.
  static Future<void> clearProfileCache() async {
    try {
      await _storage.delete(key: _kStorageKeyProfileCache);
    } catch (_) {}
  }

  static Future<void> _saveProfileToStorage(Map<String, dynamic> json) async {
    try {
      await _storage.write(
        key: _kStorageKeyProfileCache,
        value: jsonEncode(json),
      );
    } catch (_) {}
  }

  /// GET users/me – current user profile (Bearer token). Caches on success.
  Future<ApiResponse> getMe() async {
    final response = await ApiServices.get(ApiEndpoints.usersMe);
    if (response.success && response.data != null && response.data is Map) {
      final raw = Map<String, dynamic>.from(response.data as Map);
      final json = raw.containsKey('data') && raw['data'] is Map
          ? Map<String, dynamic>.from(raw['data'] as Map)
          : raw;
      final profile = UserProfileResponse.fromJson(json);
      await _saveProfileToStorage(json);
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

  /// PATCH /api/v1/users/me – update name, age, gender, profile_image, notifications_enabled.
  Future<ApiResponse> updateProfile(Map<String, dynamic> body) async {
    return ApiServices.patch(ApiEndpoints.usersMe, body: body);
  }

  /// DELETE /api/v1/users/me – deletes current user and all data. Clears local tokens after call.
  Future<ApiResponse> deleteAccount() async {
    final response = await ApiServices.delete(ApiEndpoints.usersMe);
    ApiServices.setAuthToken(null);
    try {
      await _storage.delete(key: _kStorageKeyAuthToken);
      await _storage.delete(key: _kStorageKeyRefreshToken);
      await _storage.delete(key: _kStorageKeyProfileCache);
      await _storage.delete(key: _kStorageKeySelectedDomain);
    } catch (_) {}
    return response;
  }

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

  static String? _extractRefreshToken(dynamic data) {
    if (data == null) return null;
    if (data is Map) {
      final v =
          data['refreshToken'] as String? ?? data['refresh_token'] as String?;
      if (v != null && v.isNotEmpty) return v;
      if (data['data'] is Map) return _extractRefreshToken(data['data']);
    }
    return null;
  }
}
