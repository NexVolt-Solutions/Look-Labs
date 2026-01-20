import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:flutter_svg/svg.dart';
import 'package:looklabs/Core/Constants/Widget/app_bar_container.dart';
import 'package:looklabs/Core/Constants/Widget/custom_button.dart';
import 'package:looklabs/Core/Constants/Widget/height_widget_cont.dart';
import 'package:looklabs/Core/Constants/Widget/normal_text.dart';
import 'package:looklabs/Core/Constants/Widget/plan_container.dart';
import 'package:looklabs/Core/Constants/app_assets.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Core/utils/Routes/routes_name.dart';
import 'package:looklabs/ViewModel/daily_height_routine_view_model.dart';
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
          padding: context.padSym(h: 20),
          children: [
            AppBarContainer(
              title: 'Daily Routine',
              onTap: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(height: context.h(24)),
            NormalText(
              crossAxisAlignment: CrossAxisAlignment.start,
              titleText: 'Stretching exercises for posture improvement',
              titleSize: context.text(16),
              titleWeight: FontWeight.w600,
              titleColor: AppColors.subHeadingColor,
            ),
            SizedBox(height: context.h(18)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(2, (index) {
                return SizedBox(
                  child: HeightWidgetCont(
                    // padding: context.padSym(h: 11.5, v: 14.5),
                    title: '25%',
                    subTitle: 'Evening',
                    imgPath: AppAssets.heightIcon,
                  ),
                );
              }),
            ),
            SizedBox(height: context.h(18)),

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
                          titleSize: context.text(12),
                          titleWeight: FontWeight.w600,
                          titleColor: AppColors.subHeadingColor,
                          subText: 'Best done after waking up',
                          subSize: context.text(10),
                          subWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  ...List.generate(dailyHeightViewModel.heightRoutineList.length, (
                    index,
                  ) {
                    final item = dailyHeightViewModel.heightRoutineList[index];
                    final bool isSelected = dailyHeightViewModel.isPlanSelected(
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                        dailyHeightViewModel.selectPlan(index);
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
                                              dailyHeightViewModel
                                                  .isPlanSelected(index)
                                              ? Icon(
                                                  Icons.check,
                                                  size: context.h(16),
                                                  color: AppColors.pimaryColor,
                                                )
                                              : NormalText(
                                                  titleText: '${index + 1}',
                                                ),
                                        ),
                                      ),
                                    ),

                                    SizedBox(width: context.w(9)),

                                    /// Text
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

                                // GestureDetector(
                                //   onTap: () {
                                //     dailyHeightViewModel.toggleExpand(
                                //       index,
                                //     ); // ⬇️ ONLY
                                //   },
                                //   child: Icon(
                                //     dailyHeightViewModel.isPlanSelected(index)
                                //         ? Icons.keyboard_arrow_up
                                //         : Icons.keyboard_arrow_down,
                                //     size: context.h(24),
                                //   ),
                                // ),
                                GestureDetector(
                                  onTap: () {
                                    dailyHeightViewModel.toggleExpand(index);
                                  },
                                  child: Icon(
                                    dailyHeightViewModel.isExpanded(index)
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
                                  dailyHeightViewModel.isExpanded(index)
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
          ],
        ),
      ),
    );
  }
}
