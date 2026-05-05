part of 'daily_hair_care_routine_view_model.dart';

extension _DailyHairCareRoutineParsing on DailyHairCareRoutineViewModel {
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
              final lbl = Map<String, dynamic>.from(stage)['label']?.toString().trim();
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
        _mapFromLooseJson(data['ai_routine']) ?? _mapFromLooseJson(data['aiRoutine']);
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
        final parsed = WorkoutAiExercises.fromJson(Map<String, dynamic>.from(ex));
        final today = _exercisesToRoutineItems(parsed.morning);
        final night = _exercisesToRoutineItems(parsed.evening);
        if (today.isNotEmpty || night.isNotEmpty) {
          _setRoutineLists(today, night);
        }
      } catch (_) {
        if (kDebugMode) debugPrint('[HaircareRoutine] ai_exercises parse failed');
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

  void _setRoutineLists(
    List<Map<String, String>> today,
    List<Map<String, String>> night,
  ) {
    _todayRoutine = today;
    _nightRoutine = night;
    _todayChecked = List<bool>.filled(_todayRoutine.length, false);
    _nightChecked = List<bool>.filled(_nightRoutine.length, false);
    unawaited(_loadRoutineCompletionForToday(_loadSeq));
  }

  void _applyAlbumScans(List<AlbumImage> images) {
    final tiles = <Map<String, String>>[];
    for (final view in DailyHairCareRoutineViewModel._slotViews) {
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
}
