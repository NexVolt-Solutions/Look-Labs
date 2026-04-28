import 'package:looklabs/Core/Network/api_endpoints.dart';
import 'package:looklabs/Core/Network/api_response.dart';
import 'package:looklabs/Core/Network/api_services.dart';
import 'package:looklabs/Core/Network/models/iap_entitlement_response.dart';
import 'package:looklabs/Core/Network/models/iap_request_response.dart';
import 'package:looklabs/Core/Network/models/my_subscription_response.dart';
import 'package:looklabs/Core/Network/models/subscription_plan_response.dart';
import 'package:looklabs/Core/Network/models/subscription_status_response.dart';

/// Repository for subscription and IAP APIs. All subscription/me and IAP calls require auth (Bearer).
class SubscriptionRepository {
  SubscriptionRepository._();

  static final SubscriptionRepository _instance = SubscriptionRepository._();
  static SubscriptionRepository get instance => _instance;

  /// GET subscriptions/plans – list plans (product_id for store). Auth optional per backend.
  Future<ApiResponse> getPlans() async {
    final response = await ApiServices.get(ApiEndpoints.subscriptionPlans);
    if (response.success && response.data is Map<String, dynamic>) {
      final data = SubscriptionPlanResponse.fromJson(
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

  /// GET iap/plans – list purchasable IAP/subscription plans.
  Future<ApiResponse> getIapPlans() async {
    final response = await ApiServices.get(ApiEndpoints.iapPlans);
    if (response.success && response.data is Map<String, dynamic>) {
      final data = SubscriptionPlanResponse.fromJson(
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

  /// GET subscriptions/me – current user subscription. Requires auth.
  Future<ApiResponse> getMySubscription() async {
    final response = await ApiServices.get(ApiEndpoints.subscriptionsMe);
    if (response.success && response.data is Map<String, dynamic>) {
      final data = MySubscriptionResponse.fromJson(
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

  /// GET subscriptions/me/status – quick active check. Requires auth.
  Future<ApiResponse> getSubscriptionStatus() async {
    final response = await ApiServices.get(ApiEndpoints.subscriptionsMeStatus);
    if (response.success && response.data is Map<String, dynamic>) {
      final data = SubscriptionStatusResponse.fromJson(
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
    final response = await ApiServices.post(
      ApiEndpoints.iapValidateReceipt,
      body: request.toJson(),
      headers: {
        if (request.idempotencyKey != null &&
            request.idempotencyKey!.trim().isNotEmpty)
          'Idempotency-Key': request.idempotencyKey!,
      },
    );
    return response;
  }

  /// POST iap/restore-purchases – sync past purchases. Requires auth.
  Future<ApiResponse> restorePurchases([
    RestorePurchasesRequest request = const RestorePurchasesRequest(),
  ]) async {
    final response = await ApiServices.post(
      ApiEndpoints.iapRestorePurchases,
      body: request.toJson(),
    );
    if (response.success && response.data is Map<String, dynamic>) {
       return response;
    }
    return response;
  }

   Future<ApiResponse> getIapProducts() async {
    return ApiServices.get(ApiEndpoints.iapProducts);
  }

   Future<ApiResponse> upgradePreview(UpgradePreviewRequest request) async {
    return ApiServices.post(
      ApiEndpoints.iapUpgradePreview,
      body: request.toJson(),
    );
  }

   Future<ApiResponse> assignDomains(AssignDomainsRequest request) async {
    return ApiServices.post(
      ApiEndpoints.iapAssignDomains,
      body: request.toJson(),
    );
  }

   Future<ApiResponse> cancelSubscription(String subscriptionId) async {
    return ApiServices.patch(
      ApiEndpoints.subscriptionCancel(subscriptionId),
      body: <String, dynamic>{},
    );
  }

   Future<ApiResponse> reactivateSubscription(String subscriptionId) async {
    return ApiServices.patch(
      ApiEndpoints.subscriptionReactivate(subscriptionId),
      body: <String, dynamic>{},
    );
  }
}
