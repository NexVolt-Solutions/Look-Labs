import 'package:flutter/foundation.dart';
import 'package:looklabs/Core/Network/api_endpoints.dart';
import 'package:looklabs/Core/Network/models/explore_domain.dart';
import 'package:looklabs/Core/Network/api_response.dart';
import 'package:looklabs/Core/Network/api_services.dart';

/// Repository for explore domains (Home screen "Explore your plans").
/// Uses GET domains/explore which requires authentication.
/// API returns: { "domains": [ { "key", "name", "subtitle", "icon_url" }, ... ] }.
class ExploreDomainsRepository {
  ExploreDomainsRepository._();

  static final ExploreDomainsRepository _instance = ExploreDomainsRepository._();
  static ExploreDomainsRepository get instance => _instance;

  /// Cache disabled: always return null.
  static Future<List<ExploreDomain>?> loadCachedDomains() async {
    return null;
  }

  /// Cache disabled (no-op).
  static Future<void> clearDomainsCache() async {
    return;
  }

  static List<ExploreDomain> _parseDomains(dynamic data) {
    final list = data is List
        ? data
        : data is Map
            ? (data['domains'] ?? data['data'])
            : null;
    if (list is! List) return [];
    return list
        .map((e) => e is Map ? ExploreDomain.fromJson(Map<String, dynamic>.from(e)) : null)
        .whereType<ExploreDomain>()
        .where((d) => d.key.isNotEmpty)
        .toList();
  }

  /// GET domains/explore – list of domain objects for authenticated user.
  /// Requires Bearer token. Cache disabled: always returns fresh API data.
  Future<ApiResponse> getExploreDomains() async {
    final response = await ApiServices.get(ApiEndpoints.domainsExplore);

    if (kDebugMode) {
      debugPrint(
        '[ExploreDomains] statusCode=${response.statusCode}, success=${response.success}',
      );
    }

    if (!response.success) {
      return ApiResponse(
        success: false,
        statusCode: response.statusCode,
        data: null,
        message: response.message ?? 'Could not load explore domains',
      );
    }

    final domains = _parseDomains(response.data ?? []);

    return ApiResponse(
      success: true,
      statusCode: response.statusCode,
      data: domains,
      message: response.message,
    );
  }
}
