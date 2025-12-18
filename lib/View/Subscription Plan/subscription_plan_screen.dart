import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:looklabs/Core/Constants/Widget/bar_container.dart';
import 'package:looklabs/Core/Constants/Widget/custom_button.dart';
import 'package:looklabs/Core/Constants/Widget/normal_text.dart';
import 'package:looklabs/Core/Constants/Widget/plan_container.dart';
import 'package:looklabs/Core/Constants/Widget/row_icon_and_text.dart';
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
      body: SafeArea(
        child: Padding(
          padding: context.padSym(h: 20),
          child: ListView(
            clipBehavior: Clip.hardEdge,
            children: [
              BarContainer(title: 'Subscription Plan'),
              SizedBox(height: context.h(30.89)),
              NormalText(
                crossAxisAlignment: CrossAxisAlignment.start,
                titleText: 'What you will get',
                titleSize: context.text(18),
                titleWeight: FontWeight.w600,
                titleColor: AppColors.headingColor,
              ),

              ...List.generate(
                subPlanViewModel.subscriptionData.length,
                (index) => RowIconAndText(
                  isEnabled: false,
                  titleText: subPlanViewModel.subscriptionData[index]['title']!,
                  subText:
                      subPlanViewModel.subscriptionData[index]['subtitle']!,
                  image: subPlanViewModel.subscriptionData[index]['image']!,
                ),
              ),
              ...List.generate(subPlanViewModel.subscriptionPlan.length, (
                index,
              ) {
                final plan = subPlanViewModel.subscriptionPlan[index];
                return Padding(
                  padding: context.padSym(h: 3, v: 14),
                  child: PlanContiner(
                    index: index,
                    subPlanViewModel: subPlanViewModel,
                    planName: plan['planName'],
                    price: plan['price'],
                    planDuration: plan['planDuration'] ?? '',
                    planRate: plan['planRate'],
                  ),
                );
              }),

              SizedBox(height: context.h(42)),

              CustomButton(
                isEnabled: true,
                onTap: () =>
                    Navigator.pushNamed(context, RoutesName.CardDetailsScreen),
                text: 'Continue & Subscribe ',
                color: AppColors.buttonColor,
                padding: context.padSym(v: 17),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
