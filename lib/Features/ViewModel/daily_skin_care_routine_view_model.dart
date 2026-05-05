import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:looklabs/Core/Network/models/album_image.dart';
import 'package:looklabs/Core/Network/models/workout_result_response.dart'
    show WorkoutAiExercises, WorkoutExercise;
import 'package:looklabs/Repository/domain_questions_repository.dart';
import 'package:looklabs/Repository/image_upload_repository.dart';
import 'package:looklabs/Repository/workout_completion_repository.dart';

part 'daily_skin_care_routine_flow.dart';
part 'daily_skin_care_routine_parsing.dart';
part 'daily_skin_care_routine_parse_utils.dart';

class SkincareRoutineExtraCard {
  const SkincareRoutineExtraCard({
    required this.title,
    required this.subtitle,
    required this.isRemediesNav,
  });

  final String title;
  final String subtitle;

   final bool isRemediesNav;
}

class DailySkinCareRoutineViewModel extends ChangeNotifier {
  static const String _domainKey = 'skincare';

   bool get useConcernsSpeedometer => false;

  bool _loading = false;
  bool get loading => _loading;

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

  /// Optional heading for the concerns gauge (from `ai_concerns.title` when present).
  String? _concernsMeterHeading;
  String? get concernsMeterHeading => _concernsMeterHeading;

  List<SkincareRoutineExtraCard> _extraCards = [];
  List<SkincareRoutineExtraCard> get extraCards =>
      List.unmodifiable(_extraCards);

  int _selectedExtraIndex = -1;
  int get selectedExtraIndex => _selectedExtraIndex;

  List<Map<String, dynamic>> _skincareRemedies = [];
  List<Map<String, dynamic>> get skincareRemedies =>
      List.unmodifiable(_skincareRemedies);

  List<String> _skincareSafetyTips = [];
  List<String> get skincareSafetyTips =>
      List.unmodifiable(_skincareSafetyTips);

  List<Map<String, dynamic>> _skincareProducts = [];
  List<Map<String, dynamic>> get skincareProducts =>
      List.unmodifiable(_skincareProducts);

  static const List<String> _slotViews = ['front', 'back', 'right', 'left'];

  /// Bumped on every [loadSkincareRoutine] so an older in-flight request cannot
  /// overwrite state after a rescan / new navigation (singleton VM at app root).
  int _loadSeq = 0;
  bool _savingCompletion = false;

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

  void _notify() => notifyListeners();

  Future<void> loadSkincareRoutine() => _loadSkincareRoutine();
  void toggleTodayCheck(int index) => _toggleTodayCheck(index);
  void toggleNightCheck(int index) => _toggleNightCheck(index);
  void selectExtraCard(int index) => _selectExtraCard(index);

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

  /// UI row for [SkinTopProduct] / [ProductWidget] (tags = API `tags`).
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
