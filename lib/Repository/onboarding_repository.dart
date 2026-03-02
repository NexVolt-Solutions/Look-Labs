import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:looklabs/Core/Network/api_config.dart';
import 'package:looklabs/Core/Network/api_endpoints.dart';
import 'package:looklabs/Core/Network/api_response.dart';
import 'package:looklabs/Core/Network/api_services.dart';
import 'package:looklabs/Core/Network/models/onboarding_flow_response.dart';
import 'package:looklabs/Core/Network/models/onboarding_session.dart';
import 'package:looklabs/Core/Network/models/weekly_progress_response.dart';
import 'package:looklabs/Core/Network/models/wellness_metrics.dart';

const _kStorageKeySession = 'onboarding_session';

/// Repository for anonymous onboarding (no auth token).
/// Questions: GET onboarding/questions. Answers: POST onboarding/sessions/{id}/answers.
class OnboardingRepository {
  OnboardingRepository._();

  static final OnboardingRepository _instance = OnboardingRepository._();
  static OnboardingRepository get instance => _instance;

  static const FlutterSecureStorage _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  /// Current anonymous session (set after createAnonymousSession or loadStoredSession).
  static OnboardingSession? currentSession;
  static String? get sessionId => currentSession?.id;

  /// Restore session from SecureStorage. Call on app start to skip POST if we have a valid session.
  /// Returns true if session was restored.
  static Future<bool> loadStoredSession() async {
    try {
      final json = await _storage.read(key: _kStorageKeySession);
      if (json == null || json.isEmpty) return false;
      final map = jsonDecode(json) as Map<String, dynamic>?;
      if (map == null) return false;
      currentSession = OnboardingSession.fromJson(map);
      return true;
    } catch (_) {
      return false;
    }
  }

  static Future<void> _saveSessionToStorage(OnboardingSession session) async {
    try {
      await _storage.write(
        key: _kStorageKeySession,
        value: jsonEncode(session.toJson()),
      );
    } catch (_) {}
  }

  static Future<void> _clearStoredSession() async {
    try {
      await _storage.delete(key: _kStorageKeySession);
    } catch (_) {}
  }

  /// Creates an anonymous onboarding session. On success, sets [currentSession] and saves to SecureStorage.
  Future<ApiResponse> createAnonymousSession() async {
    final response = await ApiServices.post(
      ApiEndpoints.onboardingSessions,
      body: <String, dynamic>{},
      headers: ApiConfig.defaultHeaders,
    );
    if (!response.success || response.data == null || response.data is! Map) {
      return response;
    }
    final raw = Map<String, dynamic>.from(response.data as Map);
    final json = raw.containsKey('data') && raw['data'] is Map
        ? Map<String, dynamic>.from(raw['data'] as Map)
        : raw;
    try {
      final session = OnboardingSession.fromJson(json);
      if (session.id.isEmpty) {
        return ApiResponse(
          success: false,
          statusCode: response.statusCode,
          data: response.data,
          message: 'Invalid session response',
        );
      }
      currentSession = session;
      await _saveSessionToStorage(session);
      return ApiResponse(
        success: true,
        statusCode: response.statusCode,
        data: session,
        message: response.message,
      );
    } catch (_) {
      return response;
    }
  }

  /// Clear session (e.g. after user signs in).
  static Future<void> clearSession() async {
    currentSession = null;
    await _clearStoredSession();
  }

  /// GET onboarding/questions – all steps and questions in one call.
  Future<ApiResponse> getOnboardingQuestions({String? sessionId}) async {
    final queryParams = sessionId != null && sessionId.isNotEmpty
        ? <String, String>{'session_id': sessionId}
        : null;
    final response = await ApiServices.get(
      ApiEndpoints.onboardingQuestions,
      queryParams: queryParams,
      headers: ApiConfig.defaultHeaders,
    );
    if (!response.success || response.data == null) return response;

    // API returns a raw array of questions: [ { step, id, question, type, options, constraints, created_at }, ... ]
    if (response.data is List) {
      final list = response.data as List;
      final stepsMap = <String, List<FlowQuestion>>{};
      for (final e in list) {
        if (e is! Map) continue;
        try {
          final q = FlowQuestion.fromJson(Map<String, dynamic>.from(e));
          stepsMap
              .putIfAbsent(q.step.isEmpty ? 'profile_setup' : q.step, () => [])
              .add(q);
        } catch (_) {}
      }
      final stepsList = stepsMap.entries
          .map((e) => FlowStepItem(step: e.key, questions: e.value))
          .toList();
      final flow = OnboardingFlowResponse(
        status: 'ok',
        current: null,
        next: null,
        questions: null,
        steps: stepsList,
        progress: null,
        redirect: null,
      );
      return ApiResponse(
        success: true,
        statusCode: response.statusCode,
        data: flow,
        message: response.message,
      );
    }

    // API returns object (e.g. { "status": "ok", "steps": [...] } or wrapped in "data")
    if (response.data is Map<String, dynamic>) {
      final raw = Map<String, dynamic>.from(response.data as Map);
      Map<String, dynamic> json = raw;
      if (raw.containsKey('data')) {
        final data = raw['data'];
        if (data is Map) {
          json = Map<String, dynamic>.from(data);
        } else if (data is List) {
          json = {
            'status': 'ok',
            'steps': [
              {'step': 'profile_setup', 'questions': data},
            ],
          };
        }
      }
      final flow = OnboardingFlowResponse.fromJson(json);
      return ApiResponse(
        success: true,
        statusCode: response.statusCode,
        data: flow,
        message: response.message,
      );
    }
    return response;
  }

  /// GET onboarding/domains – list of domain strings for the goal screen.
  Future<ApiResponse> getOnboardingDomains() async {
    final response = await ApiServices.get(
      ApiEndpoints.onboardingDomains,
      headers: ApiConfig.defaultHeaders,
    );
    if (!response.success) return response;
    List<String> domains = [];
    if (response.data is List) {
      for (final e in response.data as List) {
        if (e != null && e.toString().trim().isNotEmpty) {
          domains.add(e.toString().trim());
        }
      }
    } else if (response.data is Map<String, dynamic>) {
      final raw = response.data as Map<String, dynamic>;
      final list = raw['domains'];
      if (list is List) {
        for (final e in list) {
          if (e != null && e.toString().trim().isNotEmpty) {
            domains.add(e.toString().trim());
          }
        }
      }
    }
    return ApiResponse(
      success: true,
      statusCode: response.statusCode,
      data: domains,
      message: response.message,
    );
  }

  /// POST onboarding/sessions/{session_id}/domain?domain=...
  Future<ApiResponse> selectDomain({
    required String sessionId,
    required String domain,
  }) async {
    final endpoint = 'onboarding/sessions/$sessionId/domain';
    return ApiServices.post(
      endpoint,
      body: <String, dynamic>{},
      queryParams: {'domain': domain},
      headers: ApiConfig.defaultHeaders,
    );
  }

  /// PATCH onboarding/sessions/{session_id}/link – link anonymous session to authenticated user. Call after sign-in; requires Bearer token.
  Future<ApiResponse> linkSessionToUser(String sessionId) async {
    return ApiServices.patch(
      ApiEndpoints.onboardingSessionLink(sessionId),
      body: <String, dynamic>{},
    );
  }

  /// POST onboarding/sessions/{session_id}/answers?step=...
  /// Body: question_id, answer, question_type, question_options?, constraints?
  /// Response: same shape as flow (status, current, next, progress, redirect).
  Future<ApiResponse> submitAnswer({
    required String sessionId,
    required String step,
    required int questionId,
    required dynamic answer,
    required String questionType,
    List<dynamic>? questionOptions,
    Map<String, dynamic>? constraints,
  }) async {
    final response = await ApiServices.post(
      ApiEndpoints.onboardingSessionAnswers(sessionId),
      body: {
        'question_id': questionId,
        'answer': answer,
        'question_type': questionType,
        'question_options': questionOptions,
        'constraints': constraints,
      },
      queryParams: {'step': step},
      headers: ApiConfig.defaultHeaders,
    );
    if (response.success &&
        response.data != null &&
        response.data is Map<String, dynamic>) {
      final flow = OnboardingFlowResponse.fromJson(
        Map<String, dynamic>.from(response.data as Map),
      );
      return ApiResponse(
        success: true,
        statusCode: response.statusCode,
        data: flow,
        message: response.message,
      );
    }
    return response;
  }

  /// GET onboarding/users/me/wellness. Requires Bearer token (no headers = use ApiServices default with token).
  Future<ApiResponse> getWellnessMetrics() async {
    final response = await ApiServices.get(
      ApiEndpoints.onboardingUsersMeWellness,
    );
    if (kDebugMode) {
      debugPrint('[Wellness API] statusCode=${response.statusCode}, success=${response.success}, dataType=${response.data?.runtimeType}');
    }
    if (response.success && response.data != null && response.data is Map) {
      final raw = Map<String, dynamic>.from(response.data as Map);
      // Support both { height, weight, ... } and { data: { height, weight, ... } }
      final Map<String, dynamic> json = raw.containsKey('data') && raw['data'] is Map
          ? Map<String, dynamic>.from(raw['data'] as Map)
          : raw;
      final metrics = WellnessMetrics.fromJson(json);
      return ApiResponse(
        success: true,
        statusCode: response.statusCode,
        data: metrics,
        message: response.message,
      );
    }
    return response;
  }

  /// GET users/me/progress/weekly. Requires Bearer token.
  Future<ApiResponse> getWeeklyProgress() async {
    final response = await ApiServices.get(
      ApiEndpoints.usersMeProgressWeekly,
    );
    if (response.success && response.data != null && response.data is Map) {
      final raw = Map<String, dynamic>.from(response.data as Map);
      final Map<String, dynamic> json = raw.containsKey('data') && raw['data'] is Map
          ? Map<String, dynamic>.from(raw['data'] as Map)
          : raw;
      final progress = WeeklyProgressResponse.fromJson(json);
      return ApiResponse(
        success: true,
        statusCode: response.statusCode,
        data: progress,
        message: response.message,
      );
    }
    return response;
  }

  /// Parses API response data into [OnboardingSession].
  static OnboardingSession? sessionFromResponse(dynamic data) {
    if (data == null || data is! Map) return null;
    return OnboardingSession.fromJson(Map<String, dynamic>.from(data));
  }
}
