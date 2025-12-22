import 'package:flutter/material.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Core/utils/Routes/routes_name.dart';
import 'package:looklabs/View/AgeDetails/age_details_screen.dart';
import 'package:looklabs/View/Auth/auth_screen.dart';
import 'package:looklabs/View/BottomSheet/bottom_sheet_bar_screen.dart';
import 'package:looklabs/View/CardDetails/card_details_screen.dart';
import 'package:looklabs/View/GoalScreen/gaol_screen.dart';
import 'package:looklabs/View/MyAlbum/my_album_screen.dart';
import 'package:looklabs/View/OnBoard/on_board_screen.dart';
import 'package:looklabs/View/Payment%20Details/payment_details_screen.dart';
import 'package:looklabs/View/ProfileScreen/profile_screen.dart';
import 'package:looklabs/View/HealtDetailsScreen/healt_details_screen.dart';
import 'package:looklabs/View/Progress/progress_screen.dart';
import 'package:looklabs/View/Purchase/purchase_screen.dart';
import 'package:looklabs/View/SplahScreen/splash_screen.dart';
import 'package:looklabs/View/Subscription%20Plan/subscription_plan_screen.dart';

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
      case RoutesName.OnBoardScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => OnBoardScreen(),
        );
      case RoutesName.SubscriptionPlanScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => SubscriptionPlanScreen(),
        );
      case RoutesName.CardDetailsScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => CardDetailsScreen(),
        );
      case RoutesName.PurchaseScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => PurchaseScreen(),
        );
      case RoutesName.PaymentDetailsScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => PaymentDetailsScreen(),
        );
      case RoutesName.AuthScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => AuthScreen(),
        );
      case RoutesName.BottomSheetBarScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BottomSheetBarScreen(),
        );
      case RoutesName.ProgressScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => ProgressScreen(),
        );
      case RoutesName.MyAlbumScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => MyAlbumScreen(),
        );
      case RoutesName.AgeDetailsScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => AgeDetailsScreen(),
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
