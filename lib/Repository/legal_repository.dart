import 'package:looklabs/Core/Network/api_endpoints.dart';
import 'package:looklabs/Core/Network/api_response.dart';
import 'package:looklabs/Core/Network/api_services.dart';
import 'package:looklabs/Core/Network/models/privacy_policy_response.dart';

/// Repository for legal content (privacy policy, terms). No auth required.
class LegalRepository {
  LegalRepository._();

  static final LegalRepository _instance = LegalRepository._();
  static LegalRepository get instance => _instance;

  /// GET legal/privacy-policy. Returns structured privacy policy or error.
  Future<ApiResponse> getPrivacyPolicy() async {
    final response = await ApiServices.get(ApiEndpoints.privacyPolicy);
    if (response.success && response.data is Map<String, dynamic>) {
      final data = PrivacyPolicyResponse.fromJson(
        Map<String, dynamic>.from(response.data as Map),
      );
      return ApiResponse(
        success: true,
        statusCode: response.statusCode,
        data: data,
        message: response.message,
      );
    }
    return response;
  }

  /// GET legal/terms-of-service. Returns structured terms or error. Same JSON shape as privacy policy.
  Future<ApiResponse> getTermsOfService() async {
    final response = await ApiServices.get(ApiEndpoints.termsOfService);
    if (response.success && response.data is Map<String, dynamic>) {
      final data = PrivacyPolicyResponse.fromJson(
        Map<String, dynamic>.from(response.data as Map),
      );
      return ApiResponse(
        success: true,
        statusCode: response.statusCode,
        data: data,
        message: response.message,
      );
    }
    return response;
  }
}
