/// API endpoints - Add all your API paths here
class ApiEndpoints {
  ApiEndpoints._();

  // Onboarding (anonymous – no auth token required)
  static const String onboardingSessions = 'onboarding/sessions';
  /// GET onboarding/sessions/{session_id}/flow?step=...&index=...
  static String onboardingSessionFlow(String sessionId) =>
      'onboarding/sessions/$sessionId/flow';
  /// POST onboarding/sessions/{session_id}/answers
  static String onboardingSessionAnswers(String sessionId) =>
      'onboarding/sessions/$sessionId/answers';
  /// PATCH onboarding/sessions/{session_id}/domain?domain=skincare
  static String onboardingSessionDomain(String sessionId) =>
      'onboarding/sessions/$sessionId/domain';

  // Auth (Google Sign-In only)
  static const String googleSignIn = 'auth/google';
  static const String appleSignIn = 'auth/apple';
  static const String logout = 'auth/sign-out';
  static const String refreshToken = 'auth/refresh';
  static const String profile = '/auth/profile';

  // User
  static const String user = '/user';
  static String userById(String id) => '/user/$id';
  static const String userSettings = '/user/settings';

  // Subscription
  static const String subscription = '/subscription';
  static const String subscriptionPlans = '/subscription/plans';

  // Workout
  static const String workout = '/workout';
  static String workoutById(String id) => '/workout/$id';
  static const String workoutRoutine = '/workout/routine';

  // Diet
  static const String diet = '/diet';
  static const String dietRoutine = '/diet/routine';

  // Skin Care
  static const String skinCare = '/skin-care';
  static const String skinRoutine = '/skin-care/routine';

  // Hair Care
  static const String hairCare = '/hair-care';
  static const String hairRoutine = '/hair-care/routine';

  // Fashion
  static const String fashion = '/fashion';
  static const String weeklyPlan = '/fashion/weekly-plan';

  // Facial
  static const String facial = '/facial';
  static const String facialProgress = '/facial/progress';

  // Height
  static const String height = '/height';
  static const String heightRoutine = '/height/routine';

  // Upload / Multipart
  static const String upload = '/upload';
  static const String uploadImage = '/upload/image';

  // Legal (e.g. privacy policy, terms – optional, for dynamic content from backend)
  static const String privacyPolicy = '/legal/privacy-policy';
  static const String termsOfService = '/legal/terms';
}
