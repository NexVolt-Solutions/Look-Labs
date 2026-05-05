part of 'daily_hair_care_routine_view_model.dart';

extension _DailyHairCareRoutineFlow on DailyHairCareRoutineViewModel {
  Future<void> _pollUntilHaircareFlowCompleted(int seq) async {
    if (seq != _loadSeq) return;
    _flowPollOwnerSeq = seq;
    _flowPollInProgress = true;
    _notify();
    try {
      for (var i = 0; i < DailyHairCareRoutineViewModel._flowPollMaxRounds; i++) {
        await Future<void>.delayed(DailyHairCareRoutineViewModel._flowPollInterval);
        if (seq != _loadSeq) return;
        final flowRes = await DomainQuestionsRepository.instance.getDomainFlow(
          DailyHairCareRoutineViewModel._domainKey,
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
          if (DailyHairCareRoutineViewModel._flowStatusIsComplete(st)) {
            _applyFlowMap(map);
            return;
          }
          final sl = st.toLowerCase();
          if (sl == 'failed' || sl == 'error') {
            _loadError = flowRes.message ?? 'Routine generation failed. Tap Retry.';
            return;
          }
        }
      }
      _loadError = 'Routine is still updating. Tap Retry to refresh.';
    } finally {
      if (_flowPollOwnerSeq == seq) {
        _flowPollInProgress = false;
        _flowPollOwnerSeq = null;
        _notify();
      }
    }
  }

  Future<void> _loadHaircareRoutine() async {
    final seq = ++_loadSeq;
    _flowPollInProgress = false;
    _loading = true;
    _loadError = null;
    _notify();

    try {
      _resetPresentationState();

      final albumRes = await ImageUploadRepository.instance.getAlbumImages(
        domain: DailyHairCareRoutineViewModel._domainKey,
      );
      if (seq != _loadSeq) return;
      if (albumRes.success && albumRes.data is List<AlbumImage>) {
        _applyAlbumScans(albumRes.data as List<AlbumImage>);
      }

      final flowRes = await DomainQuestionsRepository.instance.getDomainFlow(
        DailyHairCareRoutineViewModel._domainKey,
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
        if (DailyHairCareRoutineViewModel._flowStatusIsProcessing(
          map['status']?.toString(),
        )) {
          unawaited(_pollUntilHaircareFlowCompleted(seq));
        }
      } else {
        _loadError = flowRes.message ?? 'Could not load domain flow.';
      }
    } finally {
      if (seq == _loadSeq) {
        _loading = false;
        _notify();
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

  void _toggleTodayCheck(int index) {
    if (index < 0 || index >= _todayChecked.length) return;
    _todayChecked[index] = !_todayChecked[index];
    _notify();
    unawaited(_saveRoutineCompletionForToday());
  }

  void _toggleNightCheck(int index) {
    if (index < 0 || index >= _nightChecked.length) return;
    _nightChecked[index] = !_nightChecked[index];
    _notify();
    unawaited(_saveRoutineCompletionForToday());
  }

  void _selectExtraCard(int index) {
    if (index < 0 || index >= _extraCards.length) return;
    _selectedExtraIndex = index;
    _notify();
  }

  void _applyFlowMap(Map<String, dynamic> data) {
    _flowStatus = data['status']?.toString();
    _parseFlowProgress(data['progress']);
    final msg = data['ai_message']?.toString().trim();
    _aiMessage = (msg != null && msg.isNotEmpty) ? msg : null;

    if (!_isTransitionalProcessingSnapshot(data)) {
      _parseRemediesAndProducts(data);
      _applyIndicatorPages(data);
      _applyRoutines(data);
    }
    _applyExtraCards();
  }

  bool _isTransitionalProcessingSnapshot(Map<String, dynamic> data) {
    if (!DailyHairCareRoutineViewModel._flowStatusIsProcessing(
      data['status']?.toString(),
    )) {
      return false;
    }
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

  void _applyExtraCards() {
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
        _flowProgressSummary = '$answered/$total${completed == true ? ' · completed' : ''}';
      }
    }
  }

  Future<void> _loadRoutineCompletionForToday(int seq) async {
    if (seq != _loadSeq) return;
    final total = _todayRoutine.length + _nightRoutine.length;
    if (total <= 0) return;
    final data = await WorkoutCompletionRepository.instance.loadCompletedExercises(
      DateTime.now(),
      domain: DailyHairCareRoutineViewModel._domainKey,
    );
    if (seq != _loadSeq || data == null) return;
    final raw = data['completed_indices'];
    if (raw is! List) return;
    final done = raw
        .map((e) => e is int ? e : int.tryParse(e?.toString() ?? ''))
        .whereType<int>()
        .where((i) => i >= 0 && i < total)
        .toSet();
    for (var i = 0; i < _todayChecked.length; i++) {
      _todayChecked[i] = done.contains(i);
    }
    final offset = _todayChecked.length;
    for (var i = 0; i < _nightChecked.length; i++) {
      _nightChecked[i] = done.contains(offset + i);
    }
    _notify();
  }

  Future<void> _saveRoutineCompletionForToday() async {
    if (_savingCompletion) return;
    _savingCompletion = true;
    try {
      final completed = <int>{};
      for (var i = 0; i < _todayChecked.length; i++) {
        if (_todayChecked[i]) completed.add(i);
      }
      final offset = _todayChecked.length;
      for (var i = 0; i < _nightChecked.length; i++) {
        if (_nightChecked[i]) completed.add(offset + i);
      }
      final total = _todayChecked.length + _nightChecked.length;
      await WorkoutCompletionRepository.instance.saveCompleted(
        DateTime.now(),
        completed,
        domain: DailyHairCareRoutineViewModel._domainKey,
        totalExercises: total,
      );
    } finally {
      _savingCompletion = false;
    }
  }
}
