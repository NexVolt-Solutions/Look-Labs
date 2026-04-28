import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:looklabs/Core/Network/models/album_image.dart';
import 'package:looklabs/Core/Network/models/workout_result_response.dart'
    show WorkoutAiExercises, WorkoutExercise;
import 'package:looklabs/Repository/domain_questions_repository.dart';
import 'package:looklabs/Repository/image_upload_repository.dart';

class HairRoutineExtraCard {
  const HairRoutineExtraCard({
    required this.title,
    required this.subtitle,
    required this.isRemediesNav,
  });

  final String title;
  final String subtitle;

  final bool isRemediesNav;
}

class DailyHairCareRoutineViewModel extends ChangeNotifier {
  /// Domain-level presentation rule: only haircare uses concerns speedometer.
  bool get useConcernsSpeedometer => true;

  bool _loading = false;
  bool get loading => _loading;

  /// True while [loadHaircareRoutine] runs or we are polling `/flow` after a `processing` response.
  bool _flowPollInProgress = false;
  int? _flowPollOwnerSeq;
  bool get showRoutineRefreshing => _loading || _flowPollInProgress;

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

  String? _concernsMeterHeading;
  String? get concernsMeterHeading => _concernsMeterHeading;

  List<HairRoutineExtraCard> _extraCards = [];
  List<HairRoutineExtraCard> get extraCards => List.unmodifiable(_extraCards);

  int _selectedExtraIndex = -1;
  int get selectedExtraIndex => _selectedExtraIndex;

  /// Parsed from `ai_remedies.remedies` for [HairHomeRemedies].
  List<Map<String, dynamic>> _hairRemedies = [];
  List<Map<String, dynamic>> get hairRemedies =>
      List.unmodifiable(_hairRemedies);

  List<String> _hairSafetyTips = [];
  List<String> get hairSafetyTips => List.unmodifiable(_hairSafetyTips);

  /// Parsed from `ai_products` for [HairTopProduct] / detail.
  List<Map<String, dynamic>> _hairProducts = [];
  List<Map<String, dynamic>> get hairProducts =>
      List.unmodifiable(_hairProducts);

  static const List<String> _slotViews = ['front', 'back', 'right', 'left'];

  static const String _domain = 'haircare';

  /// Bumped on every [loadHaircareRoutine] so an older in-flight request cannot
  /// overwrite state after a rescan / new navigation (singleton VM at app root).
  int _loadSeq = 0;

  static bool _flowStatusIsProcessing(String? s) {
    final v = s?.toLowerCase().trim() ?? '';
    return v == 'processing' || v == 'pending' || v == 'in_progress';
  }

  static bool _flowStatusIsComplete(String? s) {
    final v = s?.toLowerCase().trim() ?? '';
    return v == 'completed' || v == 'ok';
  }

  static const Duration _flowPollInterval = Duration(seconds: 3);
  static const int _flowPollMaxRounds = 45;

  Future<void> _pollUntilHaircareFlowCompleted(int seq) async {
    if (seq != _loadSeq) return;
    _flowPollOwnerSeq = seq;
    _flowPollInProgress = true;
    notifyListeners();
    try {
      for (var i = 0; i < _flowPollMaxRounds; i++) {
        await Future<void>.delayed(_flowPollInterval);
        if (seq != _loadSeq) return;
        final flowRes = await DomainQuestionsRepository.instance.getDomainFlow(
          _domain,
        );
        if (seq != _loadSeq) return;
        if (flowRes.success && flowRes.data is Map) {
          final map = Map<String, dynamic>.from(flowRes.data as Map);
          if (kDebugMode) {
            debugPrint(
              '[HaircareRoutine] poll flow status=${map['status']} keys=${map.keys.join(", ")}',
            );
          }
          final st = map['status']?.toString() ?? '';
          if (_flowStatusIsComplete(st)) {
            _applyFlowMap(map);
            return;
          }
          final sl = st.toLowerCase();
          if (sl == 'failed' || sl == 'error') {
            _loadError =
                flowRes.message ?? 'Routine generation failed. Tap Retry.';
            return;
          }
        }
      }
      _loadError = 'Routine is still updating. Tap Retry to refresh.';
    } finally {
      if (_flowPollOwnerSeq == seq) {
        _flowPollInProgress = false;
        _flowPollOwnerSeq = null;
        notifyListeners();
      }
    }
  }

  /// Loads album then **always** GET `domains/{domain}/flow` so the UI matches the server after
  /// new scans (prefetch is ignored for data to avoid stale cached flow).
  Future<void> loadHaircareRoutine() async {
    final seq = ++_loadSeq;
    _flowPollInProgress = false;
    _loading = true;
    _loadError = null;
    notifyListeners();

    try {
      _resetPresentationState();

      final albumRes = await ImageUploadRepository.instance.getAlbumImages(
        domain: _domain,
      );
      if (seq != _loadSeq) return;

      if (albumRes.success && albumRes.data is List<AlbumImage>) {
        _applyAlbumScans(albumRes.data as List<AlbumImage>);
      }

      final flowRes = await DomainQuestionsRepository.instance.getDomainFlow(
        _domain,
      );
      if (seq != _loadSeq) return;

      if (flowRes.success && flowRes.data is Map) {
        final map = Map<String, dynamic>.from(flowRes.data as Map);
        if (kDebugMode) {
          debugPrint(
            '[HaircareRoutine] flow status=${map['status']} keys=${map.keys.join(", ")}',
          );
        }
        _applyFlowMap(map);
        if (_flowStatusIsProcessing(map['status']?.toString())) {
          unawaited(_pollUntilHaircareFlowCompleted(seq));
        }
      } else {
        _loadError = flowRes.message ?? 'Could not load domain flow.';
      }
    } finally {
      if (seq == _loadSeq) {
        _loading = false;
        notifyListeners();
      }
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
    _hairRemedies = [];
    _hairSafetyTips = [];
    _hairProducts = [];
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

    // `/flow` sometimes returns `processing` with only status/progress/redirect,
    // which must not wipe a previously completed `ai_*` payload.
    if (!_isTransitionalProcessingSnapshot(data)) {
      _parseRemediesAndProducts(data);
      _applyIndicatorPages(data);
      _applyRoutines(data);
    }
    _applyExtraCards(data);
  }

  /// True when status is in-progress but the JSON carries no AI blocks yet.
  bool _isTransitionalProcessingSnapshot(Map<String, dynamic> data) {
    if (!_flowStatusIsProcessing(data['status']?.toString())) return false;
    const keys = <String>[
      'ai_routine',
      'ai_remedies',
      'ai_products',
      'ai_attributes',
      'ai_health',
      'ai_concerns',
      'ai_exercises',
    ];
    for (final k in keys) {
      if (data[k] != null) return false;
    }
    return true;
  }

  void _parseRemediesAndProducts(Map<String, dynamic> data) {
    if (data.containsKey('ai_remedies')) {
      _hairRemedies = [];
      _hairSafetyTips = [];
      final remedies = data['ai_remedies'];
      if (remedies is Map) {
        final m = Map<String, dynamic>.from(remedies);
        final list = m['remedies'];
        if (list is List) {
          for (final e in list) {
            if (e is Map) _hairRemedies.add(Map<String, dynamic>.from(e));
          }
        }
        final tips = m['safety_tips'];
        if (tips is List) {
          _hairSafetyTips = tips
              .map((e) => e.toString().trim())
              .where((s) => s.isNotEmpty)
              .toList();
        }
      }
    }

    if (data.containsKey('ai_products')) {
      _hairProducts = [];
      final products = data['ai_products'];
      if (products is List) {
        for (final raw in products) {
          if (raw is Map) _hairProducts.add(Map<String, dynamic>.from(raw));
        }
      }
    }
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
      const keys = ['ai_attributes', 'ai_health', 'ai_concerns'];
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
          if (t != null && t.isNotEmpty) {
            _concernsMeterHeading = t;
          } else {
            final stage = Map<String, dynamic>.from(c)['stage'];
            if (stage is Map) {
              final lbl = Map<String, dynamic>.from(
                stage,
              )['label']?.toString().trim();
              if (lbl != null && lbl.isNotEmpty) {
                _concernsMeterHeading = lbl;
              }
            }
          }
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

    final routine =
        _mapFromLooseJson(data['ai_routine']) ??
        _mapFromLooseJson(data['aiRoutine']);
    if (routine != null) {
      final r = routine;
      var today = _parseRoutineList(r['today'] ?? r['Today']);
      var night = _parseRoutineList(r['night'] ?? r['Night']);
      if (today.isEmpty && night.isEmpty) {
        today = _parseRoutineList(r['morning']);
        night = _parseRoutineList(r['evening']);
      }
      if (today.isEmpty && night.isEmpty) {
        today = _parseRoutineList(r['am']);
        night = _parseRoutineList(r['pm']);
      }
      if (today.isNotEmpty || night.isNotEmpty) {
        _setRoutineLists(today, night);
        return;
      }
    }

    var today = _parseRoutineList(data['today'] ?? data['Today']);
    var night = _parseRoutineList(data['night'] ?? data['Night']);
    if (today.isEmpty && night.isEmpty) {
      today = _parseRoutineList(data['morning']);
      night = _parseRoutineList(data['evening']);
    }
    if (today.isNotEmpty || night.isNotEmpty) {
      _setRoutineLists(today, night);
      return;
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
          debugPrint('[HaircareRoutine] ai_exercises parse failed');
        }
      }
    }

    if (kDebugMode) {
      final st = data['status']?.toString().toLowerCase() ?? '';
      if ((st == 'completed' || st == 'ok') &&
          _todayRoutine.isEmpty &&
          _nightRoutine.isEmpty) {
        debugPrint(
          '[HaircareRoutine] completed flow but no routine steps parsed '
          '(expected ai_routine.today / .night)',
        );
      }
    }
  }

  static Map<String, dynamic>? _mapFromLooseJson(dynamic v) {
    if (v == null) return null;
    if (v is Map) {
      return Map<String, dynamic>.from(v);
    }
    if (v is String) {
      final s = v.trim();
      if (s.isEmpty) return null;
      try {
        final decoded = jsonDecode(s);
        if (decoded is Map) {
          return Map<String, dynamic>.from(decoded);
        }
      } catch (_) {}
    }
    return null;
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

    if (_hairRemedies.isNotEmpty || _hairSafetyTips.isNotEmpty) {
      _extraCards.add(
        const HairRoutineExtraCard(
          title: 'Home Remedies',
          subtitle: 'Home Remedies',
          isRemediesNav: true,
        ),
      );
    }
    if (_hairProducts.isNotEmpty) {
      _extraCards.add(
        const HairRoutineExtraCard(
          title: 'Top Products',
          subtitle: 'Top Products Picks For You',
          isRemediesNav: false,
        ),
      );
    }
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

  static List<Map<String, String>> _parseRoutineList(dynamic raw) {
    if (raw is! List) return [];
    final out = <Map<String, String>>[];
    for (final e in raw) {
      if (e is! Map) continue;
      final m = Map<String, dynamic>.from(e);
      final title = (m['title'] ?? m['name'] ?? '').toString().trim();
      if (title.isEmpty) continue;
      final steps = m['steps'];
      var subtitle =
          (m['description'] ??
                  m['details'] ??
                  m['body'] ??
                  m['instruction'] ??
                  m['text'] ??
                  '')
              .toString()
              .trim();
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
        final vm = Map<String, dynamic>.from(value);
        final label = vm['label']?.toString().trim();
        final conf = vm['confidence'];
        if (label != null &&
            label.isNotEmpty &&
            (conf is num || conf != null)) {
          final row = <String, dynamic>{
            'title': _humanize(k),
            'subTitle': label,
          };
          _attachProgressFromValue(row, conf);
          rows.add(row);
          return;
        }
        vm.forEach((k2, v2) {
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

  List<String> get indicatorStepperLabels =>
      List.generate(_indicatorPages.length, (i) {
        if (i < _indicatorSectionTitles.length) {
          final t = _indicatorSectionTitles[i].trim();
          if (t.isNotEmpty) return t;
        }
        return ' ';
      });

  String sectionHeadingForPage(int pageIndex) {
    const fallback = ['Hair attributes', 'Hair health', 'Concerns'];
    if (pageIndex >= 0 && pageIndex < _indicatorSectionTitles.length) {
      final t = _indicatorSectionTitles[pageIndex].trim();
      if (t.isNotEmpty) return t;
    }
    if (pageIndex >= 0 && pageIndex < fallback.length) {
      return fallback[pageIndex];
    }
    return '';
  }

  /// UI row for [HairTopProduct] / [ProductWidget] (tags = API `tags`).
  static Map<String, dynamic> productRowForListUi(
    Map<String, dynamic> apiProduct,
  ) {
    final name = (apiProduct['name'] ?? apiProduct['title'] ?? '')
        .toString()
        .trim();
    final overview = (apiProduct['overview'] ?? apiProduct['description'] ?? '')
        .toString()
        .trim();
    final tod = (apiProduct['time_of_day'] ?? '').toString();
    final tagsRaw = apiProduct['tags'];
    final tags = <String>[];
    if (tagsRaw is List) {
      for (final t in tagsRaw) {
        final s = t.toString().trim();
        if (s.isNotEmpty) tags.add(s);
      }
    }
    return {
      'title': name,
      'description': overview,
      'time_of_day': tod,
      'tags': tags,
      'raw': apiProduct,
    };
  }
}
