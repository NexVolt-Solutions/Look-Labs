/// Response from GET domains/progress/overview (requires auth).
/// Returns per-domain progress (answered_questions, progress_percent, is_completed).
class DomainProgressOverviewResponse {
  final int? userId;
  final List<DomainProgressItem> domains;
  final double? overallAverage;
  final int? domainsStarted;
  final int? domainsCompleted;
  final int? totalDomains;

  const DomainProgressOverviewResponse({
    this.userId,
    this.domains = const [],
    this.overallAverage,
    this.domainsStarted,
    this.domainsCompleted,
    this.totalDomains,
  });

  factory DomainProgressOverviewResponse.fromJson(Map<String, dynamic> json) {
    List<DomainProgressItem> domainsList = [];
    if (json['domains'] is List) {
      for (final e in json['domains'] as List) {
        if (e is Map<String, dynamic>) {
          domainsList.add(DomainProgressItem.fromJson(e));
        } else if (e is Map) {
          domainsList.add(
              DomainProgressItem.fromJson(Map<String, dynamic>.from(e)));
        }
      }
    }
    return DomainProgressOverviewResponse(
      userId: json['user_id'] is int
          ? json['user_id'] as int
          : int.tryParse(json['user_id']?.toString() ?? ''),
      domains: domainsList,
      overallAverage: json['overall_average'] is num
          ? (json['overall_average'] as num).toDouble()
          : double.tryParse(json['overall_average']?.toString() ?? ''),
      domainsStarted: json['domains_started'] is int
          ? json['domains_started'] as int
          : int.tryParse(json['domains_started']?.toString() ?? ''),
      domainsCompleted: json['domains_completed'] is int
          ? json['domains_completed'] as int
          : int.tryParse(json['domains_completed']?.toString() ?? ''),
      totalDomains: json['total_domains'] is int
          ? json['total_domains'] as int
          : int.tryParse(json['total_domains']?.toString() ?? ''),
    );
  }
}

/// Single domain from domains/progress/overview.
class DomainProgressItem {
  final String domain;
  final String? iconUrl;
  final double progressPercent;
  final int answeredQuestions;
  final int totalQuestions;
  final bool isCompleted;

  const DomainProgressItem({
    this.domain = '',
    this.iconUrl,
    this.progressPercent = 0,
    this.answeredQuestions = 0,
    this.totalQuestions = 0,
    this.isCompleted = false,
  });

  factory DomainProgressItem.fromJson(Map<String, dynamic> json) {
    return DomainProgressItem(
      domain: json['domain']?.toString().trim() ?? '',
      iconUrl: json['icon_url']?.toString().trim().isNotEmpty == true
          ? json['icon_url']?.toString().trim()
          : null,
      progressPercent: json['progress_percent'] is num
          ? (json['progress_percent'] as num).toDouble()
          : double.tryParse(json['progress_percent']?.toString() ?? '0') ?? 0,
      answeredQuestions: json['answered_questions'] is int
          ? json['answered_questions'] as int
          : int.tryParse(json['answered_questions']?.toString() ?? '0') ?? 0,
      totalQuestions: json['total_questions'] is int
          ? json['total_questions'] as int
          : int.tryParse(json['total_questions']?.toString() ?? '0') ?? 0,
      isCompleted: json['is_completed'] == true,
    );
  }
}
