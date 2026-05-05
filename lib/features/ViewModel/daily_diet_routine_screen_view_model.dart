import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:looklabs/Core/Network/api_error_handler.dart';
import 'package:looklabs/Features/Widget/scan_food_widgert.dart';
import 'package:looklabs/Core/Constants/app_assets.dart';
import 'package:looklabs/Core/Routes/routes_name.dart';
import 'package:looklabs/Repository/diet_repository.dart';
import 'package:looklabs/Repository/domain_questions_repository.dart';
import 'package:looklabs/Repository/workout_completion_repository.dart';

class DailyDietRoutineScreenViewModel extends ChangeNotifier {
  bool _loading = false;
  String _insightText = '';
  String _routineSubtitle = '';
  bool _scanInProgress = false;
  String _flowDomain = 'diet';

  bool get loading => _loading;
  String get insightText => _insightText;
  String get routineSubtitle => _routineSubtitle;
  bool get scanInProgress => _scanInProgress;

  Future<void> initialize() async {
    if (_loading) return;
    _loading = true;
    notifyListeners();
    await DietRepository.instance.ensureFlowCacheLoaded();

    Map<String, dynamic>? payload;
    final cached = DietRepository.instance.cachedFlowPayload;
    if (cached != null && cached.isNotEmpty) {
      payload = cached;
      _flowDomain = _detectDomain(payload);
    } else {
      final flowRes = await DomainQuestionsRepository.instance.getDomainFlow(
        _flowDomain,
      );
      if (flowRes.success && flowRes.data is Map) {
        payload = Map<String, dynamic>.from(flowRes.data as Map);
        _flowDomain = _detectDomain(payload);
        final status = (payload['status']?.toString() ?? '').toLowerCase();
        if (status == 'processing' ||
            status == 'pending' ||
            status == 'in_progress') {
          final completed = await DomainQuestionsRepository.instance
              .pollDomainFlowUntilCompleted(
                _flowDomain,
                lastKnownResponse: payload,
              );
          if (completed != null) payload = Map<String, dynamic>.from(completed);
        }
      }
    }
    if (payload != null) {
      DietRepository.instance.setFlowCache(payload);
      _applyFlowPayload(payload);
      await _loadCompletionForToday();
    } else {
      // Keep strict API-driven behavior: clear when payload is unavailable.
      morningPlan.clear();
      eveningPlan.clear();
      _insightText = '';
      _routineSubtitle = '';
      _selectedKeys.clear();
    }
    _loading = false;
    notifyListeners();
  }

  void _applyFlowPayload(Map<String, dynamic> payload) {
    _flowDomain = _detectDomain(payload);
    final dailyRaw = payload['daily_plan'];
    final daily = dailyRaw is Map
        ? Map<String, dynamic>.from(dailyRaw)
        : <String, dynamic>{};
    final summaryRaw = payload['ai_summary'];
    final summary = summaryRaw is Map
        ? Map<String, dynamic>.from(summaryRaw)
        : <String, dynamic>{};
    final summarySubtitle = (summary['subtitle']?.toString() ?? '').trim().isEmpty
        ? (daily['subtitle']?.toString() ?? '').trim()
        : (summary['subtitle']?.toString() ?? '').trim();
    _routineSubtitle = summarySubtitle.isNotEmpty
        ? summarySubtitle
        : 'Healthy eating habits for better nutrition & energy';
    final dailyInsight = (daily['insight_text']?.toString() ?? '').trim();
    if (dailyInsight.isNotEmpty) {
      _insightText = dailyInsight;
    } else {
      final aiMessage = (payload['ai_message']?.toString() ?? '').trim();
      if (aiMessage.isNotEmpty) _insightText = aiMessage;
    }
    _selectedKeys.clear();
    final morning = _parseItems(daily['morning']);
    final evening = _parseItems(daily['evening']);
    if (morning.isNotEmpty || evening.isNotEmpty) {
      morningPlan
        ..clear()
        ..addAll(morning);
      eveningPlan
        ..clear()
        ..addAll(evening);
      return;
    }

    // Fallback mapping for fashion flow where daily_plan contains weekly_plan + seasonal_style.
    final weeklyRaw = daily['weekly_plan'];
    final weeklyItems = _parseWeeklyItems(weeklyRaw, daily);
    morningPlan
      ..clear()
      ..addAll(weeklyItems.take(4));
    eveningPlan
      ..clear()
      ..addAll(weeklyItems.skip(4));
  }

  List<Map<String, dynamic>> _parseItems(dynamic raw) {
    if (raw is! List) return [];
    final out = <Map<String, dynamic>>[];
    for (final row in raw) {
      if (row is! Map) continue;
      final m = Map<String, dynamic>.from(row);
      final title = (m['title']?.toString() ?? '').trim();
      if (title.isEmpty) continue;
      final duration = (m['duration']?.toString() ?? '').trim();
      final subtitleText = (m['subtitle']?.toString() ?? '').trim().isEmpty
          ? (m['description']?.toString() ?? '')
          : m['subtitle'].toString();
      if (m['completed'] == true) {
        final seq = (m['seq'] is num) ? (m['seq'] as num).toInt() : null;
        if (seq != null && seq > 0) {
          // Resolve section+index in toggle key space via parse order.
          // Key assignment happens in section build where index is zero-based.
          // We keep a temporary marker in row for later extraction.
          m['_completed_seq'] = seq;
        }
      }
      out.add({
        'title': title,
        'subtitle': duration.isEmpty ? subtitleText : '$subtitleText • $duration',
        'details': (m['description']?.toString() ?? '').trim(),
        '_completed': m['completed'] == true,
      });
    }
    return out;
  }

  Future<void> showTransparentDialog(BuildContext context) async {
    if (_scanInProgress) return;
    final source = await showDialog<ImageSource>(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (dialogContext) {
        return Scaffold(
          backgroundColor: Colors.black.withValues(alpha: 0.5),
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ScanFoodWidget(
                  text: 'Scan Food',
                  icon: AppAssets.sacnIcon,
                  onTap: () => Navigator.pop(dialogContext, ImageSource.camera),
                ),
                const SizedBox(height: 12),
                ScanFoodWidget(
                  text: 'Scan Barcode',
                  icon: AppAssets.mealIcon,
                  onTap: () => Navigator.pop(dialogContext, ImageSource.camera),
                ),
                const SizedBox(height: 12),
                ScanFoodWidget(
                  text: 'Gallery',
                  icon: AppAssets.galleryIcon,
                  onTap: () => Navigator.pop(dialogContext, ImageSource.gallery),
                ),
              ],
            ),
          ),
        );
      },
    );
    if (source == null || !context.mounted) return;
    await _captureAndGenerateMealPlan(context, source);
  }

  Future<void> _captureAndGenerateMealPlan(
    BuildContext context,
    ImageSource source,
  ) async {
    final picker = ImagePicker();
    final xFile = await picker.pickImage(
      source: source,
      maxWidth: 2048,
      maxHeight: 2048,
      imageQuality: 85,
    );
    if (xFile == null || !context.mounted) return;

    _scanInProgress = true;
    notifyListeners();

    try {
      await DietRepository.instance.ensureFlowCacheLoaded();
      Map<String, dynamic>? preFlowPayload;
      final preFlowRes = await DomainQuestionsRepository.instance.getDomainFlow(
        _flowDomain,
      );
      if (preFlowRes.success && preFlowRes.data is Map) {
        preFlowPayload = Map<String, dynamic>.from(preFlowRes.data as Map);
      }

      final params = DietRepository.instance.planParamsFromDietFlow(
        preFlowPayload,
      );
      final generateRes = await DietRepository.instance.generateMealPlan(
        focus: params['focus']?.toString() ?? 'build_muscle',
        calorieTarget: params['calorie_target'] is int
            ? params['calorie_target'] as int
            : 1200,
        mealCount: params['meal_count'] is int ? params['meal_count'] as int : 3,
        snackCount: params['snack_count'] is int
            ? params['snack_count'] as int
            : 2,
        dietaryPreferences:
            (params['dietary_preferences'] as List?)
                ?.map((e) => e.toString())
                .toList() ??
            const <String>[],
        allergies:
            (params['allergies'] as List?)?.map((e) => e.toString()).toList() ??
            const <String>[],
        cuisinePreference: params['cuisine_preference']?.toString() ?? '',
      );
      if (!context.mounted) return;
      if (!generateRes.success) {
        _showSnack(
          context,
          generateRes.userMessageOrFallback('Unable to generate meal plan'),
        );
        return;
      }

      final flowRes = await DomainQuestionsRepository.instance.getDomainFlow(
        _flowDomain,
      );

      Map<String, dynamic>? payload;
      if (flowRes.success && flowRes.data is Map) {
        payload = Map<String, dynamic>.from(flowRes.data as Map);
        final status = (payload['status']?.toString() ?? '').toLowerCase();
        if (status == 'processing' ||
            status == 'pending' ||
            status == 'in_progress') {
          final completed = await DomainQuestionsRepository.instance
              .pollDomainFlowUntilCompleted(
                _flowDomain,
                lastKnownResponse: payload,
              );
          if (completed != null) {
            payload = Map<String, dynamic>.from(completed);
          }
        }
      }

      if (payload == null && generateRes.data is Map) {
        payload = Map<String, dynamic>.from(generateRes.data as Map);
      }

      if (!context.mounted) return;
      if (payload != null) {
        DietRepository.instance.setFlowCache(payload);
      }
      Navigator.pushNamed(context, RoutesName.DietResultScreen, arguments: payload);
    } finally {
      _scanInProgress = false;
      notifyListeners();
    }
  }

  void _showSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  final List<Map<String, dynamic>> morningPlan = [];
  final List<Map<String, dynamic>> eveningPlan = [];

  final Set<String> _selectedKeys = <String>{};
  String _expandedKey = '';
  bool _persistInFlight = false;
  bool _persistCoalesce = false;

  int _globalIndexForKey(String key) {
    final parts = key.split('_');
    if (parts.length != 2) return -1;
    final section = parts[0];
    final idx = int.tryParse(parts[1]) ?? -1;
    if (idx < 0) return -1;
    if (section == 'morning') return idx;
    if (section == 'evening') return morningPlan.length + idx;
    return -1;
  }

  String _keyForGlobalIndex(int global) {
    if (global < 0) return '';
    if (global < morningPlan.length) return 'morning_$global';
    final eveningIndex = global - morningPlan.length;
    if (eveningIndex >= 0 && eveningIndex < eveningPlan.length) {
      return 'evening_$eveningIndex';
    }
    return '';
  }

  Set<int> _selectedGlobalIndices() {
    final out = <int>{};
    for (final key in _selectedKeys) {
      final idx = _globalIndexForKey(key);
      if (idx >= 0) out.add(idx);
    }
    return out;
  }

  int get _totalExercises => morningPlan.length + eveningPlan.length;

  Future<void> _loadCompletionForToday() async {
    // Seed checklist from backend completed flags first.
    for (var i = 0; i < morningPlan.length; i++) {
      if (morningPlan[i]['_completed'] == true) {
        _selectedKeys.add('morning_$i');
      }
    }
    for (var i = 0; i < eveningPlan.length; i++) {
      if (eveningPlan[i]['_completed'] == true) {
        _selectedKeys.add('evening_$i');
      }
    }
    if (_totalExercises <= 0) return;
    final done = await WorkoutCompletionRepository.instance.loadCompleted(
      DateTime.now(),
      domain: _flowDomain,
    );
    if (done == null) return;
    for (final idx in done) {
      final key = _keyForGlobalIndex(idx);
      if (key.isNotEmpty) _selectedKeys.add(key);
    }
  }

  Future<void> _persistSelection() async {
    if (_persistInFlight) {
      _persistCoalesce = true;
      return;
    }
    _persistInFlight = true;
    try {
      do {
        _persistCoalesce = false;
        await WorkoutCompletionRepository.instance.saveCompleted(
          DateTime.now(),
          _selectedGlobalIndices(),
          domain: _flowDomain,
          totalExercises: _totalExercises,
        );
      } while (_persistCoalesce);
    } finally {
      _persistInFlight = false;
    }
  }

  void togglePlanDone(String key) {
    if (_selectedKeys.contains(key)) {
      _selectedKeys.remove(key);
    } else {
      _selectedKeys.add(key);
    }
    notifyListeners();
    _persistSelection();
  }

  void toggleExpand(String key) {
    _expandedKey = _expandedKey == key ? '' : key;
    notifyListeners();
  }

  bool isPlanSelected(String key) => _selectedKeys.contains(key);
  bool isExpanded(String key) => _expandedKey == key;

  String _detectDomain(Map<String, dynamic> payload) {
    final progressRaw = payload['progress'];
    if (progressRaw is Map) {
      final d = (progressRaw['domain']?.toString() ?? '').trim().toLowerCase();
      if (d.isNotEmpty) return d;
    }
    final d = (payload['domain']?.toString() ?? '').trim().toLowerCase();
    return d.isEmpty ? 'diet' : d;
  }

  List<Map<String, dynamic>> _parseWeeklyItems(
    dynamic raw,
    Map<String, dynamic> daily,
  ) {
    if (raw is! List) return [];
    final seasonalStyleRaw = daily['seasonal_style'];
    final seasonalStyle = seasonalStyleRaw is Map
        ? Map<String, dynamic>.from(seasonalStyleRaw)
        : <String, dynamic>{};
    final defaultSeason = (daily['default_season']?.toString() ?? '').trim();
    final seasonDataRaw = seasonalStyle[defaultSeason];
    final seasonData = seasonDataRaw is Map
        ? Map<String, dynamic>.from(seasonDataRaw)
        : <String, dynamic>{};
    final details = _seasonDetails(seasonData);

    final out = <Map<String, dynamic>>[];
    for (final row in raw) {
      if (row is! Map) continue;
      final m = Map<String, dynamic>.from(row);
      final day = (m['day']?.toString() ?? '').trim();
      final theme = (m['theme']?.toString() ?? '').trim();
      if (day.isEmpty && theme.isEmpty) continue;
      out.add({
        'title': day.isEmpty ? theme : day,
        'subtitle': theme,
        'details': details,
        '_completed': m['completed'] == true,
      });
    }
    return out;
  }

  String _seasonDetails(Map<String, dynamic> seasonData) {
    final outfits = _listToText(seasonData['outfit_combinations']);
    final fabrics = _listToText(seasonData['recommended_fabrics']);
    final footwear = _listToText(seasonData['footwear']);
    final parts = <String>[];
    if (outfits.isNotEmpty) parts.add('Outfits: $outfits');
    if (fabrics.isNotEmpty) parts.add('Fabrics: $fabrics');
    if (footwear.isNotEmpty) parts.add('Footwear: $footwear');
    return parts.join('\n');
  }

  String _listToText(dynamic raw) {
    if (raw is! List) return '';
    final values = raw
        .map((e) => (e?.toString() ?? '').trim())
        .where((e) => e.isNotEmpty)
        .toList();
    return values.join(', ');
  }
}
