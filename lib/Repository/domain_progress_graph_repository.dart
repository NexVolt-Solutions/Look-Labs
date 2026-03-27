import 'package:looklabs/Core/Network/models/progress_graph_response.dart';
import 'package:looklabs/Model/sales_data.dart';
import 'package:looklabs/Repository/onboarding_repository.dart';

/// Shared repository for domain-scoped progress graph APIs.
/// Uses GET `domains/{domain}/progress/graph?period=...` and converts to UI series.
class DomainProgressGraphRepository {
  DomainProgressGraphRepository._();

  static final DomainProgressGraphRepository instance =
      DomainProgressGraphRepository._();

  static String periodLabelToApi(String label) {
    switch (label.toLowerCase()) {
      case 'month':
        return 'monthly';
      case 'year':
        return 'yearly';
      default:
        return 'weekly';
    }
  }

  static String labelFromRecordedAt(String recordedAt, String periodLabel) {
    final dt = DateTime.tryParse(recordedAt);
    if (dt == null) return recordedAt;
    switch (periodLabel.toLowerCase()) {
      case 'year':
        const m = [
          'Jan',
          'Feb',
          'Mar',
          'Apr',
          'May',
          'Jun',
          'Jul',
          'Aug',
          'Sep',
          'Oct',
          'Nov',
          'Dec',
        ];
        return m[dt.month - 1];
      case 'month':
        return '${dt.month}/${dt.day}';
      default:
        const d = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
        return d[dt.weekday - 1];
    }
  }

  static List<SalesData> _bucketScores(
    List<ProgressGraphScorePoint> scores,
    String periodLabel,
  ) {
    final period = periodLabel.toLowerCase();
    final bucketSum = <String, double>{};
    final bucketCount = <String, int>{};

    void addValue(String key, double value) {
      bucketSum[key] = (bucketSum[key] ?? 0) + value;
      bucketCount[key] = (bucketCount[key] ?? 0) + 1;
    }

    for (final s in scores) {
      final dt = DateTime.tryParse(s.recordedAt);
      if (dt == null) continue;
      final v = s.score.toDouble();
      if (period == 'year') {
        const months = [
          'Jan',
          'Feb',
          'Mar',
          'Apr',
          'May',
          'Jun',
          'Jul',
          'Aug',
          'Sep',
          'Oct',
          'Nov',
          'Dec',
        ];
        addValue(months[dt.month - 1], v);
      } else if (period == 'month') {
        final week = ((dt.day - 1) ~/ 7) + 1;
        addValue('Week $week', v);
      } else {
        const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
        addValue(days[dt.weekday - 1], v);
      }
    }

    List<String> order;
    if (period == 'year') {
      order = const [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
    } else if (period == 'month') {
      order = const ['Week 1', 'Week 2', 'Week 3', 'Week 4', 'Week 5'];
    } else {
      order = const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    }

    final points = <SalesData>[];
    for (final k in order) {
      final sum = bucketSum[k];
      final count = bucketCount[k];
      final value = (sum == null || count == null || count == 0)
          ? 0.0
          : (sum / count);
      points.add(SalesData(k, value));
    }
    return points;
  }

  Future<ProgressGraphDomain?> getDomainGraph({
    required String domain,
    required String periodLabel,
  }) async {
    final response = await OnboardingRepository.instance.getDomainProgressGraph(
      domain: domain,
      period: periodLabelToApi(periodLabel),
    );
    if (!response.success || response.data is! ProgressGraphDomain) {
      return null;
    }
    return response.data as ProgressGraphDomain;
  }

  Future<List<SalesData>> getDomainChartPoints({
    required String domain,
    required String periodLabel,
  }) async {
    final graph = await getDomainGraph(
      domain: domain,
      periodLabel: periodLabel,
    );
    if (graph == null) return const [];

    if (graph.scores.isNotEmpty) {
      final bucketed = _bucketScores(graph.scores, periodLabel);
      if (bucketed.isNotEmpty) return bucketed;
      return graph.scores
          .map(
            (s) => SalesData(
              labelFromRecordedAt(s.recordedAt, periodLabel),
              s.score.toDouble(),
            ),
          )
          .toList();
    }
    return _bucketScores(const [], periodLabel);
  }
}
