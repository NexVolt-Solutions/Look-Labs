import 'package:flutter/foundation.dart';
import 'package:looklabs/Core/Network/api_services.dart';
import 'package:looklabs/Core/Network/api_endpoints.dart';

/// Fetches/saves completed exercise indices (and optional recovery checklist indices) via API.
class WorkoutCompletionRepository {
  WorkoutCompletionRepository._();

  static final WorkoutCompletionRepository _instance =
      WorkoutCompletionRepository._();
  static WorkoutCompletionRepository get instance => _instance;

  static String _dateStr(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  static Set<int> _parseIndexSet(dynamic raw) {
    if (raw is! List) return {};
    return raw
        .map((e) => e is int ? e : int.tryParse(e?.toString() ?? ''))
        .whereType<int>()
        .where((i) => i >= 0)
        .toSet();
  }

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
          data['completed_indices'] = set.toList()..sort();
          final recovery = _parseIndexSet(data['recovery_completed_indices']);
          if (recovery.isNotEmpty ||
              data.containsKey('recovery_completed_indices')) {
            data['recovery_completed_indices'] = recovery.toList()..sort();
          }
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

  /// Persists completion for [date]. For domain `workout`, [completed_indices] are **exercise**
  /// positions in the generated plan; [recoveryCompletedIndices] are indices into
  /// `ai_progress.recovery_checklist` — separate concepts, same document in API.
  Future<bool> saveCompleted(
    DateTime date,
    Set<int> indices, {
    String domain = 'workout',
    int? totalExercises,
    Set<int>? recoveryCompletedIndices,
  }) async {
    final dateStr = _dateStr(date);
    final d = domain.toLowerCase().trim();

    final body = <String, dynamic>{
      'date': dateStr,
      'completed_indices': indices.toList()..sort(),
      'total_exercises': totalExercises ?? 0,
    };
    // Workout: always send both dimensions so the server never treats a missing key as ambiguous.
    if (d == 'workout') {
      body['recovery_completed_indices'] =
          (recoveryCompletedIndices ?? <int>{}).toList()..sort();
    } else if (recoveryCompletedIndices != null) {
      body['recovery_completed_indices'] = recoveryCompletedIndices.toList()
        ..sort();
    }
    final endpoint = ApiEndpoints.domainsCompletedExercises(domain);
    final response = await ApiServices.put(endpoint, body: body);

    if (response.success) {
      if (kDebugMode) {
        debugPrint(
          '[RoutineCompletion] domain=$domain saved to API: exercises=$indices '
          '${d == 'workout' ? 'recovery=${body['recovery_completed_indices']} ' : (recoveryCompletedIndices != null ? 'recovery=$recoveryCompletedIndices ' : '')}'
          'for $dateStr',
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
