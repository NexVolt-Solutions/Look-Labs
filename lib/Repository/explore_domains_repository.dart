import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:looklabs/Core/Network/api_endpoints.dart';
import 'package:looklabs/Core/Network/models/explore_domain.dart';
import 'package:looklabs/Core/Network/api_response.dart';
import 'package:looklabs/Core/Network/api_services.dart';

const _kStorageKeyExploreDomains = 'explore_domains_cache';

/// Repository for explore domains (Home screen "Explore your plans").
/// Uses GET domains/explore which requires authentication.
/// API returns: { "domains": [ { "key", "name", "subtitle", "icon_url" }, ... ] }.
class ExploreDomainsRepository {
  ExploreDomainsRepository._();

  static final ExploreDomainsRepository _instance = ExploreDomainsRepository._();
  static ExploreDomainsRepository get instance => _instance;

  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  /// Loads cached domains from secure storage. Returns null if missing or invalid.
  static Future<List<ExploreDomain>?> loadCachedDomains() async {
    try {
      final jsonStr = await _storage.read(key: _kStorageKeyExploreDomains);
      if (jsonStr == null || jsonStr.isEmpty) return null;
      final decoded = jsonDecode(jsonStr);
      if (decoded is List) {
        return decoded
            .map((e) => e is Map ? ExploreDomain.fromJson(Map<String, dynamic>.from(e)) : null)
            .whereType<ExploreDomain>()
            .where((d) => d.key.isNotEmpty)
            .toList();
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  /// Clears cached domains. Call after logout or when backend updates domains.
  static Future<void> clearDomainsCache() async {
    try {
      await _storage.delete(key: _kStorageKeyExploreDomains);
    } catch (_) {}
  }

  static Future<void> _saveDomainsToStorage(List<ExploreDomain> domains) async {
    try {
      await _storage.write(
        key: _kStorageKeyExploreDomains,
        value: jsonEncode(domains.map((d) => d.toJson()).toList()),
      );
    } catch (_) {}
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
  /// Requires Bearer token. Caches result in secure storage.
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

    if (domains.isNotEmpty) {
      await _saveDomainsToStorage(domains);
    }

    return ApiResponse(
      success: true,
      statusCode: response.statusCode,
      data: domains,
      message: response.message,
    );
  }
}
