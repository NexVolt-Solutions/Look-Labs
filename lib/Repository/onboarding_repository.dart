import 'package:flutter/foundation.dart';
import 'package:looklabs/Core/Network/api_config.dart';
import 'package:looklabs/Core/Network/api_endpoints.dart';
import 'package:looklabs/Core/Network/api_response.dart';
import 'package:looklabs/Core/Network/api_services.dart';
import 'package:looklabs/Core/Network/models/onboarding_flow_response.dart';
import 'package:looklabs/Core/Network/models/onboarding_session.dart';

/// Repository for anonymous onboarding (no auth token).
class OnboardingRepository {
  OnboardingRepository._();

  static final OnboardingRepository _instance = OnboardingRepository._();
  static OnboardingRepository get instance => _instance;

  /// Current anonymous session (set after createAnonymousSession succeeds).
  /// Use [sessionId] for API headers (e.g. X-Session-Id) if backend requires it.
  static OnboardingSession? currentSession;
  static String? get sessionId => currentSession?.id;

  /// Creates an anonymous onboarding session. No token required.
  /// POST {{base_url}}/api/v1/onboarding/sessions
  /// On success, sets [currentSession] so the app can use [sessionId] in later requests.
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
      debugPrint(
        '[OnboardingRepository] Session created: id=${session.id} isPaid=${session.isPaid}',
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

  /// Clear session (e.g. after user signs in).
  static void clearSession() {
    debugPrint('[OnboardingRepository] clearSession()');
    currentSession = null;
  }

  /// GET onboarding/sessions/{session_id}/flow?step=...&index=...
  /// Returns current question, next question, and progress. No auth.
  Future<ApiResponse> getFlow({
    required String sessionId,
    required String step,
    required int index,
  }) async {
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
