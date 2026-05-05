part of 'daily_skin_care_routine_view_model.dart';

List<Map<String, String>> _exercisesToRoutineItems(List<WorkoutExercise> list) {
  return list
      .map(
        (e) => {
          'title': e.title,
          'subtitle': e.steps.isNotEmpty ? e.steps.map((s) => '• $s').join('\n') : e.duration,
        },
      )
      .where((m) => (m['title'] ?? '').toString().trim().isNotEmpty)
      .toList();
}

List<Map<String, String>> _parseRoutineList(dynamic raw) {
  if (raw is! List) return [];
  final out = <Map<String, String>>[];
  for (final e in raw) {
    if (e is! Map) continue;
    final m = Map<String, dynamic>.from(e);
    final title = (m['title'] ?? m['name'] ?? '').toString().trim();
    if (title.isEmpty) continue;
    final steps = m['steps'];
    var subtitle = (m['description'] ?? m['details'] ?? '').toString().trim();
    if (subtitle.isEmpty && steps is List) {
      subtitle = steps.map((s) => '• $s').join('\n');
    }
    if (subtitle.isEmpty) {
      subtitle = (m['duration'] ?? '').toString().trim();
    }
    out.add({'title': title, 'subtitle': subtitle});
  }
  return out;
}

List<Map<String, dynamic>> _attrsToGridRows(Map<String, dynamic> attrs) {
  final rows = <Map<String, dynamic>>[];
  attrs.forEach((key, value) {
    final k = key.toString();
    if (k == 'title') return;
    if (value is Map) {
      Map<String, dynamic>.from(value).forEach((k2, v2) {
        final row = <String, dynamic>{
          'title': '${_humanize(k)} · ${_humanize(k2.toString())}',
          'subTitle': v2?.toString() ?? '',
        };
        _attachProgressFromValue(row, v2);
        rows.add(row);
      });
      return;
    }
    if (value is List) {
      final text = value.map((e) => e.toString()).where((s) => s.isNotEmpty).join(', ');
      if (text.isEmpty) return;
      final row = <String, dynamic>{'title': _humanize(k), 'subTitle': text};
      _attachProgressFromValue(row, value);
      rows.add(row);
      return;
    }
    final row = <String, dynamic>{'title': _humanize(k), 'subTitle': value?.toString() ?? ''};
    _attachProgressFromValue(row, value);
    rows.add(row);
  });
  return rows;
}

void _attachProgressFromValue(Map<String, dynamic> row, dynamic value) {
  final p = _progressFromApiValue(value);
  if (p != null) {
    row['progress'] = p;
    row['pers'] = _percentLabelForProgress(p, value);
  }
}

double? _progressFromApiValue(dynamic v) {
  if (v is num) {
    final n = v.toDouble();
    if (n >= 0 && n <= 100) return n;
    return null;
  }
  final s = v?.toString().trim() ?? '';
  if (s.isEmpty) return null;
  final m = RegExp(r'(\d{1,3})\s*%').firstMatch(s);
  if (m != null) return double.tryParse(m.group(1)!);
  return null;
}

String _percentLabelForProgress(double p, dynamic original) {
  if (original is num) return '${p.round()}%';
  final s = original?.toString().trim() ?? '';
  if (s.contains('%')) return s;
  return '${p.round()}%';
}

String _humanize(String key) {
  if (key.isEmpty) return key;
  return key
      .split(RegExp(r'[_\s]+'))
      .where((p) => p.isNotEmpty)
      .map((w) => w.length == 1 ? w.toUpperCase() : '${w[0].toUpperCase()}${w.substring(1).toLowerCase()}')
      .join(' ');
}
