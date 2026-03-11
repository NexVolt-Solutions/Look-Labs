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
  Future<ApiResponse> generateWorkoutPlan({
    Map<String, dynamic>? workoutData,
  }) async {
    final params = workoutData != null
        ? planParamsFromWorkoutData(workoutData)
        : <String, dynamic>{
            'focus': 'strength',
            'intensity': 'moderate',
            'activity_level': 'moderate',
            'duration_minutes': 30,
          };

    final body = <String, dynamic>{
      'focus': (params['focus'] ?? 'strength').toString(),
      'intensity': (params['intensity'] ?? 'moderate').toString(),
      'activity_level': (params['activity_level'] ?? 'moderate').toString(),
      'duration_minutes': params['duration_minutes'] is int
          ? params['duration_minutes'] as int
          : int.tryParse(params['duration_minutes']?.toString() ?? '30') ?? 30,
    };

    final endpoint = ApiEndpoints.domainsGeneratePlan('workout');
    final response = await ApiServices.post(endpoint, body: body);

    if (kDebugMode) {
      debugPrint(
        '[WorkoutRepository] generate-plan statusCode=${response.statusCode}, success=${response.success}',
      );
    }

    return response;
  }

  /// Build plan params from workout API response (ai_attributes).
  static Map<String, dynamic> planParamsFromWorkoutData(
    Map<String, dynamic> workoutData,
  ) {
    try {
      final result = WorkoutResultResponse.fromJson(workoutData);
      final a = result.aiAttributes;
      final focus = a?.todayFocus.isNotEmpty == true
          ? a!.todayFocus.first.toLowerCase().trim()
          : 'strength';
      final intensity =
          (a?.intensity ?? 'moderate').toString().toLowerCase().trim();
      final activity =
          (a?.activity ?? 'moderate').toString().toLowerCase().trim();
      final duration = a?.workoutSummary?.totalDurationMin ?? 30;

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
