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
  final String provider; // apple | google
  final String productId;
  final String? planCode;
  final String? purchaseToken; // Android
  final String? orderId; // Android
  final String? receiptData; // iOS (base64)
  final String? transactionId; // iOS

  const ValidateReceiptRequest({
    required this.provider,
    required this.productId,
    this.planCode,
    this.purchaseToken,
    this.orderId,
    this.receiptData,
    this.transactionId,
  });

  Map<String, dynamic> toJson() => {
        'provider': provider,
        'product_id': productId,
        if (planCode != null) 'plan_code': planCode,
        if (purchaseToken != null) 'purchase_token': purchaseToken,
        if (orderId != null) 'order_id': orderId,
        if (receiptData != null) 'receipt_data': receiptData,
        if (transactionId != null) 'transaction_id': transactionId,
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
