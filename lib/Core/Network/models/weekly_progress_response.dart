/// Response from GET users/me/progress/weekly (requires auth).
/// API returns: { "user_id", "domains": [ { "domain", "score", "has_data", "icon_url" }, ... ], "weekly_average" }.
class WeeklyProgressResponse {
  final List<WeeklyProgressDay> days;
  final List<WeeklyProgressDomain> domains;
  final List<String> labels;
  final List<num> scores;
  final int? userId;
  final double? weekAverage;

  const WeeklyProgressResponse({
    this.days = const [],
    this.domains = const [],
    this.labels = const [],
    this.scores = const [],
    this.userId,
    this.weekAverage,
  });

  factory WeeklyProgressResponse.fromJson(Map<String, dynamic> json) {
    List<WeeklyProgressDay> days = [];
    if (json['days'] is List) {
      for (final e in json['days'] as List) {
        if (e is Map<String, dynamic>) {
          days.add(WeeklyProgressDay.fromJson(e));
        } else if (e is Map) {
          days.add(WeeklyProgressDay.fromJson(Map<String, dynamic>.from(e)));
        }
      }
    }
    List<WeeklyProgressDomain> domains = [];
    if (json['domains'] is List) {
      for (final e in json['domains'] as List) {
        if (e is Map<String, dynamic>) {
          domains.add(WeeklyProgressDomain.fromJson(e));
        } else if (e is Map) {
          domains.add(WeeklyProgressDomain.fromJson(Map<String, dynamic>.from(e)));
        }
      }
    }
    List<String> labels = [];
    if (json['labels'] is List) {
      labels = (json['labels'] as List)
          .map((e) => e?.toString() ?? '')
          .toList()
          .cast<String>();
    }
    List<num> scores = [];
    if (json['scores'] is List) {
      for (final e in json['scores'] as List) {
        if (e is num) {
          scores.add(e);
        } else {
          scores.add((e is int) ? e : (double.tryParse(e?.toString() ?? '') ?? 0));
        }
      }
    }
    final userId = json['user_id'] is int
        ? json['user_id'] as int
        : int.tryParse(json['user_id']?.toString() ?? '');
    final weekAverage = json['weekly_average'] is num
        ? (json['weekly_average'] as num).toDouble()
        : double.tryParse(json['weekly_average']?.toString() ?? '');
    return WeeklyProgressResponse(
      days: days,
      domains: domains,
      labels: labels,
      scores: scores,
      userId: userId,
      weekAverage: weekAverage,
    );
  }
}

/// Domain progress item from API: { "domain", "score", "has_data", "icon_url" }.
class WeeklyProgressDomain {
  final String domain;
  final num score;
  final bool hasData;
  final String? iconUrl;

  const WeeklyProgressDomain({
    this.domain = '',
    this.score = 0,
    this.hasData = false,
    this.iconUrl,
  });

  factory WeeklyProgressDomain.fromJson(Map<String, dynamic> json) {
    return WeeklyProgressDomain(
      domain: json['domain']?.toString().trim() ?? '',
      score: json['score'] is num
          ? json['score'] as num
          : (double.tryParse(json['score']?.toString() ?? '') ?? 0),
      hasData: json['has_data'] == true,
      iconUrl: json['icon_url']?.toString().trim().isNotEmpty == true
          ? json['icon_url']?.toString().trim()
          : null,
    );
  }
}

class WeeklyProgressDay {
  final String date;
  final String day;
  final num score;

  const WeeklyProgressDay({
    this.date = '',
    this.day = '',
    this.score = 0,
  });

  factory WeeklyProgressDay.fromJson(Map<String, dynamic> json) {
    return WeeklyProgressDay(
      date: json['date']?.toString() ?? '',
      day: json['day']?.toString() ?? '',
      score: json['score'] is num
          ? json['score'] as num
          : (int.tryParse(json['score']?.toString() ?? '') ?? 0),
    );
  }
}
