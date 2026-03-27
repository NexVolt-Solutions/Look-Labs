import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Features/Widget/custom_container.dart';
import 'package:looklabs/Features/Widget/line_chart_widget.dart';
import 'package:looklabs/Features/Widget/normal_text.dart';
import 'package:looklabs/Features/Widget/plan_container.dart';
import 'package:looklabs/Model/sales_data.dart';

class RecoveryProgressSection extends StatelessWidget {
  const RecoveryProgressSection({
    super.key,
    required this.periodButtons,
    required this.selectedPeriod,
    required this.onPeriodTap,
    required this.chartLoading,
    required this.chartData,
    required this.repButtons,
    required this.selectedAction,
    required this.onActionTap,
  });

  final List<String> periodButtons;
  final String selectedPeriod;
  final ValueChanged<String> onPeriodTap;
  final bool chartLoading;
  final List<SalesData> chartData;
  final List<Map<String, String>> repButtons;
  final int selectedAction;
  final ValueChanged<int> onActionTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        NormalText(
          titleText: 'Your Progress',
          titleSize: context.sp(18),
          titleWeight: FontWeight.w600,
          titleColor: AppColors.subHeadingColor,
        ),
        SizedBox(height: context.sh(8)),
        Row(
          children: List.generate(periodButtons.length, (i) {
            final period = periodButtons[i];
            final selected = selectedPeriod == period;
            return Expanded(
              child: CustomContainer(
                radius: context.radiusR(10),
                onTap: () => onPeriodTap(period),
                color: selected
                    ? AppColors.buttonColor.withValues(alpha: 0.11)
                    : AppColors.backGroundColor,
                border: selected
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
          child: chartLoading
              ? SizedBox(
                  height: context.sh(120),
                  child: const Center(child: CircularProgressIndicator()),
                )
              : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: (chartData.length * 56.0).clamp(320.0, 900.0),
                    child: LineChartWidget(workoutChartData: chartData),
                  ),
                ),
        ),
        SizedBox(height: context.sh(10)),
        SizedBox(
          height: context.sh(74),
          child: Row(
            children: List.generate(2, (i) {
              final item = repButtons[i];
              return Expanded(
                child: PlanContainer(
                  margin: context.paddingSymmetricR(horizontal: 4, vertical: 0),
                  padding: context.paddingSymmetricR(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  radius: BorderRadius.circular(context.radiusR(10)),
                  isSelected: selectedAction == i,
                  onTap: () => onActionTap(i),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: context.sh(20),
                        width: context.sw(20),
                        child: SvgPicture.asset(
                          item['image']!,
                          colorFilter: const ColorFilter.mode(
                            AppColors.pimaryColor,
                            BlendMode.srcIn,
                          ),
                          fit: BoxFit.scaleDown,
                        ),
                      ),
                      SizedBox(height: context.sh(4)),
                      NormalText(
                        titleText: item['text'],
                        titleSize: context.sp(12),
                        titleWeight: FontWeight.w500,
                        titleColor: AppColors.subHeadingColor,
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
