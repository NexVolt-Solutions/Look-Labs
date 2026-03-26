import 'package:flutter/foundation.dart';

/// Morning + evening exercise rows for height domain (`ai_exercises` shape).
@immutable
class HeightRoutineLists {
  const HeightRoutineLists({
    required this.morning,
    required this.evening,
  });

  final List<Map<String, dynamic>> morning;
  final List<Map<String, dynamic>> evening;

  int get totalCount => morning.length + evening.length;

  /// Rough total minutes from digits in each row’s `activity` string.
  int get estimatedMinutesFromActivity {
    var minutes = 0;
    for (final item in [...morning, ...evening]) {
      final a = item['activity']?.toString() ?? '';
      final match = RegExp(r'(\d+)').firstMatch(a);
      if (match != null) {
        minutes += int.tryParse(match.group(1)!) ?? 0;
      }
    }
    return minutes;
  }
}
