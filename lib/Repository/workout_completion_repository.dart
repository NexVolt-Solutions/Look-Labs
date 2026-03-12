import 'package:flutter/foundation.dart';
import 'package:looklabs/Core/Network/api_services.dart';
import 'package:looklabs/Core/Network/api_endpoints.dart';
import 'package:looklabs/Repository/workout_completion_storage.dart';

/// Fetches/saves completed exercise indices via API. Falls back to local storage when API fails.
class WorkoutCompletionRepository {
  WorkoutCompletionRepository._();

  static final WorkoutCompletionRepository _instance =
      WorkoutCompletionRepository._();
  static WorkoutCompletionRepository get instance => _instance;

  static String _dateStr(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  /// Load completed indices. Tries API first; falls back to local storage.
  Future<Set<int>> loadCompleted(DateTime date) async {
    final result = await loadCompletedExercises(date);
    return result['completed_indices'] is List
        ? (result['completed_indices'] as List)
            .map((e) => e is int ? e : int.tryParse(e?.toString() ?? ''))
            .whereType<int>()
            .where((i) => i >= 0)
            .toSet()
        : await _loadFromLocal(date);
  }

  /// GET completed-exercises for [date]. Returns raw API map (date, completed_indices, total_exercises, score) or empty map on failure.
  Future<Map<String, dynamic>> loadCompletedExercises(DateTime date) async {
    final dateStr = _dateStr(date);
    final response = await ApiServices.get(
      ApiEndpoints.workoutCompletedExercises,
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
              '[WorkoutCompletion] loaded from API: $set for $dateStr',
            );
          }
          data['completed_indices'] = set.toList();
          return data;
        }
      } catch (_) {}
    }

    if (kDebugMode && response.statusCode != 404) {
      debugPrint(
        '[WorkoutCompletion] API failed (${response.statusCode}), using local storage',
      );
    }
    final localSet = await _loadFromLocal(date);
    return {
      'date': dateStr,
      'completed_indices': localSet.toList(),
      'total_exercises': 0,
      'score': 0.0,
    };
  }

  /// Save completed indices. Body includes date, completed_indices, total_exercises (required by API).
  Future<bool> saveCompleted(
    DateTime date,
    Set<int> indices, {
    int? totalExercises,
  }) async {
    final dateStr = _dateStr(date);
    await WorkoutCompletionStorage.saveCompletedForDate(date, indices);

    final body = <String, dynamic>{
      'date': dateStr,
      'completed_indices': indices.toList()..sort(),
      'total_exercises': totalExercises ?? 0,
    };
    final response = await ApiServices.put(
      ApiEndpoints.workoutCompletedExercisesSave,
      body: body,
    );

    if (response.success) {
      if (kDebugMode) {
        debugPrint(
          '[WorkoutCompletion] saved to API: $indices for $dateStr',
        );
      }
      return true;
    }

    if (kDebugMode) {
      debugPrint(
        '[WorkoutCompletion] API save failed (${response.statusCode}), local storage updated',
      );
    }
    return false;
  }

  /// GET weekly-summary. Returns { user_id, week_average, days: [{ date, score, completed, total }] } or empty map.
  Future<Map<String, dynamic>> getWeeklySummary() async {
    final response = await ApiServices.get(
      ApiEndpoints.workoutWeeklySummary,
    );
    if (response.success && response.data is Map) {
      return Map<String, dynamic>.from(response.data as Map);
    }
    return {};
  }

  Future<Set<int>> _loadFromLocal(DateTime date) async {
    return WorkoutCompletionStorage.loadCompletedForDate(date);
  }
}
