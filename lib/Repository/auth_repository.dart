import 'package:looklabs/Core/Network/api_endpoints.dart';
import 'package:looklabs/Core/Network/api_services.dart';

/// Authentication repository - handles all auth-related API calls
class AuthRepository {
  AuthRepository._();

  static final AuthRepository _instance = AuthRepository._();
  static AuthRepository get instance => _instance;

  /// Login with email and password
  Future<ApiResponse> login({
    required String email,
    required String password,
  }) async {
    final response = await ApiServices.post(
      ApiEndpoints.login,
      body: {
        'email': email,
        'password': password,
      },
    );

    if (response.success && response.data != null) {
      final token = _extractToken(response.data);
      if (token != null) {
        ApiServices.setAuthToken(token);
      }
    }
    return response;
  }

  /// Register new user
  Future<ApiResponse> register({
    required String email,
    required String password,
    String? name,
    String? phone,
    Map<String, dynamic>? extraFields,
  }) async {
    final body = <String, dynamic>{
      'email': email,
      'password': password,
      if (name != null) 'name': name,
      if (phone != null) 'phone': phone,
      if (extraFields != null) ...extraFields,
    };
    final response = await ApiServices.post(ApiEndpoints.register, body: body);

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

  /// Forgot password - send reset link to email
  Future<ApiResponse> forgotPassword({required String email}) async {
    return ApiServices.post(
      ApiEndpoints.forgotPassword,
      body: {'email': email},
    );
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
