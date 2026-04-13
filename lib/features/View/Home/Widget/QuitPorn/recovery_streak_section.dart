import 'package:flutter/material.dart';
import 'package:looklabs/Core/Constants/app_assets.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Features/Widget/normal_text.dart';
import 'package:looklabs/Features/Widget/plan_container.dart';
import 'package:looklabs/Features/Widget/streak_widget.dart';
import 'package:looklabs/Model/quit_porn_recovery_ui_data.dart';

class RecoveryStreakSection extends StatelessWidget {
  const RecoveryStreakSection({super.key, required this.streak});

  final RecoveryStreakData streak;

  @override
  Widget build(BuildContext context) {
    return PlanContainer(
      margin: context.paddingSymmetricR(vertical: 0),
      padding: context.paddingSymmetricR(horizontal: 12, vertical: 16),
      isSelected: false,
      onTap: () {},
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StreakWidget(
            image: AppAssets.fatLossIcon,
            title: 'Current Streak',
            richTitle: '${streak.currentStreak}',
            richSubTitle: ' days',
          ),
          SizedBox(height: context.sh(6)),
          Divider(color: AppColors.iconColor, thickness: 0.5),
          SizedBox(height: context.sh(4)),
          NormalText(
            titleText: streak.streakMessage,
            titleSize: context.sp(12),
            titleWeight: FontWeight.w400,
            titleColor: AppColors.iconColor,
          ),
          SizedBox(height: context.sh(8)),
          Row(
            children: [
              Expanded(
                child: PlanContainer(
                  margin: context.paddingSymmetricR(horizontal: 4),
                  padding: context.paddingSymmetricR(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  radius: BorderRadius.circular(context.radiusR(10)),
                  isSelected: false,
                  onTap: () {},
                  child: StreakWidget(
                    image: AppAssets.tropyIcon,
                    title: 'Longest Streak',
                    richTitle: '${streak.longestStreak}',
                    richSubTitle: ' days',
                    titleSize: context.sp(12),
                    richTitleSize: context.sp(14),
                    richSubTitleSize: context.sp(14),
                  ),
                ),
              ),
              Expanded(
                child: PlanContainer(
                  margin: context.paddingSymmetricR(horizontal: 4),
                  padding: context.paddingSymmetricR(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  radius: BorderRadius.circular(context.radiusR(10)),
                  isSelected: false,
                  onTap: () {},
                  child: StreakWidget(
                    image: AppAssets.goalsIcon,
                    title: 'Next Goal',
                    richTitle: '${streak.nextGoal}',
                    richSubTitle: ' days',
                    titleSize: context.sp(12),
                    richTitleSize: context.sp(14),
                    richSubTitleSize: context.sp(14),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
