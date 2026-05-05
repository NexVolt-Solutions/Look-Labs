import 'package:flutter/material.dart';
import 'package:looklabs/Core/Constants/app_assets.dart';

class PurchaseViewModel extends ChangeNotifier {
  final bool isSelected = false;
  List<Map<String, dynamic>> userInfData = [
    {'name': 'E-mail', 'subName': ''},
    {'name': 'Name', 'subName': ''},
    {'name': 'Description', 'subName': ''},
    {'name': 'PayAble Amount', 'subName': ''},
  ];

  List<Map<String, dynamic>> purchaseCardData = [
    {
      'title': 'Master Card',
      'image': AppAssets.masterCardIcon,
      'isSelected': false,
    },
    {
      'title': 'Visa Card',
      'image': AppAssets.visaCardIcon,
      'isSelected': false,
    },
  ];

  void selectPayment(int index) {
    for (int i = 0; i < purchaseCardData.length; i++) {
      purchaseCardData[i]['isSelected'] = i == index;
    }
    notifyListeners();
  }
}
