import 'package:looklabs/Core/Network/models/height_routine_lists.dart';
import 'package:looklabs/Core/Network/models/workout_result_response.dart';

/// Parses height domain flow JSON into routine lists and navigation payloads.
class HeightRoutineRepository {
  HeightRoutineRepository._();

  static final List<Map<String, dynamic>> _defaultRoutineList = [
    {
      'time': 'Neck Stretches',
      'activity': '3 min',
      'details': 'Tilt head left & right for 10 seconds',
      'steps': <String>[],
    },
    {
      'time': 'Spine Alignment',
      'activity': '5 min',
      'details': 'Sit straight and stretch your spine',
      'steps': <String>[],
    },
  ];

  static List<Map<String, dynamic>> _copyDefaults() =>
      List<Map<String, dynamic>>.from(
        _defaultRoutineList.map((e) => Map<String, dynamic>.from(e)),
      );

  static Map<String, dynamic> _rowFromExercise(WorkoutExercise e) {
    return {
      'seq': e.seq,
      'time': e.title,
      'activity': e.duration,
      'details': e.steps.isNotEmpty
          ? e.steps.map((s) => '• $s').join('\n')
          : '',
      'steps': List<String>.from(e.steps),
    };
  }

  /// Build morning/evening lists from domain completion payload (`ai_exercises`, etc.).
  /// When [data] is null: use placeholder defaults on the **result** screen only;
  /// for daily routine pass [defaultsWhenDataNull]: false to get empty lists.
  static HeightRoutineLists parseRoutineLists(
    Map<String, dynamic>? data, {
    bool defaultsWhenDataNull = true,
  }) {
    if (data == null) {
      if (!defaultsWhenDataNull) {
        return const HeightRoutineLists(morning: [], evening: []);
      }
      return HeightRoutineLists(morning: _copyDefaults(), evening: []);
    }

    final raw = data['ai_exercises'];
    if (raw is Map) {
      try {
        final ex = WorkoutAiExercises.fromJson(
          Map<String, dynamic>.from(raw),
        );
        if (ex.morning.isNotEmpty || ex.evening.isNotEmpty) {
          return HeightRoutineLists(
            morning: ex.morning.map(_rowFromExercise).toList(),
            evening: ex.evening.map(_rowFromExercise).toList(),
          );
        }
      } catch (_) {}
    }

    final flat = parseAiExercisesFlattenUnknownBuckets(raw);
    if (flat.isNotEmpty) {
      return HeightRoutineLists(morning: flat, evening: []);
    }

    return HeightRoutineLists(morning: _copyDefaults(), evening: []);
  }

  static List<Map<String, dynamic>> parseAiExercisesFlattenUnknownBuckets(
    dynamic raw,
  ) {
    if (raw is! Map) return [];
    final out = <Map<String, dynamic>>[];
    for (final entry in raw.entries) {
      final key = entry.key.toString().toLowerCase();
      if (key == 'morning' || key == 'evening') continue;
      final value = entry.value;
      if (value is! List) continue;
      for (final e in value) {
        if (e is! Map) continue;
        final m = Map<String, dynamic>.from(e);
        final title = m['title']?.toString() ?? '';
        final duration = m['duration']?.toString().trim() ?? '';
        final stepsRaw = m['steps'];
        final steps = <String>[];
        if (stepsRaw is List) {
          for (final s in stepsRaw) {
            final t = s?.toString().trim() ?? '';
            if (t.isNotEmpty) steps.add(t);
          }
        }
        final details = steps.isEmpty
            ? (m['details']?.toString() ?? '')
            : steps.join('\n');
        out.add({
          'seq': m['seq'],
          'time': title,
          'activity': duration.isEmpty ? 'Exercise' : duration,
          'details': details,
          'steps': steps,
        });
      }
    }
    return out;
  }

  static List<Map<String, dynamic>> rowsToApiExerciseMaps(
    List<Map<String, dynamic>> rows,
  ) {
    return rows.map((row) {
      final steps = row['steps'];
      final stepsList = steps is List
          ? steps.map((s) => s.toString()).toList()
          : <String>[];
      return {
        'title': row['time']?.toString() ?? row['title']?.toString() ?? '',
        'duration':
            row['activity']?.toString() ?? row['duration']?.toString() ?? '',
        'steps': stepsList,
        'seq': row['seq'] is int
            ? row['seq'] as int
            : int.tryParse(row['seq']?.toString() ?? '0') ?? 0,
      };
    }).toList();
  }

  static Map<String, dynamic> dailyRoutinePayloadFromLists(
    HeightRoutineLists lists,
  ) {
    return {
      'ai_exercises': {
        'morning': rowsToApiExerciseMaps(lists.morning),
        'evening': rowsToApiExerciseMaps(lists.evening),
      },
    };
  }
}
