part of 'home_view_model.dart';

Future<void> _openCompletedScanDomainFromHome({
  required HomeViewModel vm,
  required BuildContext context,
  required String domainKey,
  required Map<String, dynamic> flowPayload,
  required String reviewScansRoute,
}) async {
  if (!context.mounted) return;
  final normalizedDomain = vm._normalizedDomainKey(domainKey);
  final usesScanChoice = normalizedDomain == 'skincare' ||
      normalizedDomain == 'haircare' ||
      normalizedDomain == 'workout' ||
      normalizedDomain == 'fashion';
  if (!usesScanChoice) {
    Navigator.pushNamed(context, reviewScansRoute, arguments: flowPayload);
    return;
  }
  final previousRoute = _previousRecordRouteForDomain(vm, domainKey);
  final hasPreviousData = _hasPreviousDataForDomain(
    vm: vm,
    domainKey: domainKey,
    flowPayload: flowPayload,
  );
  final canUsePreviousData = previousRoute != null && hasPreviousData;
  if (!canUsePreviousData) {
    Navigator.pushNamed(context, reviewScansRoute, arguments: flowPayload);
    return;
  }
  final usePrevious = await _showScanChoiceDialog(
    vm: vm,
    context: context,
    domainKey: domainKey,
    canUsePreviousData: canUsePreviousData,
  );
  if (!context.mounted || usePrevious == null) return;
  if (usePrevious) {
    Navigator.pushNamed(context, previousRoute, arguments: flowPayload);
    return;
  }
  Navigator.pushNamed(context, reviewScansRoute, arguments: flowPayload);
}

String? _previousRecordRouteForDomain(HomeViewModel vm, String domainKey) {
  final normalized = vm._normalizedDomainKey(domainKey);
  if (normalized == 'fashion') return RoutesName.FashionProfileScreen;
  return RoutesName.dailyRoutineRouteForDomain(domainKey);
}

bool _hasPreviousDataForDomain({
  required HomeViewModel vm,
  required String domainKey,
  required Map<String, dynamic> flowPayload,
}) {
  final normalized = vm._normalizedDomainKey(domainKey);
  if (normalized == 'fashion') {
    final summary = flowPayload['ai_summary'];
    if (summary is Map && summary.isNotEmpty) return true;
    final attrs = flowPayload['ai_attributes'];
    if (attrs is List && attrs.isNotEmpty) return true;
    final recs = flowPayload['recommendations'];
    if (recs is List && recs.isNotEmpty) return true;
    final result = flowPayload['result'];
    return result is Map && result.isNotEmpty;
  }

  const resultKeys = {
    'ai_message',
    'ai_progress',
    'ai_recovery',
    'ai_attributes',
    'ai_exercises',
    'result',
    'recommendations',
  };
  for (final key in resultKeys) {
    final value = flowPayload[key];
    if (value == null) continue;
    if (value is Map && value.isEmpty) continue;
    if (value is List && value.isEmpty) continue;
    if (value.toString().trim().isEmpty) continue;
    return true;
  }
  return false;
}

Future<bool?> _showScanChoiceDialog({
  required HomeViewModel vm,
  required BuildContext context,
  required String domainKey,
  required bool canUsePreviousData,
}) {
  final normalized = vm._normalizedDomainKey(domainKey);
  final isWorkout = normalized == 'workout';
  final isFashion = normalized == 'fashion';
  final label = normalized == 'haircare' ? 'hair' : (isFashion ? 'fashion' : 'skin');
  final description = isWorkout
      ? 'Do you want a new workout analysis or continue with your previous record?'
      : 'Do you want a new $label scan or continue with your previous analysis?';
  final newActionText = isWorkout ? 'New Analysis' : 'New Scan';

  return showDialog<bool>(
    context: context,
    builder: (ctx) {
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(
          horizontal: context.sw(24),
          vertical: context.sh(24),
        ),
        child: PlanContainer(
          isSelected: false,
          onTap: () {},
          margin: EdgeInsets.zero,
          padding: context.paddingSymmetricR(horizontal: 16, vertical: 16),
          radius: BorderRadius.circular(context.radiusR(14)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Choose an option',
                style: TextStyle(
                  fontSize: context.sp(18),
                  fontWeight: FontWeight.w700,
                  color: AppColors.headingColor,
                ),
              ),
              SizedBox(height: context.sh(8)),
              Text(
                description,
                style: TextStyle(
                  fontSize: context.sp(13),
                  fontWeight: FontWeight.w500,
                  color: AppColors.subHeadingColor,
                ),
              ),
              SizedBox(height: context.sh(16)),
              Row(
                children: [
                  Expanded(
                    child: PlanContainer(
                      isSelected: false,
                      onTap: () => Navigator.pop(ctx, false),
                      margin: EdgeInsets.zero,
                      padding: context.paddingSymmetricR(horizontal: 12, vertical: 12),
                      child: Center(
                        child: Text(
                          newActionText,
                          style: TextStyle(
                            fontSize: context.sp(13),
                            fontWeight: FontWeight.w700,
                            color: AppColors.subHeadingColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: context.sw(10)),
                  Expanded(
                    child: Opacity(
                      opacity: canUsePreviousData ? 1 : 0.45,
                      child: PlanContainer(
                        isSelected: false,
                        onTap: canUsePreviousData ? () => Navigator.pop(ctx, true) : null,
                        margin: EdgeInsets.zero,
                        padding: context.paddingSymmetricR(horizontal: 12, vertical: 12),
                        child: Center(
                          child: Text(
                            'Previous Record',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: context.sp(13),
                              fontWeight: FontWeight.w700,
                              color: canUsePreviousData
                                  ? AppColors.pimaryColor
                                  : AppColors.subHeadingColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

void _showFlowLoading(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => PopScope(
      canPop: false,
      child: Center(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                Text(
                  'Loading your plan...',
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(ctx).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
