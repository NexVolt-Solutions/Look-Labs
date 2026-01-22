import 'package:flutter/material.dart';
import 'package:looklabs/Core/utils/Routes/routes.dart';
import 'package:looklabs/Core/utils/Routes/routes_name.dart';
import 'package:looklabs/View/BottomSheet/bottom_sheet_bar_screen.dart';
import 'package:looklabs/ViewModel/auth_view_model.dart';
import 'package:looklabs/ViewModel/bottom_sheet_view_model.dart';
import 'package:looklabs/ViewModel/card_details_view_model.dart';
import 'package:looklabs/ViewModel/chart_view_model.dart';
import 'package:looklabs/ViewModel/daily_hair_care_routine_view_model.dart';
import 'package:looklabs/ViewModel/daily_height_routine_view_model.dart';
import 'package:looklabs/ViewModel/daily_skin_care_routine_view_model.dart';
import 'package:looklabs/ViewModel/daily_workout_routine_view_model.dart';
import 'package:looklabs/ViewModel/diet_view_model.dart';
import 'package:looklabs/ViewModel/facial_view_model.dart';
import 'package:looklabs/ViewModel/fashion_view_model.dart';
import 'package:looklabs/ViewModel/gaol_screen_view_model.dart';
import 'package:looklabs/ViewModel/gender_view_model.dart';
import 'package:looklabs/ViewModel/hair_care_view_model.dart';
import 'package:looklabs/ViewModel/healt_details_view_model.dart';
import 'package:looklabs/ViewModel/height_screen_view_model.dart';
import 'package:looklabs/ViewModel/height_view_model.dart';
import 'package:looklabs/ViewModel/home_view_model.dart';
import 'package:looklabs/ViewModel/my_album_view_model.dart';
import 'package:looklabs/ViewModel/payment_details_vie_model.dart';
import 'package:looklabs/ViewModel/profile_view_model.dart';
import 'package:looklabs/ViewModel/progress_view_model.dart';
import 'package:looklabs/ViewModel/purchase_view_model.dart';
import 'package:looklabs/ViewModel/quit_porn_view_model.dart';
import 'package:looklabs/ViewModel/recommended_product_view_model.dart';
import 'package:looklabs/ViewModel/skin_care_view_model.dart';
import 'package:looklabs/ViewModel/skin_top_product_view_model.dart';
import 'package:looklabs/ViewModel/splash_view_model.dart';
import 'package:looklabs/ViewModel/start_screen_view_model.dart';
import 'package:looklabs/ViewModel/subscription_plan_view_model.dart';
import 'package:looklabs/ViewModel/hair_top_product_view_model.dart';
import 'package:looklabs/ViewModel/work_out_result_screen_view_model.dart';
import 'package:looklabs/ViewModel/work_out_view_model.dart';
import 'package:looklabs/ViewModel/your_progress_screen_view_model.dart';
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
        ChangeNotifierProvider(create: (context) => GenderViewModel()),
        ChangeNotifierProvider(create: (context) => StartScreenViewModel()),
        ChangeNotifierProvider(create: (context) => SkinCareViewModel()),
        ChangeNotifierProvider(create: (context) => HairCareViewModel()),
        ChangeNotifierProvider(create: (context) => HeightViewModel()),
        ChangeNotifierProvider(create: (context) => WorkoutViewModel()),
        ChangeNotifierProvider(create: (context) => DietViewModel()),
        ChangeNotifierProvider(create: (context) => FacialViewModel()),
        ChangeNotifierProvider(create: (context) => FashionViewModel()),
        ChangeNotifierProvider(create: (context) => QuitPornViewModel()),
        ChangeNotifierProvider(
          create: (context) => DailyHairCareRoutineViewModel(),
        ),
        ChangeNotifierProvider(create: (context) => HairTopProductViewModel()),
        ChangeNotifierProvider(
          create: (context) => RecommendedProductViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => DailySkinCareRoutineViewModel(),
        ),
        ChangeNotifierProvider(create: (context) => SkinTopProductViewModel()),
        ChangeNotifierProvider(create: (context) => HeightScreenViewModel()),
        ChangeNotifierProvider(
          create: (context) => DailyHeightRoutineViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => WorkOutResultScreenViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => DailyWorkoutRoutineViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => YourProgressScreenViewModel(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        // home: DailyWorkoutRoutine(),
        initialRoute: RoutesName.SplashScreen,
        onGenerateRoute: Routes.generateRoute,
      ),
    ),
  );
}
