import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:flutter_svg/svg.dart';
import 'package:looklabs/Core/Constants/app_assets.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Features/ViewModel/work_out_result_screen_view_model.dart';
import 'package:looklabs/Features/Widget/height_widget_cont.dart';
import 'package:looklabs/Features/Widget/normal_text.dart';
import 'package:looklabs/Features/Widget/plan_container.dart';

class WorkoutAiMessageSection extends StatelessWidget {
  const WorkoutAiMessageSection({super.key, required this.viewModel});

  final WorkOutResultScreenViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    if (viewModel.aiMessage == null || viewModel.aiMessage!.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        NormalText(
          crossAxisAlignment: CrossAxisAlignment.start,
          titleText: viewModel.aiMessage!,
          titleSize: context.sp(14),
          titleWeight: FontWeight.w600,
          titleColor: AppColors.subHeadingColor,
        ),
        SizedBox(height: context.sh(18)),
      ],
    );
  }
}

class WorkoutAttributesSection extends StatelessWidget {
  const WorkoutAttributesSection({super.key, required this.viewModel});

  final WorkOutResultScreenViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    if (viewModel.gridData.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(viewModel.gridData.length, (index) {
              return Padding(
                padding: context.paddingSymmetricR(vertical: 6),
                child: HeightWidgetCont(
                  title: viewModel.gridData[index]['title'],
                  subTitle: viewModel.gridData[index]['subtitle'],
                  imgPath: viewModel.gridData[index]['image'],
                ),
              );
            }),
          ),
        ),
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
          children: WorkOutResultScreenViewModel.intensityOptions.map((opt) {
            final selected = viewModel.isIntensitySelected(opt);
            return PlanContainer(
              padding: context.paddingSymmetricR(horizontal: 16, vertical: 10),
              isSelected: selected,
              radius: BorderRadius.circular(context.radiusR(12)),
              onTap: () => viewModel.selectIntensity(opt),
              child: NormalText(
                titleText: opt,
                titleSize: context.sp(14),
                titleWeight: FontWeight.w500,
                titleColor: selected
                    ? AppColors.pimaryColor
                    : AppColors.subHeadingColor,
              ),
            );
          }).toList(),
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
          children: WorkOutResultScreenViewModel.activityOptions.map((opt) {
            final selected = viewModel.isActivitySelected(opt);
            return PlanContainer(
              padding: context.paddingSymmetricR(horizontal: 16, vertical: 10),
              isSelected: selected,
              radius: BorderRadius.circular(context.radiusR(12)),
              onTap: () => viewModel.selectActivity(opt),
              child: NormalText(
                titleText: opt,
                titleSize: context.sp(14),
                titleWeight: FontWeight.w500,
                titleColor: selected
                    ? AppColors.pimaryColor
                    : AppColors.subHeadingColor,
              ),
            );
          }).toList(),
        ),
        SizedBox(height: context.sh(18)),
      ],
    );
  }
}

class WorkoutFocusSection extends StatelessWidget {
  const WorkoutFocusSection({super.key, required this.viewModel});

  final WorkOutResultScreenViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    if (viewModel.exData.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
          runSpacing: context.sh(12),
          children: List.generate(viewModel.exData.length, (btnIndex) {
            final isSelected = viewModel.isSelected(btnIndex);
            return PlanContainer(
              padding: context.paddingSymmetricR(horizontal: 18, vertical: 11),
              margin: context.paddingSymmetricR(horizontal: 0),
              isSelected: isSelected,
              radius: BorderRadius.circular(context.radiusR(16)),
              onTap: () => viewModel.selectExercise(btnIndex),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: context.sh(20),
                    width: context.sw(20),
                    child: SvgPicture.asset(
                      viewModel.exData[btnIndex]['image'],
                      fit: BoxFit.scaleDown,
                      colorFilter: ColorFilter.mode(
                        isSelected
                            ? AppColors.pimaryColor
                            : AppColors.subHeadingColor,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  SizedBox(width: context.sw(8)),
                  NormalText(
                    titleText: viewModel.exData[btnIndex]['title'],
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
        SizedBox(height: context.sh(16)),
      ],
    );
  }
}

class WorkoutPostureInsightSection extends StatelessWidget {
  const WorkoutPostureInsightSection({super.key, required this.viewModel});

  final WorkOutResultScreenViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    if (viewModel.postureInsight.isEmpty) return const SizedBox.shrink();
    return Column(
      children: [
        PlanContainer(
          margin: context.paddingSymmetricR(horizontal: 0),
          padding: context.paddingSymmetricR(horizontal: 12, vertical: 12),
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
              SizedBox(height: context.sh(8)),
              NormalText(
                titleText: viewModel.postureInsightTitle.isNotEmpty
                    ? viewModel.postureInsightTitle
                    : 'Posture Insight',
                titleSize: context.sp(16),
                titleWeight: FontWeight.w500,
                subText: viewModel.postureInsightMessage.isNotEmpty
                    ? viewModel.postureInsightMessage
                    : viewModel.postureInsight,
              ),
            ],
          ),
        ),
        SizedBox(height: context.sh(20)),
      ],
    );
  }
}
