import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:looklabs/Core/Network/api_error_handler.dart';
import 'package:looklabs/Core/Network/models/progress_graph_response.dart';
import 'package:looklabs/Core/Network/models/simple_image_upload.dart';
import 'package:looklabs/Core/Network/models/weekly_progress_response.dart';
import 'package:looklabs/Repository/image_upload_repository.dart';
import 'package:looklabs/Repository/onboarding_repository.dart';

class ProgressViewModel extends ChangeNotifier {
  static const List<String> buttonNames = ['Week', 'Month', 'Year'];
  /// Graph API expects period=weekly|monthly|yearly.
  static const List<String> _graphPeriodParams = ['weekly', 'monthly', 'yearly'];

  int _selectedTabIndex = 0;
  int get selectedTabIndex => _selectedTabIndex;
  String get selectedPeriodParam => _graphPeriodParams[_selectedTabIndex];

  // Progress graph API data (GET users/me/progress/graph)
  ProgressGraphResponse? _graph;
  bool _progressLoading = false;
  String? _progressError;

  /// Legacy progress (nullable) for backward compatibility if graph is not used.
  WeeklyProgressResponse? get progress => null;

  bool get progressLoading => _progressLoading;
  String? get progressError => _progressError;

  /// Overall first score (Before Progress) and latest score (After Progress) from graph.
  num get overallFirst => _graph?.overallFirst ?? 0;
  num get overallLatest => _graph?.overallLatest ?? 0;
  num get overallChange => _graph?.overallChange ?? 0;

  /// Select tab and load progress graph for that period.
  Future<void> selectTabAndLoad(int index) async {
    if (index < 0 || index >= buttonNames.length) return;
    if (_selectedTabIndex == index) return;
    _selectedTabIndex = index;
    notifyListeners();
    await loadProgress();
  }

  /// Load Week data and select Week tab. Call when Progress screen is first shown.
  Future<void> loadProgressForWeek() async {
    _selectedTabIndex = 0;
    notifyListeners();
    await loadProgress();
  }

  /// Load progress graph for current period (GET users/me/progress/graph?period=weekly|monthly|yearly).
  Future<void> loadProgress() async {
    if (_progressLoading) return;
    _progressLoading = true;
    _progressError = null;
    _graph = null;
    notifyListeners();

    final response = await OnboardingRepository.instance.getProgressGraph(
      period: _graphPeriodParams[_selectedTabIndex],
    );

    _progressLoading = false;
    if (response.success && response.data is ProgressGraphResponse) {
      _graph = response.data as ProgressGraphResponse;
      _progressError = null;
    } else {
      _progressError = response.userMessageOrFallback(
          'Could not load ${buttonNames[_selectedTabIndex].toLowerCase()} progress');
    }
    notifyListeners();
  }

  /// Retry loading progress for current period.
  Future<void> retryProgress() async {
    _progressError = null;
    notifyListeners();
    await loadProgress();
  }

  // Backward compatibility for screens using Week/Month/Year tabs
  List<String> get buttonName => buttonNames;
  String get selectedIndex => buttonNames[_selectedTabIndex];

  /// Select tab by index (used by diet/hair/skin routine screens). Loads progress when called from Progress screen.
  void selectIndex(int index) {
    if (index >= 0 &&
        index < buttonNames.length &&
        _selectedTabIndex != index) {
      _selectedTabIndex = index;
      notifyListeners();
      loadProgress();
    }
  }

  /// Chart-ready data: time series from first domain's scores (recorded_at -> day label, score).
  List<WeeklyProgressDay> get progressDays {
    if (_graph == null || _graph!.domains.isEmpty) return const [];
    for (final d in _graph!.domains) {
      if (d.scores.isNotEmpty) {
        return d.scores
            .map((s) => WeeklyProgressDay(
                  date: s.recordedAt,
                  day: _formatRecordedAt(s.recordedAt),
                  score: s.score,
                ))
            .toList();
      }
    }
    return const [];
  }

  static String _formatRecordedAt(String recordedAt) {
    if (recordedAt.isEmpty) return '';
    try {
      final dt = DateTime.tryParse(recordedAt);
      if (dt == null) return recordedAt.length > 10 ? recordedAt.substring(0, 10) : recordedAt;
      return '${dt.month}/${dt.day}';
    } catch (_) {
      return recordedAt.length > 10 ? recordedAt.substring(0, 10) : recordedAt;
    }
  }

  /// Chart-ready data: domains with latest_score (After Progress) from graph.
  List<WeeklyProgressDomain> get progressDomains {
    if (_graph == null) return const [];
    return _graph!.domains
        .map((d) => WeeklyProgressDomain(
              domain: d.domain,
              score: d.latestScore,
              hasData: d.scores.isNotEmpty || d.latestScore > 0,
              iconUrl: d.iconUrl,
            ))
        .toList();
  }

  /// Domains with first_score (Before Progress) for chart.
  List<WeeklyProgressDomain> get progressBeforeDomains {
    if (_graph == null) return const [];
    return _graph!.domains
        .map((d) => WeeklyProgressDomain(
              domain: d.domain,
              score: d.firstScore,
              hasData: true,
              iconUrl: d.iconUrl,
            ))
        .toList();
  }

  // Image upload (POST images/upload/simple)
  bool _uploadLoading = false;
  String? _uploadError;
  SimpleImageUpload? _lastUpload;

  bool get uploadLoading => _uploadLoading;
  String? get uploadError => _uploadError;
  SimpleImageUpload? get lastUpload => _lastUpload;

  /// Pick image from gallery and upload via POST images/upload/simple.
  /// Returns true if upload succeeded, false otherwise.
  Future<bool> pickAndUploadProgressImage() async {
    final picker = ImagePicker();
    final xFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1280,
      maxHeight: 1280,
      imageQuality: 80,
    );
    if (xFile == null) return false;

    _uploadLoading = true;
    _uploadError = null;
    notifyListeners();

    final response = await ImageUploadRepository.instance.uploadSimpleImage(
      xFile.path,
    );

    _uploadLoading = false;
    if (response.success && response.data is SimpleImageUpload) {
      _lastUpload = response.data as SimpleImageUpload;
      _uploadError = null;
      notifyListeners();
      return true;
    }
    _uploadError = response.userMessageOrFallback('Could not upload image');
    notifyListeners();
    return false;
  }

  void clearUploadError() {
    _uploadError = null;
    notifyListeners();
  }
}
