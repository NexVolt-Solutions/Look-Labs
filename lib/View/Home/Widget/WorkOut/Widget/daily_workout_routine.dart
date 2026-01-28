import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:flutter_svg/svg.dart';
import 'package:looklabs/Core/Widget/app_bar_container.dart';
import 'package:looklabs/Core/Widget/custom_button.dart';
import 'package:looklabs/Core/Widget/normal_text.dart';
import 'package:looklabs/Core/Widget/plan_container.dart';
import 'package:looklabs/Core/Constants/app_assets.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Core/utils/Routes/routes_name.dart';
import 'package:looklabs/ViewModel/daily_workout_routine_view_model.dart';
import 'package:provider/provider.dart';

class DailyWorkoutRoutine extends StatefulWidget {
  const DailyWorkoutRoutine({super.key});

  @override
  State<DailyWorkoutRoutine> createState() => _DailyWorkoutRoutineState();
}

class _DailyWorkoutRoutineState extends State<DailyWorkoutRoutine> {
  @override
  Widget build(BuildContext context) {
    final dailyWorkoutRoutineViewModel =
        Provider.of<DailyWorkoutRoutineViewModel>(context);
    return Scaffold(
      backgroundColor: AppColors.backGroundColor,
      bottomNavigationBar: CustomButton(
        text: 'Check your Progress',
        color: AppColors.pimaryColor,
        isEnabled: true,
        onTap: () {
          Navigator.pushNamed(context, RoutesName.YourProgressScreen);
        },
      ),
      body: SafeArea(
        child: ListView(
          padding: context.padSym(h: 20),
          children: [
            AppBarContainer(
              title: 'Daily Workout Routine',
              onTap: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(height: context.h(24)),
            NormalText(
              crossAxisAlignment: CrossAxisAlignment.start,
              titleText: 'Your guided exercises for today',
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
                          titleText: 'Morning Plan',
                          titleSize: context.text(12),
                          titleWeight: FontWeight.w600,
                          titleColor: AppColors.subHeadingColor,
                          // subText: 'Best done after waking up',
                          // subSize: context.text(10),
                          // subWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  ...List.generate(
                    dailyWorkoutRoutineViewModel.heightRoutineList.length,
                    (index) {
                      final item =
                          dailyWorkoutRoutineViewModel.heightRoutineList[index];
                      final bool isSelected = dailyWorkoutRoutineViewModel
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
                                      // GestureDetector(
                                      //   onTap: () {
                                      //     dailyHeightViewModel.selectPlan(
                                      //       index,
                                      //     ); // ✔ ONLY
                                      //   },
                                      //   child: Container(
                                      //     height: context.h(28),
                                      //     width: context.w(28),
                                      //     decoration: BoxDecoration(
                                      //       color: AppColors.backGroundColor,
                                      //       shape: BoxShape.circle,
                                      //       boxShadow: [
                                      //         BoxShadow(
                                      //           color: AppColors
                                      //               .customContainerColorUp
                                      //               .withOpacity(0.4),
                                      //           offset: const Offset(3, 3),
                                      //           blurRadius: 4,
                                      //           inset: true,
                                      //         ),
                                      //         BoxShadow(
                                      //           color: AppColors
                                      //               .customContinerColorDown
                                      //               .withOpacity(0.4),
                                      //           offset: const Offset(-3, -3),
                                      //           blurRadius: 4,
                                      //           inset: true,
                                      //         ),
                                      //       ],
                                      //     ),
                                      //     child: Center(
                                      //       child:
                                      //           dailyHeightViewModel
                                      //               .isPlanSelected(index)
                                      //           ? Icon(
                                      //               Icons.check,
                                      //               size: context.h(16),
                                      //               color:
                                      //                   AppColors.pimaryColor,
                                      //             )
                                      //           : NormalText(
                                      //               titleText: '${index + 1}',
                                      //               titleSize: context.text(14),
                                      //               titleWeight:
                                      //                   FontWeight.w600,
                                      //             ),
                                      //     ),
                                      //   ),
                                      // ),
                                      GestureDetector(
                                        onTap: () {
                                          dailyWorkoutRoutineViewModel
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
                                                dailyWorkoutRoutineViewModel
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
                                      dailyWorkoutRoutineViewModel.toggleExpand(
                                        index,
                                      );
                                    },
                                    child: Icon(
                                      dailyWorkoutRoutineViewModel.isExpanded(
                                            index,
                                          )
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
                                    NormalText(titleText: item['details']),
                                    SizedBox(height: context.h(6)),
                                    NormalText(
                                      titleText: "• Do exercises slowly",
                                    ),
                                    SizedBox(height: context.h(6)),
                                    NormalText(
                                      titleText: "• Maintain proper breathing",
                                    ),
                                  ],
                                ),
                                crossFadeState:
                                    dailyWorkoutRoutineViewModel.isExpanded(
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
                          titleText: 'Evening Plan',
                          titleSize: context.text(12),
                          titleWeight: FontWeight.w600,
                          titleColor: AppColors.subHeadingColor,
                          // subText: 'Best done after waking up',
                          // subSize: context.text(10),
                          // subWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  ...List.generate(
                    dailyWorkoutRoutineViewModel.heightRoutineList.length,
                    (index) {
                      final item =
                          dailyWorkoutRoutineViewModel.heightRoutineList[index];
                      final bool isSelected = dailyWorkoutRoutineViewModel
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
                                      // GestureDetector(
                                      //   onTap: () {
                                      //     dailyHeightViewModel.selectPlan(
                                      //       index,
                                      //     ); // ✔ ONLY
                                      //   },
                                      //   child: Container(
                                      //     height: context.h(28),
                                      //     width: context.w(28),
                                      //     decoration: BoxDecoration(
                                      //       color: AppColors.backGroundColor,
                                      //       shape: BoxShape.circle,
                                      //       boxShadow: [
                                      //         BoxShadow(
                                      //           color: AppColors
                                      //               .customContainerColorUp
                                      //               .withOpacity(0.4),
                                      //           offset: const Offset(3, 3),
                                      //           blurRadius: 4,
                                      //           inset: true,
                                      //         ),
                                      //         BoxShadow(
                                      //           color: AppColors
                                      //               .customContinerColorDown
                                      //               .withOpacity(0.4),
                                      //           offset: const Offset(-3, -3),
                                      //           blurRadius: 4,
                                      //           inset: true,
                                      //         ),
                                      //       ],
                                      //     ),
                                      //     child: Center(
                                      //       child:
                                      //           dailyHeightViewModel
                                      //               .isPlanSelected(index)
                                      //           ? Icon(
                                      //               Icons.check,
                                      //               size: context.h(16),
                                      //               color:
                                      //                   AppColors.pimaryColor,
                                      //             )
                                      //           : NormalText(
                                      //               titleText: '${index + 1}',
                                      //               titleSize: context.text(14),
                                      //               titleWeight:
                                      //                   FontWeight.w600,
                                      //             ),
                                      //     ),
                                      //   ),
                                      // ),
                                      GestureDetector(
                                        onTap: () {
                                          dailyWorkoutRoutineViewModel
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
                                                dailyWorkoutRoutineViewModel
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
                                      dailyWorkoutRoutineViewModel.toggleExpand(
                                        index,
                                      );
                                    },
                                    child: Icon(
                                      dailyWorkoutRoutineViewModel.isExpanded(
                                            index,
                                          )
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
                                    NormalText(titleText: item['details']),
                                    SizedBox(height: context.h(6)),
                                    NormalText(
                                      titleText: "• Do exercises slowly",
                                    ),
                                    SizedBox(height: context.h(6)),
                                    NormalText(
                                      titleText: "• Maintain proper breathing",
                                    ),
                                  ],
                                ),
                                crossFadeState:
                                    dailyWorkoutRoutineViewModel.isExpanded(
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
              child: Row(
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
                  SizedBox(width: context.w(11)),
                  Expanded(
                    child: NormalText(
                      subText:
                          'Consistency improves stamina, strength & posture over time.',
                      subSize: context.text(12),
                      subWeight: FontWeight.w600,
                      subColor: AppColors.iconColor,
                    ),
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
