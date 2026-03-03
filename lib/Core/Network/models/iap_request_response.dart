/// Request body for POST iap/validate-receipt. Align field names with backend.
class ValidateReceiptRequest {
  final String platform; // "android" | "ios"
  final String productId;
  final String? purchaseToken; // Android
  final String? orderId; // Android
  final String? receiptData; // iOS (base64)
  final String? transactionId; // iOS

  const ValidateReceiptRequest({
    required this.platform,
    required this.productId,
    this.purchaseToken,
    this.orderId,
    this.receiptData,
    this.transactionId,
  });

  Map<String, dynamic> toJson() => {
        'platform': platform,
        'product_id': productId,
        if (purchaseToken != null) 'purchase_token': purchaseToken,
        if (orderId != null) 'order_id': orderId,
        if (receiptData != null) 'receipt_data': receiptData,
        if (transactionId != null) 'transaction_id': transactionId,
      };
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
  final String platform;
  final String productId;
  final String? purchaseToken;
  final String? orderId;
  final String? transactionId;

  const RestorePurchaseItem({
    required this.platform,
    required this.productId,
    this.purchaseToken,
    this.orderId,
    this.transactionId,
  });

  Map<String, dynamic> toJson() => {
        'platform': platform,
        'product_id': productId,
        if (purchaseToken != null) 'purchase_token': purchaseToken,
        if (orderId != null) 'order_id': orderId,
        if (transactionId != null) 'transaction_id': transactionId,
      };
}
