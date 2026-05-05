part of 'domain_questions_repository.dart';

extension _DomainQuestionsRepositoryFlow on DomainQuestionsRepository {
  Future<ApiResponse> _getDomainFlow(String domain) async {
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

  Future<Map<String, dynamic>?> _pollDomainFlowUntilCompleted(
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
        final res = await _getDomainFlow(domain);
        if (!res.success || res.data is! Map) return null;
        data = Map<String, dynamic>.from(res.data as Map);
      }
      final status = data['status']?.toString().toLowerCase() ?? '';
      if (status == 'completed' || status == 'ok') return data;
      if (status == 'failed' || status == 'error') return data;

      if (status.isEmpty ||
          status == 'processing' ||
          status == 'pending' ||
          status == 'in_progress') {
        await Future<void>.delayed(interval);
        data = null;
        continue;
      }
      return data;
    }
    return null;
  }
}
