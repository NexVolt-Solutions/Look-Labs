import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:flutter_svg/svg.dart';
import 'package:looklabs/features/Widget/app_bar_container.dart';
import 'package:looklabs/features/Widget/custom_button.dart';
import 'package:looklabs/features/Widget/height_widget_cont.dart';
import 'package:looklabs/features/Widget/normal_text.dart';
import 'package:looklabs/features/Widget/plan_container.dart';
import 'package:looklabs/Core/Constants/app_assets.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Core/Routes/routes_name.dart';
import 'package:looklabs/features/ViewModel/work_out_result_screen_view_model.dart';
import 'package:provider/provider.dart';

class WorkOutResultScreen extends StatefulWidget {
  const WorkOutResultScreen({super.key});

  @override
  State<WorkOutResultScreen> createState() => _WorkOutResultScreenState();
}

class _WorkOutResultScreenState extends State<WorkOutResultScreen> {
  @override
  Widget build(BuildContext context) {
    final workOutResultViewModel = Provider.of<WorkOutResultScreenViewModel>(
      context,
    );
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: EdgeInsetsGeometry.only(
          top: context.h(5),
          left: context.w(20),
          right: context.w(20),
          bottom: context.h(30),
        ),
        child: CustomButton(
          isEnabled: true,
          onTap: () => Navigator.pushNamed(
            context,
            RoutesName.DailyWorkoutRoutineScreen,
          ),
          text: 'Get Started',
          color: AppColors.pimaryColor,
        ),
      ),

      backgroundColor: AppColors.backGroundColor,

      body: SafeArea(
        child: ListView(
          padding: context.padSym(h: 20),
          children: [
            AppBarContainer(
              title: 'Workout',
              onTap: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(height: context.h(24)),
            NormalText(
              crossAxisAlignment: CrossAxisAlignment.start,
              titleText: 'Build strength, stamina & consistency',
              titleSize: context.text(16),
              titleWeight: FontWeight.w600,
              titleColor: AppColors.subHeadingColor,
            ),
            SizedBox(height: context.h(18)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(workOutResultViewModel.gridData.length, (
                index,
              ) {
                return HeightWidgetCont(
                  // padding: context.padSym(h: 11.5, v: 14.5),
                  title: workOutResultViewModel.gridData[index]['title'],
                  subTitle: workOutResultViewModel.gridData[index]['subtitle'],
                  imgPath: workOutResultViewModel.gridData[index]['image'],
                );
              }),
            ),
            SizedBox(height: context.h(18)),
            NormalText(
              titleText: 'Today\'s Focus',
              titleSize: context.text(18),
              titleWeight: FontWeight.w600,
              titleColor: AppColors.subHeadingColor,
            ),
            SizedBox(height: context.h(8)),

            Wrap(
              spacing: context.w(5),
              runSpacing: context.h(11),
              children: List.generate(workOutResultViewModel.exData.length, (
                btnIndex,
              ) {
                final bool isSelected = workOutResultViewModel.isSelected(
                  btnIndex,
                );

                return PlanContainer(
                  padding: context.padSym(h: 18, v: 11),
                  margin: context.padSym(h: 0),
                  isSelected: isSelected,
                  radius: BorderRadius.circular(context.radius(16)),

                  onTap: () {
                    workOutResultViewModel.selectExercise(btnIndex);
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                        child: SizedBox(
                          height: context.h(20),
                          width: context.w(20),
                          child: SvgPicture.asset(
                            workOutResultViewModel.exData[btnIndex]['image'],
                            fit: BoxFit.scaleDown,
                            color: isSelected
                                ? AppColors.pimaryColor
                                : AppColors.subHeadingColor,
                          ),
                        ),
                      ),

                      SizedBox(width: context.w(8)),

                      NormalText(
                        titleText:
                            workOutResultViewModel.exData[btnIndex]['title'],
                        titleSize: context.text(14),
                        titleWeight: FontWeight.w500,
                        titleColor: isSelected
                            ? AppColors.pimaryColor
                            : AppColors.subHeadingColor,
                      ),
                    ],
                  ),
                );
              }),
            ),
            SizedBox(height: context.h(18)),
            PlanContainer(
              margin: context.padSym(h: 0),
              padding: context.padSym(h: 12, v: 12),
              isSelected: false,
              onTap: () {},
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Container(
                    height: context.h(28),
                    width: context.w(28),
                    decoration: BoxDecoration(
                      color: AppColors.backGroundColor,
                      borderRadius: BorderRadius.circular(context.radius(10)),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.customContainerColorUp.withOpacity(
                            0.4,
                          ),
                          offset: const Offset(3, 3),
                          blurRadius: 4,
                        ),
                        BoxShadow(
                          color: AppColors.customContinerColorDown.withOpacity(
                            0.4,
                          ),
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
                          AppAssets.lightBulbIcon,
                          fit: BoxFit.scaleDown,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: context.h(8)),

                  NormalText(
                    titleText: 'Posture Insight',
                    titleSize: context.text(16),
                    titleWeight: FontWeight.w500,
                    titleColor: AppColors.subHeadingColor,
                    subText:
                        'Consistency improves stamina, strength & metabolism over time. Keep pushing!',
                    subSize: context.text(12),
                    subWeight: FontWeight.w600,
                  ),
                ],
              ),
            ),
            SizedBox(height: context.h(8)),

            ...List.generate(workOutResultViewModel.heightRoutineList.length, (
              index,
            ) {
              final item = workOutResultViewModel.heightRoutineList[index];
              final bool isSelected = workOutResultViewModel.isPlanSelected(
                index,
              );

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
                        color: AppColors.customContainerColorUp.withOpacity(
                          0.4,
                        ),
                        offset: const Offset(5, 5),
                        blurRadius: 5,
                      ),
                      BoxShadow(
                        color: AppColors.customContinerColorDown.withOpacity(
                          0.4,
                        ),
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  workOutResultViewModel.selectPlan(index);
                                },
                                child: Container(
                                  height: context.h(28),
                                  width: context.w(28),
                                  decoration: BoxDecoration(
                                    color: AppColors.backGroundColor,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.customContainerColorUp
                                            .withOpacity(0.4),
                                        offset: const Offset(3, 3),
                                        blurRadius: 4,
                                        inset: true,
                                      ),
                                      BoxShadow(
                                        color: AppColors.customContinerColorDown
                                            .withOpacity(0.4),
                                        offset: const Offset(-3, -3),
                                        blurRadius: 4,
                                        inset: true,
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child:
                                        workOutResultViewModel.isPlanSelected(
                                          index,
                                        )
                                        ? Icon(
                                            Icons.check,
                                            size: context.h(16),
                                            color: AppColors.pimaryColor,
                                          )
                                        : NormalText(titleText: '${index + 1}'),
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
                              workOutResultViewModel.toggleExpand(index);
                            },
                            child: Icon(
                              workOutResultViewModel.isExpanded(index)
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
                        crossFadeState: workOutResultViewModel.isExpanded(index)
                            ? CrossFadeState.showSecond
                            : CrossFadeState.showFirst,
                        duration: const Duration(milliseconds: 300),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
