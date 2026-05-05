part of 'work_out_progress_screen_view_model.dart';

extension _WorkOutProgressChart on WorkOutProgressScreenViewModel {
  Future<void> _loadChartForPeriod(
    String periodLabel, {
    bool force = false,
  }) async {
    if (!force && _chartByPeriod.containsKey(periodLabel)) {
      selectedChartPeriod = periodLabel;
      _notify();
      return;
    }
    if (force) {
      _chartByPeriod.remove(periodLabel);
    }
    chartLoading = true;
    _notify();
    try {
      final points = await _graphRepository.loadChartForPeriod(periodLabel);
      _chartByPeriod[periodLabel] = points;
      selectedChartPeriod = periodLabel;
    } finally {
      chartLoading = false;
      _notify();
    }
  }

  Future<void> _onChartPeriodTap(String period) async {
    await loadChartForPeriod(period);
  }

  Future<void> _syncChartOverlaysAfterCompletionChange() async {
    if (_chartByPeriod.isEmpty) return;
    final next = await _graphRepository.reapplyTodayOverlayToAll(_chartByPeriod);
    _chartByPeriod
      ..clear()
      ..addAll(next);
    _notify();
  }
}
