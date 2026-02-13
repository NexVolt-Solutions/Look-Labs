import 'package:flutter/material.dart';
import 'package:looklabs/Core/Config/env_loader.dart';
import 'package:looklabs/Core/Routes/routes.dart';
import 'package:looklabs/Core/Routes/routes_name.dart';
import 'package:looklabs/features/View/BottomSheet/bottom_sheet_bar_screen.dart';
import 'package:looklabs/features/ViewModel/auth_view_model.dart';
import 'package:looklabs/features/ViewModel/bottom_sheet_view_model.dart';
import 'package:looklabs/features/ViewModel/card_details_view_model.dart';
import 'package:looklabs/features/ViewModel/chart_view_model.dart';
import 'package:looklabs/features/ViewModel/daily_diet_routine_screen_view_model.dart';
import 'package:looklabs/features/ViewModel/daily_hair_care_routine_view_model.dart';
import 'package:looklabs/features/ViewModel/daily_height_routine_view_model.dart';
import 'package:looklabs/features/ViewModel/daily_skin_care_routine_view_model.dart';
import 'package:looklabs/features/ViewModel/daily_workout_routine_view_model.dart';
import 'package:looklabs/features/ViewModel/diet_details_screen_view_model.dart';
import 'package:looklabs/features/ViewModel/diet_progress_screen_view_model.dart';
import 'package:looklabs/features/ViewModel/diet_result_screen_view_model.dart';
import 'package:looklabs/features/ViewModel/diet_view_model.dart';
import 'package:looklabs/features/ViewModel/facial_progress_screen_view_model.dart';
import 'package:looklabs/features/ViewModel/facial_view_model.dart';
import 'package:looklabs/features/ViewModel/fashion_view_model.dart';
import 'package:looklabs/features/ViewModel/gaol_screen_view_model.dart';
import 'package:looklabs/features/ViewModel/gender_view_model.dart';
import 'package:looklabs/features/ViewModel/hair_care_view_model.dart';
import 'package:looklabs/features/ViewModel/healt_details_view_model.dart';
import 'package:looklabs/features/ViewModel/height_screen_view_model.dart';
import 'package:looklabs/features/ViewModel/height_view_model.dart';
import 'package:looklabs/features/ViewModel/home_view_model.dart';
import 'package:looklabs/features/ViewModel/my_album_view_model.dart';
import 'package:looklabs/features/ViewModel/payment_details_vie_model.dart';
import 'package:looklabs/features/ViewModel/personalized_exercise_screen_view_model.dart';
import 'package:looklabs/features/ViewModel/profile_view_model.dart';
import 'package:looklabs/features/ViewModel/progress_view_model.dart';
import 'package:looklabs/features/ViewModel/purchase_view_model.dart';
import 'package:looklabs/features/ViewModel/quit_porn_view_model.dart';
import 'package:looklabs/features/ViewModel/recommended_product_view_model.dart';
import 'package:looklabs/features/ViewModel/skin_care_view_model.dart';
import 'package:looklabs/features/ViewModel/skin_top_product_view_model.dart';
import 'package:looklabs/features/ViewModel/splash_view_model.dart';
import 'package:looklabs/features/ViewModel/start_screen_view_model.dart';
import 'package:looklabs/features/ViewModel/style_profile_screen_view_model.dart';
import 'package:looklabs/features/ViewModel/subscription_plan_view_model.dart';
import 'package:looklabs/features/ViewModel/hair_top_product_view_model.dart';
import 'package:looklabs/features/ViewModel/track_your_nutrition_view_model.dart';
import 'package:looklabs/features/ViewModel/weekly_plan_screen_view_model.dart';
import 'package:looklabs/features/ViewModel/work_out_result_screen_view_model.dart';
import 'package:looklabs/features/ViewModel/work_out_view_model.dart';
import 'package:looklabs/features/ViewModel/work_out_progress_screen_view_model.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await loadEnv();
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
          create: (context) => WorkOutProgressScreenViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => DietResultScreenViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => DailyDietRoutineScreenViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => DietDetailsScreenViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => TrackYourNutritionViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => DietProgressScreenViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => StyleProfileScreenViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => PersonalizedExerciseScreenViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => FacialProgressScreenViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => WeeklyPlanScreenViewModel(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        // home: DietResultScreen(),
        initialRoute: RoutesName.SplashScreen,
        onGenerateRoute: Routes.generateRoute,
      ),
    ),
  );
}
