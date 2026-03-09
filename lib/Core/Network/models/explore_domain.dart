/// Single domain from GET domains/explore API.
/// API returns: { "key", "name", "subtitle", "icon_url" }.
class ExploreDomain {
  final String key;
  final String name;
  final String subtitle;
  final String? iconUrl;

  const ExploreDomain({
    required this.key,
    required this.name,
    required this.subtitle,
    this.iconUrl,
  });

  factory ExploreDomain.fromJson(Map<String, dynamic> json) {
    return ExploreDomain(
      key: json['key']?.toString().trim() ?? '',
      name: json['name']?.toString().trim() ?? '',
      subtitle: json['subtitle']?.toString().trim() ?? '',
      iconUrl: json['icon_url']?.toString().trim().isNotEmpty == true
          ? json['icon_url']?.toString().trim()
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'key': key,
        'name': name,
        'subtitle': subtitle,
        'icon_url': iconUrl,
      };
}
