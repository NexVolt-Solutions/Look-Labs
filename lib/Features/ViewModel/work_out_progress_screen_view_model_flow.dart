part of 'work_out_progress_screen_view_model.dart';

extension _WorkOutProgressFlow on WorkOutProgressScreenViewModel {
  Future<void> _loadProgressData() async {
    if (_progressLoading) return;
    _progressLoading = true;
    _notify();
    try {
      final now = DateTime.now();
      final results = await Future.wait<Object?>([
        WorkoutCompletionRepository.instance.loadCompletedExercises(now),
        WorkoutCompletionRepository.instance.getWeeklySummary(),
        DomainQuestionsRepository.instance.getDomainFlow(
          WorkOutProgressScreenViewModel._domainKey,
        ),
      ]);
      final todayData = results[0] as Map<String, dynamic>?;
      final weekly = results[1] as Map<String, dynamic>?;
      final flowRes = results[2] as ApiResponse;

      if (flowRes.success && flowRes.data is Map) {
        final fd = Map<String, dynamic>.from(flowRes.data as Map);
        if (_WorkOutProgressInsight._isCompletedWorkoutFlow(fd)) {
          _applyWorkoutFlowAiFromApi(fd);
        }
      }

      _ingestTodayCompletionPayload(todayData);

      if (weekly != null) {
        _weeklySummaryLoaded = true;
        if (weekly['week_average'] is num) {
          _weekAverage = (weekly['week_average'] as num).toDouble();
        }
        _weeklyDays = [];
        if (weekly['days'] is List) {
          for (final d in weekly['days'] as List) {
            if (d is Map) {
              _weeklyDays.add(Map<String, dynamic>.from(d));
            }
          }
        }
      } else {
        _weeklySummaryLoaded = false;
        _weekAverage = 0.0;
        _weeklyDays = [];
      }

      _rebuildMergedWeeklyDays(now);
      _buildProgressCardsFromApi();
      await loadChartForPeriod(selectedChartPeriod, force: true);
    } finally {
      _progressLoading = false;
      _notify();
    }
  }

  void _ingestTodayCompletionPayload(Map<String, dynamic>? todayData) {
    if (todayData != null) {
      final ci = todayData['completed_indices'];
      if (ci is List) {
        _exerciseCompletedIndices = ci
            .map((e) => e is int ? e : int.tryParse(e?.toString() ?? ''))
            .whereType<int>()
            .where((i) => i >= 0)
            .toSet();
        _todayCompleted = _exerciseCompletedIndices.length;
      } else {
        _exerciseCompletedIndices = {};
        _todayCompleted = 0;
      }
      _todayTotal = todayData['total_exercises'] is int
          ? todayData['total_exercises'] as int
          : (todayData['total_exercises'] != null
              ? int.tryParse(todayData['total_exercises'].toString()) ?? 0
              : 0);
      _todayScore =
          (todayData['score'] is num) ? (todayData['score'] as num).toDouble() : 0.0;
      _applyRecoveryChecklistFromApi(todayData);
    } else {
      _todayCompleted = 0;
      _todayTotal = 0;
      _todayScore = 0.0;
      _exerciseCompletedIndices = {};
    }
  }

  Future<void> _refreshTodayCompletionFromApi() async {
    final now = DateTime.now();
    final todayData = await WorkoutCompletionRepository.instance.loadCompletedExercises(now);
    _ingestTodayCompletionPayload(todayData);
    _rebuildMergedWeeklyDays(now);
    _buildProgressCardsFromApi();
    _notify();
    await _syncChartOverlaysAfterCompletionChange();
  }

  void _applyRecoveryChecklistFromApi(Map<String, dynamic> todayData) {
    if (_checkBoxName.isEmpty) return;
    while (_selectedChecklist.length < _checkBoxName.length) {
      _selectedChecklist.add(false);
    }
    if (_selectedChecklist.length > _checkBoxName.length) {
      _selectedChecklist = _selectedChecklist.take(_checkBoxName.length).toList(growable: false);
    }
    final raw = todayData['recovery_completed_indices'];
    final done = <int>{};
    if (raw is List) {
      for (final e in raw) {
        final i = e is int ? e : int.tryParse(e?.toString() ?? '');
        if (i != null && i >= 0) done.add(i);
      }
    }
    for (var i = 0; i < _selectedChecklist.length; i++) {
      _selectedChecklist[i] = done.contains(i);
    }
  }

  Set<int> _recoveryIndicesFromChecklist() {
    final out = <int>{};
    for (var i = 0; i < _selectedChecklist.length; i++) {
      if (_selectedChecklist[i]) out.add(i);
    }
    return out;
  }

  void _rebuildMergedWeeklyDays(DateTime now) {
    final todayStr = _dateStr(now);
    final merged = <Map<String, dynamic>>[];
    bool todayInApi = false;
    for (final d in _weeklyDays) {
      final date = d['date']?.toString() ?? '';
      if (date == todayStr) {
        todayInApi = true;
        merged.add({
          ...Map<String, dynamic>.from(d),
          'score': _todayScore,
          'completed': _todayCompleted,
          'total': _todayTotal,
        });
      } else {
        merged.add(Map<String, dynamic>.from(d));
      }
    }
    if (!todayInApi) {
      merged.add({
        'date': todayStr,
        'score': _todayScore,
        'completed': _todayCompleted,
        'total': _todayTotal,
      });
    }
    merged.sort((a, b) => (a['date']?.toString() ?? '').compareTo(b['date']?.toString() ?? ''));
    _mergedWeeklyDays = merged;
  }

  void _buildProgressCardsFromApi() {
    final cards = <Map<String, String>>[];
    if (_todayTotal >= 0) {
      cards.add({'title': 'Today', 'value': '$_todayCompleted/$_todayTotal'});
      if (_todayScore > 0 || _todayTotal > 0) {
        cards.add({'title': 'Score', 'value': _todayScore.toStringAsFixed(0)});
      }
    }
    final wAvg = displayWeekAverage;
    if (_mergedWeeklyDays.isNotEmpty || wAvg > 0 || _weekAverage > 0) {
      final weekVal = _weeklySummaryLoaded ? _weekAverage : wAvg;
      cards.add({'title': 'Week avg', 'value': weekVal.toStringAsFixed(0)});
    }
    _progressCards = cards.isNotEmpty ? cards : [{'title': '—', 'value': '—'}];
  }

  Future<void> _toggleChecklist(int index) async {
    if (index < 0 || index >= _selectedChecklist.length) return;
    _selectedChecklist[index] = !_selectedChecklist[index];
    _notify();
    _checklistSaveDebounce?.cancel();
    _checklistSaveDebounce = Timer(
      WorkOutProgressScreenViewModel._checklistSaveDelay,
      () {
      _checklistSaveDebounce = null;
      unawaited(_persistChecklistAfterDebounce());
      },
    );
  }

  Future<void> _persistChecklistAfterDebounceImpl() async {
    final recovery = _recoveryIndicesFromChecklist();
    try {
      await WorkoutCompletionRepository.instance.saveCompleted(
        DateTime.now(),
        Set<int>.from(_exerciseCompletedIndices),
        totalExercises: _todayTotal > 0 ? _todayTotal : 0,
        recoveryCompletedIndices: recovery,
      );
    } catch (_) {
      await refreshTodayCompletionFromApi();
    }
  }
}

String _dateStr(DateTime d) =>
    '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
