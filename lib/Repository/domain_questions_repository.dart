import 'package:flutter/foundation.dart';
import 'package:looklabs/Core/Network/api_endpoints.dart';
import 'package:looklabs/Core/Network/api_response.dart';
import 'package:looklabs/Core/Network/api_services.dart';
import 'package:looklabs/Core/Network/models/domain_answers_response.dart';
import 'package:looklabs/Core/Network/models/onboarding_flow_response.dart';
import 'package:looklabs/Core/Network/models/user_profile_response.dart';
import 'package:looklabs/Repository/auth_repository.dart';

/// Payload for one domain answer to submit.
class DomainAnswerPayload {
  final int questionId;
  final String answer;

  const DomainAnswerPayload({required this.questionId, required this.answer});
}

/// Repository for domain questions and domain answers (requires auth).
class DomainQuestionsRepository {
  DomainQuestionsRepository._();

  static final DomainQuestionsRepository _instance =
      DomainQuestionsRepository._();
  static DomainQuestionsRepository get instance => _instance;

  /// Effective domain: use passed domain; fallback to selected domain only when empty.
  Future<String> _effectiveDomain(String domain) async {
    final d = domain.trim();
    if (d.isNotEmpty) return d;
    return (await AuthRepository.getSelectedDomain())?.trim() ?? '';
  }

  /// GET domains/{domain}/questions – list of questions.
  Future<ApiResponse> getDomainQuestions(String domain) async {
    final effectiveDomain = await _effectiveDomain(domain);
    if (effectiveDomain.isEmpty) {
      return ApiResponse(
        success: false,
        statusCode: 400,
        message: 'Domain is required',
      );
    }
    final endpoint = ApiEndpoints.domainsQuestions(effectiveDomain);
    final response = await ApiServices.get(endpoint);

    if (kDebugMode) {
      debugPrint(
        '[DomainQuestions] domain=$effectiveDomain statusCode=${response.statusCode}, success=${response.success}',
      );
    }

    if (!response.success) {
      return ApiResponse(
        success: false,
        statusCode: response.statusCode,
        data: null,
        message: response.message ?? 'Could not load questions',
      );
    }

    // Support both: (1) list of questions, (2) { "domains": { "domainKey": [ ... ] } }
    List<dynamic> rawList;
    if (response.data is List) {
      rawList = response.data as List;
    } else if (response.data is Map) {
      final data = response.data as Map;
      final domains = data['domains'];
      if (domains is! Map) {
        return ApiResponse(
          success: false,
          statusCode: response.statusCode,
          data: null,
          message: 'Invalid response format: missing domains',
        );
      }
      final domainKey = effectiveDomain.toLowerCase().trim();
      final domainList = domains[domainKey] ?? domains[effectiveDomain];
      if (domainList is! List) {
        return ApiResponse(
          success: false,
          statusCode: response.statusCode,
          data: null,
          message: 'No questions found for domain "$effectiveDomain"',
        );
      }
      rawList = domainList;
    } else {
      return ApiResponse(
        success: false,
        statusCode: response.statusCode,
        data: null,
        message: 'Invalid response format',
      );
    }

    final pairs = <({FlowQuestion q, int seq})>[];
    for (var i = 0; i < rawList.length; i++) {
      final e = rawList[i];
      if (e is Map) {
        try {
          final map = Map<String, dynamic>.from(e);
          // Preserve step from API (e.g. "type", "density"); fallback to domain or index
          if (map['step'] == null || map['step'].toString().trim().isEmpty) {
            map['step'] = map['domain']?.toString() ?? 'step_${i + 1}';
          }
          // Ensure id for submit: backend may omit id in new format, use 1-based index
          final idRaw = map['id'];
          if (idRaw == null) {
            map['id'] = i + 1;
          } else if (idRaw is num) {
            map['id'] = idRaw.toInt();
          }
          final q = FlowQuestion.fromJson(map);
          final seq = map['seq'] is num
              ? (map['seq'] as num).toInt()
              : (map['id'] is num ? (map['id'] as num).toInt() : q.id);
          pairs.add((q: q, seq: seq));
        } catch (_) {}
      }
    }
    pairs.sort((a, b) => a.seq.compareTo(b.seq));
    final questions = pairs.map((p) => p.q).toList();

    return ApiResponse(
      success: true,
      statusCode: response.statusCode,
      data: questions,
      message: response.message,
    );
  }

  /// GET domains/{domain}/questions – returns first question + total count for step-by-step flow.
  /// Data: { "question": FlowQuestion, "totalCount": int }.
  Future<ApiResponse> getDomainFirstQuestion(String domain) async {
    final res = await getDomainQuestions(domain);
    if (!res.success || res.data is! List) return res;
    final list = res.data as List;
    if (list.isEmpty) {
      return ApiResponse(
        success: false,
        statusCode: res.statusCode,
        data: null,
        message: 'No questions found',
      );
    }
    final flowQuestions = list.map((e) {
      if (e is FlowQuestion) return e;
      return FlowQuestion.fromJson(Map<String, dynamic>.from(e as Map));
    }).toList();
    final first = flowQuestions.first;
    return ApiResponse(
      success: true,
      statusCode: res.statusCode,
      data: {
        'question': first,
        'totalCount': flowQuestions.length,
        'allQuestions': flowQuestions,
      },
      message: res.message,
    );
  }

  /// GET domains/{domain}/flow – poll for completion when status is "processing".
  Future<ApiResponse> getDomainFlow(String domain) async {
    final effectiveDomain = await _effectiveDomain(domain);
    if (effectiveDomain.isEmpty) {
      return ApiResponse(
        success: false,
        statusCode: 400,
        message: 'Domain is required',
      );
    }
    final endpoint = ApiEndpoints.domainsFlow(effectiveDomain);
    return ApiServices.get(endpoint);
  }

  /// Poll domains/{domain}/flow every [interval] until status is "completed".
  /// Pass [lastKnownResponse] when you already called [getDomainFlow] and got
  /// e.g. `processing` — avoids an immediate duplicate GET on the first poll tick.
  Future<Map<String, dynamic>?> pollDomainFlowUntilCompleted(
    String domain, {
    Map<String, dynamic>? lastKnownResponse,
    Duration interval = const Duration(seconds: 3),
    Duration timeout = const Duration(minutes: 2),
  }) async {
    final stopAt = DateTime.now().add(timeout);
    Map<String, dynamic>? data = lastKnownResponse != null
        ? Map<String, dynamic>.from(lastKnownResponse)
        : null;

    while (DateTime.now().isBefore(stopAt)) {
      if (data == null) {
        final res = await getDomainFlow(domain);
        if (!res.success || res.data is! Map) return null;
        data = Map<String, dynamic>.from(res.data as Map);
      }
      final status = data['status']?.toString() ?? '';
      if (status == 'completed' || status == 'ok') {
        return data;
      }
      await Future<void>.delayed(interval);
      data = null;
    }
    return null;
  }

  /// POST domains/{domain}/answers – submit one answer. Body: { question_id, domain, answer }.
  /// Returns full response (current, next, progress, redirect) for step-by-step flow.
  Future<ApiResponse> submitSingleAnswer(
    String domain,
    int questionId,
    String answer,
  ) async {
    final effectiveDomain = await _effectiveDomain(domain);
    if (effectiveDomain.isEmpty) {
      return ApiResponse(
        success: false,
        statusCode: 400,
        message: 'Domain is required',
      );
    }
    final endpoint = ApiEndpoints.domainsAnswers(effectiveDomain);
    final response = await ApiServices.post(
      endpoint,
      body: {
        'question_id': questionId,
        'domain': effectiveDomain,
        'answer': answer,
      },
    );
    if (!response.success) {
      if (kDebugMode) {
        debugPrint(
          '[DomainAnswers] domain=$effectiveDomain questionId=$questionId statusCode=${response.statusCode}',
        );
      }
      return response;
    }
    DomainAnswersResponse? data;
    if (response.data is Map) {
      try {
        data = DomainAnswersResponse.fromJson(
          Map<String, dynamic>.from(response.data as Map),
        );
      } catch (_) {}
    }
    return ApiResponse(
      success: true,
      statusCode: response.statusCode,
      data: data,
      message: response.message,
    );
  }

  /// POST domains/{domain}/answers – submit each answer (one request per question).
  /// Submits sequentially so the last response (status "completed") contains ai_attributes, ai_exercises, etc.
  /// Returns success with data = last response map when all succeed; use for workout result screen.
  Future<ApiResponse> submitDomainAnswers(
    String domain,
    List<DomainAnswerPayload> answers,
  ) async {
    final effectiveDomain = await _effectiveDomain(domain);
    if (effectiveDomain.isEmpty || answers.isEmpty) {
      return ApiResponse(
        success: false,
        statusCode: 400,
        message: answers.isEmpty
            ? 'No answers to submit'
            : 'Domain is required',
      );
    }

    var profile = await AuthRepository.loadCachedProfile();
    var userId = profile?.id ?? 0;
    if (userId == 0) {
      final meRes = await AuthRepository.instance.getMe();
      if (meRes.success &&
          meRes.data != null &&
          meRes.data is UserProfileResponse) {
        final p = meRes.data! as UserProfileResponse;
        if (p.id != null && p.id! > 0) {
          profile = p;
          userId = p.id!;
        }
      }
    }
    if (userId == 0) {
      return ApiResponse(
        success: false,
        statusCode: 401,
        message: 'User not found. Please sign in again.',
      );
    }

    final endpoint = ApiEndpoints.domainsAnswers(effectiveDomain);
    // Submit sequentially so the last response has status "completed" with ai_attributes, ai_exercises, etc.
    Map<String, dynamic>? lastResponseData;
    for (var i = 0; i < answers.length; i++) {
      final payload = answers[i];
      final response = await ApiServices.post(
        endpoint,
        body: {
          'question_id': payload.questionId,
          'domain': effectiveDomain,
          'answer': payload.answer,
          if (userId > 0) 'user_id': userId,
        },
      );
      if (!response.success) {
        if (kDebugMode) {
          debugPrint(
            '[DomainAnswers] domain=$effectiveDomain questionId=${payload.questionId} statusCode=${response.statusCode}',
          );
        }
        return response;
      }
      if (response.data is Map) {
        lastResponseData = Map<String, dynamic>.from(response.data as Map);
      }
    }

    if (kDebugMode) {
      debugPrint(
        '[DomainAnswers] domain=$effectiveDomain submitted ${answers.length} answers',
      );
    }
    return ApiResponse(
      success: true,
      statusCode: 200,
      data: lastResponseData,
      message: null,
    );
  }
}
