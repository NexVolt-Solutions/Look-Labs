import 'package:flutter/foundation.dart';
import 'package:looklabs/Core/Network/api_services.dart';
import 'package:looklabs/Core/Network/api_endpoints.dart';

/// Fetches/saves completed exercise indices via API only.
class WorkoutCompletionRepository {
  WorkoutCompletionRepository._();

  static final WorkoutCompletionRepository _instance =
      WorkoutCompletionRepository._();
  static WorkoutCompletionRepository get instance => _instance;

  static String _dateStr(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  /// Load completed indices for [domain] (default `workout`) from API.
  /// Returns `null` when the request fails or the payload is unusable (no client-side defaults).
  Future<Set<int>?> loadCompleted(
    DateTime date, {
    String domain = 'workout',
  }) async {
    final result = await loadCompletedExercises(date, domain: domain);
    if (result == null) return null;
    final raw = result['completed_indices'];
    if (raw is! List) return null;
    return raw
        .map((e) => e is int ? e : int.tryParse(e?.toString() ?? ''))
        .whereType<int>()
        .where((i) => i >= 0)
        .toSet();
  }

  /// GET completed-exercises for [date] and [domain].
  /// Returns `null` on non-success or invalid body (no fabricated empty map).
  Future<Map<String, dynamic>?> loadCompletedExercises(
    DateTime date, {
    String domain = 'workout',
  }) async {
    final dateStr = _dateStr(date);
    final endpoint = ApiEndpoints.domainsCompletedExercises(domain);
    final response = await ApiServices.get(
      endpoint,
      queryParams: {'date': dateStr},
    );

    if (response.success && response.data is Map) {
      try {
        final data = Map<String, dynamic>.from(response.data as Map);
        final list = data['completed_indices'];
        if (list is List) {
          final set = list
              .map((e) => e is int ? e : int.tryParse(e?.toString() ?? ''))
              .whereType<int>()
              .where((i) => i >= 0)
              .toSet();
          if (kDebugMode) {
            debugPrint(
              '[RoutineCompletion] domain=$domain loaded from API: $set for $dateStr',
            );
          }
          data['completed_indices'] = set.toList();
          return data;
        }
      } catch (_) {}
    }

    if (kDebugMode) {
      debugPrint(
        '[RoutineCompletion] domain=$domain API load failed (${response.statusCode})',
      );
    }
    return null;
  }

  /// Save completed indices for [domain] (PUT `domains/{domain}/completed-exercises`).
  Future<bool> saveCompleted(
    DateTime date,
    Set<int> indices, {
    String domain = 'workout',
    int? totalExercises,
  }) async {
    final dateStr = _dateStr(date);

    final body = <String, dynamic>{
      'date': dateStr,
      'completed_indices': indices.toList()..sort(),
      'total_exercises': totalExercises ?? 0,
    };
    final endpoint = ApiEndpoints.domainsCompletedExercises(domain);
    final response = await ApiServices.put(endpoint, body: body);

    if (response.success) {
      if (kDebugMode) {
        debugPrint(
          '[RoutineCompletion] domain=$domain saved to API: $indices for $dateStr',
        );
      }
      return true;
    }

    if (kDebugMode) {
      debugPrint(
        '[RoutineCompletion] domain=$domain API save failed (${response.statusCode})',
      );
    }
    return false;
  }

  /// GET weekly-summary. Returns map on success; `null` on failure (no empty stub).
  Future<Map<String, dynamic>?> getWeeklySummary() async {
    final response = await ApiServices.get(ApiEndpoints.workoutWeeklySummary);
    if (response.success && response.data is Map) {
      return Map<String, dynamic>.from(response.data as Map);
    }
    if (kDebugMode) {
      debugPrint(
        '[WorkoutCompletion] weekly-summary failed '
        'statusCode=${response.statusCode} message=${response.message}',
      );
    }
    return null;
  }
}
