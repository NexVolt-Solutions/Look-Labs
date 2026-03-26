import 'package:looklabs/Core/Network/models/height_routine_lists.dart';
import 'package:looklabs/Repository/height_routine_repository.dart';

/// Read-only UI fields derived from height flow `resultData` (ai_attributes, ai_message).
class HeightFlowUiData {
  const HeightFlowUiData({
    required this.currentHeightRaw,
    required this.goalHeightRaw,
    required this.richNumberPart,
    required this.richUnitPart,
    required this.progressPercent,
    required this.bmiStatus,
    required this.insightText,
    required this.dailyRoutineSubtitle,
    required this.routineExerciseCount,
    required this.routineEstimatedMinutes,
  });

  final String currentHeightRaw;
  final String goalHeightRaw;
  final String richNumberPart;
  final String richUnitPart;
  final double progressPercent;
  final String bmiStatus;
  final String insightText;
  final String dailyRoutineSubtitle;
  final int routineExerciseCount;
  final int routineEstimatedMinutes;

  static const String _fallbackInsight =
      'Consistency improves stamina, strength & posture over time.';
  static const String _fallbackDailySubtitle =
      'Stretches and posture work from your height plan.';

  static Map<String, dynamic>? _attrs(Map<String, dynamic>? data) {
    if (data == null) return null;
    final a = data['ai_attributes'];
    if (a is Map) return Map<String, dynamic>.from(a);
    return null;
  }

  static String _attr(Map<String, dynamic>? attrs, String key, String fallback) {
    if (attrs == null) return fallback;
    final v = attrs[key];
    if (v == null) return fallback;
    final s = v.toString().trim();
    return s.isEmpty ? fallback : s;
  }

  static String _currentHeightRaw(Map<String, dynamic>? data) {
    final v = _attrs(data)?['current_height']?.toString().trim();
    if (v != null && v.isNotEmpty) return v;
    if (data != null) return '—';
    return '213 cm';
  }

  static String _goalHeightRaw(Map<String, dynamic>? data) {
    final v = _attrs(data)?['goal_height']?.toString().trim();
    if (v != null && v.isNotEmpty) return v;
    if (data != null) return '—';
    return '211 cm';
  }

  static (String, String) splitHeightRich(String raw) {
    final s = raw.trim();
    final m = RegExp(r'^([\d.]+)\s*(.*)$').firstMatch(s);
    if (m != null) {
      final u = m.group(2)!.trim();
      return (m.group(1)!, u.isEmpty ? 'cm' : u);
    }
    return (s, '');
  }

  static double progressPercentFrom(Map<String, dynamic>? data) {
    final attrs = _attrs(data);
    if (attrs != null) {
      for (final key in [
        'progress_percent',
        'journey_progress',
        'height_progress',
      ]) {
        final v = attrs[key];
        if (v is num) return v.toDouble().clamp(0, 100);
      }
      final gp = attrs['growth_potential']?.toString().toLowerCase() ?? '';
      if (gp.contains('high')) return 65;
      if (gp.contains('low')) return 28;
      if (gp.contains('moderate')) return 45;
    }
    return 40;
  }

  static String insightFrom(Map<String, dynamic>? data) {
    if (data == null) return _fallbackInsight;
    final msg = data['ai_message']?.toString().trim();
    if (msg != null && msg.isNotEmpty) return msg;
    return _fallbackInsight;
  }

  static String dailySubtitleFrom(Map<String, dynamic>? data) {
    final msg = data?['ai_message']?.toString().trim();
    if (msg != null && msg.isNotEmpty) return msg;
    return _fallbackDailySubtitle;
  }

  /// Full binding for result screen: [resultData] + parsed [lists] for stats tile.
  factory HeightFlowUiData.fromResult(
    Map<String, dynamic>? resultData,
    HeightRoutineLists lists,
  ) {
    final current = _currentHeightRaw(resultData);
    final (richNum, richUnit) = splitHeightRich(current);
    return HeightFlowUiData(
      currentHeightRaw: current,
      goalHeightRaw: _goalHeightRaw(resultData),
      richNumberPart: richNum,
      richUnitPart: richUnit,
      progressPercent: progressPercentFrom(resultData),
      bmiStatus: _attr(_attrs(resultData), 'bmi_status', 'Normal'),
      insightText: insightFrom(resultData),
      dailyRoutineSubtitle: dailySubtitleFrom(resultData),
      routineExerciseCount: lists.totalCount,
      routineEstimatedMinutes: lists.estimatedMinutesFromActivity,
    );
  }

  static ({int count, int minutes}) routineStats(HeightRoutineLists lists) {
    return (
      count: lists.totalCount,
      minutes: lists.estimatedMinutesFromActivity,
    );
  }

  static Map<String, dynamic>? dailyRoutineArguments(
    Map<String, dynamic>? resultData,
    HeightRoutineLists lists,
  ) {
    if (resultData != null) {
      return Map<String, dynamic>.from(resultData);
    }
    return HeightRoutineRepository.dailyRoutinePayloadFromLists(lists);
  }
}
