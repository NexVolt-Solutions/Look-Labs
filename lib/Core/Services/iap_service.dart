import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
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
  final Map<String, List<String>> _pendingSelectedDomainsByProduct =
      <String, List<String>>{};
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
      if (p.status == PurchaseStatus.purchased ||
          p.status == PurchaseStatus.restored) {
        // Validate with backend (caller may do this after purchase flow)
        final selected =
            _pendingSelectedDomainsByProduct[p.productID] ?? const [];
        _validatePurchase(p, selectedDomainIds: selected);
        _pendingSelectedDomainsByProduct.remove(p.productID);
      } else if (p.status == PurchaseStatus.error) {
        debugPrint('[IAP] Purchase error: ${p.error?.message}');
        _pendingSelectedDomainsByProduct.remove(p.productID);
      }
      if (p.pendingCompletePurchase) {
        _iap.completePurchase(p);
      }
    }
  }

  Future<void> _validatePurchase(
    PurchaseDetails p, {
    List<String> selectedDomainIds = const [],
  }) async {
    final productId = p.productID;
    final serverData = p.verificationData.serverVerificationData;
    if (serverData.isEmpty) return;
    final txn = p.purchaseID;
    final provider = Platform.isAndroid ? 'google' : 'apple';
    final idempotencyKey = txn != null && txn.isNotEmpty
        ? '$provider-$txn'
        : '$provider-$productId';
    if (Platform.isAndroid) {
      final req = ValidateReceiptRequest(
        provider: IapProvider.google.value,
        productId: productId,
        selectedDomainIds: selectedDomainIds,
        purchaseToken: serverData,
        orderId: txn,
        platformTransactionId: txn,
        idempotencyKey: idempotencyKey,
      );
      await SubscriptionRepository.instance.validateReceipt(req);
    } else if (Platform.isIOS) {
      final req = ValidateReceiptRequest(
        provider: IapProvider.apple.value,
        productId: productId,
        selectedDomainIds: selectedDomainIds,
        receiptData: serverData,
        transactionId: txn,
        platformTransactionId: txn,
        idempotencyKey: idempotencyKey,
      );
      await SubscriptionRepository.instance.validateReceipt(req);
    }
    // Keep UI gating synchronized with backend source of truth.
    await SubscriptionRepository.instance.getEntitlement();
  }

  /// Load products by IDs from iap/plans mapping. Returns store product details.
  Future<List<ProductDetails>> loadProducts(Set<String> productIds) async {
    if (!_initialized) await initialize();
    if (!_storeAvailable || productIds.isEmpty) return [];
    debugPrint('[IAP] Query products: ${productIds.join(', ')}');
    final response = await _iap.queryProductDetails(productIds);
    if (response.notFoundIDs.isNotEmpty) {
      debugPrint('[IAP] Not found: ${response.notFoundIDs}');
    }
    for (final product in response.productDetails) {
      if (product is GooglePlayProductDetails) {
        final offerIndex = product.subscriptionIndex;
        final offers = product.productDetails.subscriptionOfferDetails;
        final offer =
            offerIndex != null && offers != null && offerIndex < offers.length
            ? offers[offerIndex]
            : null;
        debugPrint(
          '[IAP] Found Google product=${product.id} price=${product.price} '
          'basePlan=${offer?.basePlanId} offerId=${offer?.offerId} '
          'offerToken=${product.offerToken == null ? "null" : "present"}',
        );
      } else {
        debugPrint('[IAP] Found product=${product.id} price=${product.price}');
      }
    }
    return response.productDetails;
  }

  /// Start purchase flow for [productId]. User completes in store. On success, receipt is validated with backend via stream.
  Future<bool> buySubscription(
    String productId, {
    ProductDetails? productDetails,
    String? googleOfferToken,
    List<String> selectedDomainIds = const [],
  }) async {
    if (!_initialized) await initialize();
    if (!_storeAvailable) return false;
    ProductDetails? product = productDetails;
    if (product == null) {
      final products = (await loadProducts({
        productId,
      })).where((p) => p.id == productId);
      product = products.isEmpty ? null : products.first;
    }
    if (product == null) return false;
    _pendingSelectedDomainsByProduct[product.id] = selectedDomainIds;
    final purchaseParam = Platform.isAndroid
        ? GooglePlayPurchaseParam(
            productDetails: product,
            offerToken: googleOfferToken,
          )
        : PurchaseParam(productDetails: product);
    debugPrint(
      '[IAP] Launch purchase product=${product.id} '
      'androidOfferToken=${googleOfferToken == null ? "null" : "present"}',
    );
    return _iap.buyNonConsumable(purchaseParam: purchaseParam);
  }

  /// Restore past purchases. Store will emit restored items on purchaseStream; we validate each with backend.
  Future<bool> restorePurchases() async {
    if (!_initialized) await initialize();
    if (!_storeAvailable) return false;
    await _iap.restorePurchases();
    await SubscriptionRepository.instance.restorePurchases(
      const RestorePurchasesRequest(),
    );
    return true;
  }

  void dispose() {
    _subscription?.cancel();
  }
}
