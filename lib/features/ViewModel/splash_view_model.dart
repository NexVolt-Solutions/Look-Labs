import 'package:flutter/material.dart';
import 'package:looklabs/Core/Routes/routes_name.dart';

class SplashViewModel extends ChangeNotifier {
  void goTo(BuildContext context) {
    Future.delayed(Duration(seconds: 4), () {
      Navigator.pushNamed(context, RoutesName.StartScreen);
    });
  }
}
