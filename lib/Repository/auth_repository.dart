import 'package:looklabs/Core/Network/api_endpoints.dart';
import 'package:looklabs/Core/Network/api_services.dart';

/// Authentication repository - Google Sign-In only
class AuthRepository {
  AuthRepository._();

  static final AuthRepository _instance = AuthRepository._();
  static AuthRepository get instance => _instance;

  /// Sign in with Google - pass the idToken from google_sign_in package
  /// Backend validates the token and returns app JWT
  Future<ApiResponse> signInWithGoogle({
    required String idToken,
    String? accessToken,
  }) async {
    final body = <String, dynamic>{
      'idToken': idToken,
      if (accessToken != null) 'accessToken': accessToken,
    };
    final response = await ApiServices.post(
      ApiEndpoints.googleSignIn,
      body: body,
    );

    if (response.success && response.data != null) {
      final token = _extractToken(response.data);
      if (token != null) {
        ApiServices.setAuthToken(token);
      }
    }
    return response;
  }

  /// Logout - clears token and calls logout endpoint
  Future<ApiResponse> logout() async {
    final response = await ApiServices.post(ApiEndpoints.logout);
    ApiServices.setAuthToken(null);
    return response;
  }

  /// Refresh auth token
  Future<ApiResponse> refreshToken() async {
    final response = await ApiServices.post(ApiEndpoints.refreshToken);
    if (response.success && response.data != null) {
      final token = _extractToken(response.data);
      if (token != null) {
        ApiServices.setAuthToken(token);
      }
    }
    return response;
  }

  /// Get current user profile
  Future<ApiResponse> getProfile() async {
    return ApiServices.get(ApiEndpoints.profile);
  }

  /// Update profile (if your API supports PATCH/PUT on profile)
  Future<ApiResponse> updateProfile(Map<String, dynamic> body) async {
    return ApiServices.put(ApiEndpoints.profile, body: body);
  }

  /// Extract token from API response (supports common formats)
  static String? _extractToken(dynamic data) {
    if (data == null) return null;
    if (data is Map) {
      return data['token'] as String? ??
          data['accessToken'] as String? ??
          data['access_token'] as String? ??
          (data['data'] is Map
              ? _extractToken(data['data'])
              : null);
    }
    return null;
  }
}
