/// Response from GET onboarding/users/me/wellness (requires auth).
/// API returns height, weight, sleep_hours, water_intake as { value, icon_url }; daily_quote as string.
class WellnessMetrics {
  final String dailyQuote;
  final String height;
  final String sleepHours;
  final String waterIntake;
  final String weight;
  final String? heightIconUrl;
  final String? weightIconUrl;
  final String? sleepHoursIconUrl;
  final String? waterIntakeIconUrl;

  const WellnessMetrics({
    this.dailyQuote = '',
    this.height = '',
    this.sleepHours = '',
    this.waterIntake = '',
    this.weight = '',
    this.heightIconUrl,
    this.weightIconUrl,
    this.sleepHoursIconUrl,
    this.waterIntakeIconUrl,
  });

  static String _valueFrom(dynamic field) {
    if (field == null) return '';
    if (field is Map) {
      final v = field['value'];
      return v?.toString().trim() ?? '';
    }
    return field.toString().trim();
  }

  static String? _iconUrlFrom(dynamic field) {
    if (field is! Map) return null;
    final v = field['icon_url'];
    final s = v?.toString().trim();
    return s != null && s.isNotEmpty ? s : null;
  }

  Map<String, dynamic> toJson() => {
        'daily_quote': dailyQuote,
        'height': {
          'value': height,
          if (heightIconUrl != null) 'icon_url': heightIconUrl,
        },
        'weight': {
          'value': weight,
          if (weightIconUrl != null) 'icon_url': weightIconUrl,
        },
        'sleep_hours': {
          'value': sleepHours,
          if (sleepHoursIconUrl != null) 'icon_url': sleepHoursIconUrl,
        },
        'water_intake': {
          'value': waterIntake,
          if (waterIntakeIconUrl != null) 'icon_url': waterIntakeIconUrl,
        },
      };

  factory WellnessMetrics.fromJson(Map<String, dynamic> json) {
    final heightField = json['height'];
    final weightField = json['weight'];
    final sleepField = json['sleep_hours'];
    final waterField = json['water_intake'];
    return WellnessMetrics(
      dailyQuote: json['daily_quote']?.toString() ?? '',
      height: _valueFrom(heightField),
      weight: _valueFrom(weightField),
      sleepHours: _valueFrom(sleepField),
      waterIntake: _valueFrom(waterField),
      heightIconUrl: _iconUrlFrom(heightField),
      weightIconUrl: _iconUrlFrom(weightField),
      sleepHoursIconUrl: _iconUrlFrom(sleepField),
      waterIntakeIconUrl: _iconUrlFrom(waterField),
    );
  }
}
