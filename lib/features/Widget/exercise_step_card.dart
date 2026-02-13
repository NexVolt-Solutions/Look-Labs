import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:looklabs/features/Widget/normal_text.dart';
import 'package:looklabs/features/Widget/plan_container.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';

class ExerciseStepCard extends StatefulWidget {
  final int index;
  final Map<String, String> item;
  final bool isSelected;
  final VoidCallback onTap;

  const ExerciseStepCard({
    required this.index,
    required this.item,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  @override
  State<ExerciseStepCard> createState() => _ExerciseStepCardState();
}

class _ExerciseStepCardState extends State<ExerciseStepCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: context.h(8)),
      child: GestureDetector(
        onTap: () {
          setState(() => isExpanded = !isExpanded);
          widget.onTap();
        },
        child: AnimatedCrossFade(
          duration: const Duration(milliseconds: 300),
          crossFadeState: isExpanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          firstChild: PlanContainer(
            isSelected: widget.isSelected,
            onTap: () {},
            child: Row(
              children: [
                /// Number Circle
                Container(
                  height: context.h(28),
                  width: context.w(28),
                  decoration: BoxDecoration(
                    color: AppColors.backGroundColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.customContainerColorUp.withOpacity(
                          0.4,
                        ),
                        offset: const Offset(3, 3),
                        blurRadius: 4,
                        inset: true,
                      ),
                      BoxShadow(
                        color: AppColors.customContinerColorDown.withOpacity(
                          0.4,
                        ),
                        offset: const Offset(-3, -3),
                        blurRadius: 4,
                        inset: true,
                      ),
                    ],
                  ),
                  child: Center(
                    child: NormalText(
                      titleText: '${widget.index + 1}',
                      titleSize: context.text(14),
                      titleWeight: FontWeight.w600,
                      titleColor: AppColors.subHeadingColor,
                    ),
                  ),
                ),
                SizedBox(width: context.w(9)),

                /// Text
                NormalText(
                  titleText: widget.item['time'] ?? '',
                  titleSize: context.text(14),
                  titleWeight: FontWeight.w500,
                  titleColor: AppColors.subHeadingColor,
                  subText: widget.item['activity'] ?? '',
                  subSize: context.text(10),
                  subWeight: FontWeight.w400,
                  subColor: AppColors.subHeadingColor,
                ),

                const Spacer(),

                /// Dropdown Arrow
                Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: AppColors.subHeadingColor,
                ),
              ],
            ),
          ),
          secondChild: PlanContainer(
            onTap: () {},
            isSelected: widget.isSelected,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      height: context.h(28),
                      width: context.w(28),
                      decoration: BoxDecoration(
                        color: AppColors.backGroundColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.customContainerColorUp.withOpacity(
                              0.4,
                            ),
                            offset: const Offset(3, 3),
                            blurRadius: 4,
                            inset: true,
                          ),
                          BoxShadow(
                            color: AppColors.customContinerColorDown
                                .withOpacity(0.4),
                            offset: const Offset(-3, -3),
                            blurRadius: 4,
                            inset: true,
                          ),
                        ],
                      ),
                      child: Center(
                        child: NormalText(
                          titleText: '${widget.index + 1}',
                          titleSize: context.text(14),
                          titleWeight: FontWeight.w600,
                          titleColor: AppColors.subHeadingColor,
                        ),
                      ),
                    ),
                    SizedBox(width: context.w(9)),
                    NormalText(
                      titleText: widget.item['time'] ?? '',
                      titleSize: context.text(14),
                      titleWeight: FontWeight.w500,
                      titleColor: AppColors.subHeadingColor,
                      subText: widget.item['activity'] ?? '',
                      subSize: context.text(10),
                      subWeight: FontWeight.w400,
                      subColor: AppColors.subHeadingColor,
                    ),
                    const Spacer(),
                    Icon(
                      Icons.keyboard_arrow_up,
                      color: AppColors.subHeadingColor,
                    ),
                  ],
                ),
                SizedBox(height: context.h(10)),

                /// Expanded Instructions
                NormalText(
                  titleText:
                      '• Come on all fours, hands under shoulders, knees under hips\n'
                      '• Inhale, drop belly, lift chest & chin (Cow)\n'
                      '• Exhale, round spine, tuck chin to chest (Cat)\n'
                      '• Move slowly with your breath\n'
                      '• Repeat in a smooth, controlled flow',
                  titleSize: context.text(12),
                  titleWeight: FontWeight.w400,
                  titleColor: AppColors.subHeadingColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
