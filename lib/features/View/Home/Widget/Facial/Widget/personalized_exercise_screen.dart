import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:flutter_svg/svg.dart';
import 'package:looklabs/Features/Widget/app_bar_container.dart';
import 'package:looklabs/Features/Widget/custom_button.dart';
import 'package:looklabs/Features/Widget/normal_text.dart';
import 'package:looklabs/Features/Widget/plan_container.dart';
import 'package:looklabs/Core/Constants/app_assets.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Core/Routes/routes_name.dart';
import 'package:looklabs/Features/ViewModel/personalized_exercise_screen_view_model.dart';
import 'package:provider/provider.dart';

class PersonalizedExerciseScreen extends StatefulWidget {
  const PersonalizedExerciseScreen({super.key});

  @override
  State<PersonalizedExerciseScreen> createState() =>
      _PersonalizedExerciseScreenState();
}

class _PersonalizedExerciseScreenState
    extends State<PersonalizedExerciseScreen> {
  @override
  Widget build(BuildContext context) {
    final personalizedExerciseScreenViewModel =
        Provider.of<PersonalizedExerciseScreenViewModel>(context);
    return Scaffold(
      backgroundColor: AppColors.backGroundColor,
      bottomNavigationBar: Padding(
        padding: EdgeInsetsGeometry.only(
          top: context.sh(5),
          left: context.sw(20),
          right: context.sw(20),
          bottom: context.sh(30),
        ),
        child: CustomButton(
          text: 'Check Your Progress',
          color: AppColors.pimaryColor,
          isEnabled: true,
          onTap: () {
            Navigator.pushNamed(context, RoutesName.FacialProgressScreen);
          },
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: context.paddingSymmetricR(horizontal: 20),
          children: [
            AppBarContainer(
              title: 'Personalized Exercise',
              onTap: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(height: context.sh(20)),
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
                              AppAssets.yogaIcon,
                              fit: BoxFit.scaleDown,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: context.sw(11)),
                      Expanded(
                        child: NormalText(
                          titleText: 'Today\'s Progress',
                          titleSize: context.sp(12),
                          titleWeight: FontWeight.w600,
                          titleColor: AppColors.subHeadingColor,
                          // subText: 'Best done after waking up',
                          // subSize: context.sp(10),
                          // subWeight: FontWeight.w400,
                        ),
                      ),
                      NormalText(
                        titleText: '2/5',
                        titleSize: context.sp(12),
                        titleWeight: FontWeight.w600,
                        titleColor: AppColors.iconColor,
                      ),
                    ],
                  ),
                  ...List.generate(
                    personalizedExerciseScreenViewModel
                        .heightRoutineList
                        .length,
                    (index) {
                      final item = personalizedExerciseScreenViewModel
                          .heightRoutineList[index];
                      final bool isSelected =
                          personalizedExerciseScreenViewModel.isPlanSelected(
                            index,
                          );

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
                                          personalizedExerciseScreenViewModel
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
                                                personalizedExerciseScreenViewModel
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
                                      personalizedExerciseScreenViewModel
                                          .toggleExpand(index);
                                    },
                                    child: Icon(
                                      personalizedExerciseScreenViewModel
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
                                      titleText: '• ' + item['details'],
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
                                    personalizedExerciseScreenViewModel
                                        .isExpanded(index)
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

            SizedBox(height: context.sh(30)),
          ],
        ),
      ),
    );
  }
}
