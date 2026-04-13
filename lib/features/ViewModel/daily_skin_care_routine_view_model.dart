import 'package:flutter/foundation.dart';
import 'package:looklabs/Core/Network/models/album_image.dart';
import 'package:looklabs/Core/Network/models/workout_result_response.dart'
    show WorkoutAiExercises, WorkoutExercise;
import 'package:looklabs/Repository/domain_questions_repository.dart';
import 'package:looklabs/Repository/image_upload_repository.dart';

/// One optional row under routines (from `ai_remedies` / `ai_products` on domain flow).
class SkincareRoutineExtraCard {
  const SkincareRoutineExtraCard({
    required this.title,
    required this.subtitle,
    required this.isRemediesNav,
  });

  final String title;
  final String subtitle;

  /// `true` → [RoutesName.SkinHomeRemediesScreen], `false` → [RoutesName.SkinTopProductScreen].
  final bool isRemediesNav;
}

class DailySkinCareRoutineViewModel extends ChangeNotifier {
  bool _loading = false;
  bool get loading => _loading;

  String? _loadError;
  String? get loadError => _loadError;

  String? _flowStatus;
  String? get flowStatus => _flowStatus;

  double? _flowProgressPercent;
  double? get flowProgressPercent => _flowProgressPercent;

  String? _flowProgressSummary;
  String? get flowProgressSummary => _flowProgressSummary;

  List<Map<String, String>> _scanTiles = [];
  List<Map<String, String>> get scanTiles => List.unmodifiable(_scanTiles);

  List<String> _indicatorSectionTitles = [];
  List<String> get indicatorSectionTitles =>
      List.unmodifiable(_indicatorSectionTitles);

  List<List<Map<String, dynamic>>> _indicatorPages = [];
  List<List<Map<String, dynamic>>> get indicatorPages => _indicatorPages;

  List<Map<String, String>> _todayRoutine = [];
  List<Map<String, String>> get todayRoutine =>
      List.unmodifiable(_todayRoutine);

  List<Map<String, String>> _nightRoutine = [];
  List<Map<String, String>> get nightRoutine =>
      List.unmodifiable(_nightRoutine);

  List<bool> _todayChecked = [];
  List<bool> get todayChecked => List.unmodifiable(_todayChecked);

  List<bool> _nightChecked = [];
  List<bool> get nightChecked => List.unmodifiable(_nightChecked);

  String? _aiMessage;
  String? get aiMessage => _aiMessage;

  bool get hasIndicatorGrid => _indicatorPages.any((page) => page.isNotEmpty);

  /// Optional heading for the concerns gauge (from `ai_concerns.title` when present).
  String? _concernsMeterHeading;
  String? get concernsMeterHeading => _concernsMeterHeading;

  List<SkincareRoutineExtraCard> _extraCards = [];
  List<SkincareRoutineExtraCard> get extraCards =>
      List.unmodifiable(_extraCards);

  int _selectedExtraIndex = -1;
  int get selectedExtraIndex => _selectedExtraIndex;

  static const List<String> _slotViews = ['front', 'back', 'right', 'left'];

  Future<void> loadSkincareRoutine() async {
    if (_loading) return;
    _loading = true;
    _loadError = null;
    notifyListeners();

    try {
      _resetPresentationState();

      final albumRes = await ImageUploadRepository.instance.getAlbumImages(
        domain: 'skincare',
      );
      if (albumRes.success && albumRes.data is List<AlbumImage>) {
        _applyAlbumScans(albumRes.data as List<AlbumImage>);
      }

      final flowRes = await DomainQuestionsRepository.instance.getDomainFlow(
        'skincare',
      );
      if (flowRes.success && flowRes.data is Map) {
        final map = Map<String, dynamic>.from(flowRes.data as Map);
        if (kDebugMode) {
          debugPrint(
            '[SkincareRoutine] flow status=${map['status']} keys=${map.keys.join(", ")}',
          );
        }
        _applyFlowMap(map);
      } else {
        _loadError = flowRes.message ?? 'Could not load domain flow.';
      }
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  void _resetPresentationState() {
    _flowStatus = null;
    _flowProgressPercent = null;
    _flowProgressSummary = null;
    _indicatorPages = [];
    _indicatorSectionTitles = [];
    _todayRoutine = [];
    _nightRoutine = [];
    _todayChecked = [];
    _nightChecked = [];
    _aiMessage = null;
    _scanTiles = [];
    _concernsMeterHeading = null;
    _extraCards = [];
    _selectedExtraIndex = -1;
  }

  void toggleTodayCheck(int index) {
    if (index < 0 || index >= _todayChecked.length) return;
    _todayChecked[index] = !_todayChecked[index];
    notifyListeners();
  }

  void toggleNightCheck(int index) {
    if (index < 0 || index >= _nightChecked.length) return;
    _nightChecked[index] = !_nightChecked[index];
    notifyListeners();
  }

  void selectExtraCard(int index) {
    if (index < 0 || index >= _extraCards.length) return;
    _selectedExtraIndex = index;
    notifyListeners();
  }

  void _applyFlowMap(Map<String, dynamic> data) {
    _flowStatus = data['status']?.toString();
    _parseFlowProgress(data['progress']);

    final msg = data['ai_message']?.toString().trim();
    _aiMessage = (msg != null && msg.isNotEmpty) ? msg : null;

    _applyIndicatorPages(data);
    _applyRoutines(data);
    _applyExtraCards(data);
  }

  void _applyIndicatorPages(Map<String, dynamic> data) {
    _indicatorPages = [];
    _indicatorSectionTitles = [];
    _concernsMeterHeading = null;

    final attrs = data['ai_attributes'];
    final health = data['ai_health'];
    final concerns = data['ai_concerns'];

    final sectioned =
        health is Map<String, dynamic> || concerns is Map<String, dynamic>;

    if (sectioned) {
      final keys = ['ai_attributes', 'ai_health', 'ai_concerns'];
      final pages = <List<Map<String, dynamic>>>[];
      final titles = <String>[];
      for (final key in keys) {
        final raw = data[key];
        if (raw is Map) {
          final m = Map<String, dynamic>.from(raw);
          titles.add(m['title']?.toString().trim() ?? '');
          pages.add(_attrsToGridRows(m));
        } else {
          titles.add('');
          pages.add([]);
        }
      }
      if (pages.any((p) => p.isNotEmpty)) {
        _indicatorPages = pages;
        _indicatorSectionTitles = titles;
        final c = data['ai_concerns'];
        if (c is Map) {
          final t = Map<String, dynamic>.from(c)['title']?.toString().trim();
          if (t != null && t.isNotEmpty) _concernsMeterHeading = t;
        }
      }
      return;
    }

    if (attrs is Map) {
      final m = Map<String, dynamic>.from(attrs);
      final title = m['title']?.toString().trim() ?? '';
      final rows = _attrsToGridRows(m);
      if (rows.isNotEmpty) {
        _indicatorPages = [rows];
        _indicatorSectionTitles = [title];
      }
    }
  }

  void _applyRoutines(Map<String, dynamic> data) {
    _todayRoutine = [];
    _nightRoutine = [];
    _todayChecked = [];
    _nightChecked = [];

    final routine = data['ai_routine'];
    if (routine is Map) {
      final r = Map<String, dynamic>.from(routine);
      var today = _parseRoutineList(r['today']);
      var night = _parseRoutineList(r['night']);
      if (today.isEmpty && night.isEmpty) {
        today = _parseRoutineList(r['morning']);
        night = _parseRoutineList(r['evening']);
      }
      if (today.isNotEmpty || night.isNotEmpty) {
        _setRoutineLists(today, night);
        return;
      }
    }

    final ex = data['ai_exercises'];
    if (ex is Map) {
      try {
        final parsed = WorkoutAiExercises.fromJson(
          Map<String, dynamic>.from(ex),
        );
        final today = _exercisesToRoutineItems(parsed.morning);
        final night = _exercisesToRoutineItems(parsed.evening);
        if (today.isNotEmpty || night.isNotEmpty) {
          _setRoutineLists(today, night);
        }
      } catch (_) {
        if (kDebugMode) {
          debugPrint('[SkincareRoutine] ai_exercises parse failed');
        }
      }
    }
  }

  void _setRoutineLists(
    List<Map<String, String>> today,
    List<Map<String, String>> night,
  ) {
    _todayRoutine = today;
    _nightRoutine = night;
    _todayChecked = List<bool>.filled(_todayRoutine.length, false);
    _nightChecked = List<bool>.filled(_nightRoutine.length, false);
  }

  void _applyExtraCards(Map<String, dynamic> data) {
    _extraCards = [];
    _selectedExtraIndex = -1;

    final remedies = data['ai_remedies'];
    if (remedies is Map && remedies.isNotEmpty) {
      final m = Map<String, dynamic>.from(remedies);
      final title = _firstNonEmptyString(m, const ['title', 'name']) ?? '';
      final subtitle =
          _firstNonEmptyString(m, const [
            'subtitle',
            'summary',
            'description',
          ]) ??
          '';
      if (title.isNotEmpty || subtitle.isNotEmpty) {
        _extraCards.add(
          SkincareRoutineExtraCard(
            title: title,
            subtitle: subtitle,
            isRemediesNav: true,
          ),
        );
      }
    }

    final products = data['ai_products'];
    if (products is List) {
      for (final raw in products) {
        if (raw is! Map) continue;
        final m = Map<String, dynamic>.from(raw);
        final title =
            _firstNonEmptyString(m, const ['name', 'title', 'product_name']) ??
            '';
        final subtitle =
            _firstNonEmptyString(m, const [
              'subtitle',
              'description',
              'brand',
            ]) ??
            '';
        if (title.isEmpty && subtitle.isEmpty) continue;
        _extraCards.add(
          SkincareRoutineExtraCard(
            title: title,
            subtitle: subtitle,
            isRemediesNav: false,
          ),
        );
      }
    }
  }

  static String? _firstNonEmptyString(
    Map<String, dynamic> m,
    List<String> keys,
  ) {
    for (final k in keys) {
      final v = m[k]?.toString().trim();
      if (v != null && v.isNotEmpty) return v;
    }
    return null;
  }

  void _parseFlowProgress(dynamic p) {
    if (p is! Map) return;
    final pm = Map<String, dynamic>.from(p);
    final pp = pm['progress_percent'];
    if (pp is num) {
      _flowProgressPercent = pp.toDouble();
    } else if (pp != null) {
      _flowProgressPercent = double.tryParse(pp.toString());
    }
    final inner = pm['progress'];
    if (inner is Map) {
      final m = Map<String, dynamic>.from(inner);
      final total = m['total'];
      final answered = m['answered'];
      final completed = m['completed'];
      if (total != null && answered != null) {
        _flowProgressSummary =
            '$answered/$total${completed == true ? ' · completed' : ''}';
      }
    }
  }

  static List<Map<String, String>> _exercisesToRoutineItems(
    List<WorkoutExercise> list,
  ) {
    return list
        .map(
          (e) => {
            'title': e.title,
            'subtitle': e.steps.isNotEmpty
                ? e.steps.map((s) => '• $s').join('\n')
                : e.duration,
          },
        )
        .where((m) => (m['title'] ?? '').toString().trim().isNotEmpty)
        .toList();
  }

  /// Routine steps: list of objects with `title` (or `name`) from domain flow `ai_routine` / `ai_exercises`.
  static List<Map<String, String>> _parseRoutineList(dynamic raw) {
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

  static List<Map<String, dynamic>> _attrsToGridRows(
    Map<String, dynamic> attrs,
  ) {
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
        final text = value
            .map((e) => e.toString())
            .where((s) => s.isNotEmpty)
            .join(', ');
        if (text.isEmpty) return;
        final row = <String, dynamic>{'title': _humanize(k), 'subTitle': text};
        _attachProgressFromValue(row, value);
        rows.add(row);
        return;
      }
      final row = <String, dynamic>{
        'title': _humanize(k),
        'subTitle': value?.toString() ?? '',
      };
      _attachProgressFromValue(row, value);
      rows.add(row);
    });
    return rows;
  }

  static void _attachProgressFromValue(
    Map<String, dynamic> row,
    dynamic value,
  ) {
    final p = _progressFromApiValue(value);
    if (p != null) {
      row['progress'] = p;
      row['pers'] = _percentLabelForProgress(p, value);
    }
  }

  /// Returns 0–100 when the API value is an explicit number or contains a percentage.
  static double? _progressFromApiValue(dynamic v) {
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

  static String _percentLabelForProgress(double p, dynamic original) {
    if (original is num) return '${p.round()}%';
    final s = original?.toString().trim() ?? '';
    if (s.contains('%')) return s;
    return '${p.round()}%';
  }

  static String _humanize(String key) {
    if (key.isEmpty) return key;
    return key
        .split(RegExp(r'[_\s]+'))
        .where((p) => p.isNotEmpty)
        .map(
          (w) => w.length == 1
              ? w.toUpperCase()
              : '${w[0].toUpperCase()}${w.substring(1).toLowerCase()}',
        )
        .join(' ');
  }

  void _applyAlbumScans(List<AlbumImage> images) {
    final tiles = <Map<String, String>>[];
    for (final view in _slotViews) {
      final img = AlbumImage.pickDisplayImageForView(images, view);
      final label = _displayViewLabel(img?.view ?? view);
      tiles.add({'label': label, 'url': img?.url ?? ''});
    }
    _scanTiles = tiles;
  }

  static String _displayViewLabel(String view) {
    final v = view.trim();
    if (v.isEmpty) return v;
    return v[0].toUpperCase() + (v.length > 1 ? v.substring(1) : '');
  }

  /// Labels under the stepper: section titles from the API only (space when missing).
  List<String> get indicatorStepperLabels =>
      List.generate(_indicatorPages.length, (i) {
        if (i < _indicatorSectionTitles.length) {
          final t = _indicatorSectionTitles[i].trim();
          if (t.isNotEmpty) return t;
        }
        return ' ';
      });

  String sectionHeadingForPage(int pageIndex) {
    if (pageIndex >= 0 && pageIndex < _indicatorSectionTitles.length) {
      return _indicatorSectionTitles[pageIndex].trim();
    }
    return '';
  }
}
