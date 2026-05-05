part of 'home_view_model.dart';

bool _isCompletedFlowPayload(Map<String, dynamic> data) {
  final status = data['status']?.toString().toLowerCase().trim() ?? '';
  if (status == 'completed') return true;
  if (data['completed'] == true || data['is_completed'] == true) return true;

  const resultKeys = {
    'ai_message',
    'ai_progress',
    'ai_recovery',
    'ai_attributes',
    'ai_exercises',
    'result',
    'recommendations',
  };
  for (final k in resultKeys) {
    if (data.containsKey(k) && data[k] != null) return true;
  }

  final current = data['current'];
  final next = data['next'];
  if (status == 'ok' && current == null && next == null) return true;
  return false;
}


Future<void> _onItemTap(
  HomeViewModel vm,
  int index,
  BuildContext context,
) async {
  if (vm._domains.isEmpty || index < 0 || index >= vm._domains.length) return;
  final key = vm._normalizedDomainKey(vm._domains[index].key);
  if (!vm.isDomainEnabled(key)) {
    _showDomainLockedMessage(vm, context);
    return;
  }

  final resultRoute = RoutesName.routeForDomain(key);
  final isFlowDomain = HomeViewModel._flowDomains.contains(key) && resultRoute != null;
  if (vm._loadingDomainKey == key) return;

  _setLoadingDomain(vm, key);
  try {
    if (isFlowDomain &&
        await _handleFlowDomainTap(
          vm: vm,
          context: context,
          key: key,
          reviewScansRoute: resultRoute,
        )) {
      return;
    }

    if (!context.mounted) return;
    _setLoadingDomain(vm, null);
    _navigateToDomainQuestions(context, key);
  } catch (_) {
    _setLoadingDomain(vm, null);
  }
}

void _setLoadingDomain(HomeViewModel vm, String? key) {
  vm._loadingDomainKey = key;
  vm._notify();
}

void _showDomainLockedMessage(HomeViewModel vm, BuildContext context) {
  final message = vm.hasNoGoalSelected
      ? 'Please select your goal first to unlock plans.'
      : 'This plan is not your selected goal. Only your chosen goal is available to use.';
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
      action: vm.hasNoGoalSelected
          ? SnackBarAction(
              label: 'Select goal',
              onPressed: () => Navigator.pushNamed(context, RoutesName.GaolScreen),
            )
          : null,
    ),
  );
}

void _navigateToDomainQuestions(BuildContext context, String key) {
  Navigator.pushNamed(context, RoutesName.DomainQuestionScreen, arguments: key);
}

Future<bool> _handleFlowDomainTap({
  required HomeViewModel vm,
  required BuildContext context,
  required String key,
  required String reviewScansRoute,
}) async {
  final flowRes = await DomainQuestionsRepository.instance.getDomainFlow(key);
  if (!context.mounted) return true;
  if (!(flowRes.success && flowRes.data is Map)) return false;

  final data = Map<String, dynamic>.from(flowRes.data as Map);
  final status = data['status']?.toString() ?? '';
  final isCompleted = _isCompletedFlowPayload(data);
  if (isCompleted) {
    _setLoadingDomain(vm, null);
    await _openCompletedScanDomainFromHome(
      vm: vm,
      context: context,
      domainKey: key,
      flowPayload: data,
      reviewScansRoute: reviewScansRoute,
    );
    return true;
  }

  if (status == 'ok') {
    _setLoadingDomain(vm, null);
    _navigateToDomainQuestions(context, key);
    return true;
  }
  if (status != 'processing') return false;

  _showFlowLoading(context);
  final completed = await DomainQuestionsRepository.instance
      .pollDomainFlowUntilCompleted(key, lastKnownResponse: data);
  if (context.mounted) Navigator.of(context).pop();
  if (!context.mounted) return true;

  _setLoadingDomain(vm, null);
  if (completed != null) {
    await _openCompletedScanDomainFromHome(
      vm: vm,
      context: context,
      domainKey: key,
      flowPayload: Map<String, dynamic>.from(completed),
      reviewScansRoute: reviewScansRoute,
    );
    return true;
  }

  ApiErrorHandler.showSnackBar(
    context,
    fallback: 'Processing timed out. Please try again.',
  );
  return true;
}

