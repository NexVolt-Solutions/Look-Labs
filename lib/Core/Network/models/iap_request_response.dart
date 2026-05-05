enum IapProvider { apple, google }

extension IapProviderValue on IapProvider {
  String get value => this == IapProvider.apple ? 'apple' : 'google';
}

/// Request body for POST iap/upgrade-preview.
class UpgradePreviewRequest {
  final String planCode; // domain_1 | domain_2 | domain_3 | domain_all

  const UpgradePreviewRequest({required this.planCode});

  Map<String, dynamic> toJson() => {'plan_code': planCode};
}

/// Request body for POST iap/validate-receipt.
class ValidateReceiptRequest {
  final String provider; // "google" | "apple"
  final String productId;
  final List<String> selectedDomainIds;
  final String? purchaseToken; // Android
  final String? orderId; // Android
  final String? receiptData; // iOS (base64)
  final String? transactionId; // iOS
  final String? platformTransactionId; // Unified contract field
  final String? idempotencyKey;

  const ValidateReceiptRequest({
    required this.provider,
    required this.productId,
    this.selectedDomainIds = const [],
    this.purchaseToken,
    this.orderId,
    this.receiptData,
    this.transactionId,
    this.platformTransactionId,
    this.idempotencyKey,
  });

  Map<String, dynamic> toJson() => {
        'provider': provider,
        // Backward-compatible alias for older backend contracts.
        'platform': provider == 'google' ? 'android' : 'ios',
        'product_id': productId,
        if (selectedDomainIds.isNotEmpty) 'selected_domain_ids': selectedDomainIds,
        if (purchaseToken != null) 'purchase_token': purchaseToken,
        if (orderId != null) 'order_id': orderId,
        if (receiptData != null) 'receipt_data': receiptData,
        if (transactionId != null) 'transaction_id': transactionId,
        if (platformTransactionId != null)
          'platform_transaction_id': platformTransactionId,
        if (idempotencyKey != null) 'idempotency_key': idempotencyKey,
      };
}

/// Request body for POST iap/assign-domains.
class AssignDomainsRequest {
  final List<String> domains;

  const AssignDomainsRequest({this.domains = const []});

  Map<String, dynamic> toJson() => {'domains': domains};
}

/// Request body for POST iap/restore-purchases. Send list of purchases from store.
class RestorePurchasesRequest {
  final List<RestorePurchaseItem> purchases;

  const RestorePurchasesRequest({this.purchases = const []});

  Map<String, dynamic> toJson() => {
        'purchases': purchases.map((e) => e.toJson()).toList(),
      };
}

class RestorePurchaseItem {
  final String provider; // apple | google
  final String productId;
  final String? purchaseToken;
  final String? orderId;
  final String? transactionId;

  const RestorePurchaseItem({
    required this.provider,
    required this.productId,
    this.purchaseToken,
    this.orderId,
    this.transactionId,
  });

  Map<String, dynamic> toJson() => {
        'provider': provider,
        'product_id': productId,
        if (purchaseToken != null) 'purchase_token': purchaseToken,
        if (orderId != null) 'order_id': orderId,
        if (transactionId != null) 'transaction_id': transactionId,
      };
}

class UpgradePreviewRequest {
  final String targetPlanCode;
  final List<String> selectedDomainIds;
  final String provider; // "google" | "apple"

  const UpgradePreviewRequest({
    required this.targetPlanCode,
    required this.provider,
    this.selectedDomainIds = const [],
  });

  Map<String, dynamic> toJson() => {
        'target_plan_code': targetPlanCode,
        'selected_domain_ids': selectedDomainIds,
        'provider': provider,
      };
}

class AssignDomainsRequest {
  final List<String> domainIdsToAdd;

  const AssignDomainsRequest({this.domainIdsToAdd = const []});

  Map<String, dynamic> toJson() => {'domain_ids_to_add': domainIdsToAdd};
}
