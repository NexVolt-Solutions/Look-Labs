part of 'domain_questions_repository.dart';

extension _DomainQuestionsRepositorySubmit on DomainQuestionsRepository {
  Future<ApiResponse> _submitSingleAnswer(
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

  Future<ApiResponse> _submitDomainAnswers(
    String domain,
    List<DomainAnswerPayload> answers,
  ) async {
    final effectiveDomain = await _effectiveDomain(domain);
    if (effectiveDomain.isEmpty || answers.isEmpty) {
      return ApiResponse(
        success: false,
        statusCode: 400,
        message: answers.isEmpty ? 'No answers to submit' : 'Domain is required',
      );
    }

    final meRes = await AuthRepository.instance.getMe();
    final userId =
        (meRes.success && meRes.data != null && meRes.data is UserProfileResponse)
        ? (meRes.data! as UserProfileResponse).id ?? 0
        : 0;
    if (userId <= 0) {
      return ApiResponse(
        success: false,
        statusCode: 401,
        message: 'User not found. Please sign in again.',
      );
    }

    final endpoint = ApiEndpoints.domainsAnswers(effectiveDomain);
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
