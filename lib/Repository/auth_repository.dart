import 'package:flutter/foundation.dart';
import 'package:looklabs/Core/Network/api_config.dart';
import 'package:looklabs/Core/Network/api_endpoints.dart';
import 'package:looklabs/Core/Network/api_response.dart';
import 'package:looklabs/Core/Network/api_services.dart';

/// Authentication repository - Google Sign-In only
class AuthRepository {
  AuthRepository._();

  static final AuthRepository _instance = AuthRepository._();
  static AuthRepository get instance => _instance;

  static void _log(String method, String endpoint, ApiResponse response) {
    debugPrint(
      '[AuthRepository] $method $endpoint → success=${response.success} statusCode=${response.statusCode} message=${response.message}',
    );
    if (!response.success && response.data != null) {
      final dataStr = response.data.toString();
      debugPrint(
        '[AuthRepository] failure body: ${dataStr.length > 400 ? "${dataStr.substring(0, 400)}..." : dataStr}',
      );
    }
  }

  /// Sign in with Google - pass the idToken from google_sign_in package
  /// Backend validates the token and returns app JWT
  Future<ApiResponse> signInWithGoogle({
    required String idToken,
    String? accessToken,
  }) async {
    final endpoint = ApiEndpoints.googleSignIn;
    final fullUrl = ApiConfig.getFullUrl(endpoint);
    debugPrint(
      '[AuthRepository] POST $endpoint (idToken length=${idToken.length}, accessToken=${accessToken != null})',
    );
    debugPrint('[AuthRepository] URL: $fullUrl');
    final body = <String, dynamic>{
      'id_token': idToken,
      if (accessToken != null) 'access_token': accessToken,
    };
    final response = await ApiServices.post(endpoint, body: body);
    _log('POST', endpoint, response);
    if (response.success && response.data != null) {
      final token = _extractToken(response.data);
      if (token != null) {
        ApiServices.setAuthToken(token);
        debugPrint('[AuthRepository] Auth token set (length=${token.length})');
      }
    }
    return response;
  }

  /// Logout - clears token and calls logout endpoint
  Future<ApiResponse> logout() async {
    final endpoint = ApiEndpoints.logout;
    debugPrint('[AuthRepository] POST $endpoint');
    final response = await ApiServices.post(endpoint);
    _log('POST', endpoint, response);
    ApiServices.setAuthToken(null);
    debugPrint('[AuthRepository] Auth token cleared');
    return response;
  }

  /// Refresh auth token
  Future<ApiResponse> refreshToken() async {
    final endpoint = ApiEndpoints.refreshToken;
    debugPrint('[AuthRepository] POST $endpoint');
    final response = await ApiServices.post(endpoint);
    _log('POST', endpoint, response);
    if (response.success && response.data != null) {
      final token = _extractToken(response.data);
      if (token != null) {
        ApiServices.setAuthToken(token);
        debugPrint('[AuthRepository] Auth token refreshed');
      }
    }
    return response;
  }

  /// Get current user profile
  Future<ApiResponse> getProfile() async {
    final endpoint = ApiEndpoints.profile;
    debugPrint('[AuthRepository] GET $endpoint');
    final response = await ApiServices.get(endpoint);
    _log('GET', endpoint, response);
    return response;
  }

  /// Update profile (if your API supports PATCH/PUT on profile)
  Future<ApiResponse> updateProfile(Map<String, dynamic> body) async {
    final endpoint = ApiEndpoints.profile;
    debugPrint('[AuthRepository] PUT $endpoint');
    final response = await ApiServices.put(endpoint, body: body);
    _log('PUT', endpoint, response);
    return response;
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
