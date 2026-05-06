import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:looklabs/Core/Constants/app_assets.dart';
import 'package:looklabs/Core/Network/models/iap_entitlement_response.dart';
import 'package:looklabs/Core/Network/models/iap_request_response.dart';
import 'package:looklabs/Core/Network/models/subscription_plan_response.dart';
import 'package:looklabs/Core/Services/iap_service.dart';
import 'package:looklabs/Repository/subscription_repository.dart';

class SubscriptionPlanViewModel extends ChangeNotifier {
  static const List<String> availableDomainIds = <String>[
    'facial',
    'skincare',
    'haircare',
    'workout',
    'diet',
    'fashion',
    'height',
    'quit_porn',
  ];
  static const List<String> preferredBillingPeriods = <String>[
    'monthly',
    'yearly',
  ];

  int selectedIndex = -1;
  bool _isLoadingPlans = false;
  bool _isPurchasing = false;
  String? _error;
  List<SubscriptionPlan> _plans = [];
  Map<String, ProductDetails> _storeProducts = {};
  final Set<String> _selectedDomainIds = <String>{};
  String? _selectedBillingPeriod;

  bool get isLoadingPlans => _isLoadingPlans;
  bool get isPurchasing => _isPurchasing;
  String? get error => _error;
  List<SubscriptionPlan> get plans => _plans;
  Set<String> get selectedDomainIds => Set<String>.from(_selectedDomainIds);
  String? get selectedBillingPeriod => _selectedBillingPeriod;
  int get selectedDomainCount => _selectedDomainIds.length;

  List<String> get billingPeriods {
    final periods = _plans
        .map((p) => p.billingPeriod?.trim().toLowerCase())
        .whereType<String>()
        .where((period) => period.isNotEmpty)
        .toSet();
    final ordered = <String>[
      for (final period in preferredBillingPeriods)
        if (periods.remove(period)) period,
      ...periods.toList()..sort(),
    ];
    return ordered;
  }

  List<SubscriptionPlan> get visiblePlans {
    final period = _selectedBillingPeriod;
    if (period == null || period.isEmpty) return _plans;
    return _plans
        .where((plan) => plan.billingPeriod?.trim().toLowerCase() == period)
        .toList();
  }

  SubscriptionPlan? get selectedPlan {
    if (selectedIndex < 0 || selectedIndex >= _plans.length) return null;
    return _plans[selectedIndex];
  }

  String? get domainSelectionGuidance {
    if (_selectedDomainIds.isEmpty) {
      return 'Choose at least 1 domain to continue.';
    }
    if (_selectedDomainIds.length > 3 &&
        _selectedDomainIds.length < availableDomainIds.length) {
      return 'Current catalog supports 1, 2, 3, or all 8 domains.';
    }
    return null;
  }

  bool isBillingPeriodSelected(String period) =>
      _selectedBillingPeriod == period.trim().toLowerCase();

  void selectPlan(int index) {
    selectedIndex = index;
    _selectedDomainIds.clear();
    notifyListeners();
  }

  void selectVisiblePlan(SubscriptionPlan plan) {
    final index = _plans.indexOf(plan);
    if (index == -1) return;
    selectPlan(index);
  }

  void selectBillingPeriod(String period) {
    final normalized = period.trim().toLowerCase();
    if (_selectedBillingPeriod == normalized) return;
    _selectedBillingPeriod = normalized;
    _syncSelectedPlanFromCurrentSelection();
    notifyListeners();
  }

  bool isPlanSelected(int index) {
    return selectedIndex == index;
  }

  int get selectedPlanMaxDomains {
    if (selectedIndex < 0 || selectedIndex >= _plans.length) return 0;
    return _plans[selectedIndex].maxDomainsAllowed ?? 0;
  }

  bool get requiresDomainSelection {
    final max = selectedPlanMaxDomains;
    return max > 0 && max < availableDomainIds.length;
  }

  bool get isDomainSelectionValid {
    if (!requiresDomainSelection) return true;
    return _selectedDomainIds.length == selectedPlanMaxDomains;
  }

  bool isDomainSelected(String domainId) =>
      _selectedDomainIds.contains(domainId);

  bool toggleDomainSelection(String domainId) {
    if (!availableDomainIds.contains(domainId)) return false;
    if (_selectedDomainIds.contains(domainId)) {
      _selectedDomainIds.remove(domainId);
      _syncSelectedPlanFromCurrentSelection();
      notifyListeners();
      return true;
    }
    _selectedDomainIds.add(domainId);
    _syncSelectedPlanFromCurrentSelection();
    notifyListeners();
    return true;
  }

  Future<void> loadPlans() async {
    if (_isLoadingPlans) return;
    _isLoadingPlans = true;
    _error = null;
    notifyListeners();

    final plansRes = await SubscriptionRepository.instance.getPlans();

    if (plansRes.success && plansRes.data is SubscriptionPlanResponse) {
      _plans = (plansRes.data as SubscriptionPlanResponse).plans
          .where((p) => p.resolveProductId(isIos: Platform.isIOS).isNotEmpty)
          .toList();
      if (_plans.isEmpty) {
        _error = 'No plans available right now';
      } else {
        _selectedBillingPeriod ??= billingPeriods.isNotEmpty
            ? billingPeriods.first
            : null;
        _syncSelectedPlanFromCurrentSelection();
      }
    } else {
      _error = plansRes.message ?? 'Could not load plans';
    }

    await _loadStoreProducts();
    _isLoadingPlans = false;
    notifyListeners();
  }

  Future<void> _loadStoreProducts() async {
    if (_plans.isEmpty) return;
    final available = await IapService.instance.initialize();
    if (!available) return;
    final ids = _plans
        .map((e) => e.resolveProductId(isIos: Platform.isIOS))
        .where((id) => id.isNotEmpty)
        .toSet();
    final products = await IapService.instance.loadProducts(ids);
    _storeProducts = {for (final p in products) _storeProductKey(p): p};
    debugPrint('[IAP] Store product keys: ${_storeProducts.keys.join(', ')}');
  }

  String getPlanPriceText(SubscriptionPlan plan) {
    final p = _storeProductForPlan(plan);
    if (p != null) return p.price;
    return plan.priceDisplay ?? '';
  }

  String getBillingPeriodTitle(String period) =>
      period == 'yearly' ? 'Yearly' : 'Monthly';

  String getBillingPeriodSubtitle(String period) {
    final count = _normalizedSelectedDomainCount();
    final tierText = count == null
        ? 'Select domains below to see the matching tier'
        : count >= availableDomainIds.length
        ? 'Covers all 8 domains'
        : 'Covers $count domain${count == 1 ? '' : 's'}';
    return period == 'yearly'
        ? '$tierText with yearly billing'
        : '$tierText with monthly billing';
  }

  String getBillingPeriodPriceText(String period) {
    final plan = getPlanForPeriod(period) ?? const SubscriptionPlan();
    return getPlanPriceText(plan);
  }

  SubscriptionPlan? getPlanForPeriod(String period) {
    final normalizedPeriod = period.trim().toLowerCase();
    final selectedCount = _normalizedSelectedDomainCount();
    if (selectedCount != null) {
      final matching = _plans.where(
        (plan) =>
            plan.billingPeriod?.trim().toLowerCase() == normalizedPeriod &&
            (plan.maxDomainsAllowed ?? 0) == selectedCount,
      );
      if (matching.isNotEmpty) {
        return matching.first;
      }
    }
    final fallback = _plans.where(
      (plan) =>
          plan.billingPeriod?.trim().toLowerCase() == normalizedPeriod &&
          (plan.maxDomainsAllowed ?? 0) == 1,
    );
    if (fallback.isNotEmpty) return fallback.first;
    final any = _plans.where(
      (plan) => plan.billingPeriod?.trim().toLowerCase() == normalizedPeriod,
    );
    return any.isNotEmpty ? any.first : null;
  }

  String getPlanTitle(SubscriptionPlan plan) {
    final maxDomains = plan.maxDomainsAllowed ?? 0;
    if (maxDomains >= availableDomainIds.length) {
      return 'All Domains';
    }
    return '$maxDomains Domain${maxDomains == 1 ? '' : 's'}';
  }

  String getPlanDescription(SubscriptionPlan plan) {
    final maxDomains = plan.maxDomainsAllowed ?? 0;
    if (maxDomains <= 0) {
      return 'Unlock your personalized plan';
    }
    if (maxDomains >= availableDomainIds.length) {
      return 'Full access to every transformation track in the app';
    }
    if (maxDomains == 1) {
      return 'Pick the one area you want to improve first';
    }
    return 'Mix and match any $maxDomains focus areas';
  }

  String getPriceSourceLabel(SubscriptionPlan plan) {
    final product = _storeProductForPlan(plan);
    return product == null
        ? 'Price from API'
        : Platform.isIOS
        ? 'Price from App Store'
        : 'Price from Google Play';
  }

  List<Map<String, dynamic>> get subscriptionData {
    final count = _normalizedSelectedDomainCount();
    if (count == null) {
      return [
        {
          'title': 'Pick Your Domains',
          'subtitle':
              'Choose 1, 2, 3, or all 8 domains and we will match the right plan.',
          'image': AppAssets.aiIcon,
        },
        {
          'title': 'Monthly Or Yearly',
          'subtitle':
              'Select the billing cycle first, then see the store price for that tier.',
          'image': AppAssets.instIcon,
        },
        {
          'title': 'Real Store Pricing',
          'subtitle':
              'The amount shown comes from the active App Store or Google Play product.',
          'image': AppAssets.privacyIcon,
        },
      ];
    }

    final tierTitle = count >= availableDomainIds.length
        ? 'All 8 Domains'
        : '$count Domain${count == 1 ? '' : 's'}';
    final tierSubtitle = count >= availableDomainIds.length
        ? 'Unlock every transformation track in the app with one subscription.'
        : count == 1
        ? 'Start with one focused area and build your routine there first.'
        : 'Mix the domains you care about most inside one subscription.';

    return [
      {'title': tierTitle, 'subtitle': tierSubtitle, 'image': AppAssets.aiIcon},
      {
        'title': 'Billing Matches This Tier',
        'subtitle':
            'Monthly and yearly cards now show the real store price for this domain count.',
        'image': AppAssets.instIcon,
      },
      {
        'title': 'Upgrade Path',
        'subtitle':
            'If you change the number of selected domains, the app switches to the matching plan tier.',
        'image': AppAssets.privacyIcon,
      },
    ];
  }

  ProductDetails? _storeProductForPlan(SubscriptionPlan plan) {
    final productId = plan.resolveProductId(isIos: Platform.isIOS);
    if (productId.isEmpty) return null;
    if (!Platform.isAndroid) return _storeProducts[productId];

    final basePlanId = plan.googleBasePlanId?.trim();
    if (basePlanId != null && basePlanId.isNotEmpty) {
      final keyedProduct = _storeProducts['$productId::$basePlanId'];
      if (keyedProduct != null) return keyedProduct;
    }

    final matchingProducts = _storeProducts.values.where(
      (p) => p.id == productId,
    );
    return matchingProducts.isEmpty ? null : matchingProducts.first;
  }

  String? _googleOfferTokenForPlan(
    SubscriptionPlan plan,
    ProductDetails product,
  ) {
    if (!Platform.isAndroid || product is! GooglePlayProductDetails) {
      return null;
    }
    final basePlanId = plan.googleBasePlanId?.trim();
    if (basePlanId == null || basePlanId.isEmpty) {
      return product.offerToken;
    }
    final offers = product.productDetails.subscriptionOfferDetails;
    final index = product.subscriptionIndex;
    if (offers != null && index != null && index < offers.length) {
      final offer = offers[index];
      if (offer.basePlanId == basePlanId) return offer.offerIdToken;
    }
    return product.offerToken;
  }

  String _storeProductKey(ProductDetails product) {
    if (Platform.isAndroid && product is GooglePlayProductDetails) {
      final offers = product.productDetails.subscriptionOfferDetails;
      final index = product.subscriptionIndex;
      if (offers != null && index != null && index < offers.length) {
        return '${product.id}::${offers[index].basePlanId}';
      }
    }
    return product.id;
  }

  void _syncSelectedPlanFromCurrentSelection() {
    final period = _selectedBillingPeriod;
    if (period == null || period.isEmpty) {
      selectedIndex = -1;
      return;
    }

    final targetMaxDomains = _normalizedSelectedDomainCount();

    if (targetMaxDomains == null) {
      selectedIndex = -1;
      return;
    }

    final index = _plans.indexWhere(
      (plan) =>
          plan.billingPeriod?.trim().toLowerCase() == period &&
          (plan.maxDomainsAllowed ?? 0) == targetMaxDomains,
    );
    selectedIndex = index;
  }

  int? _normalizedSelectedDomainCount() {
    if (_selectedDomainIds.isEmpty) return null;
    if (_selectedDomainIds.length >= availableDomainIds.length) {
      return availableDomainIds.length;
    }
    if (_selectedDomainIds.isNotEmpty && _selectedDomainIds.length <= 3) {
      return _selectedDomainIds.length;
    }
    return null;
  }

  Future<bool> subscribeSelectedPlan() async {
    if (_selectedDomainIds.isEmpty) {
      _error = 'Choose at least 1 domain';
      notifyListeners();
      return false;
    }
    if (_selectedDomainIds.length > 3 &&
        _selectedDomainIds.length < availableDomainIds.length) {
      _error = 'Choose 1, 2, 3, or all 8 domains';
      notifyListeners();
      return false;
    }
    if (selectedIndex < 0 || selectedIndex >= _plans.length) {
      _error = 'Selected combination is not available';
      notifyListeners();
      return false;
    }
    final plan = _plans[selectedIndex];
    final bool isIos = Platform.isIOS;
    final productId = plan.resolveProductId(isIos: isIos);
    if (productId.isEmpty) {
      _error = 'Selected plan is not configured';
      notifyListeners();
      return false;
    }
    if (!isDomainSelectionValid) {
      _error = 'Please select exactly $selectedPlanMaxDomains domains';
      notifyListeners();
      return false;
    }

    final storeProduct = _storeProductForPlan(plan);
    if (storeProduct == null) {
      _error = 'Selected plan is not available in the store';
      notifyListeners();
      return false;
    }

    _isPurchasing = true;
    _error = null;
    notifyListeners();
    final preview = await SubscriptionRepository.instance.previewUpgrade(
      UpgradePreviewRequest(
        targetPlanCode: plan.planCode.isNotEmpty ? plan.planCode : plan.id,
        provider: isIos ? 'apple' : 'google',
        selectedDomainIds: _selectedDomainIds.toList(),
      ),
    );
    if (preview.statusCode != 404 && preview.statusCode != 405) {
      if (!preview.success) {
        _isPurchasing = false;
        _error = preview.message ?? 'Could not validate plan selection';
        notifyListeners();
        return false;
      }
      final data = preview.data;
      if (data is Map<String, dynamic> && data['allowed'] == false) {
        _isPurchasing = false;
        _error = data['reason']?.toString() ?? 'Upgrade not allowed';
        notifyListeners();
        return false;
      }
    }

    final selectedDomains = _selectedDomainIds.toList();
    debugPrint(
      '[IAP] Selected plan=${plan.planCode} period=${plan.billingPeriod} '
      'product=$productId basePlan=${plan.googleBasePlanId} '
      'storeProduct=${_storeProductKey(storeProduct)}',
    );
    final started = await IapService.instance.buySubscription(
      productId,
      productDetails: storeProduct,
      googleOfferToken: _googleOfferTokenForPlan(plan, storeProduct),
      selectedDomainIds: selectedDomains,
    );
    _isPurchasing = false;
    if (!started) {
      _error = 'Could not start purchase. Please try again.';
    }
    notifyListeners();
    return started;
  }

  Future<bool> waitForEntitlementActivation({
    Duration timeout = const Duration(seconds: 20),
    Duration interval = const Duration(seconds: 2),
  }) async {
    final end = DateTime.now().add(timeout);
    while (DateTime.now().isBefore(end)) {
      final res = await SubscriptionRepository.instance.getEntitlement();
      if (res.success && res.data is IapEntitlementResponse) {
        final ent = res.data as IapEntitlementResponse;
        if (ent.isActive) return true;
      }
      await Future<void>.delayed(interval);
    }
    return false;
  }

  Future<bool> assignAdditionalDomains(List<String> domainIds) async {
    if (domainIds.isEmpty) return true;
    final res = await SubscriptionRepository.instance.assignDomains(
      AssignDomainsRequest(domainIdsToAdd: domainIds),
    );
    if (!res.success) {
      _error = res.message ?? 'Could not assign domains';
      notifyListeners();
      return false;
    }
    return true;
  }
}
