import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:looklabs/Core/Network/api_endpoints.dart';
import 'package:looklabs/Core/Network/api_response.dart';
import 'package:looklabs/Core/Network/api_services.dart';

/// Repository for diet-specific APIs.
class DietRepository {
  DietRepository._();

  static final DietRepository _instance = DietRepository._();
  static DietRepository get instance => _instance;
  static const FlutterSecureStorage _storage = FlutterSecureStorage();
  static const String _kDietFlowCachePayload = 'diet_flow_cache_payload';
  static const String _kDietFlowCacheUpdatedAt = 'diet_flow_cache_updated_at';

  Map<String, dynamic>? _cachedFlowPayload;
  DateTime? _cacheUpdatedAt;
  bool _cacheLoadedFromStorage = false;

  /// POST domains/diet/generate-meal-plan.
  ///
  /// Uses safe defaults when values are missing.
  Future<ApiResponse> generateMealPlan({
    String focus = 'build_muscle',
    int calorieTarget = 1200,
    int mealCount = 3,
    int snackCount = 2,
    List<String> dietaryPreferences = const [],
    List<String> allergies = const [],
    String cuisinePreference = '',
  }) async {
    final body = <String, dynamic>{
      'focus': focus.trim().isEmpty ? 'build_muscle' : focus.trim(),
      'calorie_target': calorieTarget > 0 ? calorieTarget : 1200,
      'meal_count': mealCount > 0 ? mealCount : 3,
      'snack_count': snackCount >= 0 ? snackCount : 2,
      'dietary_preferences': dietaryPreferences,
      'allergies': allergies,
      'cuisine_preference': cuisinePreference.trim(),
    };

    if (kDebugMode) {
      debugPrint('[DietRepository] generate-meal-plan request body: $body');
    }

    final response = await ApiServices.post(
      ApiEndpoints.dietGenerateMealPlan,
      body: body,
    );

    if (kDebugMode) {
      debugPrint(
        '[DietRepository] generate-meal-plan statusCode=${response.statusCode}, success=${response.success}',
      );
    }

    return response;
  }

  Map<String, dynamic>? get cachedFlowPayload => _cachedFlowPayload == null
      ? null
      : Map<String, dynamic>.from(_cachedFlowPayload!);

  DateTime? get cacheUpdatedAt => _cacheUpdatedAt;

  bool hasFreshFlowCache({Duration ttl = const Duration(minutes: 2)}) {
    if (_cachedFlowPayload == null || _cacheUpdatedAt == null) return false;
    return DateTime.now().difference(_cacheUpdatedAt!) <= ttl;
  }

  Future<void> ensureFlowCacheLoaded() async {
    if (_cacheLoadedFromStorage) return;
    _cacheLoadedFromStorage = true;
    try {
      final payloadRaw = await _storage.read(key: _kDietFlowCachePayload);
      final updatedRaw = await _storage.read(key: _kDietFlowCacheUpdatedAt);
      if (payloadRaw == null || payloadRaw.trim().isEmpty) return;
      final decoded = jsonDecode(payloadRaw);
      if (decoded is! Map) return;
      _cachedFlowPayload = Map<String, dynamic>.from(decoded);
      final parsedAt = DateTime.tryParse(updatedRaw ?? '');
      _cacheUpdatedAt = parsedAt ?? DateTime.now();
    } catch (_) {
      _cachedFlowPayload = null;
      _cacheUpdatedAt = null;
    }
  }

  void setFlowCache(Map<String, dynamic>? payload) {
    if (payload == null || payload.isEmpty) return;
    _cachedFlowPayload = Map<String, dynamic>.from(payload);
    _cacheUpdatedAt = DateTime.now();
    unawaited(_persistFlowCache());
  }

  void clearFlowCache() {
    _cachedFlowPayload = null;
    _cacheUpdatedAt = null;
    unawaited(_storage.delete(key: _kDietFlowCachePayload));
    unawaited(_storage.delete(key: _kDietFlowCacheUpdatedAt));
  }

  Future<void> _persistFlowCache() async {
    final payload = _cachedFlowPayload;
    final updatedAt = _cacheUpdatedAt;
    if (payload == null || updatedAt == null) return;
    try {
      await _storage.write(
        key: _kDietFlowCachePayload,
        value: jsonEncode(payload),
      );
      await _storage.write(
        key: _kDietFlowCacheUpdatedAt,
        value: updatedAt.toIso8601String(),
      );
    } catch (_) {}
  }

  /// Derive generate-meal-plan params from diet flow payload.
  ///
  /// Supports both root-level and ai_attributes keys with safe fallbacks.
  Map<String, dynamic> planParamsFromDietFlow(Map<String, dynamic>? flowData) {
    final data = flowData ?? const <String, dynamic>{};
    final attrsRaw = data['ai_attributes'];
    final attrs = attrsRaw is Map
        ? Map<String, dynamic>.from(attrsRaw)
        : <String, dynamic>{};

    final focus = _normalizeFocus(
      _pickString(
        [attrs['focus'], attrs['goal_focus'], attrs['today_focus'], data['focus']],
      ),
    );

    final calorieTarget = _pickInt(
      [attrs['calorie_target'], attrs['daily_calories'], data['calorie_target']],
      fallback: 1200,
    );
    final mealCount = _pickInt(
      [attrs['meal_count'], attrs['meals_per_day'], data['meal_count']],
      fallback: 3,
    );
    final snackCount = _pickInt(
      [attrs['snack_count'], attrs['snacks_per_day'], data['snack_count']],
      fallback: 2,
    );

    final dietaryPreferences = _pickStringList([
      attrs['dietary_preferences'],
      attrs['diet_preferences'],
      data['dietary_preferences'],
    ]);
    final allergies = _pickStringList([
      attrs['allergies'],
      attrs['allergy'],
      data['allergies'],
    ]);
    final cuisinePreference = _pickString(
      [attrs['cuisine_preference'], attrs['cuisine'], data['cuisine_preference']],
    );

    return <String, dynamic>{
      'focus': focus,
      'calorie_target': calorieTarget,
      'meal_count': mealCount,
      'snack_count': snackCount,
      'dietary_preferences': dietaryPreferences,
      'allergies': allergies,
      'cuisine_preference': cuisinePreference,
    };
  }

  static String _pickString(List<dynamic> candidates, {String fallback = ''}) {
    for (final c in candidates) {
      if (c is String && c.trim().isNotEmpty) return c.trim();
      if (c is List) {
        for (final e in c) {
          if (e is String && e.trim().isNotEmpty) return e.trim();
        }
      }
    }
    return fallback;
  }

  static int _pickInt(List<dynamic> candidates, {required int fallback}) {
    for (final c in candidates) {
      if (c is int && c > 0) return c;
      if (c is num && c > 0) return c.toInt();
      if (c is String) {
        final parsed = int.tryParse(c.trim());
        if (parsed != null && parsed > 0) return parsed;
      }
    }
    return fallback;
  }

  static List<String> _pickStringList(List<dynamic> candidates) {
    for (final c in candidates) {
      if (c is List) {
        final out = <String>[];
        for (final e in c) {
          final s = e?.toString().trim() ?? '';
          if (s.isNotEmpty) out.add(s);
        }
        if (out.isNotEmpty) return out;
      }
      if (c is String && c.trim().isNotEmpty) {
        return c
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList();
      }
    }
    return const <String>[];
  }

  static String _normalizeFocus(String raw) {
    final t = raw.toLowerCase().trim().replaceAll(' ', '_');
    if (t.isEmpty) return 'build_muscle';
    if (t.contains('muscle') || t.contains('build')) return 'build_muscle';
    if (t.contains('fat') || t.contains('loss')) return 'fatloss';
    if (t.contains('strength')) return 'strength';
    if (t.contains('flex')) return 'flexibility';
    return t;
  }
}
