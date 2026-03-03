import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:looklabs/Core/Network/models/iap_request_response.dart';
import 'package:looklabs/Repository/subscription_repository.dart';

/// Wraps in_app_purchase and backend: load products, purchase, validate receipt, restore.
/// Call [initialize] once (e.g. from app start or before subscription screen).
class IapService {
  IapService._();

  static final IapService _instance = IapService._();
  static IapService get instance => _instance;

  final InAppPurchase _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;
  bool _initialized = false;
  bool _storeAvailable = false;
  bool get isAvailable => _initialized && _storeAvailable;

  /// Call once. Returns true if store is available.
  Future<bool> initialize() async {
    if (_initialized) return _storeAvailable;
    _initialized = true;
    _storeAvailable = await _iap.isAvailable();
    if (!_storeAvailable) {
      if (kDebugMode) {
        debugPrint('[IAP] Store not available (emulator or not configured)');
      }
      return false;
    }
    _subscription = _iap.purchaseStream.listen(
      _onPurchaseUpdates,
      onDone: () => _subscription?.cancel(),
      onError: (e) => debugPrint('[IAP] purchaseStream error: $e'),
    );
    return _storeAvailable;
  }

  void _onPurchaseUpdates(List<PurchaseDetails> purchases) {
    for (final p in purchases) {
      if (p.status == PurchaseStatus.purchased || p.status == PurchaseStatus.restored) {
        // Validate with backend (caller may do this after purchase flow)
        _validatePurchase(p);
      } else if (p.status == PurchaseStatus.error) {
        debugPrint('[IAP] Purchase error: ${p.error?.message}');
      }
    }
  }

  Future<void> _validatePurchase(PurchaseDetails p) async {
    final productId = p.productID;
    final serverData = p.verificationData.serverVerificationData;
    if (serverData.isEmpty) return;
    if (Platform.isAndroid) {
      final req = ValidateReceiptRequest(
        platform: 'android',
        productId: productId,
        purchaseToken: serverData,
        orderId: p.purchaseID,
      );
      await SubscriptionRepository.instance.validateReceipt(req);
    } else if (Platform.isIOS) {
      final req = ValidateReceiptRequest(
        platform: 'ios',
        productId: productId,
        receiptData: serverData,
        transactionId: p.purchaseID,
      );
      await SubscriptionRepository.instance.validateReceipt(req);
    }
  }

  /// Load products by IDs (from GET subscriptions/plans product_id). Returns store product details.
  Future<List<ProductDetails>> loadProducts(Set<String> productIds) async {
    if (!_initialized) await initialize();
    if (!_storeAvailable || productIds.isEmpty) return [];
    final response = await _iap.queryProductDetails(productIds);
    if (response.notFoundIDs.isNotEmpty) {
      debugPrint('[IAP] Not found: ${response.notFoundIDs}');
    }
    return response.productDetails;
  }

  /// Start purchase flow for [productId]. User completes in store. On success, receipt is validated with backend via stream.
  Future<bool> buySubscription(String productId) async {
    if (!_initialized) await initialize();
    if (!_storeAvailable) return false;
    final products = await loadProducts({productId});
    if (products.isEmpty) return false;
    final product = products.first;
    final purchaseParam = PurchaseParam(productDetails: product);
    return _iap.buyNonConsumable(purchaseParam: purchaseParam);
  }

  /// Restore past purchases. Store will emit restored items on purchaseStream; we validate each with backend.
  Future<bool> restorePurchases() async {
    if (!_initialized) await initialize();
    if (!_storeAvailable) return false;
    await _iap.restorePurchases();
    return true;
  }

  void dispose() {
    _subscription?.cancel();
  }
}
