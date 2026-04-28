import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:looklabs/Core/Network/models/album_image.dart';
import 'package:looklabs/Repository/domain_questions_repository.dart';
import 'package:looklabs/Repository/image_upload_repository.dart';

// Album contract (haircare / skincare / etc.): new rows often return `status: "processing"`
// immediately after upload (not `pending`). Treat `processing` like in-flight analysis.
// UI: show the analyzing screen as soon as any standard-slot image is `processing`
// (see [ReviewScansViewModel.uploadAllDomainImages] early-navigation callback).
// Bullet list: **only** from GET album `analysis_result` (prefer `points`); no static copy.

/// Parses [AlbumImage.analysisResult] into bullet lines (prefers `points` when present).
List<String> parseAnalysisResultBullets(dynamic raw) {
  if (raw == null) return [];
  if (raw is String) {
    final t = raw.trim();
    if (t.isEmpty) return [];
    if (t.startsWith('{') || t.startsWith('[')) {
      try {
        final decoded = jsonDecode(t) as Object?;
        return parseAnalysisResultBullets(decoded);
      } catch (_) {
        return _splitLooseText(t);
      }
    }
    return _splitLooseText(t);
  }
  if (raw is List) {
    return raw
        .map((e) => e?.toString().trim())
        .whereType<String>()
        .where((s) => s.isNotEmpty)
        .toList();
  }
  if (raw is Map) {
    // Backend: analysis_result.points as string list (e.g. "Hairloss: Low").
    const keys = [
      'points',
      'findings',
      'concerns',
      'items',
      'bullets',
      'recommendations',
      'summary_points',
      'issues',
      'observations',
      'skin_concerns',
    ];
    for (final k in keys) {
      if (raw[k] != null) {
        final nested = parseAnalysisResultBullets(raw[k]);
        if (nested.isNotEmpty) return nested;
      }
    }
    final text = raw['summary'] ?? raw['text'] ?? raw['message'];
    if (text != null) {
      final nested = parseAnalysisResultBullets(text);
      if (nested.isNotEmpty) return nested;
    }
  }
  final s = raw.toString().trim();
  return s.isEmpty ? [] : [s];
}

List<String> _splitLooseText(String t) {
  return t
      .split(RegExp(r'[\n\r]+|•\s*|\s*[·]\s*'))
      .map((s) => s.replaceFirst(RegExp(r'^[-*]\s*'), '').trim())
      .where((s) => s.isNotEmpty)
      .toList();
}

List<String> _dedupePreserveOrder(List<String> items) {
  final seen = <String>{};
  final out = <String>[];
  for (final s in items) {
    final key = s.toLowerCase();
    if (seen.add(key)) out.add(s);
  }
  return out;
}

/// Lines from album `analysis_result` for the analyzing screen — only server data (no static copy).
/// Uses `analysis_result.points` when present; otherwise a bare list, else nothing.
List<String> parseAlbumAnalysisPoints(dynamic analysisResult) {
  if (analysisResult == null) return [];
  if (analysisResult is Map) {
    final p = analysisResult['points'];
    if (p != null) return parseAnalysisResultBullets(p);
    return [];
  }
  if (analysisResult is List) {
    return parseAnalysisResultBullets(analysisResult);
  }
  return [];
}

class SkinAnalyzingViewModel extends ChangeNotifier {
  SkinAnalyzingViewModel({
    String domain = 'skincare',
    Duration pollInterval = const Duration(seconds: 3),
    Duration timeout = const Duration(minutes: 2),
  }) : _domain = domain,
       _pollInterval = pollInterval,
       _timeout = timeout;

  final String _domain;
  final Duration _pollInterval;
  final Duration _timeout;

  static const List<String> _views = ['front', 'back', 'right', 'left'];

  final ImageUploadRepository _repo = ImageUploadRepository.instance;
  DateTime? _startedAt;

  /// Only one async poll loop runs at a time ([startPolling] is idempotent).
  bool _pollLoopRunning = false;

  List<String> _bullets = [];
  int _processedCount = 0;
  int _displayProgressPercent = 0;

  /// Views whose newest album row exists but is not yet terminal-processed (`processing`, etc.).
  int _queuedViewCount = 0;
  String? _fetchError;
  String? _analysisError;
  bool _timedOut = false;
  bool _pollingStopped = false;

  /// Latest GET domains/{domain}/flow — [isFlowCompleted] when `status` is ok/completed.
  bool _flowCompleted = false;

  /// Throttle + backoff for GET …/flow (album is polled every [_pollInterval]; flow is stricter).
  DateTime? _lastFlowPollAt;
  DateTime? _flowBackoffUntil;

  /// Keep in line with [_pollInterval] so `/flow` can flip to `completed` soon after album does.
  static const Duration _flowPollMinInterval = Duration(seconds: 3);
  static const int _flow429DefaultBackoffSeconds = 50;

  List<String> get analysisBullets => List.unmodifiable(_bullets);

  /// Bullet list built only from latest album rows’ `analysis_result` (see [_pollOnce]).
  List<String> get displayBullets => analysisBullets;

  List<String> get stagedBullets => analysisBullets;

  /// Credits both finished rows and in-flight `processing` rows so the bar does not snap to 0%
  /// during rescans when every view’s **newest** row is still in the pipeline (strict `processed/n`
  /// would be 0 while all four images are analyzing — see [_pollOnce]).
  static const double _pipelineSlotWeight = 0.5;

  int _calculateRawProgressPercent() {
    if (isFullyComplete) return 100;
    final n = _views.length;
    if (n == 0) return 0;
    final frac =
        (_processedCount + _pipelineSlotWeight * _queuedViewCount) / n;
    final linear = (frac * 100).round().clamp(0, 100);
    final allLatestTerminal =
        _queuedViewCount == 0 && _processedCount >= n;
    if (!allLatestTerminal) {
      return linear.clamp(0, 99);
    }
    if (!isAlbumAnalysisReady) {
      return linear.clamp(90, 99);
    }
    if (!isFlowCompleted) {
      return linear.clamp(95, 99);
    }
    return 99;
  }

  /// Monotonic UI progress: never decreases within the same scan run.
  int get progressPercent => _displayProgressPercent;

  int get processedViewCount => _processedCount;

  String? get fetchError => _fetchError;

  /// e.g. a view returned status `failed`.
  String? get analysisError => _analysisError;

  bool get timedOut => _timedOut;

  /// All four latest album rows processed with at least one parsed bullet from `analysis_result`.
  bool get isAlbumAnalysisReady =>
      _processedCount >= _views.length &&
      _analysisError == null &&
      _bullets.isNotEmpty;

  /// GET domains/{domain}/flow reports a terminal success status.
  bool get isFlowCompleted => _flowCompleted;

  /// Album bullets ready **and** domain flow `status` is completed/ok (backend contract).
  bool get isFullyComplete => isAlbumAnalysisReady && isFlowCompleted;

  /// Prefer [isFullyComplete]; kept for call sites that only checked album state.
  bool get isAllProcessed => isFullyComplete;

  /// Auto-advance only when album + `/flow` both agree (avoids leaving early at ~35% or on timeout).
  bool get shouldAutoNavigateToRoutine => isFullyComplete;

  /// Hide the main spinner when done, failed, or timed out.
  bool get showBusyIndicator =>
      !_pollingStopped &&
      !isFullyComplete &&
      _analysisError == null &&
      !_timedOut;

  /// Under the progress bar while rows are still updating — including when some angles already
  /// show points but others are still `processing` (avoids a silent gap between old bullets clearing
  /// and the new batch finishing).
  bool get showAlbumPendingSyncHint =>
      !_pollingStopped &&
      !isFullyComplete &&
      _analysisError == null &&
      _fetchError == null &&
      (_bullets.isEmpty || _queuedViewCount > 0);

  /// Clears UI + flow state so a new scan does not reuse a previous "completed" `/flow` snapshot.
  void resetForNewScan() {
    _bullets = [];
    _processedCount = 0;
    _displayProgressPercent = 0;
    _queuedViewCount = 0;
    _fetchError = null;
    _analysisError = null;
    _timedOut = false;
    _flowCompleted = false;
    _lastFlowPollAt = null;
    _flowBackoffUntil = null;
  }

  void startPolling() {
    if (_pollLoopRunning) return;
    resetForNewScan();
    _pollLoopRunning = true;
    _startedAt = DateTime.now();
    _pollingStopped = false;
    unawaited(_runPollLoop());
  }

  Future<void> _runPollLoop() async {
    try {
      while (!_pollingStopped) {
        if (_startedAt != null &&
            DateTime.now().difference(_startedAt!) > _timeout) {
          _timedOut = true;
          _stopPolling();
          notifyListeners();
          return;
        }

        await _pollOnce();

        if (_pollingStopped) return;

        await Future<void>.delayed(_pollInterval);
      }
    } finally {
      _pollLoopRunning = false;
    }
  }

  Future<void> _pollOnce() async {
    if (_pollingStopped) return;

    final response = await _repo.getAlbumImages(domain: _domain);
    if (_pollingStopped) return;

    if (!response.success) {
      _fetchError = response.message ?? 'Could not load analysis status';
      notifyListeners();
      return;
    }

    _fetchError = null;

    final list = response.data is List<AlbumImage>
        ? response.data as List<AlbumImage>
        : const <AlbumImage>[];

    var processed = 0;
    var queued = 0;
    // Recompute failure state from the latest album snapshot each poll.
    // Keeping previous value can preserve stale errors from an earlier scan/poll
    // and incorrectly stop loading for a new in-flight batch.
    String? failedMessage;
    final collected = <String>[];

    for (final view in _views) {
      final latest = AlbumImage.pickNewestByIdForView(list, view);
      if (latest == null) continue;

      // Show real AI bullets as soon as backend attaches preview points, even while
      // the latest row is still `processing`.
      collected.addAll(parseAlbumAnalysisPoints(latest.analysisResult));

      if (AlbumImage.isTerminalProcessedStatus(latest.status)) {
        processed++;
        continue;
      }

      if (AlbumImage.isFailureStatus(latest.status)) {
        failedMessage ??=
            latest.errorMessage ??
            'Analysis failed for ${view[0].toUpperCase()}${view.substring(1)} view.';
        continue;
      }

      // Newest row still in the pipeline (`processing`, etc.) — do **not** merge older
      // processed rows into [_bullets] / readiness (avoids stale points during rescans).
      queued++;
    }

    _processedCount = processed;
    _queuedViewCount = queued;
    _analysisError = failedMessage;
    final nextBullets = _dedupePreserveOrder(collected);
    if (nextBullets.isNotEmpty) {
      _bullets = nextBullets;
    }

    if (_analysisError != null) {
      _stopPolling();
      notifyListeners();
      return;
    }

    // New uploads still processing: backend may clear `/flow` cache and re-run AI — do not trust an
    // earlier `completed` until this batch finishes and we poll `/flow` again.
    if (queued > 0) {
      _flowCompleted = false;
    }

    final urgentFlowPoll =
        processed >= _views.length && queued == 0 && _bullets.isNotEmpty;
    await _refreshFlowCompletedFlag(urgent: urgentFlowPoll);
    if (_pollingStopped) return;

    final rawProgress = _calculateRawProgressPercent();
    if (rawProgress > _displayProgressPercent) {
      _displayProgressPercent = rawProgress;
    }

    // Album: keep polling until latest per view is processed **and** bullets parse.
    // Flow: GET domains/{domain}/flow must report completed/ok as well.
    if (isFullyComplete) {
      _displayProgressPercent = 100;
      _stopPolling();
      notifyListeners();
      return;
    }

    notifyListeners();
  }

  static bool _isFlowStatusComplete(Map<String, dynamic> data) {
    final s = data['status']?.toString().toLowerCase().trim() ?? '';
    return s == 'completed' || s == 'ok';
  }

  Future<void> _refreshFlowCompletedFlag({bool urgent = false}) async {
    if (_pollingStopped) return;
    final now = DateTime.now();
    if (_flowBackoffUntil != null && now.isBefore(_flowBackoffUntil!)) {
      return;
    }
    if (!urgent &&
        _lastFlowPollAt != null &&
        now.difference(_lastFlowPollAt!) < _flowPollMinInterval) {
      return;
    }
    _lastFlowPollAt = now;

    try {
      final res = await DomainQuestionsRepository.instance.getDomainFlow(
        _domain,
      );
      if (_pollingStopped) return;

      // Rate limits / transient overload: do **not** clear [_flowCompleted].
      // Otherwise a prior `completed` (before album finished) is wiped by 429 and the UI never reaches 100%.
      if (res.statusCode == 429 ||
          res.statusCode == 503 ||
          res.statusCode == 502) {
        final secs = res.retryAfterSeconds ?? _flow429DefaultBackoffSeconds;
        _flowBackoffUntil = DateTime.now().add(
          Duration(seconds: secs.clamp(5, 120)),
        );
        return;
      }

      if (res.success && res.data is Map) {
        _flowCompleted = _isFlowStatusComplete(
          Map<String, dynamic>.from(res.data as Map),
        );
      } else {
        _flowCompleted = false;
      }
    } catch (_) {
      // Network errors: keep last known [_flowCompleted].
    }
  }

  void _stopPolling() {
    _pollingStopped = true;
  }

  @override
  void dispose() {
    _stopPolling();
    super.dispose();
  }
}
