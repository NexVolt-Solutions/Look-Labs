import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:looklabs/Core/Constants/app_assets.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Features/Widget/normal_text.dart';
import 'package:looklabs/Features/Widget/plan_container.dart';
import 'package:looklabs/Model/quit_porn_recovery_ui_data.dart';

class RecoveryTaskList extends StatelessWidget {
  const RecoveryTaskList({
    super.key,
    required this.selectedSection,
    required this.taskItems,
    required this.taskDone,
    required this.onToggleDaily,
    required this.onToggleExercise,
  });

  final String selectedSection;
  final List<RecoveryTaskItem> taskItems;
  final List<bool> taskDone;
  final ValueChanged<int> onToggleDaily;
  final ValueChanged<int> onToggleExercise;

  @override
  Widget build(BuildContext context) {
    return PlanContainer(
      margin: context.paddingSymmetricR(vertical: 0),
      padding: context.paddingSymmetricR(horizontal: 10, vertical: 8),
      isSelected: false,
      onTap: () {},
      child: Column(
        children: List.generate(taskItems.length, (i) {
          final item = taskItems[i];
          final checked = i < taskDone.length ? taskDone[i] : false;
          return PlanContainer(
            margin: context.paddingSymmetricR(vertical: 6),
            padding: context.paddingSymmetricR(horizontal: 12, vertical: 10),
            radius: BorderRadius.circular(context.radiusR(12)),
            isSelected: false,
            onTap: () {},
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (selectedSection == 'Daily Plan')
                  GestureDetector(
                    onTap: () => onToggleDaily(i),
                    child: _CheckCircle(checked: checked),
                  )
                else
                  PlanContainer(
                    margin: context.paddingSymmetricR(vertical: 1),
                    padding: context.paddingSymmetricR(
                      horizontal: 4,
                      vertical: 4,
                    ),
                    isSelected: false,
                    onTap: () {},
                    child: SizedBox(
                      height: context.sh(20),
                      width: context.sw(20),
                      child: SvgPicture.asset(
                        AppAssets.lightBulbIcon,
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                  ),
                SizedBox(width: context.sw(10)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: NormalText(
                              titleText: item.title,
                              titleSize: context.sp(14),
                              titleWeight: FontWeight.w600,

                              titleDecoration: checked
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),
                          if (item.duration.isNotEmpty)
                            NormalText(
                              titleText: item.duration,
                              titleSize: context.sp(11),
                              titleWeight: FontWeight.w500,
                            ),
                        ],
                      ),
                      if (item.subtitle.isNotEmpty)
                        NormalText(
                          titleText: item.subtitle,
                          titleSize: context.sp(12),
                          titleWeight: FontWeight.w400,
                        ),
                    ],
                  ),
                ),
                if (selectedSection == 'Exercise') ...[
                  SizedBox(width: context.sw(8)),
                  GestureDetector(
                    onTap: () => onToggleExercise(i),
                    child: _CheckCircle(checked: checked),
                  ),
                ],
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _CheckCircle extends StatelessWidget {
  const _CheckCircle({required this.checked});

  final bool checked;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.sh(24),
      width: context.sw(24),
      decoration: BoxDecoration(
        color: checked ? AppColors.pimaryColor : AppColors.backGroundColor,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.iconColor.withValues(alpha: 0.2)),
      ),
      child: checked
          ? Icon(Icons.check, size: context.sh(14), color: AppColors.white)
          : null,
    );
  }
}
