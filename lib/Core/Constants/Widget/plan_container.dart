import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/ViewModel/subscription_plan_view_model.dart';

class PlanContiner extends StatelessWidget {
  final SubscriptionPlanViewModel subPlanViewModel;
  final int index;

  final bool? isSelected;
  final String? planName;
  final String? price;
  final String? planDuration;
  final String? planRate;
  const PlanContiner({
    super.key,
    required this.subPlanViewModel,
    this.isSelected,
    this.planName,
    this.price,
    this.planDuration,
    this.planRate,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        subPlanViewModel.selectPlan(index);
      },
      child: Container(
        padding: context.padSym(h: 12, v: 31),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(context.radius(10)),
          border: Border.all(
            color: subPlanViewModel.isPlanSelected(index)
                ? AppColors.pimaryColor
                : AppColors.white,
            width: context.w(1),
          ),

          color: subPlanViewModel.isPlanSelected(index)
              ? AppColors.pimaryColor.withOpacity(0.15)
              : AppColors.backGroundColor,
          boxShadow: subPlanViewModel.isPlanSelected(index)
              ? [
                  // BoxShadow(
                  //   color: AppColors.buttonColor.withOpacity(0.5),
                  //   offset: const Offset(5, 5),
                  //   blurRadius: 100,
                  //   inset: true,
                  // ),
                  // BoxShadow(
                  //   color: AppColors.buttonColor.withOpacity(0.5),
                  //   offset: const Offset(-5, -5),
                  //   blurRadius: 100,
                  //   inset: true,
                  // ),
                ]
              : [
                  BoxShadow(
                    color: AppColors.customContainerColorUp.withOpacity(0.4),
                    offset: const Offset(5, 5),
                    blurRadius: 5,
                    inset: false,
                  ),
                  BoxShadow(
                    color: AppColors.customContinerColorDown.withOpacity(0.4),
                    offset: const Offset(-5, -5),
                    blurRadius: 5,
                    inset: false,
                  ),
                ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  planName!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.subHeadingColor,
                    fontSize: context.text(12),
                    fontWeight: FontWeight.w500,
                    // fontFamily: 'Raleway',
                  ),
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: context.h(8)),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: price!,
                        style: TextStyle(
                          color: AppColors.headingColor,
                          fontSize: context.text(14),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                        text: planDuration!,
                        style: TextStyle(
                          color: AppColors.subHeadingColor,
                          fontSize: context.text(10),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: context.h(8)),
                Text(
                  planRate!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.subHeadingColor,
                    fontSize: context.text(12),
                    fontWeight: FontWeight.w600,
                    // fontFamily: 'Raleway',
                  ),
                  textAlign: TextAlign.start,
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                subPlanViewModel.selectPlan(index);
              },
              child: Container(
                height: context.h(26),
                width: context.w(26),
                margin: context.padSym(v: 12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: subPlanViewModel.isPlanSelected(index)
                        ? AppColors.pimaryColor
                        : AppColors.white,
                    width: context.w(1),
                  ),
                  color: subPlanViewModel.isPlanSelected(index)
                      ? AppColors.pimaryColor
                      : AppColors.backGroundColor,
                  boxShadow: subPlanViewModel.isPlanSelected(index)
                      ? [
                          // BoxShadow(
                          //   color: AppColors.buttonColor.withOpacity(0.5),
                          //   offset: const Offset(5, 5),
                          //   blurRadius: 20,
                          //   inset: true,
                          // ),
                          // BoxShadow(
                          //   color: AppColors.buttonColor.withOpacity(0.5),
                          //   offset: const Offset(-5, -5),
                          //   blurRadius: 20,
                          //   inset: true,
                          // ),
                        ]
                      : [
                          BoxShadow(
                            offset: Offset(-2.5, -2.5),
                            blurRadius: 4,
                            color: AppColors.blurTopColor,
                            inset: true,
                          ),
                          BoxShadow(
                            offset: Offset(2.5, 2.5),
                            blurRadius: 5,
                            color: AppColors.blurBottomColor,
                            inset: true,
                          ),
                        ],
                ),
                child: subPlanViewModel.isPlanSelected(index)
                    ? Icon(Icons.check, color: AppColors.blurTopColor, size: 20)
                    : const SizedBox(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
