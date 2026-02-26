# Looks Lab – Project & Flow Analysis

## 1. Project overview

**App:** Looks Lab – wellness/self-improvement (skincare, haircare, diet, workout, fashion, facial, height, quit porn).

**Stack:** Flutter, Firebase (Auth), Google Sign-In, Provider, REST API (base URL from `api.env`).

**Entry:** `lib/main.dart` → `initialRoute: RoutesName.SplashScreen` → `Routes.generateRoute`.

---

## 2. Folder structure (lib)

```
lib/
├── main.dart                    # Entry, MultiProvider, MaterialApp, initialRoute
├── firebase_options.dart        # Firebase config
├── Core/
│   ├── Config/                  # env_loader (api.env), env
│   ├── Constants/               # app_colors, app_text, app_assets, app_theme, size_extension
│   ├── Network/                 # api_config, api_endpoints, api_response, api_services, models/
│   └── Routes/                  # routes.dart, routes_name.dart
├── Features/
│   ├── View/                    # All UI screens (Auth, Home, OnBoard, Question, etc.)
│   └── ViewModel/               # ChangeNotifier VMs (one per feature/screen)
├── Repository/                  # auth_repository, onboarding_repository
├── Model/                       # auth_response_model, user_model, subscription_model, etc.
└── features/                   # Duplicate structure (lowercase) – many same screens
```

**Note:** There are two view layers: `lib/Features/` (capital F) and `lib/features/` (lowercase). Routes import from `Features/`. On case-sensitive systems these are different; consider unifying to one.

---

## 3. App flow (navigation)

### 3.1 Cold start → main app (logged out)

```
SplashScreen (4s delay)
    ↓
StartScreen ("Get Started")
    ↓
QuestionScreen (5 steps: Profile → LifeStyle → Goals → Motivations → Planning, "Complete")
    ↓
GaolScreen (choose goal, "Get Started")
    ↓
OnBoardScreen ("Next")
    ↓
SubscriptionPlanScreen (plan selection, "Continue & Subscribe")
    ↓
CardDetailsScreen → PurchaseScreen → PaymentDetailsScreen
    ↓
AuthScreen (Google Sign-In)
    ↓ (on success, pushNamedAndRemoveUntil)
BottomSheetBarScreen (main app)
```

### 3.2 Main app (tabs)

**BottomSheetBarScreen** has 3 tabs (BottomSheetViewModel.selectedIndex → `screen[index]`):

| Index | Screen           | Label       |
|-------|------------------|------------|
| 0     | HomeScreen       | Home       |
| 1     | ProgressScreen   | Processing |
| 2     | SettingScreen    | Setting    |

- **Home:** Wellness overview grid (SkinCare, HairCare, Facial, Fashion, Height, Quit Porn, WorkOut, Diet) + plan cards that push to respective feature flows.
- **Progress:** Progress overview; can open MyAlbumScreen.
- **Setting:** Settings; can open Privacy, Terms, etc.

### 3.3 Feature sub-flows (from Home)

- **Diet:** DietScreen → DietResultScreen → DailyDietRoutineScreen / TrackYourNutritionScreen / DietProgressScreen / DietDetailsScreen / AllTrackedFood.
- **WorkOut:** WorkOut → WorkOutResultScreen → DailyWorkoutRoutineScreen → WorkOutProgressScreen.
- **Height:** HeightScreen → HeightResultScreen → DailyHeightRoutineScreen.
- **SkinCare:** SkinCare → SkinReviewScans → SkinAnalyzingScreen → DailySkinCareRoutineScreen / SkinTopProduct / SkinHomeRemedies / SkinProductDetailScreen.
- **HairCare:** HairCare → HairReviewScans → HairAnalyzingScreen → DailyHairCareRoutine / HairTopProduct / HairHomeRemedies / HairProductDetailScreen.
- **Facial:** Facial → FacialReviewScansScreen → FacialAnalyzingScren → StyleProfileScreen → PersonalizedExerciseScreen → FacialProgressScreen.
- **Fashion:** Fashion → FashionReviewScanScreen → FashionAnalyzingScreen → FashionProfileScreen → WeeklyPlanScreen.
- **Quit Porn:** QuitPorn → RecoveryPathScreen.

### 3.4 Payment / auth

- **PaymentDetailsScreen** → "Sign In" → AuthScreen.
- **AuthScreen** → Google Sign-In → on success → `pushNamedAndRemoveUntil(BottomSheetBarScreen)`.

### 3.5 Other routes

- **HealtDetailsScreen** → GaolScreen (defined in routes but not pushed from any screen in current code; possible deep link or future entry).

---

## 4. State management

- **Provider** (MultiProvider in main.dart).
- **ViewModels:** One (or more) ChangeNotifier per feature; registered in main.dart (e.g. AuthViewModel, HomeViewModel, QuestionAnswerViewModel, GaolScreenViewModel, BottomSheetViewModel, etc.).
- **Auth token:** AuthViewModel + AuthRepository set `ApiServices.setAuthToken(...)` after Google Sign-In; cleared on logout.

---

## 5. API & config

- **Base URL:** From `api.env` (asset) via `env_loader.dart` → `ApiConfig.baseUrl`.
- **Auth:** Google Sign-In → Firebase → backend `auth/google` with idToken → JWT stored and sent as `Authorization: Bearer <token>`.
- **Anonymous:** `POST onboarding/sessions` (no token) – OnboardingRepository.createAnonymousSession().
- **Endpoints:** Centralized in `api_endpoints.dart`; used by ApiServices (get/post/put/patch/delete/multipart) and repositories.

---

## 6. Responsive / UI

- **Figma reference:** 375×844 (kFigmaDesignWidth / kFigmaDesignHeight in size_extension.dart).
- **Helpers:** `context.sw()`, `context.sh()`, `context.sp()`, `context.radiusR()`, `context.paddingSymmetricR()`, `context.paddingOnlyR()`, `context.paddingAllR()` used across screens for scaling.

---

## 7. Flow summary diagram

```
                    ┌─────────────────┐
                    │  SplashScreen   │
                    └────────┬────────┘
                             │ 4s
                             ▼
                    ┌─────────────────┐
                    │  StartScreen    │
                    └────────┬────────┘
                             │ Get Started
                             ▼
                    ┌─────────────────┐
                    │ QuestionScreen  │ (5 steps)
                    └────────┬────────┘
                             │ Complete
                             ▼
                    ┌─────────────────┐     ┌──────────────────┐
                    │   GaolScreen    │◄────│ HealtDetailsScreen│
                    └────────┬────────┘     └──────────────────┘
                             │ Get Started
                             ▼
                    ┌─────────────────┐
                    │  OnBoardScreen  │
                    └────────┬────────┘
                             │ Next
                             ▼
                    ┌─────────────────┐
                    │SubscriptionPlan │
                    └────────┬────────┘
                             │ Continue
                             ▼
                    ┌─────────────────┐
                    │ CardDetails     │ → Purchase → PaymentDetails
                    └────────┬────────┘
                             │
                             ▼
                    ┌─────────────────┐
                    │   AuthScreen    │ (Google Sign-In)
                    └────────┬────────┘
                             │ success
                             ▼
                    ┌─────────────────┐
                    │BottomSheetBar   │ ←── 3 tabs: Home | Progress | Setting
                    │  (main app)     │
                    └────────┬────────┘
                             │
         ┌───────────────────┼───────────────────┐
         ▼                   ▼                   ▼
   HomeScreen          ProgressScreen      SettingScreen
   (grid → Diet,       (MyAlbum, etc.)     (Privacy, Terms,
    Skin, Hair,                             logout, etc.)
    Facial, Fashion,
    Height, QuitPorn,
    WorkOut)
```

---

## 8. Where to plug in onboarding session (anonymous)

- **Best place:** Right after **SplashScreen** (or before **StartScreen**). Call `OnboardingRepository.instance.createAnonymousSession()` when the user starts the anonymous flow (e.g. in SplashViewModel after delay, or in StartScreen.initState).
- **Optional:** Store `session.id` (e.g. SharedPreferences or a small SessionViewModel) and send it in later API calls if the backend expects a session header or body field for anonymous users.

---

*Generated from codebase analysis.*
