import 'package:flutter/foundation.dart';
import 'package:looklabs/Core/Network/api_response.dart';
import 'package:looklabs/Core/Network/api_services.dart';
import 'package:looklabs/Core/Network/api_endpoints.dart';
import 'package:looklabs/Core/Network/models/workout_result_response.dart';

/// Repository for workout domain APIs (generate-plan, etc.).
class WorkoutRepository {
  WorkoutRepository._();

  static final WorkoutRepository _instance = WorkoutRepository._();
  static WorkoutRepository get instance => _instance;

  /// POST domains/workout/generate-plan – generate workout plan.
  /// Body: focus, intensity, activity_level, duration_minutes.
  /// Pass [workoutData] to derive params from ai_attributes, or use defaults.
  /// Overrides from UI selection: [focusOverride], [intensityOverride], [activityOverride].
  Future<ApiResponse> generateWorkoutPlan({
    Map<String, dynamic>? workoutData,
    String? focusOverride,
    String? intensityOverride,
    String? activityOverride,
  }) async {
    var params = workoutData != null
        ? planParamsFromWorkoutData(workoutData)
        : <String, dynamic>{
            'focus': 'strength',
            'intensity': 'moderate',
            'activity_level': 'moderate',
            'duration_minutes': 30,
          };
    if (focusOverride != null && focusOverride.trim().isNotEmpty) {
      params = {...params, 'focus': _normalizeFocus(focusOverride)};
    }
    if (intensityOverride != null && intensityOverride.trim().isNotEmpty) {
      params = {...params, 'intensity': intensityOverride.trim()};
    }
    if (activityOverride != null && activityOverride.trim().isNotEmpty) {
      params = {...params, 'activity_level': activityOverride.trim()};
    }

    final body = <String, dynamic>{
      'focus': (params['focus'] ?? 'strength').toString(),
      'intensity': (params['intensity'] ?? 'moderate').toString(),
      'activity_level': (params['activity_level'] ?? 'moderate').toString(),
      'duration_minutes': params['duration_minutes'] is int
          ? params['duration_minutes'] as int
          : int.tryParse(params['duration_minutes']?.toString() ?? '30') ?? 30,
    };

    if (kDebugMode) {
      debugPrint('[WorkoutRepository] generate-plan request body: $body');
    }

    final endpoint = ApiEndpoints.domainsGeneratePlan('workout');
    final response = await ApiServices.post(endpoint, body: body);

    if (kDebugMode) {
      debugPrint(
        '[WorkoutRepository] generate-plan statusCode=${response.statusCode}, success=${response.success}',
      );
    }

    return response;
  }

  /// Generate-plan API expects: 'flexibility' | 'build_muscle' | 'fatloss' | 'strength'.
  static const Set<String> _validFocus = {
    'flexibility',
    'build_muscle',
    'fatloss',
    'strength',
  };

  static String _normalizeFocus(String raw) {
    final t = raw.toLowerCase().trim().replaceAll(' ', '_');
    if (_validFocus.contains(t)) return t;
    if (t.contains('flex')) return 'flexibility';
    if (t.contains('build') || t.contains('muscle')) return 'build_muscle';
    if (t.contains('fat') || t.contains('endurance') || t.contains('loss')) {
      return 'fatloss';
    }
    return 'strength';
  }

  /// Build plan params from workout API response (ai_attributes).
  /// Maps today_focus ["Strength", "Fatloss"] → focus: "strength" (API expects lowercase).
  static Map<String, dynamic> planParamsFromWorkoutData(
    Map<String, dynamic> workoutData,
  ) {
    try {
      final result = WorkoutResultResponse.fromJson(workoutData);
      final a = result.aiAttributes;
      final focus = a?.todayFocus.isNotEmpty == true
          ? _normalizeFocus(a!.todayFocus.first)
          : 'strength';
      final intensity = (a?.intensity ?? 'Moderate').toString().trim();
      final activity = (a?.activity ?? 'Moderate').toString().trim();
      final duration = 30; // workout_summary removed; use default

      return {
        'focus': focus,
        'intensity': intensity,
        'activity_level': activity,
        'duration_minutes': duration,
      };
    } catch (_) {
      return {
        'focus': 'strength',
        'intensity': 'moderate',
        'activity_level': 'moderate',
        'duration_minutes': 30,
      };
    }
  }
}
