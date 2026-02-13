import 'package:flutter/material.dart';
import 'package:looklabs/Core/Constants/app_assets.dart';
import 'package:looklabs/Core/Constants/chart_constants.dart';
import 'package:looklabs/Model/sales_data.dart';
import 'package:looklabs/Features/ViewModel/chart_view_model.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class LineChartWidget extends StatelessWidget {
  const LineChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final chartVM = context.watch<ChartViewModel>();

    return SfCartesianChart(
      primaryXAxis: CategoryAxis(),
      tooltipBehavior: ChartConstants.tooltip,
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
