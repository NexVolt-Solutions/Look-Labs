import 'package:flutter/material.dart';

class PaymentDetailsVieModel extends ChangeNotifier {
  List<Map<String, dynamic>> userInfData = [
    {'name': 'E-mail', 'subName': 'amnauxstudio@gmail.com'},
    {'name': 'Name', 'subName': 'M.Shehzad'},
    {'name': 'Description', 'subName': 'Monthly sub'},
    {'name': 'PayAble Amount', 'subName': '\$19.99'},
  ];
  List<Map<String, dynamic>> cardDetails = [
    {'name': 'Holder Name', 'subName': 'Muhammad Shehzad'},
    {'name': 'Card Name', 'subName': '3243-7283-000'},
  ];
}
