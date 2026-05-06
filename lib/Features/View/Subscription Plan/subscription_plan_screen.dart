import 'package:flutter/material.dart';
import 'package:looklabs/Features/Widget/custom_container.dart';
import 'package:looklabs/Features/Widget/app_bar_container.dart';
import 'package:looklabs/Features/Widget/custom_button.dart';
import 'package:looklabs/Features/Widget/normal_text.dart';
import 'package:looklabs/Features/Widget/plan_container.dart';
import 'package:looklabs/Features/Widget/row_icon_and_text.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/app_text.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Features/ViewModel/subscription_plan_view_model.dart';
import 'package:provider/provider.dart';

class SubscriptionPlanScreen extends StatefulWidget {
  const SubscriptionPlanScreen({super.key});

  @override
  State<SubscriptionPlanScreen> createState() => _SubscriptionPlanScreenState();
}

class _SubscriptionPlanScreenState extends State<SubscriptionPlanScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<SubscriptionPlanViewModel>().loadPlans();
    });
  }

  @override
  Widget build(BuildContext context) {
    final subPlanViewModel = Provider.of<SubscriptionPlanViewModel>(context);

    return Scaffold(
      backgroundColor: AppColors.backGroundColor,
      bottomNavigationBar: Padding(
        padding: context.paddingSymmetricR(horizontal: 20, vertical: 30),
        child: CustomButton(
          isEnabled: true,
          onTap: subPlanViewModel.isPurchasing
              ? null
              : () async {
                  final started = await subPlanViewModel
                      .subscribeSelectedPlan();
                  if (!context.mounted) return;
                  if (started) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Purchase started. Waiting for confirmation...',
                        ),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                    final activated = await subPlanViewModel
                        .waitForEntitlementActivation();
                    if (!context.mounted) return;
                    if (activated) {
                      Navigator.pop(context, true);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Purchase processing in store. Please wait a moment and try again.',
                          ),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  } else if (subPlanViewModel.error != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(subPlanViewModel.error!),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                },
          text: subPlanViewModel.isPurchasing
              ? 'Processing...'
              : AppText.continueAndSubscribe,
          color: AppColors.buttonColor,
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: context.paddingSymmetricR(horizontal: 20),
          children: [
            AppBarContainer(
              title: AppText.subscriptionPlan,
              onTap: () => Navigator.pop(context),
            ),
            SizedBox(height: context.sh(24)),
            NormalText(
              crossAxisAlignment: CrossAxisAlignment.start,
              titleText: AppText.whatYouWillGet,
              titleSize: context.sp(18),
              titleWeight: FontWeight.w600,
              titleColor: AppColors.headingColor,
            ),
            SizedBox(height: context.sh(12)),
            ...List.generate(
              subPlanViewModel.subscriptionData.length,
              (index) => RowIconAndText(
                isEnabled: false,
                titleText: subPlanViewModel.subscriptionData[index]['title']!,
                subText: subPlanViewModel.subscriptionData[index]['subtitle']!,
                image: subPlanViewModel.subscriptionData[index]['image']!,
              ),
            ),
            if (subPlanViewModel.error != null &&
                !subPlanViewModel.isLoadingPlans &&
                subPlanViewModel.plans.isEmpty)
              Padding(
                padding: EdgeInsets.only(top: context.sh(10)),
                child: Text(
                  subPlanViewModel.error!,
                  style: TextStyle(
                    color: AppColors.notSelectedColor,
                    fontSize: context.sp(12),
                  ),
                ),
              ),
            if (subPlanViewModel.isLoadingPlans &&
                subPlanViewModel.plans.isEmpty)
              Padding(
                padding: EdgeInsets.symmetric(vertical: context.sh(20)),
                child: const Center(child: CircularProgressIndicator()),
              ),
            if (subPlanViewModel.billingPeriods.isNotEmpty) ...[
              SizedBox(height: context.sh(16)),
              Text(
                'Choose subscription',
                style: TextStyle(
                  color: AppColors.headingColor,
                  fontSize: context.sp(14),
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: context.sh(10)),
              Column(
                children: subPlanViewModel.billingPeriods.map((period) {
                  final isSelected = subPlanViewModel.isBillingPeriodSelected(
                    period,
                  );
                  final periodPlan = subPlanViewModel.getPlanForPeriod(period);
                  return PlanContainer(
                    padding: context.paddingSymmetricR(
                      horizontal: 14,
                      vertical: 14,
                    ),
                    margin: context.paddingSymmetricR(vertical: 8),
                    isSelected: isSelected,
                    onTap: () => subPlanViewModel.selectBillingPeriod(period),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                subPlanViewModel.getBillingPeriodTitle(period),
                                style: TextStyle(
                                  color: AppColors.headingColor,
                                  fontSize: context.sp(15),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(height: context.sh(4)),
                              Text(
                                subPlanViewModel.getBillingPeriodSubtitle(
                                  period,
                                ),
                                style: TextStyle(
                                  color: AppColors.notSelectedColor,
                                  fontSize: context.sp(11),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: context.sw(10)),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              subPlanViewModel.getBillingPeriodPriceText(
                                period,
                              ),
                              style: TextStyle(
                                color: AppColors.headingColor,
                                fontSize: context.sp(14),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            if (periodPlan != null)
                              Text(
                                subPlanViewModel.getPriceSourceLabel(
                                  periodPlan,
                                ),
                                style: TextStyle(
                                  color: AppColors.notSelectedColor,
                                  fontSize: context.sp(9),
                                ),
                              ),
                            Text(
                              period == 'yearly' ? '/year' : '/month',
                              style: TextStyle(
                                color: AppColors.notSelectedColor,
                                fontSize: context.sp(10),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
            SizedBox(height: context.sh(18)),
            Text(
              'Choose your domains',
              style: TextStyle(
                color: AppColors.headingColor,
                fontSize: context.sp(14),
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: context.sh(8)),
            Text(
              'Pick 1, 2, 3, or all 8 domains. The app will match the right plan automatically.',
              style: TextStyle(
                color: AppColors.notSelectedColor,
                fontSize: context.sp(11),
              ),
            ),
            SizedBox(height: context.sh(12)),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: SubscriptionPlanViewModel.availableDomainIds.map((
                domain,
              ) {
                final selected = subPlanViewModel.isDomainSelected(domain);
                final label = domain == 'quit_porn'
                    ? 'Quit Porn'
                    : '${domain[0].toUpperCase()}${domain.substring(1)}';
                return GestureDetector(
                  onTap: () => subPlanViewModel.toggleDomainSelection(domain),
                  child: Container(
                    padding: context.paddingSymmetricR(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(context.radiusR(12)),
                      border: Border.all(
                        color: selected
                            ? AppColors.pimaryColor
                            : AppColors.backGroundColor,
                        width: context.sw(1.2),
                      ),
                      color: selected
                          ? AppColors.pimaryColor.withValues(alpha: 0.12)
                          : AppColors.backGroundColor,
                      boxShadow: selected
                          ? []
                          : [
                              BoxShadow(
                                color: AppColors.customContainerColorUp
                                    .withValues(alpha: 0.35),
                                offset: const Offset(4, 4),
                                blurRadius: 5,
                              ),
                              BoxShadow(
                                color: AppColors.customContinerColorDown
                                    .withValues(alpha: 0.5),
                                offset: const Offset(-4, -4),
                                blurRadius: 5,
                              ),
                            ],
                    ),
                    child: Text(
                      label,
                      style: TextStyle(
                        color: selected
                            ? AppColors.headingColor
                            : AppColors.subHeadingColor,
                        fontSize: context.sp(11),
                        fontWeight: selected
                            ? FontWeight.w600
                            : FontWeight.w500,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: context.sh(12)),
            CustomContainer(
              padding: context.paddingSymmetricR(horizontal: 14, vertical: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Selection summary',
                    style: TextStyle(
                      color: AppColors.headingColor,
                      fontSize: context.sp(13),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: context.sh(6)),
                  Text(
                    subPlanViewModel.selectedDomainCount == 0
                        ? 'No domains selected yet.'
                        : '${subPlanViewModel.selectedDomainCount} domain${subPlanViewModel.selectedDomainCount == 1 ? '' : 's'} selected',
                    style: TextStyle(
                      color: AppColors.subHeadingColor,
                      fontSize: context.sp(12),
                    ),
                  ),
                  if (subPlanViewModel.selectedPlan != null) ...[
                    SizedBox(height: context.sh(4)),
                    Text(
                      'Plan: ${subPlanViewModel.getPlanTitle(subPlanViewModel.selectedPlan!)} ${subPlanViewModel.selectedBillingPeriod == 'yearly' ? '(Yearly)' : '(Monthly)'}',
                      style: TextStyle(
                        color: AppColors.subHeadingColor,
                        fontSize: context.sp(12),
                      ),
                    ),
                    SizedBox(height: context.sh(4)),
                    Text(
                      'Price: ${subPlanViewModel.getPlanPriceText(subPlanViewModel.selectedPlan!)} ${subPlanViewModel.selectedBillingPeriod == 'yearly' ? '/year' : '/month'}',
                      style: TextStyle(
                        color: AppColors.subHeadingColor,
                        fontSize: context.sp(12),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      subPlanViewModel.getPriceSourceLabel(
                        subPlanViewModel.selectedPlan!,
                      ),
                      style: TextStyle(
                        color: AppColors.notSelectedColor,
                        fontSize: context.sp(10),
                      ),
                    ),
                  ],
                  if (subPlanViewModel.domainSelectionGuidance != null) ...[
                    SizedBox(height: context.sh(6)),
                    Text(
                      subPlanViewModel.domainSelectionGuidance!,
                      style: TextStyle(
                        color: AppColors.notSelectedColor,
                        fontSize: context.sp(11),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (subPlanViewModel.selectedIndex >= 0) ...[
              SizedBox(height: context.sh(14)),
              if (subPlanViewModel.requiresDomainSelection) ...[
                const SizedBox.shrink(),
              ] else ...[
                const SizedBox.shrink(),
              ],
            ],
            SizedBox(height: context.sh(20)),
          ],
        ),
      ),
    );
  }
}
