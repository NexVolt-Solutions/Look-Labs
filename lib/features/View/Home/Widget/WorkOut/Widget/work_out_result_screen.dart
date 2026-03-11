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

  /// API response from domain answers (ai_attributes, ai_exercises, ai_message, ai_progress).
  final Map<String, dynamic>? workoutData;

  @override
  State<WorkOutResultScreen> createState() => _WorkOutResultScreenState();
}

class _WorkOutResultScreenState extends State<WorkOutResultScreen> {
  Widget _buildProgressChip(BuildContext context, String label) {
    return Container(
      padding: context.paddingSymmetricR(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.pimaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(context.radiusR(8)),
      ),
      child: NormalText(
        titleText: label,
        titleSize: context.sp(11),
        titleWeight: FontWeight.w500,
        titleColor: AppColors.subHeadingColor,
      ),
    );
  }

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
            final response =
                await workOutResultViewModel.generateWorkoutPlan();
            if (!context.mounted) return;
            if (!response.success) {
              ApiErrorHandler.showSnackBar(
                context,
                fallback: response.message ??
                    'Could not generate workout plan. Proceeding anyway.',
              );
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
              title: 'Workout',
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
                titleSize: context.sp(16),
                titleWeight: FontWeight.w600,
                titleColor: AppColors.subHeadingColor,
              ),
            if (workOutResultViewModel.aiMessage != null &&
                workOutResultViewModel.aiMessage!.isNotEmpty)
              SizedBox(height: context.sh(18)),
            if (workOutResultViewModel.gridData.isNotEmpty) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(workOutResultViewModel.gridData.length, (
                  index,
                ) {
                  return HeightWidgetCont(
                    // padding: context.paddingSymmetricR(horizontal: 11.5, vertical: 14.5),
                    title: workOutResultViewModel.gridData[index]['title'],
                    subTitle:
                        workOutResultViewModel.gridData[index]['subtitle'],
                    imgPath: workOutResultViewModel.gridData[index]['image'],
                  );
                }),
              ),
              SizedBox(height: context.sh(18)),
            ],

            // Today's Workout card – only when API data exists
            if ((workOutResultViewModel.workoutData ?? widget.workoutData) !=
                null) ...[
              PlanContainer(
                margin: context.paddingSymmetricR(horizontal: 0),
                padding: context.paddingSymmetricR(
                  horizontal: 12,
                  vertical: 12,
                ),
                isSelected: false,
                onTap: () {
                  final data =
                      workOutResultViewModel.workoutData ?? widget.workoutData;
                  if (data != null)
                    Navigator.pushNamed(
                      context,
                      RoutesName.WorkOutProgressScreen,
                      arguments: data,
                    );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
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
                                    '${workOutResultViewModel.totalExercises ?? 0} exercises • ${workOutResultViewModel.totalDurationMin ?? 0} min',
                                titleSize: context.sp(12),
                                titleWeight: FontWeight.w400,
                                titleColor: AppColors.subHeadingColor
                                    .withOpacity(0.7),
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
                    if (workOutResultViewModel.weeklyCalories != null ||
                        workOutResultViewModel.consistency != null ||
                        workOutResultViewModel.strengthGain != null ||
                        workOutResultViewModel.fitnessConsistency != null ||
                        workOutResultViewModel
                            .recoveryChecklist
                            .isNotEmpty) ...[
                      SizedBox(height: context.sh(12)),
                      const Divider(height: 1),
                      SizedBox(height: context.sh(12)),
                      Wrap(
                        spacing: context.sw(8),
                        runSpacing: context.sh(8),
                        children: [
                          if (workOutResultViewModel.weeklyCalories != null)
                            _buildProgressChip(
                              context,
                              '${workOutResultViewModel.weeklyCalories} cal',
                            ),
                          if (workOutResultViewModel.consistency != null)
                            _buildProgressChip(
                              context,
                              workOutResultViewModel.consistency!,
                            ),
                          if (workOutResultViewModel.strengthGain != null)
                            _buildProgressChip(
                              context,
                              workOutResultViewModel.strengthGain!,
                            ),
                          if (workOutResultViewModel.fitnessConsistency != null)
                            _buildProgressChip(
                              context,
                              workOutResultViewModel.fitnessConsistency!,
                            ),
                        ],
                      ),
                      if (workOutResultViewModel
                          .recoveryChecklist
                          .isNotEmpty) ...[
                        SizedBox(height: context.sh(12)),
                        ...workOutResultViewModel.recoveryChecklist.map(
                          (item) => Padding(
                            padding: EdgeInsets.only(bottom: context.sh(4)),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.check_circle_outline,
                                  size: context.sh(14),
                                  color: AppColors.pimaryColor,
                                ),
                                SizedBox(width: context.sw(6)),
                                Expanded(
                                  child: NormalText(
                                    titleText: item,
                                    titleSize: context.sp(11),
                                    titleWeight: FontWeight.w400,
                                    titleColor: AppColors.subHeadingColor
                                        .withOpacity(0.8),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ],
                ),
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
                spacing: context.sw(5),
                runSpacing: context.sh(11),
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

                    onTap: () {
                      workOutResultViewModel.selectExercise(btnIndex);
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
                      titleText: 'Posture Insight',
                      titleSize: context.sp(16),
                      titleWeight: FontWeight.w500,
                      titleColor: AppColors.subHeadingColor,
                      subText: workOutResultViewModel.postureInsight,
                      subSize: context.sp(12),
                      subWeight: FontWeight.w600,
                    ),
                  ],
                ),
              ),
              SizedBox(height: context.sh(20)),
            ],

            // ai_exercises: Morning category from API – wrapped in PlanContainer
            if (workOutResultViewModel.morningRoutineList.isNotEmpty) ...[
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
                            titleText: 'Morning Plan',
                            titleSize: context.sp(14),
                            titleWeight: FontWeight.w600,
                            titleColor: AppColors.subHeadingColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: context.sh(8)),
                    ...workOutResultViewModel.morningRoutineList
                        .asMap()
                        .entries
                        .map(
                          (entry) => _ExerciseCard(
                            item: entry.value,
                            globalIndex: entry.key,
                            viewModel: workOutResultViewModel,
                            ctx: context,
                          ),
                        ),
                  ],
                ),
              ),
              SizedBox(height: context.sh(8)),
            ],
            SizedBox(height: context.sh(20)),
            // ai_exercises: Evening category from API – wrapped in PlanContainer
            if (workOutResultViewModel.eveningRoutineList.isNotEmpty) ...[
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
                            titleText: 'Evening Plan',
                            titleSize: context.sp(14),
                            titleWeight: FontWeight.w600,
                            titleColor: AppColors.subHeadingColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: context.sh(8)),
                    ...workOutResultViewModel.eveningRoutineList
                        .asMap()
                        .entries
                        .map(
                          (entry) => _ExerciseCard(
                            item: entry.value,
                            globalIndex:
                                workOutResultViewModel
                                    .morningRoutineList
                                    .length +
                                entry.key,
                            viewModel: workOutResultViewModel,
                            ctx: context,
                          ),
                        ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Reusable exercise card from ai_exercises (morning/evening).
class _ExerciseCard extends StatelessWidget {
  const _ExerciseCard({
    required this.item,
    required this.globalIndex,
    required this.viewModel,
    required this.ctx,
  });

  final Map<String, dynamic> item;
  final int globalIndex;
  final WorkOutResultScreenViewModel viewModel;
  final BuildContext ctx;

  @override
  Widget build(BuildContext context) {
    final isSelected = viewModel.isPlanSelected(globalIndex);
    final seq = item['seq'];
    final displayNum = seq is int ? seq : (globalIndex + 1);

    return Center(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: double.infinity,
        padding: ctx.paddingSymmetricR(vertical: 8, horizontal: 20),
        margin: ctx.paddingSymmetricR(vertical: 11),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected
                ? AppColors.pimaryColor
                : AppColors.backGroundColor,
            width: ctx.sw(1.5),
          ),
          color: isSelected
              ? AppColors.pimaryColor.withOpacity(0.15)
              : AppColors.backGroundColor,
          boxShadow: [
            BoxShadow(
              color: AppColors.customContainerColorUp.withOpacity(0.4),
              offset: const Offset(5, 5),
              blurRadius: 5,
            ),
            BoxShadow(
              color: AppColors.customContinerColorDown.withOpacity(0.4),
              offset: const Offset(-5, -5),
              blurRadius: 5,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => viewModel.selectPlan(globalIndex),
                      child: Container(
                        height: ctx.sh(28),
                        width: ctx.sw(28),
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
                          child: viewModel.isPlanSelected(globalIndex)
                              ? Icon(
                                  Icons.check,
                                  size: ctx.sh(16),
                                  color: AppColors.pimaryColor,
                                )
                              : NormalText(titleText: '$displayNum'),
                        ),
                      ),
                    ),
                    SizedBox(width: ctx.sw(9)),
                    NormalText(
                      titleText: item['time'] ?? '',
                      titleSize: ctx.sp(14),
                      titleWeight: FontWeight.w500,
                      titleColor: AppColors.subHeadingColor,
                      subText: item['activity'] ?? '',
                      subSize: ctx.sp(10),
                      subWeight: FontWeight.w400,
                      subColor: AppColors.subHeadingColor,
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () => viewModel.toggleExpand(globalIndex),
                  child: Icon(
                    viewModel.isExpanded(globalIndex)
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    size: ctx.sh(24),
                  ),
                ),
              ],
            ),
            AnimatedCrossFade(
              firstChild: const SizedBox(),
              secondChild: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: ctx.sh(12)),
                  NormalText(
                    titleText: item['details'] ?? '',
                    titleSize: ctx.sp(12),
                    titleWeight: FontWeight.w600,
                    titleColor: AppColors.iconColor,
                  ),
                ],
              ),
              crossFadeState: viewModel.isExpanded(globalIndex)
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 300),
            ),
          ],
        ),
      ),
    );
  }
}
