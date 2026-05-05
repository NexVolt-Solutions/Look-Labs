import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_svg/svg.dart';
import 'package:looklabs/Core/Constants/app_assets.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Features/ViewModel/work_out_progress_screen_view_model.dart';
import 'package:looklabs/Features/Widget/custom_container.dart';
import 'package:looklabs/Features/Widget/height_widget_cont.dart';
import 'package:looklabs/Features/Widget/line_chart_widget.dart';
import 'package:looklabs/Features/Widget/linear_slider_widget.dart';
import 'package:looklabs/Features/Widget/normal_text.dart';
import 'package:looklabs/Features/Widget/plan_container.dart';

class WorkoutProgressHeaderSection extends StatelessWidget {
  const WorkoutProgressHeaderSection({super.key, required this.viewModel});

  final WorkOutProgressScreenViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        NormalText(
          crossAxisAlignment: CrossAxisAlignment.start,
          titleText: 'Track your fitness, consistency, and recovery over time',
          titleSize: context.sp(16),
          titleWeight: FontWeight.w600,
          titleColor: AppColors.subHeadingColor,
        ),
        SizedBox(height: context.sh(8)),
        SizedBox(
          height: context.sh(135),
          child: ListView.builder(
            itemCount: viewModel.combinedTopCards.isEmpty
                ? 1
                : viewModel.combinedTopCards.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final cards = viewModel.combinedTopCards;
              final item = cards.isEmpty
                  ? {
                      'title': '—',
                      'value': '—',
                      'icon': AppAssets.fatLossIcon,
                    }
                  : cards[index];
              return HeightWidgetCont(
                title: item['value'] ?? '—',
                subTitle: item['title'] ?? '—',
                imgPath: item['icon'] ?? AppAssets.fatLossIcon,
              );
            },
          ),
        ),
      ],
    );
  }
}

class WorkoutMetricsSection extends StatelessWidget {
  const WorkoutMetricsSection({super.key, required this.viewModel});

  final WorkOutProgressScreenViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: context.sh(7)),
        Row(
          children: [
            CustomContainer(
              padding: context.paddingSymmetricR(horizontal: 4, vertical: 4),
              radius: context.radiusR(10),
              color: AppColors.backGroundColor,
              child: SvgPicture.asset(
                AppAssets.graphIcon,
                colorFilter: const ColorFilter.mode(
                  AppColors.pimaryColor,
                  BlendMode.srcIn,
                ),
                height: context.sh(24),
                width: context.sw(24),
                fit: BoxFit.scaleDown,
              ),
            ),
            SizedBox(width: context.sw(12)),
            NormalText(
              titleText: 'Workout Progress',
              titleSize: context.sp(18),
              titleWeight: FontWeight.w600,
              titleColor: AppColors.subHeadingColor,
            ),
          ],
        ),
        SizedBox(height: context.sh(8)),
        SizedBox(
          height: context.sh(155),
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.zero,
            children: [
              _ProgressBarCard(
                label: 'Fitness consistency',
                progress: viewModel.fitnessBarValue,
              ),
              SizedBox(width: context.sw(12)),
              _ProgressBarCard(
                label: 'Calorie balance',
                progress: viewModel.calorieBarValue,
              ),
              SizedBox(width: context.sw(12)),
              _ProgressBarCard(
                label: 'Hydration',
                progress: viewModel.hydrationBarValue,
              ),
              if (viewModel.showStrengthProgressBar) ...[
                SizedBox(width: context.sw(12)),
                _ProgressBarCard(
                  label: 'Strength gain',
                  progress: viewModel.strengthBarValue,
                ),
              ],
            ],
          ),
        ),
        SizedBox(height: context.sh(8)),
        Row(
          children: List.generate(viewModel.buttonName.length, (index) {
            final period = viewModel.buttonName[index];
            final isSelected = viewModel.selectedChartPeriod == period;
            return Expanded(
              child: CustomContainer(
                radius: context.radiusR(10),
                onTap: () => viewModel.onChartPeriodTap(period),
                color: isSelected
                    ? AppColors.buttonColor.withValues(alpha: 0.11)
                    : AppColors.backGroundColor,
                border: isSelected
                    ? Border.all(color: AppColors.pimaryColor, width: 1.5)
                    : null,
                padding: context.paddingSymmetricR(horizontal: 8, vertical: 12),
                margin: context.paddingSymmetricR(horizontal: 4, vertical: 0),
                child: Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      period,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: context.sp(14),
                        fontWeight: FontWeight.w700,
                        color: AppColors.seconderyColor,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
        SizedBox(height: context.sh(8)),
        PlanContainer(
          padding: context.paddingSymmetricR(horizontal: 10, vertical: 10),
          radius: BorderRadius.circular(context.radiusR(10)),
          isSelected: false,
          onTap: () {},
          child: viewModel.chartLoading
              ? SizedBox(
                  height: context.sh(120),
                  child: const Center(child: CircularProgressIndicator()),
                )
              : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: (viewModel.chartDataForSelectedPeriod.length * 56.0)
                        .clamp(320.0, 900.0),
                    child: LineChartWidget(
                      workoutChartData: viewModel.chartDataForSelectedPeriod,
                      yAxisMinimum: 0,
                      yAxisMaximum: 100,
                      valueDisplaySuffix: '%',
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}

class _ProgressBarCard extends StatelessWidget {
  const _ProgressBarCard({required this.label, required this.progress});

  final String label;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.sw(220),
      child: PlanContainer(
        padding: context.paddingSymmetricR(horizontal: 7, vertical: 12),
        isSelected: false,
        onTap: () {},
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            NormalText(
              titleText: label,
              titleSize: context.sp(16),
              titleWeight: FontWeight.w500,
              titleColor: AppColors.subHeadingColor,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: context.sh(8)),
            LinearSliderWidget(
              progress: progress,
              height: context.sh(12),
              animatedConHeight: context.sh(12),
            ),
          ],
        ),
      ),
    );
  }
}
