class RecoveryTaskItem {
  const RecoveryTaskItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.duration,
    required this.completed,
    required this.order,
  });

  final String id;
  final String title;
  final String subtitle;
  final String duration;
  final bool completed;
  final int order;
}

class RecoveryStreakData {
  const RecoveryStreakData({
    required this.currentStreak,
    required this.longestStreak,
    required this.nextGoal,
    required this.streakMessage,
  });

  final int currentStreak;
  final int longestStreak;
  final int nextGoal;
  final String streakMessage;
}

class RecoveryPathUiData {
  const RecoveryPathUiData({
    required this.insightText,
    required this.streak,
    required this.dailyPlanItems,
    required this.exerciseItems,
  });

  final String insightText;
  final RecoveryStreakData streak;
  final List<RecoveryTaskItem> dailyPlanItems;
  final List<RecoveryTaskItem> exerciseItems;

  factory RecoveryPathUiData.empty() {
    return const RecoveryPathUiData(
      insightText: '',
      streak: RecoveryStreakData(
        currentStreak: 0,
        longestStreak: 0,
        nextGoal: 0,
        streakMessage: '',
      ),
      dailyPlanItems: [],
      exerciseItems: [],
    );
  }
}
