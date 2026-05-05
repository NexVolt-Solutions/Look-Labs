import 'package:looklabs/Core/Network/api_endpoints.dart';
import 'package:looklabs/Core/Network/api_response.dart';
import 'package:looklabs/Core/Network/api_services.dart';
import 'package:looklabs/Core/Network/models/iap_entitlement_response.dart';
import 'package:looklabs/Core/Network/models/iap_request_response.dart';

/// Repository for IAP domain-plan APIs.
class SubscriptionRepository {
  SubscriptionRepository._();

  static final SubscriptionRepository _instance = SubscriptionRepository._();
  static SubscriptionRepository get instance => _instance;

  /// GET iap/plans – canonical plan contract and provider product mappings.
  Future<ApiResponse> getPlans() async {
    return ApiServices.get(ApiEndpoints.iapPlans);
  }

  /// GET iap/entitlement – current entitlement source of truth.
  Future<ApiResponse> getEntitlement() async {
    return ApiServices.get(ApiEndpoints.iapEntitlement);
  }

  /// POST iap/upgrade-preview – preview target plan price and credits.
  Future<ApiResponse> previewUpgrade(UpgradePreviewRequest request) async {
    return ApiServices.post(
      ApiEndpoints.iapUpgradePreview,
      body: request.toJson(),
    );
  }

  /// GET iap/entitlement – domain access entitlements.
  Future<ApiResponse> getIapEntitlement() async {
    final response = await ApiServices.get(ApiEndpoints.iapEntitlement);
    if (response.success && response.data is Map<String, dynamic>) {
      final data = IapEntitlementResponse.fromJson(
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

  /// POST iap/validate-receipt – after store purchase. Requires auth.
  Future<ApiResponse> validateReceipt(ValidateReceiptRequest request) async {
    return ApiServices.post(
      ApiEndpoints.iapValidateReceipt,
      body: request.toJson(),
      headers: {
        if (request.idempotencyKey != null &&
            request.idempotencyKey!.trim().isNotEmpty)
          'Idempotency-Key': request.idempotencyKey!,
      },
    );
  }

  /// POST iap/assign-domains – assign selected domains to current entitlement.
  Future<ApiResponse> assignDomains(AssignDomainsRequest request) async {
    return ApiServices.post(
      ApiEndpoints.iapAssignDomains,
      body: request.toJson(),
    );
  }

  /// POST iap/restore-purchases – sync past purchases. Requires auth.
  Future<ApiResponse> restorePurchases(RestorePurchasesRequest request) async {
    return ApiServices.post(
      ApiEndpoints.iapRestorePurchases,
      body: request.toJson(),
    );
  }
}
