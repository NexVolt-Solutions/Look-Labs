import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:looklabs/Core/Network/api_config.dart';
import 'package:looklabs/Core/Network/api_endpoints.dart';
import 'package:looklabs/Core/Network/api_response.dart';
import 'package:looklabs/Core/Network/api_services.dart';
import 'package:looklabs/Core/Network/models/onboarding_flow_response.dart';
import 'package:looklabs/Core/Network/models/onboarding_session.dart';

const _kStorageKeySession = 'onboarding_session';

/// Repository for anonymous onboarding (no auth token).
class OnboardingRepository {
  OnboardingRepository._();

  static final OnboardingRepository _instance = OnboardingRepository._();
  static OnboardingRepository get instance => _instance;

  static const FlutterSecureStorage _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  /// In-memory cache: key = "$sessionId\_$step", value = flow response. Reduces GET when user goes back.
  static final Map<String, OnboardingFlowResponse> _flowCache = {};

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
      debugPrint(
        '[OnboardingRepository] Session restored from storage: ${currentSession!.id}',
      );
      return true;
    } catch (e) {
      debugPrint('[OnboardingRepository] loadStoredSession error: $e');
      return false;
    }
  }

  static Future<void> _saveSessionToStorage(OnboardingSession session) async {
    try {
      await _storage.write(
        key: _kStorageKeySession,
        value: jsonEncode(session.toJson()),
      );
    } catch (e) {
      debugPrint('[OnboardingRepository] _saveSessionToStorage error: $e');
    }
  }

  static Future<void> _clearStoredSession() async {
    try {
      await _storage.delete(key: _kStorageKeySession);
    } catch (e) {
      debugPrint('[OnboardingRepository] _clearStoredSession error: $e');
    }
  }

  /// Creates an anonymous onboarding session. No token required.
  /// POST {{base_url}}/api/v1/onboarding/sessions
  /// On success, sets [currentSession] and saves to SecureStorage.
  Future<ApiResponse> createAnonymousSession() async {
    final endpoint = ApiEndpoints.onboardingSessions;
    final fullUrl = ApiConfig.getFullUrl(endpoint);
    debugPrint('[OnboardingRepository] POST $endpoint (anonymous, no auth)');
    debugPrint('[OnboardingRepository] URL: $fullUrl');
    final response = await ApiServices.post(
      endpoint,
      body: <String, dynamic>{},
      headers: ApiConfig.defaultHeaders,
    );
    debugPrint(
      '[OnboardingRepository] POST $endpoint → success=${response.success} statusCode=${response.statusCode} message=${response.message}',
    );
    if (!response.success) {
      final dataStr = response.data != null ? response.data.toString() : 'null';
      debugPrint(
        '[OnboardingRepository] failure body: ${dataStr.length > 400 ? "${dataStr.substring(0, 400)}..." : dataStr}',
      );
    }

    if (response.success && response.data is Map<String, dynamic>) {
      final session = OnboardingSession.fromJson(
        Map<String, dynamic>.from(response.data as Map),
      );
      currentSession = session;
      await _saveSessionToStorage(session);
      _flowCache.clear();
      debugPrint(
        '[OnboardingRepository] Session created and saved: id=${session.id} isPaid=${session.isPaid}',
      );
      return ApiResponse(
        success: true,
        statusCode: response.statusCode,
        data: session,
        message: response.message,
      );
    }
    return response;
  }

  /// Clear session (e.g. after user signs in). Removes from memory and SecureStorage.
  static Future<void> clearSession() async {
    debugPrint('[OnboardingRepository] clearSession()');
    currentSession = null;
    _flowCache.clear();
    await _clearStoredSession();
  }

  /// GET onboarding/sessions/{session_id}/flow?step=...&index=...
  /// Returns current question, next question, and progress. Uses in-memory cache when available (e.g. when user goes back).
  Future<ApiResponse> getFlow({
    required String sessionId,
    required String step,
    required int index,
  }) async {
    final cacheKey = '${sessionId}_${step}_$index';
    final cached = _flowCache[cacheKey];
    if (cached != null) {
      debugPrint(
        '[OnboardingRepository] GET flow (step=$step index=$index) → cache hit',
      );
      return ApiResponse(
        success: true,
        statusCode: 200,
        data: cached,
        message: null,
      );
    }

    final endpoint = ApiEndpoints.onboardingSessionFlow(sessionId);
    final queryParams = <String, String>{
      'step': step,
      'index': index.toString(),
    };
    final fullUrl = ApiConfig.getFullUrl(endpoint);
    debugPrint(
      '[OnboardingRepository] GET $endpoint (step=$step index=$index)',
    );
    debugPrint('[OnboardingRepository] URL: $fullUrl');
    final response = await ApiServices.get(
      endpoint,
      queryParams: queryParams,
      headers: ApiConfig.defaultHeaders,
    );
    debugPrint(
      '[OnboardingRepository] GET $endpoint → success=${response.success} statusCode=${response.statusCode}',
    );
    if (!response.success && response.data != null) {
      final dataStr = response.data.toString();
      debugPrint(
        '[OnboardingRepository] failure body: ${dataStr.length > 300 ? "${dataStr.substring(0, 300)}..." : dataStr}',
      );
    }
    if (response.success &&
        response.data != null &&
        response.data is Map<String, dynamic>) {
      final flow = OnboardingFlowResponse.fromJson(
        Map<String, dynamic>.from(response.data as Map),
      );
      _flowCache[cacheKey] = flow;
      _logFlowResponse(flow);
      return ApiResponse(
        success: true,
        statusCode: response.statusCode,
        data: flow,
        message: response.message,
      );
    }
    return response;
  }

  /// PATCH onboarding/sessions/{session_id}/domain?domain=skincare
  /// Domain must be one of: skincare, haircare, facial, diet, height, workout, quit_porn, fashion.
  Future<ApiResponse> selectDomain({
    required String sessionId,
    required String domain,
  }) async {
    final endpoint = ApiEndpoints.onboardingSessionDomain(sessionId);
    final queryParams = <String, String>{'domain': domain};
    final fullUrl = ApiConfig.getFullUrl(endpoint);
    debugPrint(
      '[OnboardingRepository] PATCH $endpoint (domain=$domain)',
    );
    debugPrint('[OnboardingRepository] URL: $fullUrl');
    final response = await ApiServices.patch(
      endpoint,
      queryParams: queryParams,
      headers: ApiConfig.defaultHeaders,
    );
    debugPrint(
      '[OnboardingRepository] PATCH $endpoint → success=${response.success} statusCode=${response.statusCode}',
    );
    return response;
  }

  /// POST onboarding/sessions/{session_id}/answers
  /// Body: question_id, answer, question_type, question_options?, constraints?
  /// Response: same shape as flow (status, current, next, progress, redirect).
  Future<ApiResponse> submitAnswer({
    required String sessionId,
    required int questionId,
    required dynamic answer,
    required String questionType,
    List<dynamic>? questionOptions,
    Map<String, dynamic>? constraints,
  }) async {
    final endpoint = ApiEndpoints.onboardingSessionAnswers(sessionId);
    final fullUrl = ApiConfig.getFullUrl(endpoint);
    final body = <String, dynamic>{
      'question_id': questionId,
      'answer': answer,
      'question_type': questionType,
      'question_options': questionOptions,
      'constraints': constraints,
    };
    debugPrint(
      '[OnboardingRepository] POST $endpoint (question_id=$questionId type=$questionType)',
    );
    debugPrint('[OnboardingRepository] URL: $fullUrl');
    final response = await ApiServices.post(
      endpoint,
      body: body,
      headers: ApiConfig.defaultHeaders,
    );
    debugPrint(
      '[OnboardingRepository] POST $endpoint → success=${response.success} statusCode=${response.statusCode}',
    );
    if (!response.success && response.data != null) {
      final dataStr = response.data.toString();
      debugPrint(
        '[OnboardingRepository] failure body: ${dataStr.length > 300 ? "${dataStr.substring(0, 300)}..." : dataStr}',
      );
    }
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

  /// Log flow API response for debugging (Question screen).
  static void _logFlowResponse(OnboardingFlowResponse flow) {
    debugPrint('[OnboardingRepository] === flow response ===');
    debugPrint('[OnboardingRepository] status: ${flow.status}');
    debugPrint('[OnboardingRepository] redirect: ${flow.redirect}');
    if (flow.current != null) {
      final c = flow.current!;
      debugPrint(
        '[OnboardingRepository] current: id=${c.id} step=${c.step} type=${c.type} question="${c.question}"',
      );
      debugPrint('[OnboardingRepository] current options: ${c.options}');
      debugPrint(
        '[OnboardingRepository] current constraints: ${c.constraints}',
      );
    } else {
      debugPrint('[OnboardingRepository] current: null');
    }
    if (flow.next != null) {
      final n = flow.next!;
      debugPrint(
        '[OnboardingRepository] next: id=${n.id} step=${n.step} type=${n.type} question="${n.question}"',
      );
      debugPrint('[OnboardingRepository] next options: ${n.options}');
      debugPrint('[OnboardingRepository] next constraints: ${n.constraints}');
    } else {
      debugPrint('[OnboardingRepository] next: null');
    }
    if (flow.progress != null) {
      final p = flow.progress!;
      debugPrint(
        '[OnboardingRepository] progress: session_id=${p.sessionId} step=${p.step} total_questions=${p.totalQuestions}',
      );
      debugPrint(
        '[OnboardingRepository] progress answered_questions: ${p.answeredQuestions}',
      );
      if (p.progress != null) {
        debugPrint(
          '[OnboardingRepository] progress.sections: ${p.progress!.sections}',
        );
        debugPrint(
          '[OnboardingRepository] progress.overall: ${p.progress!.overall}',
        );
      }
    } else {
      debugPrint('[OnboardingRepository] progress: null');
    }
    debugPrint('[OnboardingRepository] === end flow response ===');
  }

  /// Parses API response data into [OnboardingSession]. Use when you have raw map.
  static OnboardingSession? sessionFromResponse(dynamic data) {
    if (data == null || data is! Map) return null;
    return OnboardingSession.fromJson(Map<String, dynamic>.from(data));
  }
}
