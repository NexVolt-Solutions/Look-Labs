import 'package:flutter/material.dart';
import 'package:looklabs/Core/Widget/app_bar_container.dart';
import 'package:looklabs/Core/Widget/custom_button.dart';
import 'package:looklabs/Core/Widget/normal_text.dart';
import 'package:looklabs/Core/Widget/plan_container.dart';
import 'package:looklabs/Core/Widget/row_icon_and_text.dart';
import 'package:looklabs/Core/Widget/simple_check_box.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Core/utils/Routes/routes_name.dart';
import 'package:looklabs/ViewModel/subscription_plan_view_model.dart';
import 'package:provider/provider.dart';

class SubscriptionPlanScreen extends StatefulWidget {
  const SubscriptionPlanScreen({super.key});

  @override
  State<SubscriptionPlanScreen> createState() => _SubscriptionPlanScreenState();
}

class _SubscriptionPlanScreenState extends State<SubscriptionPlanScreen> {
  @override
  Widget build(BuildContext context) {
    final subPlanViewModel = Provider.of<SubscriptionPlanViewModel>(context);

    return Scaffold(
      backgroundColor: AppColors.backGroundColor,
      bottomNavigationBar: Padding(
        padding: context.padSym(h: 20, v: 30),
        child: CustomButton(
          isEnabled: true,
          onTap: () =>
              Navigator.pushNamed(context, RoutesName.CardDetailsScreen),
          text: 'Continue & Subscribe',
          color: AppColors.buttonColor,
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: context.padSym(h: 20),
          children: [
            AppBarContainer(
              title: 'Subscription Plan',
              onTap: () => Navigator.pop(context),
            ),
            SizedBox(height: context.h(24)),
            NormalText(
              crossAxisAlignment: CrossAxisAlignment.start,
              titleText: 'What you will get',
              titleSize: context.text(18),
              titleWeight: FontWeight.w600,
              titleColor: AppColors.headingColor,
            ),
            SizedBox(height: context.h(12)),
            ...List.generate(
              subPlanViewModel.subscriptionData.length,
              (index) => RowIconAndText(
                isEnabled: false,
                titleText: subPlanViewModel.subscriptionData[index]['title']!,
                subText: subPlanViewModel.subscriptionData[index]['subtitle']!,
                image: subPlanViewModel.subscriptionData[index]['image']!,
              ),
            ),
            ...List.generate(subPlanViewModel.subscriptionPlan.length, (index) {
              final isSelected = subPlanViewModel.isPlanSelected(index);
              final plan = subPlanViewModel.subscriptionPlan[index];
              return PlanContainer(
                padding: context.padSym(h: 12, v: 12),
                margin: context.padSym(v: 10),
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
                            plan['planName'],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: AppColors.subHeadingColor,
                              fontSize: context.text(12),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: context.h(8)),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: plan['price'],
                                  style: TextStyle(
                                    color: AppColors.headingColor,
                                    fontSize: context.text(14),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const WidgetSpan(child: SizedBox(width: 4)),
                                TextSpan(
                                  text: plan['planDuration'],
                                  style: TextStyle(
                                    color: AppColors.subHeadingColor,
                                    fontSize: context.text(10),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          if (index != 0 && plan['planRate'] != null) ...[
                            SizedBox(height: context.h(8)),
                            Text(
                              plan['planRate'],
                              style: TextStyle(
                                color: AppColors.subHeadingColor,
                                fontSize: context.text(12),
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
            SizedBox(height: context.h(20)),
          ],
        ),
      ),
    );
  }
}
