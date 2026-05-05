part of 'daily_skin_care_routine_view_model.dart';

extension _DailySkinCareRoutineParsing on DailySkinCareRoutineViewModel {
  void _parseRemediesAndProducts(Map<String, dynamic> data) {
    if (data.containsKey('ai_remedies')) {
      _skincareRemedies = [];
      _skincareSafetyTips = [];
      final remedies = data['ai_remedies'];
      if (remedies is Map) {
        final m = Map<String, dynamic>.from(remedies);
        final list = m['remedies'];
        if (list is List) {
          for (final e in list) {
            if (e is Map) _skincareRemedies.add(Map<String, dynamic>.from(e));
          }
        }
        final tips = m['safety_tips'];
        if (tips is List) {
          _skincareSafetyTips = tips
              .map((e) => e.toString().trim())
              .where((s) => s.isNotEmpty)
              .toList();
        }
      }
    }

    if (data.containsKey('ai_products')) {
      _skincareProducts = [];
      final products = data['ai_products'];
      if (products is List) {
        for (final raw in products) {
          if (raw is Map) _skincareProducts.add(Map<String, dynamic>.from(raw));
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
        final parsed = WorkoutAiExercises.fromJson(Map<String, dynamic>.from(ex));
        final today = _exercisesToRoutineItems(parsed.morning);
        final night = _exercisesToRoutineItems(parsed.evening);
        if (today.isNotEmpty || night.isNotEmpty) {
          _setRoutineLists(today, night);
        }
      } catch (_) {
        if (kDebugMode) debugPrint('[SkincareRoutine] ai_exercises parse failed');
      }
    }
  }

  void _applyAlbumScans(List<AlbumImage> images) {
    final tiles = <Map<String, String>>[];
    for (final view in DailySkinCareRoutineViewModel._slotViews) {
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
