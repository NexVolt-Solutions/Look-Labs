import 'package:flutter/foundation.dart';
import 'package:looklabs/Core/Network/api_endpoints.dart';
import 'package:looklabs/Core/Network/api_response.dart';
import 'package:looklabs/Core/Network/api_services.dart';
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

  /// GET domains/{domain}/questions – list of questions. Uses user's selected domain from onboarding (link response) when set.
  Future<ApiResponse> getDomainQuestions(String domain) async {
    final effectiveDomain =
        (await AuthRepository.getSelectedDomain())?.trim() ?? domain.trim();
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

    if (response.data is! List) {
      return ApiResponse(
        success: false,
        statusCode: response.statusCode,
        data: null,
        message: 'Invalid response format',
      );
    }

    final list = response.data as List;
    final pairs = <({FlowQuestion q, int seq})>[];
    for (final e in list) {
      if (e is Map) {
        try {
          final map = Map<String, dynamic>.from(e);
          map['step'] = map['domain'] ?? '';
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

  /// POST domains/{domain}/answers – submit each answer (one request per question).
  /// Uses user's selected domain from onboarding (link response) when set; otherwise the given domain.
  Future<ApiResponse> submitDomainAnswers(
    String domain,
    List<DomainAnswerPayload> answers,
  ) async {
    final effectiveDomain =
        (await AuthRepository.getSelectedDomain())?.trim() ?? domain.trim();
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
    // Submit all answers in parallel so total time ≈ one round-trip instead of N.
    final futures = answers.map(
      (payload) => ApiServices.post(
        endpoint,
        body: {
          'user_id': userId,
          'question_id': payload.questionId,
          'answer': payload.answer,
          'domain': effectiveDomain,
        },
      ),
    );
    final results = await Future.wait(futures);

    for (var i = 0; i < results.length; i++) {
      final response = results[i];
      if (!response.success) {
        if (kDebugMode) {
          debugPrint(
            '[DomainAnswers] domain=$effectiveDomain questionId=${answers[i].questionId} statusCode=${response.statusCode}',
          );
        }
        return response;
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
      data: null,
      message: null,
    );
  }
}
