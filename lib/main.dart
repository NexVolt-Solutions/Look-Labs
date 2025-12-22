import 'package:flutter/material.dart';
import 'package:looklabs/Core/utils/Routes/routes.dart';
import 'package:looklabs/Core/utils/Routes/routes_name.dart';
import 'package:looklabs/View/AgeDetails/age_details_screen.dart';
import 'package:looklabs/View/BottomSheet/bottom_sheet_bar_screen.dart';
import 'package:looklabs/View/Home/home_screen.dart';
import 'package:looklabs/View/MyAlbum/my_album_screen.dart';
import 'package:looklabs/ViewModel/age_details_view_model.dart';
import 'package:looklabs/ViewModel/auth_view_model.dart';
import 'package:looklabs/ViewModel/bottom_sheet_view_model.dart';
import 'package:looklabs/ViewModel/card_details_view_model.dart';
import 'package:looklabs/ViewModel/chart_view_model.dart';
import 'package:looklabs/ViewModel/gaol_screen_view_model.dart';
import 'package:looklabs/ViewModel/healt_details_view_model.dart';
import 'package:looklabs/ViewModel/home_view_model.dart';
import 'package:looklabs/ViewModel/my_album_view_model.dart';
import 'package:looklabs/ViewModel/payment_details_vie_model.dart';
import 'package:looklabs/ViewModel/profile_view_model.dart';
import 'package:looklabs/ViewModel/progress_view_model.dart';
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
        ChangeNotifierProvider(create: (context) => PaymentDetailsVieModel()),
        ChangeNotifierProvider(create: (context) => AuthViewModel()),
        ChangeNotifierProvider(
          create: (_) => BottomSheetViewModel(),
          child: const BottomSheetBarScreen(),
        ),
        ChangeNotifierProvider(create: (context) => HomeViewModel()),
        ChangeNotifierProvider(create: (context) => ProgressViewModel()),
        ChangeNotifierProvider(create: (context) => ChartViewModel()),
        ChangeNotifierProvider(create: (context) => MyAlbumViewModel()),
        ChangeNotifierProvider(create: (context) => AgeDetailsViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: AgeDetailsScreen(),
        // initialRoute: RoutesName.SplashScreen,
        onGenerateRoute: Routes.generateRoute,
      ),
    ),
  );
}
