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
  Future<Set<int>> loadCompleted(
    DateTime date, {
    String domain = 'workout',
  }) async {
    final result = await loadCompletedExercises(date, domain: domain);
    return result['completed_indices'] is List
        ? (result['completed_indices'] as List)
              .map((e) => e is int ? e : int.tryParse(e?.toString() ?? ''))
              .whereType<int>()
              .where((i) => i >= 0)
              .toSet()
        : <int>{};
  }

  /// GET completed-exercises for [date] and [domain].
  Future<Map<String, dynamic>> loadCompletedExercises(
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
    return {
      'date': dateStr,
      'completed_indices': <int>[],
      'total_exercises': 0,
      'score': 0.0,
    };
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

  /// GET weekly-summary. Returns { user_id, week_average, days: [{ date, score, completed, total }] } or empty map.
  Future<Map<String, dynamic>> getWeeklySummary() async {
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
    return {};
  }
}
