import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:flutter_svg/svg.dart';
import 'package:looklabs/Features/Widget/app_bar_container.dart';
import 'package:looklabs/Features/Widget/custom_button.dart';
import 'package:looklabs/Features/Widget/custom_container.dart';
import 'package:looklabs/Features/Widget/light_card_widget.dart';
import 'package:looklabs/Features/Widget/line_chart_widget.dart';
import 'package:looklabs/Features/Widget/normal_text.dart';
import 'package:looklabs/Features/Widget/plan_container.dart';
import 'package:looklabs/Core/Constants/app_assets.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Core/Routes/routes_name.dart';
import 'package:looklabs/Features/ViewModel/daily_diet_routine_screen_view_model.dart';
import 'package:looklabs/Features/ViewModel/progress_view_model.dart';
import 'package:provider/provider.dart';

class DailyDietRoutineScreen extends StatefulWidget {
  const DailyDietRoutineScreen({super.key});

  @override
  State<DailyDietRoutineScreen> createState() => _DailyDietRoutineScreenState();
}

class _DailyDietRoutineScreenState extends State<DailyDietRoutineScreen> {
  @override
  Widget build(BuildContext context) {
    final dailyDietRoutineScreenViewModel =
        Provider.of<DailyDietRoutineScreenViewModel>(context);
    final progressViewModel = Provider.of<ProgressViewModel>(context);

    return Scaffold(
      backgroundColor: AppColors.backGroundColor,
      floatingActionButton: PlanContainer(
        padding: context.paddingSymmetricR(horizontal: 8, vertical: 8),
        radius: BorderRadius.circular(context.radiusR(10)),
        isSelected: false,
        onTap: () {
          dailyDietRoutineScreenViewModel.showTransparentDialog(context);
        },
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsetsGeometry.only(
          top: context.sh(5),
          left: context.sw(20),
          right: context.sw(20),
          bottom: context.sh(30),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: PlanContainer(
                padding: context.paddingSymmetricR(horizontal: 12, vertical: 18),
                radius: BorderRadius.circular(context.radiusR(16)),
                isSelected: false,
                onTap: () {
                  Navigator.pushNamed(context, RoutesName.AllTrackedFood);
                },
                child: NormalText(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  titleText: 'Track Nutrition',
                  titleSize: context.sp(14),
                  titleColor: AppColors.subHeadingColor,
                  titleWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(width: context.sw(12)),
            Expanded(
              child: CustomButton(
                padding: context.paddingSymmetricR(horizontal: 12),
                isEnabled: true,
                onTap: () => Navigator.pushNamed(
                  context,
                  RoutesName.TrackYourNutritionScreen,
                ),
                text: 'Your Progress',
                color: AppColors.pimaryColor,
              ),
            ),
          ],
        ),
      ),

      body: SafeArea(
        child: ListView(
          padding: context.paddingSymmetricR(horizontal: 20),
          children: [
            AppBarContainer(
              title: 'Daily Diet Routine',
              onTap: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(height: context.sh(24)),
            NormalText(
              crossAxisAlignment: CrossAxisAlignment.start,
              titleText: 'Healthy eating habits for better nutrition & energy',
              titleSize: context.sp(16),
              titleWeight: FontWeight.w600,
              titleColor: AppColors.subHeadingColor,
            ),

            SizedBox(height: context.sh(8)),

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
                        ),
                      ),
                    ],
                  ),
                  ...List.generate(
                    dailyDietRoutineScreenViewModel.heightRoutineList.length,
                    (index) {
                      final item = dailyDietRoutineScreenViewModel
                          .heightRoutineList[index];
                      final bool isSelected = dailyDietRoutineScreenViewModel
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
                                          dailyDietRoutineScreenViewModel
                                              .selectPlan(index);
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
                                                dailyDietRoutineScreenViewModel
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
                                      dailyDietRoutineScreenViewModel
                                          .toggleExpand(index);
                                    },
                                    child: Icon(
                                      dailyDietRoutineScreenViewModel
                                              .isExpanded(index)
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
                                    dailyDietRoutineScreenViewModel.isExpanded(
                                      index,
                                    )
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
            SizedBox(height: context.sh(8)),

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
                              AppAssets.nightIcon,
                              fit: BoxFit.scaleDown,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: context.sw(11)),
                      Expanded(
                        child: NormalText(
                          titleText: 'Evening Routine',
                          titleSize: context.sp(14),
                          titleWeight: FontWeight.w600,
                          titleColor: AppColors.subHeadingColor,
                        ),
                      ),
                    ],
                  ),
                  ...List.generate(
                    dailyDietRoutineScreenViewModel.heightRoutineList.length,
                    (index) {
                      final item = dailyDietRoutineScreenViewModel
                          .heightRoutineList[index];
                      final bool isSelected = dailyDietRoutineScreenViewModel
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
                                          dailyDietRoutineScreenViewModel
                                              .selectPlan(index);
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
                                                dailyDietRoutineScreenViewModel
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
                                      dailyDietRoutineScreenViewModel
                                          .toggleExpand(index);
                                    },
                                    child: Icon(
                                      dailyDietRoutineScreenViewModel
                                              .isExpanded(index)
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
                                    dailyDietRoutineScreenViewModel.isExpanded(
                                      index,
                                    )
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
            SizedBox(height: context.sh(10)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(progressViewModel.buttonName.length, (
                index,
              ) {
                final bool isSelected =
                    progressViewModel.selectedIndex ==
                    progressViewModel.buttonName[index];
                return CustomContainer(
                  radius: context.radiusR(10),
                  onTap: () {
                    progressViewModel.selectIndex(index);
                  },
                  color: isSelected
                      ? AppColors.buttonColor.withOpacity(0.11)
                      : AppColors.backGroundColor,
                  border: isSelected
                      ? Border.all(color: AppColors.pimaryColor, width: 1.5)
                      : null,
                  padding: context.paddingSymmetricR(horizontal: 38, vertical: 12),
                  margin: context.paddingSymmetricR(horizontal: 0, vertical: 0),
                  child: Center(
                    child: Text(
                      progressViewModel.buttonName[index],
                      style: TextStyle(
                        fontSize: context.sp(14),
                        fontWeight: FontWeight.w700,
                        color: AppColors.seconderyColor,
                      ),
                    ),
                  ),
                );
              }),
            ),

            SizedBox(height: context.sh(10)),
            PlanContainer(
              padding: context.paddingSymmetricR(horizontal: 10, vertical: 10),
              margin: context.paddingSymmetricR(vertical: 10),
              radius: BorderRadius.circular(context.radiusR(10)),
              isSelected: false,
              onTap: () {},
              child: LineChartWidget(),
            ),
            PlanContainer(
              padding: context.paddingSymmetricR(horizontal: 10, vertical: 10),
              margin: context.paddingSymmetricR(vertical: 10),
              radius: BorderRadius.circular(context.radiusR(10)),
              isSelected: false,
              onTap: () {},
              child: NormalText(
                titleText: 'Check your daily Calories Intake',
                titleSize: context.sp(14),
                titleWeight: FontWeight.w600,
              ),
            ),

            // Padding(
            //   padding: context.paddingSymmetricR(vertical: 10),
            //   child: CustomButton(
            //     padding: context.paddingSymmetricR(horizontal: 20),
            //     radius: BorderRadius.circular(context.radiusR(10)),
            //     text: 'Check your daily Calories Intake',
            //     color: AppColors.backGroundColor,
            //     isEnabled: true,
            //     onTap: () {
            //       Navigator.pushNamed(
            //         context,
            //         RoutesName.TrackYourNutritionScreen,
            //       );
            //     },
            //   ),
            // ),
            SizedBox(height: context.sh(8)),
            LightCardWidget(
              text:
                  'Consistency improves stamina, strength & posture over time.',
            ),
            SizedBox(height: context.sh(30)),
          ],
        ),
      ),
    );
  }
}
