/// API endpoints - Add all your API paths here
class ApiEndpoints {
  ApiEndpoints._();

  // Onboarding (anonymous – no auth token required)
  static const String onboardingSessions = 'onboarding/sessions';

  /// GET all onboarding questions (steps + questions). Optional ?session_id=...
  static const String onboardingQuestions = 'onboarding/questions';

  /// GET available domains for goal screen (returns { "domains": [ "skincare", ... ] }).
  static const String onboardingDomains = 'onboarding/domains';

  /// GET domains/explore – explore plans for Home screen (requires Bearer token).
  /// Returns list of domain strings, e.g. ["skincare", "hair", "workout", ...].
  static const String domainsExplore = 'domains/explore';

  /// GET domains/progress/overview – per-domain progress (progress_percent, answered_questions, is_completed). Requires auth.
  static const String domainsProgressOverview = 'domains/progress/overview';

  /// GET domains/{domain}/questions – questions for a domain (requires Bearer token).
  static String domainsQuestions(String domain) => 'domains/$domain/questions';

  /// POST domains/{domain}/answers – submit one domain answer (requires Bearer token).
  static String domainsAnswers(String domain) => 'domains/$domain/answers';

  /// GET domains/{domain}/flow – poll for completion when status is "processing".
  static String domainsFlow(String domain) => 'domains/$domain/flow';

  /// GET domains/{domain}/progress/graph – domain-specific score history.
  /// Query: period=weekly|monthly|yearly.
  static String domainsProgressGraph(String domain) =>
      'domains/$domain/progress/graph';

  /// POST domains/{domain}/generate-plan – generate workout plan (focus, intensity, etc.).
  static String domainsGeneratePlan(String domain) =>
      'domains/$domain/generate-plan';

  static String domainsCompletedExercises(String domain) =>
      'domains/${domain.toLowerCase().trim()}/completed-exercises';

  /// GET domains/workout/weekly-summary – weekly workout summary (user_id, week_average, days).
  static const String workoutWeeklySummary = 'domains/workout/weekly-summary';

  /// POST onboarding/sessions/{session_id}/answers
  static String onboardingSessionAnswers(String sessionId) =>
      'onboarding/sessions/$sessionId/answers';

  /// POST onboarding/sessions/{session_id}/domain?domain=...
  static String onboardingSessionDomain(String sessionId) {
    return 'onboarding/sessions/$sessionId/domain';
  }

  /// PATCH onboarding/sessions/{session_id}/link – link anonymous session to authenticated user (requires Bearer token).
  static String onboardingSessionLink(String sessionId) =>
      'onboarding/sessions/$sessionId/link';

  /// GET onboarding/users/me/wellness – wellness metrics (requires Bearer token).
  static const String onboardingUsersMeWellness =
      'onboarding/users/me/wellness';

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

  /// GET users/me – current user profile (requires Bearer token).
  static const String usersMe = 'users/me';

  /// GET users/me/progress/weekly – weekly progress for Home screen (requires Bearer token).
  static const String usersMeProgressWeekly = 'users/me/progress/weekly';

  /// GET users/me/progress – progress with period param for Progress screen. Query: period=week|month|year.
  static const String usersMeProgress = 'users/me/progress';

  /// GET users/me/progress/graph – score history for all domains. Query: period=weekly|monthly|yearly.
  static const String usersMeProgressGraph = 'users/me/progress/graph';

  // Subscriptions (requires auth unless noted)
  static const String subscriptionPlans = 'subscriptions/plans';
  static const String subscriptions = 'subscriptions';
  static const String subscriptionsMe = 'subscriptions/me';
  static String subscriptionById(String id) => 'subscriptions/$id';
  static String subscriptionCancel(String id) => 'subscriptions/$id/cancel';
  static String subscriptionReactivate(String id) =>
      'subscriptions/$id/reactivate';
  static const String subscriptionsMeStatus = 'subscriptions/me/status';

  // In-App Purchase (validate, restore, products; webhooks are server-only)
  static const String iapValidateReceipt = 'iap/validate-receipt';
  static const String iapRestorePurchases = 'iap/restore-purchases';
  static const String iapProducts = 'iap/products';
  static const String iapWebhookApple = 'iap/webhooks/apple';
  static const String iapWebhookGoogle = 'iap/webhooks/google';

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

  /// POST images/upload/simple – simple image upload (profile, onboarding, etc.). Requires auth.
  static const String imagesUploadSimple = 'images/upload/simple';

  /// POST images/upload – domain analysis uploads (multipart file + query: domain, view, image_type).
  static const String imagesUpload = 'images/upload';

  /// GET images/album – user's album images. Optional query: domain, view, status (processing|processed|failed).
  static const String imagesAlbum = 'images/album';

  // Legal (e.g. privacy policy, terms – optional, for dynamic content from backend)
  static const String privacyPolicy = '/legal/privacy-policy';
  static const String termsOfService = '/legal/terms-of-service';
}
