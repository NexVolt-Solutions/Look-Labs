import 'package:flutter/material.dart';
import 'package:looklabs/Core/Constants/app_assets.dart';
import 'package:looklabs/Core/Routes/routes_name.dart';

class HomeViewModel extends ChangeNotifier {
  List<Map<String, dynamic>> homeOverViewData = [
    {'title': 'Your Height', 'subTitle': '7 cm', 'image': AppAssets.heightIcon},
    {
      'title': 'Your Weight',
      'subTitle': '78 kg',
      'image': AppAssets.weightIcon,
    },
    {
      'title': 'Sleep Hours',
      'subTitle': '8 Hours',
      'image': AppAssets.sleepIcon,
    },
    {
      'title': 'Water Intake',
      'subTitle': '2.5 L',
      'image': AppAssets.waterIcon,
    },
  ];
  List<Map<String, dynamic>> listViewData = [
    {'title': 'Skin', 'subTitle': '34/100', 'image': AppAssets.skinCare},
    {'title': 'Hair', 'subTitle': '34/100', 'image': AppAssets.hair},
    {'title': 'Height', 'subTitle': '34/100', 'image': AppAssets.height},
    {'title': 'Diet', 'subTitle': '34/100', 'image': AppAssets.diet},
    {'title': 'facial', 'subTitle': '34/100', 'image': AppAssets.facial},
    {'title': 'Fashion', 'subTitle': '34/100', 'image': AppAssets.fashion},
    {'title': 'QuitPorn', 'subTitle': '34/100', 'image': AppAssets.quitPorn},
    {'title': 'WorkOut', 'subTitle': '34/100', 'image': AppAssets.workOut},
  ];
  List<Map<String, dynamic>> gridData = [
    {
      'title': 'SkinCare',
      'subTitle': 'Daily glow routine',
      'image': AppAssets.skinCare,
    },
    {
      'title': 'Hair',
      'subTitle': 'Daily glow routine',
      'image': AppAssets.hair,
    },
    {
      'title': 'WorkOut',
      'subTitle': 'Daily glow routine',
      'image': AppAssets.workOut,
    },
    {
      'title': 'Diet',
      'subTitle': 'Daily glow routine',
      'image': AppAssets.diet,
    },
    {
      'title': 'Facial',
      'subTitle': 'Daily glow routine',
      'image': AppAssets.facial,
    },
    {
      'title': 'Fashion',
      'subTitle': 'Daily glow routine',
      'image': AppAssets.fashion,
    },
    {
      'title': 'Height',
      'subTitle': 'Daily glow routine',
      'image': AppAssets.height,
    },
    {
      'title': 'QuitPorn',
      'subTitle': 'Daily glow routine',
      'image': AppAssets.quitPorn,
    },
  ];

  void onItemTap(int index, BuildContext context) {
    if (index == 0) {
      Navigator.pushNamed(context, RoutesName.SkinCareScreen);
    } else if (index == 1) {
      Navigator.pushNamed(context, RoutesName.HairCareScreen);
    } else if (index == 2) {
      Navigator.pushNamed(context, RoutesName.WorkOutScreen);
    } else if (index == 3) {
      Navigator.pushNamed(context, RoutesName.DietScreen);
    } else if (index == 4) {
      Navigator.pushNamed(context, RoutesName.FacialScreen);
    } else if (index == 5) {
      Navigator.pushNamed(context, RoutesName.FashionScreen);
    } else if (index == 6) {
      Navigator.pushNamed(context, RoutesName.HeightScreen);
    } else if (index == 7) {
      Navigator.pushNamed(context, RoutesName.QuitPornScreen);
    }
  }
}
