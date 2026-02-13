import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:flutter_svg/svg.dart';
import 'package:looklabs/features/Widget/app_bar_container.dart';
import 'package:looklabs/features/Widget/custom_button.dart';
import 'package:looklabs/features/Widget/custom_container.dart';
import 'package:looklabs/features/Widget/light_card_widget.dart';
import 'package:looklabs/features/Widget/line_chart_widget.dart';
import 'package:looklabs/features/Widget/normal_text.dart';
import 'package:looklabs/features/Widget/plan_container.dart';
import 'package:looklabs/Core/Constants/app_assets.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Core/utils/Routes/routes_name.dart';
import 'package:looklabs/features/ViewModel/daily_diet_routine_screen_view_model.dart';
import 'package:looklabs/features/ViewModel/progress_view_model.dart';
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
        padding: context.padSym(h: 8, v: 8),
        radius: BorderRadius.circular(context.radius(10)),
        isSelected: false,
        onTap: () {
          dailyDietRoutineScreenViewModel.showTransparentDialog(context);
        },
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsetsGeometry.only(
          top: context.h(5),
          left: context.w(20),
          right: context.w(20),
          bottom: context.h(30),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: PlanContainer(
                padding: context.padSym(h: 12, v: 18),
                radius: BorderRadius.circular(context.radius(16)),
                isSelected: false,
                onTap: () {
                  Navigator.pushNamed(context, RoutesName.AllTrackedFood);
                },
                child: NormalText(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  titleText: 'Track Nutrition',
                  titleSize: context.text(14),
                  titleColor: AppColors.subHeadingColor,
                  titleWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(width: context.w(12)),
            Expanded(
              child: CustomButton(
                padding: context.padSym(h: 12),
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
          padding: context.padSym(h: 20),
          children: [
            AppBarContainer(
              title: 'Daily Diet Routine',
              onTap: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(height: context.h(24)),
            NormalText(
              crossAxisAlignment: CrossAxisAlignment.start,
              titleText: 'Healthy eating habits for better nutrition & energy',
              titleSize: context.text(16),
              titleWeight: FontWeight.w600,
              titleColor: AppColors.subHeadingColor,
            ),

            SizedBox(height: context.h(8)),

            PlanContainer(
              padding: context.padSym(h: 12, v: 12),
              isSelected: false,
              onTap: () {},
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        height: context.h(28),
                        width: context.w(28),
                        decoration: BoxDecoration(
                          color: AppColors.backGroundColor,
                          borderRadius: BorderRadius.circular(
                            context.radius(10),
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
                            height: context.h(32),
                            width: context.w(32),
                            child: SvgPicture.asset(
                              AppAssets.sunIcon,
                              color: AppColors.fireColor,
                              fit: BoxFit.scaleDown,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: context.w(11)),
                      Expanded(
                        child: NormalText(
                          titleText: 'Morning Routine',
                          titleSize: context.text(14),
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
                          padding: context.padSym(v: 8, h: 20),
                          margin: context.padSym(v: 11),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.pimaryColor
                                  : AppColors.backGroundColor,
                              width: context.w(1.5),
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
                                          height: context.h(28),
                                          width: context.w(28),
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
                                                    size: context.h(16),
                                                    color:
                                                        AppColors.pimaryColor,
                                                  )
                                                : NormalText(
                                                    titleText: '${index + 1}',
                                                  ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: context.w(9)),
                                      NormalText(
                                        titleText: item['time'],
                                        titleSize: context.text(14),
                                        titleWeight: FontWeight.w500,
                                        titleColor: AppColors.subHeadingColor,
                                        subText: item['activity'],
                                        subSize: context.text(10),
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
                                      size: context.h(24),
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
                                    SizedBox(height: context.h(12)),
                                    NormalText(
                                      titleText: item['details'],
                                      titleSize: context.text(12),
                                      titleWeight: FontWeight.w600,
                                      titleColor: AppColors.iconColor,
                                    ),
                                    SizedBox(height: context.h(6)),
                                    NormalText(
                                      titleText: "• Do exercises slowly",
                                      titleSize: context.text(12),
                                      titleWeight: FontWeight.w600,
                                      titleColor: AppColors.iconColor,
                                    ),
                                    SizedBox(height: context.h(6)),
                                    NormalText(
                                      titleText: "• Maintain proper breathing",
                                      titleSize: context.text(12),
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
            SizedBox(height: context.h(8)),

            PlanContainer(
              padding: context.padSym(h: 12, v: 12),
              isSelected: false,
              onTap: () {},
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        height: context.h(28),
                        width: context.w(28),
                        decoration: BoxDecoration(
                          color: AppColors.backGroundColor,
                          borderRadius: BorderRadius.circular(
                            context.radius(10),
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
                            height: context.h(32),
                            width: context.w(32),
                            child: SvgPicture.asset(
                              AppAssets.nightIcon,
                              fit: BoxFit.scaleDown,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: context.w(11)),
                      Expanded(
                        child: NormalText(
                          titleText: 'Evening Routine',
                          titleSize: context.text(14),
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
                          padding: context.padSym(v: 8, h: 20),
                          margin: context.padSym(v: 11),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.pimaryColor
                                  : AppColors.backGroundColor,
                              width: context.w(1.5),
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
                                          height: context.h(28),
                                          width: context.w(28),
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
                                                    size: context.h(16),
                                                    color:
                                                        AppColors.pimaryColor,
                                                  )
                                                : NormalText(
                                                    titleText: '${index + 1}',
                                                  ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: context.w(9)),
                                      NormalText(
                                        titleText: item['time'],
                                        titleSize: context.text(14),
                                        titleWeight: FontWeight.w500,
                                        titleColor: AppColors.subHeadingColor,
                                        subText: item['activity'],
                                        subSize: context.text(10),
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
                                      size: context.h(24),
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
                                    SizedBox(height: context.h(12)),
                                    NormalText(
                                      titleText: item['details'],
                                      titleSize: context.text(12),
                                      titleWeight: FontWeight.w600,
                                      titleColor: AppColors.iconColor,
                                    ),
                                    SizedBox(height: context.h(6)),
                                    NormalText(
                                      titleText: "• Do exercises slowly",
                                      titleSize: context.text(12),
                                      titleWeight: FontWeight.w600,
                                      titleColor: AppColors.iconColor,
                                    ),
                                    SizedBox(height: context.h(6)),
                                    NormalText(
                                      titleText: "• Maintain proper breathing",
                                      titleSize: context.text(12),
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
            SizedBox(height: context.h(10)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(progressViewModel.buttonName.length, (
                index,
              ) {
                final bool isSelected =
                    progressViewModel.selectedIndex ==
                    progressViewModel.buttonName[index];
                return CustomContainer(
                  radius: context.radius(10),
                  onTap: () {
                    progressViewModel.selectIndex(index);
                  },
                  color: isSelected
                      ? AppColors.buttonColor.withOpacity(0.11)
                      : AppColors.backGroundColor,
                  border: isSelected
                      ? Border.all(color: AppColors.pimaryColor, width: 1.5)
                      : null,
                  padding: context.padSym(h: 38, v: 12),
                  margin: context.padSym(h: 0, v: 0),
                  child: Center(
                    child: Text(
                      progressViewModel.buttonName[index],
                      style: TextStyle(
                        fontSize: context.text(14),
                        fontWeight: FontWeight.w700,
                        color: AppColors.seconderyColor,
                      ),
                    ),
                  ),
                );
              }),
            ),

            SizedBox(height: context.h(10)),
            PlanContainer(
              padding: context.padSym(h: 10, v: 10),
              margin: context.padSym(v: 10),
              radius: BorderRadius.circular(context.radius(10)),
              isSelected: false,
              onTap: () {},
              child: LineChartWidget(),
            ),
            PlanContainer(
              padding: context.padSym(h: 10, v: 10),
              margin: context.padSym(v: 10),
              radius: BorderRadius.circular(context.radius(10)),
              isSelected: false,
              onTap: () {},
              child: NormalText(
                titleText: 'Check your daily Calories Intake',
                titleSize: context.text(14),
                titleWeight: FontWeight.w600,
              ),
            ),

            // Padding(
            //   padding: context.padSym(v: 10),
            //   child: CustomButton(
            //     padding: context.padSym(h: 20),
            //     radius: BorderRadius.circular(context.radius(10)),
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
            SizedBox(height: context.h(8)),
            LightCardWidget(
              text:
                  'Consistency improves stamina, strength & posture over time.',
            ),
            SizedBox(height: context.h(30)),
          ],
        ),
      ),
    );
  }
}
