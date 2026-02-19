import 'package:flutter/material.dart';

class PaymentDetailsVieModel extends ChangeNotifier {
  List<Map<String, dynamic>> userInfData = [
    {'name': 'E-mail', 'subName': ''},
    {'name': 'Name', 'subName': ''},
    {'name': 'Description', 'subName': ''},
    {'name': 'PayAble Amount', 'subName': ''},
  ];
  List<Map<String, dynamic>> cardDetails = [
    {'name': 'Holder Name', 'subName': ''},
    {'name': 'Card Name', 'subName': ''},
  ];
}
