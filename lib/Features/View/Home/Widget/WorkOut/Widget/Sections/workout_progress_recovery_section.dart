import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:flutter_svg/svg.dart';
import 'package:looklabs/Core/Constants/app_assets.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Core/Routes/routes_name.dart';
import 'package:looklabs/Features/ViewModel/work_out_progress_screen_view_model.dart';
import 'package:looklabs/Features/Widget/activity_consistency_widget.dart';
import 'package:looklabs/Features/Widget/normal_text.dart';
import 'package:looklabs/Features/Widget/plan_container.dart';

class WorkoutTodayCardSection extends StatelessWidget {
  const WorkoutTodayCardSection({
    super.key,
    required this.viewModel,
    required this.workoutData,
  });

  final WorkOutProgressScreenViewModel viewModel;
  final Map<String, dynamic>? workoutData;

  @override
  Widget build(BuildContext context) {
    return PlanContainer(
      margin: context.paddingSymmetricR(horizontal: 0),
      padding: context.paddingSymmetricR(horizontal: 12, vertical: 12),
      isSelected: false,
      onTap: () {
        final data = workoutData ?? <String, dynamic>{};
        Navigator.pushNamed(
          context,
          RoutesName.DailyWorkoutRoutineScreen,
          arguments: data,
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            fit: FlexFit.loose,
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
                      '${viewModel.todayCompleted}/${viewModel.todayTotal} exercises',
                  titleSize: context.sp(12),
                  titleWeight: FontWeight.w400,
                  titleColor: AppColors.subHeadingColor.withValues(alpha: 0.7),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right,
            size: context.sh(24),
            color: AppColors.subHeadingColor,
          ),
        ],
      ),
    );
  }
}

class WorkoutRecoverySection extends StatelessWidget {
  const WorkoutRecoverySection({super.key, required this.viewModel});

  final WorkOutProgressScreenViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ActivityConsistencyWidget(
          title: 'Workout Consistency',
          subtitle: 'Your workout activity this week',
          pressentage: viewModel.displayWorkoutWeekScore > 0
              ? viewModel.displayWorkoutWeekScore
              : (viewModel.todayScore > 0
                  ? viewModel.todayScore
                  : (viewModel.fitnessConsistencyProgress > 0
                      ? viewModel.fitnessConsistencyProgress.toDouble()
                      : 0.0)),
        ),
        SizedBox(height: context.sh(16)),
        NormalText(
          titleText: 'Daily Recovery Checklist',
          titleSize: context.sp(18),
          titleWeight: FontWeight.w600,
          titleColor: AppColors.subHeadingColor,
        ),
        SizedBox(height: context.sh(18)),
        Column(
          children: List.generate(viewModel.checkBoxName.length, (index) {
            return Padding(
              padding: EdgeInsets.only(bottom: context.sh(12)),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () async => viewModel.toggleChecklist(index),
                    child: Container(
                      height: context.sh(28),
                      width: context.sw(28),
                      decoration: BoxDecoration(
                        color: viewModel.selectedChecklist[index]
                            ? AppColors.pimaryColor
                            : AppColors.backGroundColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.customContainerColorUp
                                .withValues(alpha: 0.4),
                            offset: const Offset(3, 3),
                            blurRadius: 4,
                            inset: true,
                          ),
                          BoxShadow(
                            color: AppColors.customContinerColorDown
                                .withValues(alpha: 0.4),
                            offset: const Offset(-3, -3),
                            blurRadius: 4,
                            inset: true,
                          ),
                        ],
                      ),
                      child: Center(
                        child: viewModel.selectedChecklist[index]
                            ? Icon(
                                Icons.check,
                                size: context.sh(16),
                                color: AppColors.white,
                              )
                            : const SizedBox(),
                      ),
                    ),
                  ),
                  SizedBox(width: context.sw(12)),
                  Expanded(
                    child: NormalText(
                      titleText: viewModel.checkBoxName[index],
                      titleSize: context.sp(16),
                      titleWeight: FontWeight.w600,
                      titleColor: AppColors.subHeadingColor,
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }
}

class WorkoutInsightCardSection extends StatelessWidget {
  const WorkoutInsightCardSection({super.key, required this.viewModel});

  final WorkOutProgressScreenViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final title = viewModel.insightCardTitle ??
        viewModel.postureInsight ??
        viewModel.aiMessage ??
        'Small daily workouts create big long-term results. You\'re doing great—keep up the momentum.';
    final body = viewModel.insightCardBody;
    final sub = (body != null && body.isNotEmpty && body != title) ? body : null;

    return PlanContainer(
      padding: context.paddingSymmetricR(horizontal: 12, vertical: 12),
      isSelected: false,
      onTap: () {},
      child: Row(
        children: [
          Container(
            height: context.sh(28),
            width: context.sw(28),
            decoration: BoxDecoration(
              color: AppColors.backGroundColor,
              borderRadius: BorderRadius.circular(context.radiusR(10)),
              boxShadow: [
                BoxShadow(
                  color: AppColors.customContainerColorUp.withValues(alpha: 0.4),
                  offset: const Offset(3, 3),
                  blurRadius: 4,
                ),
                BoxShadow(
                  color: AppColors.customContinerColorDown.withValues(alpha: 0.4),
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
          SizedBox(width: context.sw(11)),
          Expanded(
            child: NormalText(
              titleText: title,
              subText: sub,
              titleSize: context.sp(12),
              titleWeight: FontWeight.w600,
              titleColor: AppColors.subHeadingColor,
              subSize: context.sp(11),
              subWeight: FontWeight.w400,
              subColor: AppColors.subHeadingColor.withValues(alpha: 0.85),
              sizeBoxheight: sub != null ? context.sh(6) : null,
            ),
          ),
        ],
      ),
    );
  }
}
