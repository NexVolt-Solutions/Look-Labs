import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:flutter_svg/svg.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Features/ViewModel/daily_workout_routine_view_model.dart';
import 'package:looklabs/Features/Widget/light_card_widget.dart';
import 'package:looklabs/Features/Widget/normal_text.dart';
import 'package:looklabs/Features/Widget/plan_container.dart';

class WorkoutRoutineHeaderSection extends StatelessWidget {
  const WorkoutRoutineHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: context.sh(24)),
        NormalText(
          crossAxisAlignment: CrossAxisAlignment.start,
          titleText: 'Your guided exercises for today',
          titleSize: context.sp(16),
          titleWeight: FontWeight.w600,
          titleColor: AppColors.subHeadingColor,
        ),
        SizedBox(height: context.sh(8)),
      ],
    );
  }
}

class WorkoutPlanCard extends StatelessWidget {
  const WorkoutPlanCard({
    super.key,
    required this.title,
    required this.iconAsset,
    required this.iconColorFilter,
    required this.items,
    required this.baseGlobalIndex,
    required this.viewModel,
  });

  final String title;
  final String iconAsset;
  final ColorFilter? iconColorFilter;
  final List<Map<String, dynamic>> items;
  final int baseGlobalIndex;
  final DailyWorkoutRoutineViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();
    return PlanContainer(
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
                      iconAsset,
                      colorFilter: iconColorFilter,
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                ),
              ),
              SizedBox(width: context.sw(11)),
              Expanded(
                child: NormalText(
                  titleText: title,
                  titleSize: context.sp(12),
                  titleWeight: FontWeight.w600,
                  titleColor: AppColors.subHeadingColor,
                ),
              ),
            ],
          ),
          ...List.generate(items.length, (index) {
            final item = items[index];
            final globalIndex = baseGlobalIndex + index;
            final isDone = viewModel.isCompleted(globalIndex);
            final seq = item['seq'];
            final displayNum = seq is int ? seq : (index + 1);
            return _WorkoutRoutineItemTile(
              item: item,
              globalIndex: globalIndex,
              displayNum: displayNum,
              isDone: isDone,
              viewModel: viewModel,
            );
          }),
        ],
      ),
    );
  }
}

class _WorkoutRoutineItemTile extends StatelessWidget {
  const _WorkoutRoutineItemTile({
    required this.item,
    required this.globalIndex,
    required this.displayNum,
    required this.isDone,
    required this.viewModel,
  });

  final Map<String, dynamic> item;
  final int globalIndex;
  final int displayNum;
  final bool isDone;
  final DailyWorkoutRoutineViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: double.infinity,
        padding: context.paddingSymmetricR(vertical: 8, horizontal: 20),
        margin: context.paddingSymmetricR(vertical: 11),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isDone ? AppColors.pimaryColor : AppColors.backGroundColor,
            width: context.sw(1.5),
          ),
          color: isDone
              ? AppColors.pimaryColor.withValues(alpha: 0.15)
              : AppColors.backGroundColor,
          boxShadow: [
            BoxShadow(
              color: AppColors.customContainerColorUp.withValues(alpha: 0.4),
              offset: const Offset(5, 5),
              blurRadius: 5,
            ),
            BoxShadow(
              color: AppColors.customContinerColorDown.withValues(alpha: 0.4),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => viewModel.markExerciseDone(globalIndex),
                        child: Container(
                          height: context.sh(28),
                          width: context.sw(28),
                          decoration: BoxDecoration(
                            color: isDone
                                ? AppColors.pimaryColor
                                : AppColors.backGroundColor,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.customContainerColorUp.withValues(alpha: 0.4),
                                offset: const Offset(3, 3),
                                blurRadius: 4,
                                inset: true,
                              ),
                              BoxShadow(
                                color: AppColors.customContinerColorDown.withValues(alpha: 0.4),
                                offset: const Offset(-3, -3),
                                blurRadius: 4,
                                inset: true,
                              ),
                            ],
                          ),
                          child: Center(
                            child: isDone
                                ? Icon(
                                    Icons.check,
                                    size: context.sh(16),
                                    color: AppColors.white,
                                  )
                                : NormalText(titleText: '$displayNum'),
                          ),
                        ),
                      ),
                      SizedBox(width: context.sw(9)),
                      Expanded(
                        child: NormalText(
                          titleText: item['time'],
                          titleSize: context.sp(14),
                          titleWeight: FontWeight.w500,
                          titleColor: AppColors.subHeadingColor,
                          subText: item['activity'],
                          subSize: context.sp(10),
                          subWeight: FontWeight.w400,
                          subColor: AppColors.subHeadingColor,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => viewModel.toggleExpand(globalIndex),
                  child: Icon(
                    viewModel.isExpanded(globalIndex)
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    size: context.sh(24),
                  ),
                ),
              ],
            ),
            AnimatedCrossFade(
              firstChild: const SizedBox(),
              secondChild: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: context.sh(12)),
                  NormalText(
                    titleText: item['details'] ?? '',
                    titleSize: context.sp(12),
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

class WorkoutRoutineInsightCard extends StatelessWidget {
  const WorkoutRoutineInsightCard({super.key, required this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    if (message == null || message!.isEmpty) return const SizedBox.shrink();
    return Column(
      children: [
        SizedBox(height: context.sh(8)),
        LightCardWidget(text: message!),
      ],
    );
  }
}
