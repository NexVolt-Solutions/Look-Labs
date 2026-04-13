// ignore_for_file: constant_identifier_names

class RoutesName {
  static const String SplashScreen = 'Splash_screen';
  static const String ProfileScreen = 'profile_screen';
  static const String HealtDetailsScreen = 'healt_details_screen';
  static const String GaolScreen = 'gaol_screen';
  static const String OnBoardScreen = 'on_boarding_screen';
  static const String SubscriptionPlanScreen = 'subscription_plan_screen';
  static const String CardDetailsScreen = 'card_Details_screen';
  static const String PurchaseScreen = 'purchase_screen';
  static const String PaymentDetailsScreen = 'payment_details_screen';
  static const String AuthScreen = 'auth_screen';
  static const String BottomSheetBarScreen = 'bottom_sheet_bar_screen';
  static const String ProgressScreen = 'progress_screen';
  static const String MyAlbumScreen = 'my_album_screen';
  static const String AgeDetailsScreen = 'age_details_screen';
  static const String GenderScreen = 'gender_screen';
  static const String StartScreen = 'start_screen';
  static const String QuestionScreen = 'question_screen';
  static const String DomainQuestionScreen = 'domain_question_screen';
  static const String SkinCareScreen = 'skin_care_screen';
  static const String HairCareScreen = 'hair_care_screen';

  static const String WorkOutScreen = 'work_out_screen';
  static const String WorkOutResultScreen = 'work_out_result_screen';
  static const String DailyWorkoutRoutineScreen =
      'daily_work_out_routine_screen';
  static const String WorkOutProgressScreen = 'your_progress_screen';

  static const String DietScreen = 'diet_screen';
  static const String DietResultScreen = 'diet_result_screen';
  static const String DailyDietRoutineScreen = 'daily_diet_routine_screen';
  static const String DietDetailsScreen = 'diet_details_screen';
  static const String TrackYourNutritionScreen = 'track_your_nutrition_screen';
  static const String DietProgressScreen = 'diet_progress_screen';
  static const String AllTrackedFood = 'all_tracked_food_screen';

  static const String FacialScreen = 'facial_screen';
  static const String FacialReviewScansScreen = 'facial_review_scans_screen';
  static const String FacialAnalyzingScren = 'facial_analyzing_screen';
  static const String StyleProfileScreen = 'style_profile_screen';
  static const String PersonalizedExerciseScreen = 'pers_exer_screen';
  static const String FacialProgressScreen = 'facial_progress_screen';

  static const String FashionScreen = 'fashion_screen';
  static const String FashionReviewScanScreen = 'fashion_review_scan_screen';
  static const String FashionAnalyzingScreen = 'fashion_analyzing_screen';
  static const String FashionProfileScreen = 'fashion_profle_screen';
  static const String WeeklyPlanScreen = 'weekly_plan_screen';

  static const String QuitPornScreen = 'quit_porn_screen';
  static const String RecoveryPathScreen = 'recovery_path_screen';

  static const String HairReviewScansScreen = 'hair_review_scans_screen';
  static const String HairAnalyzingScreen = 'hair_analyzing_screen';
  static const String DailyHairCareRoutineScreen = 'daily_hair_routine_screen';
  static const String HairHomeRemediesScreen = 'hair_home_remedies_screen';
  static const String HairTopProductScreen = 'hair_top_product_screen';
  static const String HairProductDetailScreen = 'hair_product_screen';

  static const String SkinReviewScansScreen = 'skin_review_scans_screen';
  static const String SkinAnalyzingScreen = 'skin_analyzing_screen';
  static const String DailySkinCareRoutineScreen = 'daily_skin_routine_screen';
  static const String SkinHomeRemediesScreen = 'skin_home_remedies_screen';
  static const String SkinTopProductScreen = 'skin_top_product_screen';
  static const String SkinProductDetailScreen = 'skin_product_screen';

  static const String HeightScreen = 'height_screen';
  static const String HeightResultScreen = 'height_result_screen';
  static const String DailyHeightRoutineScreen = 'daily_height_routine_screen';

  /// Route for the main screen of a domain after completing domain questions. Returns null if unknown.
  static String? routeForDomain(String domain) {
    final d = domain.trim().toLowerCase();
    switch (d) {
      case 'facial':
        return FacialScreen;
      case 'skincare':
      case 'skin_care':
      case 'skin':
        // After domain questions → capture & upload angles, then analyzing → daily routine.
        return SkinReviewScansScreen;
      case 'haircare':
      case 'hair_care':
      case 'hair':
        // After domain questions → capture & upload angles, then analyzing → daily routine.
        return HairReviewScansScreen;
      case 'workout':
        return WorkOutResultScreen; // Skip old WorkOut questions; go to result after domain questions
      case 'diet':
        return DietScreen;
      case 'fashion':
        return FashionScreen;
      case 'height':
        return HeightResultScreen; // Skip HeightScreen questions; go to result after domain questions
      case 'quit_porn':
        return RecoveryPathScreen;
      default:
        return null;
    }
  }

  /// Daily routine screen for domains that use the 4-angle scan flow (reached after upload + analyzing).
  static String? dailyRoutineRouteForDomain(String domain) {
    final d = domain.trim().toLowerCase();
    switch (d) {
      case 'skincare':
      case 'skin_care':
      case 'skin':
        return DailySkinCareRoutineScreen;
      case 'haircare':
      case 'hair_care':
      case 'hair':
        return DailyHairCareRoutineScreen;
      default:
        return null;
    }
  }
}
