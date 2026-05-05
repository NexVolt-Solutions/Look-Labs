import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
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

  int selectedIndex = -1;
  bool _isLoadingPlans = false;
  bool _isPurchasing = false;
  String? _error;
  List<SubscriptionPlan> _plans = [];
  Map<String, ProductDetails> _storeProducts = {};
  final Set<String> _selectedDomainIds = <String>{};

  bool get isLoadingPlans => _isLoadingPlans;
  bool get isPurchasing => _isPurchasing;
  String? get error => _error;
  List<SubscriptionPlan> get plans => _plans;
  Set<String> get selectedDomainIds => Set<String>.from(_selectedDomainIds);

  void selectPlan(int index) {
    selectedIndex = index;
    _selectedDomainIds.clear();
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

  bool isDomainSelected(String domainId) => _selectedDomainIds.contains(domainId);

  bool toggleDomainSelection(String domainId) {
    if (!availableDomainIds.contains(domainId)) return false;
    if (_selectedDomainIds.contains(domainId)) {
      _selectedDomainIds.remove(domainId);
      notifyListeners();
      return true;
    }
    final max = selectedPlanMaxDomains;
    if (max > 0 && _selectedDomainIds.length >= max) {
      return false;
    }
    _selectedDomainIds.add(domainId);
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
      _plans = (plansRes.data as SubscriptionPlanResponse)
          .plans
          .where(
            (p) =>
                p.resolveProductId(isIos: true).isNotEmpty ||
                p.productId.isNotEmpty,
          )
          .toList();
      if (_plans.isEmpty) {
        _error = 'No plans available right now';
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
    _storeProducts = {for (final p in products) p.id: p};
  }

  String getPlanPriceText(SubscriptionPlan plan) {
    final p = _storeProducts[plan.resolveProductId(isIos: false)] ??
        _storeProducts[plan.resolveProductId(isIos: true)];
    if (p != null) return p.price;
    return plan.priceDisplay ?? '';
  }

  Future<bool> subscribeSelectedPlan() async {
    if (selectedIndex < 0 || selectedIndex >= _plans.length) {
      _error = 'Please select a plan';
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
    final started = await IapService.instance.buySubscription(
      productId,
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

  List<Map<String, dynamic>> subscriptionData = [
    {
      'title': 'AI-Powered Analysis',
      'subtitle':
          'Get personalized recommendations based on your unique features',
      'image': AppAssets.aiIcon,
    },
    {
      'title': 'Instant Transformation',
      'subtitle': 'See your glow-up potential with rev6fal-time AI previews',
      'image': AppAssets.instIcon,
    },
    {
      'title': 'Privacy First',
      'subtitle': 'Your photos are encrypted and never shared',
      'image': AppAssets.privacyIcon,
    },
    {
      'title': 'Premium Filters',
      'subtitle': 'Access 50+ exclusive enhancement filters',
      'image': AppAssets.premIcon,
    },
  ];
}
