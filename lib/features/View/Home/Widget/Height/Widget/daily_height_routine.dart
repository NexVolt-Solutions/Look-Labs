import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:flutter_svg/svg.dart';
import 'package:looklabs/Features/Widget/app_bar_container.dart';
import 'package:looklabs/Features/Widget/height_widget_cont.dart';
import 'package:looklabs/Features/Widget/normal_text.dart';
import 'package:looklabs/Features/Widget/plan_container.dart';
import 'package:looklabs/Core/Constants/app_assets.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Features/ViewModel/daily_height_routine_view_model.dart';
import 'package:provider/provider.dart';

class DailyHeightRoutineScreen extends StatefulWidget {
  const DailyHeightRoutineScreen({super.key});

  @override
  State<DailyHeightRoutineScreen> createState() =>
      _DailyHeightRoutineScreenState();
}

class _DailyHeightRoutineScreenState extends State<DailyHeightRoutineScreen> {
  bool isExpanded = false; // ✅ yahan rakho

  @override
  Widget build(BuildContext context) {
    final dailyHeightViewModel = Provider.of<DailyHeightRoutineViewModel>(
      context,
    );
    return Scaffold(
      backgroundColor: AppColors.backGroundColor,

      body: SafeArea(
        child: ListView(
          padding: context.paddingSymmetricR(horizontal: 20),
          children: [
            AppBarContainer(
              title: 'Daily Routine',
              onTap: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(height: context.sh(24)),
            NormalText(
              crossAxisAlignment: CrossAxisAlignment.start,
              titleText: 'Stretching exercises for posture improvement',
              titleSize: context.sp(16),
              titleWeight: FontWeight.w600,
              titleColor: AppColors.subHeadingColor,
            ),
            SizedBox(height: context.sh(18)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(2, (index) {
                return SizedBox(
                  child: HeightWidgetCont(
                    // padding: context.paddingSymmetricR(horizontal: 11.5, vertical: 14.5),
                    title: '25%',
                    subTitle: 'Evening',
                    imgPath: AppAssets.heightIcon,
                  ),
                );
              }),
            ),
            SizedBox(height: context.sh(18)),

            PlanContainer(
              padding: context.paddingSymmetricR(horizontal: 12, vertical: 12),
              isSelected: false,
              onTap: () {},
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        height: context.sh(28),
                        width: context.sw(28),
                        decoration: BoxDecoration(
                          color: AppColors.backGroundColor,
                          borderRadius: BorderRadius.circular(
                            context.radiusR(10),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.customContainerColorUp
                                  .withOpacity(0.4),
                              offset: const Offset(3, 3),
                              blurRadius: 4,
                            ),
                            BoxShadow(
                              color: AppColors.customContinerColorDown
                                  .withOpacity(0.4),
                              offset: const Offset(-3, -3),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Center(
                          child: SizedBox(
                            height: context.sh(32),
                            width: context.sw(32),
                            child: SvgPicture.asset(
                              AppAssets.sunIcon,
                              color: AppColors.fireColor,
                              fit: BoxFit.scaleDown,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: context.sw(11)),
                      Expanded(
                        child: NormalText(
                          titleText: 'Morning Routine',
                          titleSize: context.sp(14),
                          titleWeight: FontWeight.w600,
                          titleColor: AppColors.subHeadingColor,
                          subText: 'Best done after waking up',
                          subSize: context.sp(10),
                          subWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  ...List.generate(
                    dailyHeightViewModel.heightRoutineList.length,
                    (index) {
                      final item =
                          dailyHeightViewModel.heightRoutineList[index];
                      final bool isSelected = dailyHeightViewModel
                          .isPlanSelected(index);

                      return Center(
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: double.infinity,
                          padding: context.paddingSymmetricR(vertical: 8, horizontal: 20),
                          margin: context.paddingSymmetricR(vertical: 11),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.pimaryColor
                                  : AppColors.backGroundColor,
                              width: context.sw(1.5),
                            ),
                            color: isSelected
                                ? AppColors.pimaryColor.withOpacity(0.15)
                                : AppColors.backGroundColor,

                            boxShadow: [
                              BoxShadow(
                                color: AppColors.customContainerColorUp
                                    .withOpacity(0.4),
                                offset: const Offset(5, 5),
                                blurRadius: 5,
                              ),
                              BoxShadow(
                                color: AppColors.customContinerColorDown
                                    .withOpacity(0.4),
                                offset: const Offset(-5, -5),
                                blurRadius: 5,
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              /// Header
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          dailyHeightViewModel.selectPlan(
                                            index,
                                          );
                                        },
                                        child: Container(
                                          height: context.sh(28),
                                          width: context.sw(28),
                                          decoration: BoxDecoration(
                                            color: AppColors.backGroundColor,
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: AppColors
                                                    .customContainerColorUp
                                                    .withOpacity(0.4),
                                                offset: const Offset(3, 3),
                                                blurRadius: 4,
                                                inset: true,
                                              ),
                                              BoxShadow(
                                                color: AppColors
                                                    .customContinerColorDown
                                                    .withOpacity(0.4),
                                                offset: const Offset(-3, -3),
                                                blurRadius: 4,
                                                inset: true,
                                              ),
                                            ],
                                          ),
                                          child: Center(
                                            child:
                                                dailyHeightViewModel
                                                    .isPlanSelected(index)
                                                ? Icon(
                                                    Icons.check,
                                                    size: context.sh(16),
                                                    color:
                                                        AppColors.pimaryColor,
                                                  )
                                                : NormalText(
                                                    titleText: '${index + 1}',
                                                  ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: context.sw(9)),
                                      NormalText(
                                        titleText: item['time'],
                                        titleSize: context.sp(14),
                                        titleWeight: FontWeight.w500,
                                        titleColor: AppColors.subHeadingColor,
                                        subText: item['activity'],
                                        subSize: context.sp(10),
                                        subWeight: FontWeight.w400,
                                        subColor: AppColors.subHeadingColor,
                                      ),
                                    ],
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      dailyHeightViewModel.toggleExpand(index);
                                    },
                                    child: Icon(
                                      dailyHeightViewModel.isExpanded(index)
                                          ? Icons.keyboard_arrow_up
                                          : Icons.keyboard_arrow_down,
                                      size: context.sh(24),
                                    ),
                                  ),
                                ],
                              ),

                              /// Expand Section
                              AnimatedCrossFade(
                                firstChild: const SizedBox(),
                                secondChild: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: context.sh(12)),
                                    NormalText(
                                      titleText: item['details'],
                                      titleSize: context.sp(12),
                                      titleWeight: FontWeight.w600,
                                      titleColor: AppColors.iconColor,
                                    ),
                                    SizedBox(height: context.sh(6)),
                                    NormalText(
                                      titleText: "• Do exercises slowly",
                                      titleSize: context.sp(12),
                                      titleWeight: FontWeight.w600,
                                      titleColor: AppColors.iconColor,
                                    ),
                                    SizedBox(height: context.sh(6)),
                                    NormalText(
                                      titleText: "• Maintain proper breathing",
                                      titleSize: context.sp(12),
                                      titleWeight: FontWeight.w600,
                                      titleColor: AppColors.iconColor,
                                    ),
                                  ],
                                ),
                                crossFadeState:
                                    dailyHeightViewModel.isExpanded(index)
                                    ? CrossFadeState.showSecond
                                    : CrossFadeState.showFirst,
                                duration: const Duration(milliseconds: 300),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
