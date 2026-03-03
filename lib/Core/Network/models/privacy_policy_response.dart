/// Response from GET /api/v1/legal/privacy-policy (no auth required).
class PrivacyPolicyResponse {
  final String version;
  final String lastUpdated;
  final List<PrivacyPolicySection> sections;

  const PrivacyPolicyResponse({
    this.version = '',
    this.lastUpdated = '',
    this.sections = const [],
  });

  factory PrivacyPolicyResponse.fromJson(Map<String, dynamic> json) {
    final sectionsList = json['sections'];
    List<PrivacyPolicySection> sections = [];
    if (sectionsList is List) {
      for (final e in sectionsList) {
        if (e is Map<String, dynamic>) {
          sections.add(PrivacyPolicySection.fromJson(e));
        } else if (e is Map) {
          sections.add(PrivacyPolicySection.fromJson(Map<String, dynamic>.from(e)));
        }
      }
    }
    return PrivacyPolicyResponse(
      version: json['version']?.toString() ?? '',
      lastUpdated: json['lastUpdated']?.toString() ?? '',
      sections: sections,
    );
  }
}

class PrivacyPolicySection {
  final String id;
  final String title;
  final String body;

  const PrivacyPolicySection({
    this.id = '',
    this.title = '',
    this.body = '',
  });

  factory PrivacyPolicySection.fromJson(Map<String, dynamic> json) {
    return PrivacyPolicySection(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      body: json['body']?.toString() ?? '',
    );
  }
}
