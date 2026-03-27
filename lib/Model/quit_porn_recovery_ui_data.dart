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

  factory RecoveryPathUiData.fallback() {
    return const RecoveryPathUiData(
      insightText: 'One day at a time. Keep going!',
      streak: RecoveryStreakData(
        currentStreak: 0,
        longestStreak: 0,
        nextGoal: 0,
        streakMessage: 'Today is day one. Let\'s make it count!',
      ),
      dailyPlanItems: [
        RecoveryTaskItem(
          id: 'daily_0',
          title: 'Set Your Daily Intention',
          subtitle: 'Take 2 minutes to write down your intention.',
          duration: '2 min',
          completed: false,
          order: 1,
        ),
        RecoveryTaskItem(
          id: 'daily_1',
          title: 'Evening Reflection',
          subtitle: 'Write 3 wins from today, no matter how small.',
          duration: '5 min',
          completed: false,
          order: 2,
        ),
      ],
      exerciseItems: [
        RecoveryTaskItem(
          id: 'exercise_0',
          title: 'Box Breathing',
          subtitle: 'Breathe in 4, hold 4, out 4, hold 4.',
          duration: '5 min',
          completed: false,
          order: 1,
        ),
      ],
    );
  }
}
