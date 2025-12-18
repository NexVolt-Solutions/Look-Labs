import 'package:flutter/material.dart';
import 'package:looklabs/Core/utils/Routes/routes.dart';
import 'package:looklabs/Core/utils/Routes/routes_name.dart';
import 'package:looklabs/ViewModel/card_details_view_model.dart';
import 'package:looklabs/ViewModel/gaol_screen_view_model.dart';
import 'package:looklabs/ViewModel/healt_details_view_model.dart';
import 'package:looklabs/ViewModel/profile_view_model.dart';
import 'package:looklabs/ViewModel/purchase_view_model.dart';
import 'package:looklabs/ViewModel/splash_view_model.dart';
import 'package:looklabs/ViewModel/subscription_plan_view_model.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SplashViewModel()),
        ChangeNotifierProvider(create: (context) => ProfileViewModel()),
        ChangeNotifierProvider(create: (context) => HealtDetailsViewModel()),
        ChangeNotifierProvider(create: (context) => GaolScreenViewModel()),
        ChangeNotifierProvider(
          create: (context) => SubscriptionPlanViewModel(),
        ),
        ChangeNotifierProvider(create: (context) => CardDetailsViewModel()),
        ChangeNotifierProvider(create: (context) => PurchaseViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: RoutesName.SplashScreen,
        onGenerateRoute: Routes.generateRoute,
      ),
    ),
  );
}
