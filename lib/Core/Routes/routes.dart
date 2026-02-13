import 'package:flutter/material.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Core/Routes/routes_name.dart';
import 'package:looklabs/Features/View/Auth/auth_screen.dart';
import 'package:looklabs/Features/View/BottomSheet/bottom_sheet_bar_screen.dart';
import 'package:looklabs/Features/View/CardDetails/card_details_screen.dart';
import 'package:looklabs/Features/View/GenderScreen/gender_screen.dart';
import 'package:looklabs/Features/View/GoalScreen/gaol_screen.dart';
import 'package:looklabs/Features/View/Home/Widget/Diet/Widget/all_tracked_food.dart';
import 'package:looklabs/Features/View/Home/Widget/Diet/Widget/daily_diet_routine_screen.dart';
import 'package:looklabs/Features/View/Home/Widget/Diet/Widget/diet_details_screen.dart';
import 'package:looklabs/Features/View/Home/Widget/Diet/Widget/diet_progress_screen.dart';
import 'package:looklabs/Features/View/Home/Widget/Diet/Widget/diet_result_screen.dart';
import 'package:looklabs/Features/View/Home/Widget/Diet/Widget/track_your_nutrition_screen.dart';
import 'package:looklabs/Features/View/Home/Widget/Diet/diet_screen.dart';
import 'package:looklabs/Features/View/Home/Widget/Facial/Widget/facial_analyzing_scren.dart';
import 'package:looklabs/Features/View/Home/Widget/Facial/Widget/facial_progress_screen.dart';
import 'package:looklabs/Features/View/Home/Widget/Facial/Widget/facial_review_scans_screen.dart';
import 'package:looklabs/Features/View/Home/Widget/Facial/Widget/personalized_exercise_screen.dart';
import 'package:looklabs/Features/View/Home/Widget/Facial/Widget/style_profile_screen.dart';
import 'package:looklabs/Features/View/Home/Widget/Facial/facial.dart';
import 'package:looklabs/Features/View/Home/Widget/Fashion/fashion.dart';
import 'package:looklabs/Features/View/Home/Widget/Fashion/Widget/fashion_analyzing_screen.dart';
import 'package:looklabs/Features/View/Home/Widget/Fashion/Widget/fashion_profile_screen.dart';
import 'package:looklabs/Features/View/Home/Widget/Fashion/Widget/fashion_review_scan_screen.dart';
import 'package:looklabs/Features/View/Home/Widget/Fashion/Widget/weekly_plan_screen.dart';
import 'package:looklabs/Features/View/Home/Widget/HairCare/hair_care.dart';
import 'package:looklabs/Features/View/Home/Widget/Height/Widget/daily_height_routine.dart';
import 'package:looklabs/Features/View/Home/Widget/Height/Widget/height_result_screen.dart';
import 'package:looklabs/Features/View/Home/Widget/Height/height_screen.dart';
import 'package:looklabs/Features/View/Home/Widget/QuitPorn/quit_porn.dart';
import 'package:looklabs/Features/View/Home/Widget/HairCare/Widget/hair_analyzing_screen.dart';
import 'package:looklabs/Features/View/Home/Widget/HairCare/Widget/daily_hair_care_routine.dart';
import 'package:looklabs/Features/View/Home/Widget/HairCare/Widget/hair_home_remedies.dart';
import 'package:looklabs/Features/View/Home/Widget/HairCare/Widget/hair_product_detail_screen.dart';
import 'package:looklabs/Features/View/Home/Widget/HairCare/Widget/hair_review_scans.dart';
import 'package:looklabs/Features/View/Home/Widget/HairCare/Widget/hair_top_product.dart';
import 'package:looklabs/Features/View/Home/Widget/QuitPorn/recovery_path_screen.dart';
import 'package:looklabs/Features/View/Home/Widget/SkinCare/Widget/daily_skin_care_routine.dart';
import 'package:looklabs/Features/View/Home/Widget/SkinCare/Widget/skin_analyzing_screen.dart';
import 'package:looklabs/Features/View/Home/Widget/SkinCare/Widget/skin_home_remedies.dart';
import 'package:looklabs/Features/View/Home/Widget/SkinCare/Widget/skin_product_Detail_screen.dart';
import 'package:looklabs/Features/View/Home/Widget/SkinCare/Widget/skin_top_product.dart';
import 'package:looklabs/Features/View/Home/Widget/SkinCare/Widget/skin_review_scans.dart';
import 'package:looklabs/Features/View/Home/Widget/SkinCare/skin_care.dart';
import 'package:looklabs/Features/View/Home/Widget/WorkOut/Widget/daily_workout_routine.dart';
import 'package:looklabs/Features/View/Home/Widget/WorkOut/Widget/work_out_result_screen.dart';
import 'package:looklabs/Features/View/Home/Widget/WorkOut/Widget/work_out_progress_screen.dart';
import 'package:looklabs/Features/View/Home/Widget/WorkOut/work_out.dart';
import 'package:looklabs/Features/View/MyAlbum/my_album_screen.dart';
import 'package:looklabs/Features/View/OnBoard/on_board_screen.dart';
import 'package:looklabs/Features/View/Payment%20Details/payment_details_screen.dart';
import 'package:looklabs/Features/View/HealtDetailsScreen/healt_details_screen.dart';
import 'package:looklabs/Features/View/Progress/progress_screen.dart';
import 'package:looklabs/Features/View/Purchase/purchase_screen.dart';
import 'package:looklabs/Features/View/QuestionScreen/question_screen.dart';
import 'package:looklabs/Features/View/SplahScreen/splash_screen.dart';
import 'package:looklabs/Features/View/StartScreen/start_screen.dart';
import 'package:looklabs/Features/View/Subscription%20Plan/subscription_plan_screen.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.SplashScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => SplashScreen(),
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
      case RoutesName.GenderScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => GenderScreen(),
        );
      case RoutesName.StartScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => StartScreen(),
        );
      case RoutesName.QuestionScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => QuestionScreen(),
        );
      case RoutesName.SkinCareScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => SkinCare(),
        );
      case RoutesName.HairCareScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => HairCare(),
        );
      case RoutesName.FacialScreen:
        return MaterialPageRoute(settings: settings, builder: (_) => Facial());
      case RoutesName.FashionScreen:
        return MaterialPageRoute(settings: settings, builder: (_) => Fashion());
      case RoutesName.HeightScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => HeightScreen(),
        );
      case RoutesName.QuitPornScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => QuitPorn(),
        );
      case RoutesName.WorkOutScreen:
        return MaterialPageRoute(settings: settings, builder: (_) => WorkOut());
      case RoutesName.DietScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => DietScreen(),
        );
      case RoutesName.HairReviewScansScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => HairReviewScans(),
        );
      case RoutesName.HairAnalyzingScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => HairAnalyzingScreen(),
        );
      case RoutesName.DailyHairCareRoutineScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => DailyHairCareRoutine(),
        );
      case RoutesName.HairHomeRemediesScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => HairHomeRemedies(),
        );
      case RoutesName.HairTopProductScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => HairTopProduct(),
        );
      case RoutesName.HairProductDetailScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => HairProductDetailScreen(),
        );
      case RoutesName.SkinAnalyzingScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => SkinAnalyzingScreen(),
        );
      case RoutesName.SkinReviewScansScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => SkinReviewScans(),
        );
      case RoutesName.SkinHomeRemediesScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => SkinHomeRemedies(),
        );
      case RoutesName.SkinTopProductScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => SkinTopProduct(),
        );
      case RoutesName.DailySkinCareRoutineScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => DailySkinCareRoutine(),
        );
      case RoutesName.SkinProductDetailScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => SkinProductDetailScreen(),
        );
      case RoutesName.DailyHeightRoutineScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => DailyHeightRoutineScreen(),
        );
      case RoutesName.HeightResultScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => HeightResultScreen(),
        );
      case RoutesName.WorkOutResultScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => WorkOutResultScreen(),
        );
      case RoutesName.DailyWorkoutRoutineScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => DailyWorkoutRoutine(),
        );
      case RoutesName.WorkOutProgressScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => WorkOutProgressScreen(),
        );
      case RoutesName.DietResultScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => DietResultScreen(),
        );
      case RoutesName.DailyDietRoutineScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => DailyDietRoutineScreen(),
        );
      case RoutesName.DietDetailsScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => DietDetailsScreen(),
        );
      case RoutesName.TrackYourNutritionScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => TrackYourNutritionScreen(),
        );
      case RoutesName.DietProgressScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => DietProgressScreen(),
        );
      case RoutesName.FacialReviewScansScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => FacialReviewScansScreen(),
        );
      case RoutesName.FacialAnalyzingScren:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => FacialAnalyzingScren(),
        );
      case RoutesName.StyleProfileScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => StyleProfileScreen(),
        );
      case RoutesName.PersonalizedExerciseScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => PersonalizedExerciseScreen(),
        );
      case RoutesName.FacialProgressScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => FacialProgressScreen(),
        );
      case RoutesName.RecoveryPathScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => RecoveryPathScreen(),
        );

      case RoutesName.FashionAnalyzingScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => FashionAnalyzingScreen(),
        );
      case RoutesName.FashionReviewScanScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => FashionReviewScanScreen(),
        );
      case RoutesName.FashionProfileScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => FashionProfileScreen(),
        );
      case RoutesName.WeeklyPlanScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => WeeklyPlanScreen(),
        );
      case RoutesName.AllTrackedFood:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => AllTrackedFood(),
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
