import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:flutter_svg/svg.dart';
import 'package:looklabs/Core/Network/api_error_handler.dart';
import 'package:looklabs/Features/Widget/app_bar_container.dart';
import 'package:looklabs/Features/Widget/custom_button.dart';
import 'package:looklabs/Features/Widget/height_widget_cont.dart';
import 'package:looklabs/Features/Widget/normal_text.dart';
import 'package:looklabs/Features/Widget/plan_container.dart';
import 'package:looklabs/Core/Constants/app_assets.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Core/Routes/routes_name.dart';
import 'package:looklabs/Features/ViewModel/work_out_result_screen_view_model.dart';
import 'package:provider/provider.dart';

class WorkOutResultScreen extends StatefulWidget {
  const WorkOutResultScreen({super.key, this.workoutData});

  final Map<String, dynamic>? workoutData;

  @override
  State<WorkOutResultScreen> createState() => _WorkOutResultScreenState();
}

class _WorkOutResultScreenState extends State<WorkOutResultScreen> {
  // Widget _buildProgressChip(BuildContext context, String label) {
  //   return Container(
  //     padding: context.paddingSymmetricR(horizontal: 10, vertical: 6),
  //     decoration: BoxDecoration(
  //       color: AppColors.pimaryColor.withOpacity(0.1),
  //       borderRadius: BorderRadius.circular(context.radiusR(8)),
  //     ),
  //     child: NormalText(
  //       titleText: label,
  //       titleSize: context.sp(11),
  //       titleWeight: FontWeight.w500,
  //       titleColor: AppColors.subHeadingColor,
  //     ),
  //   );
  // }

  @override
  void initState() {
    super.initState();
    if (widget.workoutData != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        context.read<WorkOutResultScreenViewModel>().setWorkoutData(
          widget.workoutData!,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final workOutResultViewModel = Provider.of<WorkOutResultScreenViewModel>(
      context,
    );
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: EdgeInsetsGeometry.only(
          top: context.sh(5),
          left: context.sw(20),
          right: context.sw(20),
          bottom: context.sh(30),
        ),
        child: CustomButton(
          isEnabled: !workOutResultViewModel.generatePlanLoading,
          onTap: () async {
            if (workOutResultViewModel.selectedIndex < 0) {
              ApiErrorHandler.showSnackBar(context);
              return;
            }
            final response = await workOutResultViewModel.generateWorkoutPlan(
              selectedFocusIndex: workOutResultViewModel.selectedIndex,
            );
            if (!context.mounted) return;
            if (!response.success) {
              ApiErrorHandler.showSnackBar(context, response: response);
            }
            Navigator.pushNamed(
              context,
              RoutesName.WorkOutProgressScreen,
              arguments:
                  workOutResultViewModel.workoutData ?? widget.workoutData,
            );
          },
          text: workOutResultViewModel.generatePlanLoading
              ? 'Generating...'
              : 'Get Started',
          color: AppColors.pimaryColor,
        ),
      ),

      backgroundColor: AppColors.backGroundColor,

      body: SafeArea(
        child: ListView(
          padding: context.paddingSymmetricR(horizontal: 20),
          children: [
            AppBarContainer(
              title: workOutResultViewModel.screenTitle ?? 'Workout',
              onTap: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(height: context.sh(24)),
            if (workOutResultViewModel.aiMessage != null &&
                workOutResultViewModel.aiMessage!.isNotEmpty)
              NormalText(
                crossAxisAlignment: CrossAxisAlignment.start,
                titleText: workOutResultViewModel.aiMessage!,
                titleSize: context.sp(14),
                titleWeight: FontWeight.w600,
                titleColor: AppColors.subHeadingColor,
              ),
            if (workOutResultViewModel.aiMessage != null &&
                workOutResultViewModel.aiMessage!.isNotEmpty)
              SizedBox(height: context.sh(18)),
            if (workOutResultViewModel.gridData.isNotEmpty) ...[
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    workOutResultViewModel.gridData.length,
                    (index) {
                      return Padding(
                        padding: context.paddingSymmetricR(vertical: 6),
                        child: HeightWidgetCont(
                          title:
                              workOutResultViewModel.gridData[index]['title'],
                          subTitle: workOutResultViewModel
                              .gridData[index]['subtitle'],
                          imgPath:
                              workOutResultViewModel.gridData[index]['image'],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
            if (workOutResultViewModel.gridData.isNotEmpty) ...[
              SizedBox(height: context.sh(18)),
              NormalText(
                titleText: 'Intensity',
                titleSize: context.sp(16),
                titleWeight: FontWeight.w600,
                titleColor: AppColors.subHeadingColor,
              ),
              SizedBox(height: context.sh(8)),
              Wrap(
                spacing: context.sw(12),
                runSpacing: context.sh(8),
                children: WorkOutResultScreenViewModel.intensityOptions
                    .map(
                      (opt) => PlanContainer(
                        padding: context.paddingSymmetricR(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        isSelected: workOutResultViewModel.isIntensitySelected(
                          opt,
                        ),
                        radius: BorderRadius.circular(context.radiusR(12)),
                        onTap: () =>
                            workOutResultViewModel.selectIntensity(opt),
                        child: NormalText(
                          titleText: opt,
                          titleSize: context.sp(14),
                          titleWeight: FontWeight.w500,
                          titleColor:
                              workOutResultViewModel.isIntensitySelected(opt)
                              ? AppColors.pimaryColor
                              : AppColors.subHeadingColor,
                        ),
                      ),
                    )
                    .toList(),
              ),
              SizedBox(height: context.sh(12)),
              NormalText(
                titleText: 'Activity',
                titleSize: context.sp(16),
                titleWeight: FontWeight.w600,
                titleColor: AppColors.subHeadingColor,
              ),
              SizedBox(height: context.sh(8)),
              Wrap(
                spacing: context.sw(12),
                runSpacing: context.sh(8),
                children: WorkOutResultScreenViewModel.activityOptions
                    .map(
                      (opt) => PlanContainer(
                        padding: context.paddingSymmetricR(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        isSelected: workOutResultViewModel.isActivitySelected(
                          opt,
                        ),
                        radius: BorderRadius.circular(context.radiusR(12)),
                        onTap: () => workOutResultViewModel.selectActivity(opt),
                        child: NormalText(
                          titleText: opt,
                          titleSize: context.sp(14),
                          titleWeight: FontWeight.w500,
                          titleColor:
                              workOutResultViewModel.isActivitySelected(opt)
                              ? AppColors.pimaryColor
                              : AppColors.subHeadingColor,
                        ),
                      ),
                    )
                    .toList(),
              ),
              SizedBox(height: context.sh(18)),
            ],
            if (workOutResultViewModel.exData.isNotEmpty) ...[
              SizedBox(height: context.sh(18)),
              NormalText(
                titleText: 'Today\'s Focus',
                titleSize: context.sp(18),
                titleWeight: FontWeight.w600,
                titleColor: AppColors.subHeadingColor,
              ),
              SizedBox(height: context.sh(8)),
              Wrap(
                spacing: context.sw(12),
                // runSpacing: context.sh(1),
                children: List.generate(workOutResultViewModel.exData.length, (
                  btnIndex,
                ) {
                  final bool isSelected = workOutResultViewModel.isSelected(
                    btnIndex,
                  );

                  return PlanContainer(
                    padding: context.paddingSymmetricR(
                      horizontal: 18,
                      vertical: 11,
                    ),
                    margin: context.paddingSymmetricR(horizontal: 0),
                    isSelected: isSelected,
                    radius: BorderRadius.circular(context.radiusR(16)),

                    onTap: () async {
                      final wasSelected = workOutResultViewModel.isSelected(
                        btnIndex,
                      );
                      workOutResultViewModel.selectExercise(btnIndex);
                      // Call generate-plan when selecting a chip to update Today's Workout card
                      if (!wasSelected) {
                        await workOutResultViewModel.generateWorkoutPlan(
                          selectedFocusIndex: btnIndex,
                        );
                      }
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Center(
                          child: SizedBox(
                            height: context.sh(20),
                            width: context.sw(20),
                            child: SvgPicture.asset(
                              workOutResultViewModel.exData[btnIndex]['image'],
                              fit: BoxFit.scaleDown,
                              color: isSelected
                                  ? AppColors.pimaryColor
                                  : AppColors.subHeadingColor,
                            ),
                          ),
                        ),

                        SizedBox(width: context.sw(8)),

                        NormalText(
                          titleText:
                              workOutResultViewModel.exData[btnIndex]['title'],
                          titleSize: context.sp(14),
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
              SizedBox(height: context.sh(18)),
            ],

            // Today's Workout card – only when API data exists
            // Counts from generate-plan; show "0 exercises • 0 min" until chip is tapped.
            // On tap: call generate-plan if no exercises yet, then navigate.
            if ((workOutResultViewModel.workoutData ?? widget.workoutData) !=
                null) ...[
              PlanContainer(
                margin: context.paddingSymmetricR(horizontal: 0),
                padding: context.paddingSymmetricR(
                  horizontal: 12,
                  vertical: 12,
                ),
                isSelected: false,
                onTap: workOutResultViewModel.generatePlanLoading
                    ? null
                    : () async {
                        var data =
                            workOutResultViewModel.workoutData ??
                            widget.workoutData;
                        if (data == null) return;
                        var hasExercises =
                            workOutResultViewModel
                                .morningRoutineList
                                .isNotEmpty ||
                            workOutResultViewModel
                                .eveningRoutineList
                                .isNotEmpty;
                        if (!hasExercises) {
                          if (workOutResultViewModel.selectedIndex < 0) {
                            ApiErrorHandler.showSnackBar(context);
                            return;
                          }
                          final response = await workOutResultViewModel
                              .generateWorkoutPlan(
                                selectedFocusIndex:
                                    workOutResultViewModel.selectedIndex,
                              );
                          if (!context.mounted) return;
                          if (!response.success) {
                            ApiErrorHandler.showSnackBar(
                              context,
                              response: response,
                            );
                            return;
                          }
                          data = workOutResultViewModel.workoutData ?? data;
                          hasExercises =
                              workOutResultViewModel
                                  .morningRoutineList
                                  .isNotEmpty ||
                              workOutResultViewModel
                                  .eveningRoutineList
                                  .isNotEmpty;
                          if (!hasExercises) {
                            ApiErrorHandler.showSnackBar(context);
                            return;
                          }
                        }
                        if (!context.mounted) return;
                        Navigator.pushNamed(
                          context,
                          RoutesName.DailyWorkoutRoutineScreen,
                          arguments: data,
                        );
                      },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          NormalText(
                            titleText: 'Today\'s Workout',
                            titleSize: context.sp(16),
                            titleWeight: FontWeight.w600,
                            titleColor: AppColors.subHeadingColor,
                          ),
                          SizedBox(height: context.sh(4)),
                          NormalText(
                            titleText:
                                workOutResultViewModel.generatePlanLoading
                                ? 'Loading plan...'
                                : '${workOutResultViewModel.totalExercises ?? 0} exercises • ${workOutResultViewModel.totalDurationMin ?? 0} min',
                            titleSize: context.sp(12),
                            titleWeight: FontWeight.w400,
                            titleColor: AppColors.subHeadingColor.withOpacity(
                              0.7,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (workOutResultViewModel.generatePlanLoading)
                      SizedBox(
                        width: context.sw(24),
                        height: context.sh(24),
                        child: const CircularProgressIndicator(strokeWidth: 2),
                      )
                    else
                      Icon(
                        Icons.chevron_right,
                        size: context.sh(24),
                        color: AppColors.subHeadingColor,
                      ),
                  ],
                ),
              ),
              SizedBox(height: context.sh(18)),
            ],
            if (workOutResultViewModel.postureInsight.isNotEmpty) ...[
              PlanContainer(
                margin: context.paddingSymmetricR(horizontal: 0),
                padding: context.paddingSymmetricR(
                  horizontal: 12,
                  vertical: 12,
                ),
                isSelected: false,
                onTap: () {},
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                            color: AppColors.customContainerColorUp.withOpacity(
                              0.4,
                            ),
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
                            AppAssets.lightBulbIcon,
                            fit: BoxFit.scaleDown,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: context.sh(8)),

                    NormalText(
                      titleText:
                          workOutResultViewModel.postureInsightTitle.isNotEmpty
                          ? workOutResultViewModel.postureInsightTitle
                          : 'Posture Insight',
                      titleSize: context.sp(16),
                      titleWeight: FontWeight.w500,
                      titleColor: AppColors.subHeadingColor,
                      subText:
                          workOutResultViewModel
                              .postureInsightMessage
                              .isNotEmpty
                          ? workOutResultViewModel.postureInsightMessage
                          : workOutResultViewModel.postureInsight,
                      subSize: context.sp(12),
                      subWeight: FontWeight.w600,
                    ),
                  ],
                ),
              ),
              SizedBox(height: context.sh(20)),
            ],
          ],
        ),
      ),
    );
  }
}
