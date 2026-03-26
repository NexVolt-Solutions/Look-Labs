import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:flutter_svg/svg.dart';
import 'package:looklabs/Features/Widget/app_bar_container.dart';
import 'package:looklabs/Features/Widget/normal_text.dart';
import 'package:looklabs/Features/Widget/plan_container.dart';
import 'package:looklabs/Core/Constants/app_assets.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Core/Network/models/height_flow_ui_data.dart';
import 'package:looklabs/Features/View/Home/Widget/Height/Widget/height_exercise_detail_widgets.dart';
import 'package:looklabs/Features/ViewModel/daily_height_routine_view_model.dart';
import 'package:provider/provider.dart';

class DailyHeightRoutineScreen extends StatefulWidget {
  const DailyHeightRoutineScreen({super.key, this.resultData});

  final Map<String, dynamic>? resultData;

  @override
  State<DailyHeightRoutineScreen> createState() =>
      _DailyHeightRoutineScreenState();
}

class _DailyHeightRoutineScreenState extends State<DailyHeightRoutineScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      await context.read<DailyHeightRoutineViewModel>().loadFromFlowResult(
            widget.resultData,
          );
    });
  }

  Widget _buildRoutineExerciseTile(
    BuildContext context,
    DailyHeightRoutineViewModel vm,
    Map<String, dynamic> item,
    int flatIndex,
  ) {
    final isDone = vm.isCompleted(flatIndex);
    final seq = item['seq'];
    final displayNum = seq is int && seq > 0 ? seq : (flatIndex + 1);
    return Center(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: double.infinity,
        padding: context.paddingSymmetricR(vertical: 8, horizontal: 20),
        margin: context.paddingSymmetricR(vertical: 11),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isDone
                ? AppColors.pimaryColor
                : AppColors.backGroundColor,
            width: context.sw(1.5),
          ),
          color: isDone
              ? AppColors.pimaryColor.withOpacity(0.15)
              : AppColors.backGroundColor,
          boxShadow: [
            BoxShadow(
              color: AppColors.customContainerColorUp.withOpacity(0.4),
              offset: const Offset(5, 5),
              blurRadius: 5,
            ),
            BoxShadow(
              color: AppColors.customContinerColorDown.withOpacity(0.4),
              offset: const Offset(-5, -5),
              blurRadius: 5,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => vm.markExerciseDone(flatIndex),
                      child: Container(
                        height: context.sh(28),
                        width: context.sw(28),
                        decoration: BoxDecoration(
                          color: isDone
                              ? AppColors.pimaryColor
                              : AppColors.backGroundColor,
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
                          child: isDone
                              ? Icon(
                                  Icons.check,
                                  size: context.sh(16),
                                  color: AppColors.white,
                                )
                              : NormalText(
                                  titleText: '$displayNum',
                                ),
                        ),
                      ),
                    ),
                    SizedBox(width: context.sw(9)),
                    NormalText(
                      titleText: item['time']?.toString() ?? '',
                      titleSize: context.sp(14),
                      titleWeight: FontWeight.w500,
                      titleColor: AppColors.subHeadingColor,
                      subText: item['activity']?.toString() ?? '',
                      subSize: context.sp(10),
                      subWeight: FontWeight.w400,
                      subColor: AppColors.subHeadingColor,
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () => vm.toggleExpand(flatIndex),
                  child: Icon(
                    vm.isExpanded(flatIndex)
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    size: context.sh(24),
                  ),
                ),
              ],
            ),
            AnimatedCrossFade(
              firstChild: const SizedBox(),
              secondChild: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: context.sh(12)),
                  ...buildHeightExerciseDetailWidgets(context, item),
                ],
              ),
              crossFadeState: vm.isExpanded(flatIndex)
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 300),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DailyHeightRoutineViewModel>();
    final hasAny = vm.morningRoutineList.isNotEmpty ||
        vm.eveningRoutineList.isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.backGroundColor,
      body: SafeArea(
        child: ListView(
          padding: context.paddingSymmetricR(horizontal: 20),
          children: [
            AppBarContainer(
              title: 'Daily Routine',
              onTap: () => Navigator.pop(context),
            ),
            SizedBox(height: context.sh(24)),
            NormalText(
              crossAxisAlignment: CrossAxisAlignment.start,
              titleText:
                  HeightFlowUiData.dailySubtitleFrom(widget.resultData),
              titleSize: context.sp(16),
              titleWeight: FontWeight.w600,
              titleColor: AppColors.subHeadingColor,
            ),
            SizedBox(height: context.sh(18)),
            if (!hasAny)
              Padding(
                padding: EdgeInsets.only(top: context.sh(24)),
                child: NormalText(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  titleText:
                      'No exercises yet. Complete your height plan on the result screen first.',
                  titleSize: context.sp(14),
                  titleWeight: FontWeight.w500,
                  titleColor: AppColors.subHeadingColor,
                ),
              )
            else ...[
              if (vm.morningRoutineList.isNotEmpty)
                PlanContainer(
                  padding: context.paddingSymmetricR(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  isSelected: false,
                  onTap: () {},
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            height: context.sh(28),
                            width: context.sw(28),
                            decoration: BoxDecoration(
                              color: AppColors.backGroundColor,
                              borderRadius: BorderRadius.circular(
                                context.radiusR(10),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.customContainerColorUp
                                      .withOpacity(0.4),
                                  offset: const Offset(3, 3),
                                  blurRadius: 4,
                                ),
                                BoxShadow(
                                  color: AppColors.customContinerColorDown
                                      .withOpacity(0.4),
                                  offset: const Offset(-3, -3),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            child: Center(
                              child: SizedBox(
                                height: context.sh(32),
                                width: context.sw(32),
                                child: SvgPicture.asset(
                                  AppAssets.sunIcon,
                                  colorFilter: const ColorFilter.mode(
                                    AppColors.fireColor,
                                    BlendMode.srcIn,
                                  ),
                                  fit: BoxFit.scaleDown,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: context.sw(11)),
                          Expanded(
                            child: NormalText(
                              titleText: 'Morning routine',
                              titleSize: context.sp(14),
                              titleWeight: FontWeight.w600,
                              titleColor: AppColors.subHeadingColor,
                              subText: 'Best done after waking up',
                              subSize: context.sp(10),
                              subWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      ...vm.morningRoutineList.asMap().entries.map(
                            (e) => _buildRoutineExerciseTile(
                              context,
                              vm,
                              e.value,
                              e.key,
                            ),
                          ),
                    ],
                  ),
                ),
              if (vm.morningRoutineList.isNotEmpty &&
                  vm.eveningRoutineList.isNotEmpty)
                SizedBox(height: context.sh(16)),
              if (vm.eveningRoutineList.isNotEmpty)
                PlanContainer(
                  padding: context.paddingSymmetricR(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  isSelected: false,
                  onTap: () {},
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            height: context.sh(28),
                            width: context.sw(28),
                            decoration: BoxDecoration(
                              color: AppColors.backGroundColor,
                              borderRadius: BorderRadius.circular(
                                context.radiusR(10),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.customContainerColorUp
                                      .withOpacity(0.4),
                                  offset: const Offset(3, 3),
                                  blurRadius: 4,
                                ),
                                BoxShadow(
                                  color: AppColors.customContinerColorDown
                                      .withOpacity(0.4),
                                  offset: const Offset(-3, -3),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            child: Center(
                              child: Icon(
                                Icons.nightlight_round,
                                size: context.sh(20),
                                color: AppColors.pimaryColor,
                              ),
                            ),
                          ),
                          SizedBox(width: context.sw(11)),
                          Expanded(
                            child: NormalText(
                              titleText: 'Evening routine',
                              titleSize: context.sp(14),
                              titleWeight: FontWeight.w600,
                              titleColor: AppColors.subHeadingColor,
                              subText: 'Wind down and decompress',
                              subSize: context.sp(10),
                              subWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      ...vm.eveningRoutineList.asMap().entries.map(
                            (e) => _buildRoutineExerciseTile(
                              context,
                              vm,
                              e.value,
                              vm.morningRoutineList.length + e.key,
                            ),
                          ),
                    ],
                  ),
                ),
            ],
            SizedBox(height: context.sh(30)),
          ],
        ),
      ),
    );
  }
}
