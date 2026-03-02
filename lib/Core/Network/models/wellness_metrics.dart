/// Response from GET onboarding/users/me/wellness (requires auth).
class WellnessMetrics {
  final String dailyQuote;
  final String height;
  final String sleepHours;
  final String waterIntake;
  final String weight;

  const WellnessMetrics({
    this.dailyQuote = '',
    this.height = '',
    this.sleepHours = '',
    this.waterIntake = '',
    this.weight = '',
  });

  factory WellnessMetrics.fromJson(Map<String, dynamic> json) {
    return WellnessMetrics(
      dailyQuote: json['daily_quote']?.toString() ?? '',
      height: json['height']?.toString() ?? '',
      sleepHours: json['sleep_hours']?.toString() ?? '',
      waterIntake: json['water_intake']?.toString() ?? '',
      weight: json['weight']?.toString() ?? '',
    );
  }
}
