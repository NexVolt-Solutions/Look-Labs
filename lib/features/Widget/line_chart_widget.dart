import 'package:flutter/material.dart';
import 'package:looklabs/Core/Constants/app_assets.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Network/models/weekly_progress_response.dart';
import 'package:looklabs/Model/sales_data.dart';
import 'package:looklabs/Features/ViewModel/chart_view_model.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

/// Custom tooltip that shows [label] (e.g. day) and [value] with cloud icon and neumorphic style.
class _ChartTooltipContent extends StatelessWidget {
  const _ChartTooltipContent({required this.label, required this.value});

  final String label;
  final num value;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.sh(25),
      width: context.sw(40),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(context.radiusR(12)),
        boxShadow: [
          BoxShadow(
            color: AppColors.white,
            blurRadius: 8,
            offset: const Offset(2.5, 2.5),
          ),
        ],
      ),
      child: Center(
        child: Text(
          value.truncateToDouble() == value
              ? value.toInt().toString()
              : value.toStringAsFixed(1),
          style: TextStyle(
            fontSize: context.sp(12),
            color: AppColors.subHeadingColor,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

/// Tooltip behavior that shows actual chart data with custom cloud-style tooltip.
TooltipBehavior _customChartTooltip(BuildContext context) => TooltipBehavior(
  enable: true,
  color: Theme.of(context).colorScheme.surface,
  borderColor: Theme.of(context).colorScheme.surface,
  borderWidth: 0,
  builder:
      (
        dynamic data,
        dynamic point,
        dynamic series,
        int pointIndex,
        int seriesIndex,
      ) {
        String label;
        num value;
        if (data is WeeklyProgressDay) {
          label = data.day;
          value = data.score;
        } else if (data is SalesData) {
          label = data.month;
          value = data.sales;
        } else {
          label = '';
          value = 0;
        }
        return _ChartTooltipContent(label: label, value: value);
      },
);

class LineChartWidget extends StatelessWidget {
  const LineChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final chartVM = context.watch<ChartViewModel>();

    return SfCartesianChart(
      primaryXAxis: CategoryAxis(),

      tooltipBehavior: _customChartTooltip(context),

      series: <LineSeries<SalesData, String>>[
        LineSeries<SalesData, String>(
          dataSource: chartVM.chartData,
          xValueMapper: (data, _) => data.month,
          yValueMapper: (data, _) => data.sales,
          markerSettings: MarkerSettings(
            isVisible: true,
            image: AssetImage(AppAssets.image),
          ),
          dataLabelSettings: const DataLabelSettings(isVisible: true),
          enableTooltip: true,
        ),
      ],
    );
  }
}

/// Line chart for weekly progress (GET users/me/progress/weekly). Same style as [LineChartWidget].
class WeeklyProgressLineChart extends StatelessWidget {
  const WeeklyProgressLineChart({super.key, required this.days});

  final List<WeeklyProgressDay> days;

  @override
  Widget build(BuildContext context) {
    if (days.isEmpty) {
      return const SizedBox(
        height: 120,
        child: Center(child: Text('No data yet')),
      );
    }
    return SfCartesianChart(
      primaryXAxis: CategoryAxis(),
      tooltipBehavior: _customChartTooltip(context),
      series: <LineSeries<WeeklyProgressDay, String>>[
        LineSeries<WeeklyProgressDay, String>(
          dataSource: days,
          xValueMapper: (data, _) => data.day,
          yValueMapper: (data, _) => data.score.toDouble(),
          markerSettings: MarkerSettings(
            isVisible: true,
            image: AssetImage(AppAssets.masterCardIcon),
          ),
          dataLabelSettings: const DataLabelSettings(isVisible: true),
          enableTooltip: true,
        ),
      ],
    );
  }
}
