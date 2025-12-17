import 'package:flutter/material.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Core/utils/Routes/routes_name.dart';
import 'package:looklabs/View/GoalScreen/gaol_screen.dart';
import 'package:looklabs/View/ProfileScreen/profile_screen.dart';
import 'package:looklabs/View/HealtDetailsScreen/healt_details_screen.dart';
import 'package:looklabs/View/SplahScreen/splash_screen.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.SplashScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => SplashScreen(),
        );
      case RoutesName.ProfileScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => ProfileScreen(),
        );
      case RoutesName.HealtDetailsScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => HealtDetailsScreen(),
        );
      case RoutesName.GaolScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => GaolScreen(),
        );

      default:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => Scaffold(
            body: Stack(
              children: [
                Center(
                  child: Text(
                    'No Route Found',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.headingColor,
                      fontSize: context.text(18),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Positioned(
                  top: context.h(50),
                  left: context.w(20),
                  child: InkWell(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.arrow_back_ios,
                      color: AppColors.headingColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
    }
  }
}
