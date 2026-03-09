/// Response from GET users/me/progress/graph?period=weekly|monthly|yearly (requires auth).
/// first_score = Before Progress (static), latest_score = After Progress (updates when AI re-runs).
class ProgressGraphResponse {
  final String period;
  final List<ProgressGraphDomain> domains;
  final num overallFirst;
  final num overallLatest;
  final num overallChange;

  const ProgressGraphResponse({
    this.period = 'weekly',
    this.domains = const [],
    this.overallFirst = 0,
    this.overallLatest = 0,
    this.overallChange = 0,
  });

  factory ProgressGraphResponse.fromJson(Map<String, dynamic> json) {
    List<ProgressGraphDomain> domainsList = [];
    if (json['domains'] is List) {
      for (final e in json['domains'] as List) {
        if (e is Map<String, dynamic>) {
          domainsList.add(ProgressGraphDomain.fromJson(e));
        } else if (e is Map) {
          domainsList.add(
              ProgressGraphDomain.fromJson(Map<String, dynamic>.from(e)));
        }
      }
    }
    final overallFirst = json['overall_first'] is num
        ? json['overall_first'] as num
        : (double.tryParse(json['overall_first']?.toString() ?? '') ?? 0);
    final overallLatest = json['overall_latest'] is num
        ? json['overall_latest'] as num
        : (double.tryParse(json['overall_latest']?.toString() ?? '') ?? 0);
    final overallChange = json['overall_change'] is num
        ? json['overall_change'] as num
        : (double.tryParse(json['overall_change']?.toString() ?? '') ?? 0);
    return ProgressGraphResponse(
      period: json['period']?.toString() ?? 'weekly',
      domains: domainsList,
      overallFirst: overallFirst,
      overallLatest: overallLatest,
      overallChange: overallChange,
    );
  }
}

/// Per-domain graph data: scores history, first_score, latest_score, change.
class ProgressGraphDomain {
  final String domain;
  final String? iconUrl;
  final List<ProgressGraphScorePoint> scores;
  final num firstScore;
  final num latestScore;
  final num change;

  const ProgressGraphDomain({
    this.domain = '',
    this.iconUrl,
    this.scores = const [],
    this.firstScore = 0,
    this.latestScore = 0,
    this.change = 0,
  });

  factory ProgressGraphDomain.fromJson(Map<String, dynamic> json) {
    List<ProgressGraphScorePoint> scoresList = [];
    if (json['scores'] is List) {
      for (final e in json['scores'] as List) {
        if (e is Map<String, dynamic>) {
          scoresList.add(ProgressGraphScorePoint.fromJson(e));
        } else if (e is Map) {
          scoresList.add(
              ProgressGraphScorePoint.fromJson(Map<String, dynamic>.from(e)));
        }
      }
    }
    final firstScore = json['first_score'] is num
        ? json['first_score'] as num
        : (double.tryParse(json['first_score']?.toString() ?? '') ?? 0);
    final latestScore = json['latest_score'] is num
        ? json['latest_score'] as num
        : (double.tryParse(json['latest_score']?.toString() ?? '') ?? 0);
    final change = json['change'] is num
        ? json['change'] as num
        : (double.tryParse(json['change']?.toString() ?? '') ?? 0);
    return ProgressGraphDomain(
      domain: json['domain']?.toString().trim() ?? '',
      iconUrl: json['icon_url']?.toString().trim().isNotEmpty == true
          ? json['icon_url']?.toString().trim()
          : null,
      scores: scoresList,
      firstScore: firstScore,
      latestScore: latestScore,
      change: change,
    );
  }
}

/// Single score point: score and recorded_at.
class ProgressGraphScorePoint {
  final String domain;
  final num score;
  final String recordedAt;

  const ProgressGraphScorePoint({
    this.domain = '',
    this.score = 0,
    this.recordedAt = '',
  });

  factory ProgressGraphScorePoint.fromJson(Map<String, dynamic> json) {
    return ProgressGraphScorePoint(
      domain: json['domain']?.toString().trim() ?? '',
      score: json['score'] is num
          ? json['score'] as num
          : (double.tryParse(json['score']?.toString() ?? '') ?? 0),
      recordedAt: json['recorded_at']?.toString() ?? '',
    );
  }
}
