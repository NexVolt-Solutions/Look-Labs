import 'package:flutter/material.dart';
import 'package:looklabs/Core/Constants/app_assets.dart';

class PurchaseViewModel extends ChangeNotifier {
  final bool isSelected = false;
  List<Map<String, dynamic>> userInfData = [
    {'name': 'E-mail', 'subName': 'amnauxstudio@gmail.com'},
    {'name': 'Name', 'subName': 'M.Shehzad'},
    {'name': 'Description', 'subName': 'Monthly sub'},
    {'name': 'PayAble Amount', 'subName': '\$19.99'},
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
