import 'package:flutter/material.dart';
import 'package:looklabs/Core/Constants/app_assets.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Network/models/progress_graph_response.dart';
import 'package:looklabs/Core/Network/models/weekly_progress_response.dart';
import 'package:looklabs/Model/sales_data.dart';
import 'package:looklabs/Features/ViewModel/chart_view_model.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

/// Distinct colors for up to 8 domain lines in multi-line chart.
const List<Color> _domainChartColors = [
  Color(0xFF3A3559), // primary
  Color(0xFFE57373), // red
  Color(0xFF81C784), // green
  Color(0xFF64B5F6), // blue
  Color(0xFFFFB74D), // orange
  Color(0xFFBA68C8), // purple
  Color(0xFF4DB6AC), // teal
  Color(0xFFEDAF29), // gold
];

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
        } else if (data is WeeklyProgressDomain) {
          label = data.domain;
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
  /// When non-null and non-empty, shows this workout weekly data (from GET weekly-summary) instead of ChartViewModel.
  const LineChartWidget({super.key, this.workoutChartData});

  final List<SalesData>? workoutChartData;

  @override
  Widget build(BuildContext context) {
    final chartVM = context.watch<ChartViewModel>();
    final dataSource = (workoutChartData != null && workoutChartData!.isNotEmpty)
        ? workoutChartData!
        : chartVM.chartData;

    return SfCartesianChart(
      primaryXAxis: CategoryAxis(),
      tooltipBehavior: _customChartTooltip(context),
      series: <LineSeries<SalesData, String>>[
        LineSeries<SalesData, String>(
          dataSource: dataSource,
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

/// Placeholder domain used when there is no data so the chart frame (axes) still shows.
const WeeklyProgressDomain _emptyChartPlaceholder = WeeklyProgressDomain(
  domain: ' ',
  score: 0,
  hasData: false,
);

/// Data point for multi-line chart (domain progress over time).
class _DomainScorePoint {
  final String dateLabel;
  final String recordedAt;
  final num score;
  final String domain;

  const _DomainScorePoint({
    required this.dateLabel,
    required this.recordedAt,
    required this.score,
    required this.domain,
  });
}

/// Multi-line chart: one colored line per domain showing progress over time.
/// When [graphDomains] has time-series (scores), shows lines over dates.
/// When only [overviewDomains] (no time-series), shows bar chart with all domains.
class MultiDomainLineChart extends StatelessWidget {
  const MultiDomainLineChart({
    super.key,
    this.graphDomains = const [],
    this.overviewDomains = const [],
  });

  final List<WeeklyProgressDomain> overviewDomains;
  final List<ProgressGraphDomain> graphDomains;

  static String _formatDate(String recordedAt) {
    if (recordedAt.isEmpty) return '';
    try {
      final dt = DateTime.tryParse(recordedAt);
      if (dt == null) {
        return recordedAt.length > 10
            ? recordedAt.substring(0, 10)
            : recordedAt;
      }
      return '${dt.month}/${dt.day}';
    } catch (_) {
      return recordedAt.length > 10 ? recordedAt.substring(0, 10) : recordedAt;
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasTimeSeries = graphDomains.any((d) => d.scores.isNotEmpty);
    if (hasTimeSeries) {
      return _buildMultiLineChart(context);
    }
    if (overviewDomains.isNotEmpty) {
      return _buildDomainBarChart(context);
    }
    return _buildEmptyState(context);
  }

  Widget _buildMultiLineChart(BuildContext context) {
    final seriesList = <LineSeries<_DomainScorePoint, String>>[];
    for (
      var i = 0;
      i < graphDomains.length && i < _domainChartColors.length;
      i++
    ) {
      final domain = graphDomains[i];
      final points = <_DomainScorePoint>[];
      for (final s in domain.scores) {
        points.add(
          _DomainScorePoint(
            dateLabel: _formatDate(s.recordedAt),
            recordedAt: s.recordedAt,
            score: s.score,
            domain: domain.domain,
          ),
        );
      }
      points.sort((a, b) => a.recordedAt.compareTo(b.recordedAt));
      if (points.isEmpty) continue;
      seriesList.add(
        LineSeries<_DomainScorePoint, String>(
          dataSource: points,
          xValueMapper: (p, _) => p.dateLabel,
          yValueMapper: (p, _) => p.score.toDouble(),
          color: _domainChartColors[i],
          width: 2,
          markerSettings: MarkerSettings(
            isVisible: true,
            height: 6,
            width: 6,
            color: _domainChartColors[i],
          ),
          dataLabelSettings: const DataLabelSettings(isVisible: false),
          enableTooltip: true,
          name: domain.domain,
        ),
      );
    }
    if (seriesList.isEmpty) return _buildDomainBarChart(context);

    return SfCartesianChart(
      primaryXAxis: CategoryAxis(
        labelRotation: -45,
        majorGridLines: const MajorGridLines(width: 0.5),
      ),
      primaryYAxis: NumericAxis(
        minimum: 0,
        maximum: 100,
        axisLine: const AxisLine(width: 1),
        majorGridLines: const MajorGridLines(width: 0.5),
      ),
      tooltipBehavior: TooltipBehavior(
        enable: true,
        builder:
            (
              dynamic data,
              dynamic point,
              dynamic series,
              int pointIndex,
              int seriesIndex,
            ) {
              if (data is _DomainScorePoint) {
                return _ChartTooltipContent(
                  label: '${data.domain}: ${data.dateLabel}',
                  value: data.score,
                );
              }
              return const SizedBox.shrink();
            },
      ),
      legend: Legend(
        isVisible: true,
        position: LegendPosition.bottom,
        overflowMode: LegendItemOverflowMode.wrap,
      ),
      series: seriesList,
    );
  }

  Widget _buildDomainBarChart(BuildContext context) {
    return SfCartesianChart(
      primaryXAxis: CategoryAxis(
        labelRotation: -45,
        majorGridLines: const MajorGridLines(width: 0.5),
      ),
      primaryYAxis: NumericAxis(
        minimum: 0,
        maximum: 100,
        axisLine: const AxisLine(width: 1),
        majorGridLines: const MajorGridLines(width: 0.5),
      ),
      tooltipBehavior: _customChartTooltip(context),
      series: <CartesianSeries<WeeklyProgressDomain, String>>[
        ColumnSeries<WeeklyProgressDomain, String>(
          dataSource: overviewDomains,
          xValueMapper: (data, _) => data.domain,
          yValueMapper: (data, _) => data.score.toDouble(),
          pointColorMapper: (data, index) => index < _domainChartColors.length
              ? _domainChartColors[index]
              : _domainChartColors[0],
          dataLabelSettings: DataLabelSettings(
            isVisible: true,
            labelAlignment: ChartDataLabelAlignment.top,
          ),
          enableTooltip: true,
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return SizedBox(
      height: 160,
      child: Center(
        child: Text(
          'Complete domains to see progress',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.subHeadingColor.withValues(alpha: 0.7),
          ),
        ),
      ),
    );
  }
}

/// Line chart for weekly progress (GET users/me/progress/graph). Same style as [LineChartWidget].
/// Supports both days (time series) and domains (skincare, hair, etc.) from API.
/// When both are empty, the full chart frame (axes) is still shown with "No data yet" – only values are hidden.
class WeeklyProgressLineChart extends StatelessWidget {
  const WeeklyProgressLineChart({
    super.key,
    this.days = const [],
    this.domains = const [],
  });

  final List<WeeklyProgressDay> days;
  final List<WeeklyProgressDomain> domains;

  @override
  Widget build(BuildContext context) {
    // Period labels (Mon, Week 1–4, Jan 25) on X axis; score (0–100%) on Y axis
    if (days.isNotEmpty) {
      return SfCartesianChart(
        primaryXAxis: CategoryAxis(
          labelRotation: -45,
          majorGridLines: const MajorGridLines(width: 0.5),
        ),
        primaryYAxis: NumericAxis(
          minimum: 0,
          maximum: 100,
          axisLine: const AxisLine(width: 1),
          majorGridLines: const MajorGridLines(width: 0.5),
          axisLabelFormatter: (AxisLabelRenderDetails details) =>
              ChartAxisLabel('${details.value.toInt()}%', details.textStyle),
        ),
        tooltipBehavior: _customChartTooltip(context),
        series: <LineSeries<WeeklyProgressDay, String>>[
          LineSeries<WeeklyProgressDay, String>(
            dataSource: days,
            xValueMapper: (data, _) => data.day,
            yValueMapper: (data, _) => data.score.toDouble(),
            markerSettings: const MarkerSettings(isVisible: false),
            dataLabelSettings: const DataLabelSettings(isVisible: false),
            enableTooltip: true,
          ),
        ],
      );
    }
    // Domain names on X axis; score (0–100%) on Y axis
    if (domains.isNotEmpty) {
      return SfCartesianChart(
        primaryXAxis: CategoryAxis(
          labelRotation: -45,
          maximumLabels: 20,

          labelIntersectAction: AxisLabelIntersectAction.rotate45,
          labelsExtent: 60,
          majorGridLines: const MajorGridLines(width: 0.5),
        ),
        primaryYAxis: NumericAxis(
          minimum: 0,
          maximum: 100,
          axisLine: const AxisLine(width: 1),
          majorGridLines: const MajorGridLines(width: 0.5),
          axisLabelFormatter: (AxisLabelRenderDetails details) =>
              ChartAxisLabel('${details.value.toInt()}%', details.textStyle),
        ),
        tooltipBehavior: _customChartTooltip(context),
        series: <LineSeries<WeeklyProgressDomain, String>>[
          LineSeries<WeeklyProgressDomain, String>(
            dataSource: domains,

            xValueMapper: (data, _) => data.domain,
            yValueMapper: (data, _) => data.score.toDouble(),
            markerSettings: const MarkerSettings(isVisible: true),
            dataLabelSettings: const DataLabelSettings(isVisible: false),
            enableTooltip: true,
          ),
        ],
      );
    }
    // No data: keep the full graph (chart frame with axes), show only "No data yet" inside – don't remove the chart.
    return SizedBox(
      height: 120,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SfCartesianChart(
            primaryXAxis: CategoryAxis(
              maximumLabels: 1,
              majorGridLines: MajorGridLines(width: 0),
              axisLine: AxisLine(width: 1),
            ),
            primaryYAxis: NumericAxis(
              minimum: 0,
              maximum: 100,
              majorGridLines: MajorGridLines(width: 0),
              axisLine: AxisLine(width: 1),
            ),
            series: <LineSeries<WeeklyProgressDomain, String>>[
              LineSeries<WeeklyProgressDomain, String>(
                dataSource: const [_emptyChartPlaceholder],
                xValueMapper: (_, _) => ' ',
                yValueMapper: (_, _) => 0.0,
                markerSettings: const MarkerSettings(isVisible: false),
                dataLabelSettings: const DataLabelSettings(isVisible: false),
                enableTooltip: false,
              ),
            ],
          ),
          Text(
            'No data yet',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.subHeadingColor.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}
