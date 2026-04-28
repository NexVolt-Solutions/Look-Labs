import 'package:flutter/material.dart';
import 'package:looklabs/Features/Widget/app_bar_container.dart';
import 'package:looklabs/Features/Widget/custom_button.dart';
import 'package:looklabs/Features/Widget/normal_text.dart';
import 'package:looklabs/Features/Widget/plan_container.dart';
import 'package:looklabs/Features/Widget/row_icon_and_text.dart';
import 'package:looklabs/Features/Widget/simple_check_box.dart';
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
                  final started = await subPlanViewModel.subscribeSelectedPlan();
                  if (!context.mounted) return;
                  if (started) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Purchase started. Waiting for confirmation...'),
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
            ...List.generate(subPlanViewModel.plans.length, (index) {
              final isSelected = subPlanViewModel.isPlanSelected(index);
              final plan = subPlanViewModel.plans[index];
              return PlanContainer(
                padding: context.paddingSymmetricR(horizontal: 12, vertical: 12),
                margin: context.paddingSymmetricR(vertical: 10),
                isSelected: isSelected,
                onTap: () => subPlanViewModel.selectPlan(index),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            plan.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: AppColors.subHeadingColor,
                              fontSize: context.sp(12),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: context.sh(8)),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: subPlanViewModel.getPlanPriceText(plan),
                                  style: TextStyle(
                                    color: AppColors.headingColor,
                                    fontSize: context.sp(14),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const WidgetSpan(child: SizedBox(width: 4)),
                                TextSpan(
                                  text: plan.durationDisplay ?? '',
                                  style: TextStyle(
                                    color: AppColors.subHeadingColor,
                                    fontSize: context.sp(10),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          if (plan.badge != null && plan.badge!.isNotEmpty) ...[
                            SizedBox(height: context.sh(8)),
                            Text(
                              plan.badge!,
                              style: TextStyle(
                                color: AppColors.subHeadingColor,
                                fontSize: context.sp(12),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    SimpleCheckBox(
                      isSelected: isSelected,
                      onTap: () => subPlanViewModel.selectPlan(index),
                    ),
                  ],
                ),
              );
            }),
            if (subPlanViewModel.selectedIndex >= 0) ...[
              SizedBox(height: context.sh(14)),
              if (subPlanViewModel.requiresDomainSelection) ...[
                Text(
                  'Select ${subPlanViewModel.selectedPlanMaxDomains} domain(s)',
                  style: TextStyle(
                    color: AppColors.headingColor,
                    fontSize: context.sp(14),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: context.sh(8)),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: SubscriptionPlanViewModel.availableDomainIds.map((
                    domain,
                  ) {
                    final selected = subPlanViewModel.isDomainSelected(domain);
                    final label = domain == 'quit_porn'
                        ? 'Quit Porn'
                        : '${domain[0].toUpperCase()}${domain.substring(1)}';
                    return ChoiceChip(
                      label: Text(label),
                      selected: selected,
                      onSelected: (_) {
                        final ok = subPlanViewModel.toggleDomainSelection(domain);
                        if (!ok) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'You can select up to ${subPlanViewModel.selectedPlanMaxDomains} domains',
                              ),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      },
                    );
                  }).toList(),
                ),
                SizedBox(height: context.sh(6)),
                Text(
                  '${subPlanViewModel.selectedDomainIds.length}/${subPlanViewModel.selectedPlanMaxDomains} selected',
                  style: TextStyle(
                    color: AppColors.subHeadingColor,
                    fontSize: context.sp(11),
                  ),
                ),
              ] else ...[
                Text(
                  'This plan unlocks all domains.',
                  style: TextStyle(
                    color: AppColors.subHeadingColor,
                    fontSize: context.sp(12),
                  ),
                ),
              ],
            ],
            SizedBox(height: context.sh(20)),
          ],
        ),
      ),
    );
  }
}
