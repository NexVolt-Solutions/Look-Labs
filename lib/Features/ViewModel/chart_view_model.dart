import 'package:flutter/material.dart';
import 'package:looklabs/Model/sales_data.dart';

class ChartViewModel extends ChangeNotifier {
  final List<SalesData> chartData = [
    SalesData('Jan', 35),
    SalesData('Feb', 28),
    SalesData('Mar', 34),
    SalesData('Apr', 32),
    SalesData('May', 40),
  ];
}
