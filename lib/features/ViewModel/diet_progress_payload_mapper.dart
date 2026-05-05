class DietProgressParsedData {
  const DietProgressParsedData({
    required this.flowDomain,
    required this.subtitle,
    required this.topStats,
    required this.miniBars,
    required this.mainConsistency,
    required this.insightText,
    required this.checkBoxName,
    required this.selectedChecklist,
  });

  final String flowDomain;
  final String subtitle;
  final List<Map<String, dynamic>> topStats;
  final List<Map<String, dynamic>> miniBars;
  final Map<String, dynamic> mainConsistency;
  final String insightText;
  final List<String> checkBoxName;
  final List<bool> selectedChecklist;
}

class DietProgressPayloadMapper {
  static String detectDomain(Map<String, dynamic> payload) {
    final progressRaw = payload['progress'];
    if (progressRaw is Map) {
      final d = (progressRaw['domain']?.toString() ?? '').trim().toLowerCase();
      if (d.isNotEmpty) return d;
    }
    final d = (payload['domain']?.toString() ?? '').trim().toLowerCase();
    return d.isEmpty ? 'diet' : d;
  }

  static DietProgressParsedData parse({
    required Map<String, dynamic> payload,
    required String currentSubtitle,
    required List<Map<String, dynamic>> currentTopStats,
    required List<Map<String, dynamic>> currentMiniBars,
    required Map<String, dynamic> currentMainConsistency,
    required String currentInsightText,
    required List<String> currentCheckBoxName,
    required List<bool> currentSelectedChecklist,
  }) {
    var subtitle = currentSubtitle;
    var topStats = List<Map<String, dynamic>>.from(currentTopStats);
    var miniBars = List<Map<String, dynamic>>.from(currentMiniBars);
    var mainConsistency = Map<String, dynamic>.from(currentMainConsistency);
    var insightText = currentInsightText;
    var checkBoxName = List<String>.from(currentCheckBoxName);
    var selectedChecklist = List<bool>.from(currentSelectedChecklist);

    final flowDomain = detectDomain(payload);
    final psRaw = payload['progress_screen'];
    if (psRaw is Map) {
      final ps = Map<String, dynamic>.from(psRaw);
      subtitle = (ps['subtitle']?.toString() ?? '').trim();

      final statsRaw = ps['top_stats'];
      if (statsRaw is List) {
        topStats = statsRaw
            .whereType<Map>()
            .map((e) => Map<String, dynamic>.from(e))
            .toList();
      }

      final barsRaw = ps['mini_bars'];
      if (barsRaw is List) {
        miniBars = barsRaw
            .whereType<Map>()
            .map((e) => Map<String, dynamic>.from(e))
            .toList();
      }

      final mcRaw = ps['main_consistency'];
      if (mcRaw is Map) {
        mainConsistency = Map<String, dynamic>.from(mcRaw);
      }

      final insight = (ps['insight_text']?.toString() ?? '').trim();
      if (insight.isNotEmpty) insightText = insight;

      final checklistRaw = ps['daily_recovery_checklist'];
      if (checklistRaw is List && checklistRaw.isNotEmpty) {
        final titles = <String>[];
        final checks = <bool>[];
        for (final row in checklistRaw) {
          if (row is! Map) continue;
          final m = Map<String, dynamic>.from(row);
          final title = (m['title']?.toString() ?? '').trim();
          if (title.isEmpty) continue;
          titles.add(title);
          checks.add(m['completed'] == true);
        }
        if (titles.isNotEmpty) {
          checkBoxName = titles;
          selectedChecklist = checks;
        }
      }
    }

    final summaryRaw = payload['ai_summary'];
    final summary = summaryRaw is Map
        ? Map<String, dynamic>.from(summaryRaw)
        : <String, dynamic>{};
    if (subtitle.trim().isEmpty) {
      subtitle = (summary['subtitle']?.toString() ?? '').trim();
    }

    final progressRaw = payload['progress'];
    final progress = progressRaw is Map
        ? Map<String, dynamic>.from(progressRaw)
        : <String, dynamic>{};
    final total = _toInt(progress['total'], fallback: 0);
    final answered = _toInt(progress['answered'], fallback: 0);
    final percent = _toDouble(
      progress['progress_percent'],
      fallback: total > 0 ? (answered * 100.0) / total : 0,
    );
    if (topStats.isEmpty && progress.isNotEmpty) {
      topStats = [
        {'value': '$answered/$total', 'label': 'Answered'},
        {'value': '${percent.toStringAsFixed(0)}%', 'label': 'Completion'},
        {
          'value': (payload['subscription_status']?.toString() ?? '-').toUpperCase(),
          'label': 'Subscription',
        },
      ];
    }
    if (miniBars.isEmpty && progress.isNotEmpty) {
      miniBars = [
        {'title': 'Answered', 'percent': total > 0 ? answered / total : 0},
        {'title': 'Progress', 'percent': percent / 100.0},
      ];
    }
    if (mainConsistency.isEmpty && progress.isNotEmpty) {
      mainConsistency = {
        'title': 'Flow Completion',
        'subtitle': '$answered of $total questions answered',
        'percent': percent,
      };
    }
    if (insightText.trim().isEmpty) {
      insightText = (payload['ai_message']?.toString() ?? '').trim();
    }
    if (insightText.isEmpty) {
      final insights = summary['analyzing_insights'];
      if (insights is List && insights.isNotEmpty) {
        insightText = (insights.first?.toString() ?? '').trim();
      }
    }

    if (checkBoxName.isEmpty) {
      final dailyRaw = payload['daily_plan'];
      if (dailyRaw is Map) {
        final daily = Map<String, dynamic>.from(dailyRaw);
        final weeklyRaw = daily['weekly_plan'];
        if (weeklyRaw is List && weeklyRaw.isNotEmpty) {
          final titles = <String>[];
          for (final row in weeklyRaw) {
            if (row is! Map) continue;
            final m = Map<String, dynamic>.from(row);
            final day = (m['day']?.toString() ?? '').trim();
            final theme = (m['theme']?.toString() ?? '').trim();
            final title = [day, theme].where((e) => e.isNotEmpty).join(' • ');
            if (title.isNotEmpty) titles.add(title);
          }
          if (titles.isNotEmpty) {
            checkBoxName = titles;
            selectedChecklist = List<bool>.filled(titles.length, false);
          }
        }

        if (checkBoxName.isEmpty) {
          final morning = daily['morning'];
          final evening = daily['evening'];
          final titles = <String>[];
          if (morning is List) {
            for (final row in morning) {
              if (row is! Map) continue;
              final t = (row['title']?.toString() ?? '').trim();
              if (t.isNotEmpty) titles.add(t);
            }
          }
          if (evening is List) {
            for (final row in evening) {
              if (row is! Map) continue;
              final t = (row['title']?.toString() ?? '').trim();
              if (t.isNotEmpty) titles.add(t);
            }
          }
          if (titles.isNotEmpty) {
            checkBoxName = titles;
            selectedChecklist = List<bool>.filled(titles.length, false);
          }
        }
      }
    }

    return DietProgressParsedData(
      flowDomain: flowDomain,
      subtitle: subtitle,
      topStats: topStats,
      miniBars: miniBars,
      mainConsistency: mainConsistency,
      insightText: insightText,
      checkBoxName: checkBoxName,
      selectedChecklist: selectedChecklist,
    );
  }

  static int _toInt(dynamic raw, {required int fallback}) {
    if (raw is int) return raw;
    if (raw is num) return raw.toInt();
    if (raw is String) return int.tryParse(raw.trim()) ?? fallback;
    return fallback;
  }

  static double _toDouble(dynamic raw, {required double fallback}) {
    if (raw is double) return raw;
    if (raw is num) return raw.toDouble();
    if (raw is String) return double.tryParse(raw.trim()) ?? fallback;
    return fallback;
  }
}
