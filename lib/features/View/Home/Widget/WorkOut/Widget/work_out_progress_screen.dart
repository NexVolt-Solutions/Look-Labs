import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:flutter_svg/svg.dart';
import 'package:looklabs/Features/Widget/activity_consistency_widget.dart';
import 'package:looklabs/Features/Widget/app_bar_container.dart';
import 'package:looklabs/Features/Widget/custom_container.dart';
import 'package:looklabs/Features/Widget/height_widget_cont.dart';
import 'package:looklabs/Features/Widget/line_chart_widget.dart';
import 'package:looklabs/Features/Widget/linear_slider_widget.dart';
import 'package:looklabs/Features/Widget/normal_text.dart';
import 'package:looklabs/Features/Widget/plan_container.dart';
import 'package:looklabs/Core/Constants/app_assets.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Features/ViewModel/work_out_progress_screen_view_model.dart';
import 'package:provider/provider.dart';

class WorkOutProgressScreen extends StatefulWidget {
  const WorkOutProgressScreen({super.key, this.workoutData});

  final Map<String, dynamic>? workoutData;

  @override
  State<WorkOutProgressScreen> createState() => _WorkOutProgressScreenState();
}

class _WorkOutProgressScreenState extends State<WorkOutProgressScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final vm = context.read<WorkOutProgressScreenViewModel>();
      if (widget.workoutData != null) {
        vm.setWorkoutData(widget.workoutData!);
      }
      vm.loadProgressData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final yourProgressScreenViewModel =
        Provider.of<WorkOutProgressScreenViewModel>(context);
    return Scaffold(
      backgroundColor: AppColors.backGroundColor,

      body: SafeArea(
        child: yourProgressScreenViewModel.progressLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: context.paddingSymmetricR(horizontal: 20),
                children: [
                  AppBarContainer(
                    title: 'Your Progress',
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(height: context.sh(24)),
                  NormalText(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    titleText:
                        'Track your fitness, consistency, and recovery over time',
                    titleSize: context.sp(16),
                    titleWeight: FontWeight.w600,
                    titleColor: AppColors.subHeadingColor,
                  ),
                  SizedBox(height: context.sh(8)),
                  SizedBox(
                    height: context.sh(135),
                    child: ListView.builder(
                      itemCount:
                          yourProgressScreenViewModel.combinedTopCards.isEmpty
                          ? 1
                          : yourProgressScreenViewModel.combinedTopCards.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final cards =
                            yourProgressScreenViewModel.combinedTopCards;
                        final item = cards.isEmpty
                            ? {
                                'title': '—',
                                'value': '—',
                                'icon': AppAssets.fatLossIcon,
                              }
                            : cards[index];
                        return HeightWidgetCont(
                          title: item['value'] ?? '—',
                          subTitle: item['title'] ?? '—',
                          imgPath: item['icon'] ?? AppAssets.fatLossIcon,
                        );
                      },
                    ),
                  ),
                  SizedBox(height: context.sh(7)),
                  Row(
                    children: [
                      CustomContainer(
                        padding: context.paddingSymmetricR(
                          horizontal: 4,
                          vertical: 4,
                        ),
                        radius: context.radiusR(10),
                        color: AppColors.backGroundColor,
                        child: SvgPicture.asset(
                          AppAssets.graphIcon,
                          height: context.sh(24),
                          width: context.sw(24),
                          fit: BoxFit.scaleDown,
                        ),
                      ),
                      SizedBox(width: context.sw(12)),
                      NormalText(
                        titleText: 'Your Progress',
                        titleSize: context.sp(18),
                        titleWeight: FontWeight.w600,
                        titleColor: AppColors.subHeadingColor,
                      ),
                    ],
                  ),
                  SizedBox(height: context.sh(8)),
                  SizedBox(
                    height: context.sh(155),
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.zero,
                      children: [
                        _progressBarCard(
                          context,
                          label: 'Fitness Consistency',
                          progress:
                              yourProgressScreenViewModel.fitnessBarValue,
                        ),
                        SizedBox(width: context.sw(12)),
                        _progressBarCard(
                          context,
                          label: 'Calorie Balance',
                          progress:
                              yourProgressScreenViewModel.calorieBarValue,
                        ),
                        SizedBox(width: context.sw(12)),
                        _progressBarCard(
                          context,
                          label: 'Hydration',
                          progress:
                              yourProgressScreenViewModel.hydrationBarValue,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: context.sh(8)),
                  Row(
                    children: List.generate(
                      yourProgressScreenViewModel.buttonName.length,
                      (index) {
                        final bool isSelected =
                            yourProgressScreenViewModel.selectedIndex ==
                            yourProgressScreenViewModel.buttonName[index];
                        return Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                              right:
                                  index <
                                      yourProgressScreenViewModel
                                              .buttonName
                                              .length -
                                          1
                                  ? context.sw(6)
                                  : 0,
                            ),
                            child: CustomContainer(
                              radius: context.radiusR(10),
                              onTap: () {
                                yourProgressScreenViewModel.selectIndex(index);
                              },
                              color: isSelected
                                  ? AppColors.buttonColor.withValues(alpha: 0.11)
                                  : AppColors.backGroundColor,
                              border: isSelected
                                  ? Border.all(
                                      color: AppColors.pimaryColor,
                                      width: 1.5,
                                    )
                                  : null,
                              padding: context.paddingSymmetricR(
                                horizontal: 12,
                                vertical: 12,
                              ),
                              margin: EdgeInsets.zero,
                              child: Center(
                                child: Text(
                                  yourProgressScreenViewModel.buttonName[index],
                                  style: TextStyle(
                                    fontSize: context.sp(14),
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.seconderyColor,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: context.sh(16)),
                  CustomContainer(
                    radius: context.radiusR(10),
                    color: AppColors.backGroundColor,
                    padding: context.paddingSymmetricR(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    margin: EdgeInsets.only(bottom: context.sh(8)),
                    child: Center(
                      child: LineChartWidget(
                        workoutChartData:
                            yourProgressScreenViewModel.workoutChartData.isEmpty
                            ? null
                            : yourProgressScreenViewModel.workoutChartData,
                      ),
                    ),
                  ),
                  PlanContainer(
                    padding: context.paddingSymmetricR(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    isSelected: false,
                    onTap: () {},
                    child: Column(
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
                                        .withValues(alpha: 0.4),
                                    offset: const Offset(3, 3),
                                    blurRadius: 4,
                                  ),
                                  BoxShadow(
                                    color: AppColors.customContinerColorDown
                                        .withValues(alpha: 0.4),
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
                                    AppAssets.lightBulbIcon,
                                    fit: BoxFit.scaleDown,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: context.sw(11)),
                            Expanded(
                              child: NormalText(
                                titleText:
                                    yourProgressScreenViewModel
                                        .postureInsight ??
                                    yourProgressScreenViewModel.aiMessage ??
                                    'Small daily workouts create big long-term results. You\'re doing great—keep up the momentum.',
                                titleSize: context.sp(12),
                                titleWeight: FontWeight.w600,
                                titleColor: AppColors.subHeadingColor,
                                // subText: 'Best done after waking up',
                                // subSize: context.sp(10),
                                // subWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  ActivityConsistencyWidget(
                    title: 'Workout Consistency',
                    subtitle: 'Your workout activity this week',
                    pressentage:
                        yourProgressScreenViewModel.displayWeekAverage > 0
                        ? yourProgressScreenViewModel.displayWeekAverage
                        : (yourProgressScreenViewModel.todayScore > 0
                              ? yourProgressScreenViewModel.todayScore
                              : (yourProgressScreenViewModel
                                            .fitnessConsistencyProgress >
                                        0
                                    ? yourProgressScreenViewModel
                                          .fitnessConsistencyProgress
                                          .toDouble()
                                    : 20.0)),
                  ),
                  SizedBox(height: context.sh(16)),
                  NormalText(
                    titleText: 'Daily Recovery Checklist',
                    titleSize: context.sp(18),
                    titleWeight: FontWeight.w600,
                    titleColor: AppColors.subHeadingColor,
                  ),
                  SizedBox(height: context.sh(18)),
                  Column(
                    children: List.generate(
                      yourProgressScreenViewModel.checkBoxName.length,
                      (index) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: context.sh(12)),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  yourProgressScreenViewModel.toggleChecklist(
                                    index,
                                  );
                                },
                                child: Container(
                                  height: context.sh(28),
                                  width: context.sw(28),
                                  decoration: BoxDecoration(
                                    color:
                                        yourProgressScreenViewModel
                                            .selectedChecklist[index]
                                        ? AppColors.pimaryColor
                                        : AppColors.backGroundColor,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.customContainerColorUp
                                            .withValues(alpha: 0.4),
                                        offset: const Offset(3, 3),
                                        blurRadius: 4,
                                        inset: true,
                                      ),
                                      BoxShadow(
                                        color: AppColors.customContinerColorDown
                                            .withValues(alpha: 0.4),
                                        offset: const Offset(-3, -3),
                                        blurRadius: 4,
                                        inset: true,
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child:
                                        yourProgressScreenViewModel
                                            .selectedChecklist[index]
                                        ? Icon(
                                            Icons.check,
                                            size: context.sh(16),
                                            color: AppColors.white,
                                          )
                                        : SizedBox(),
                                  ),
                                ),
                              ),

                              SizedBox(width: context.sw(12)),

                              Expanded(
                                child: NormalText(
                                  titleText: yourProgressScreenViewModel
                                      .checkBoxName[index],
                                  titleSize: context.sp(16),
                                  titleWeight: FontWeight.w600,
                                  titleColor: AppColors.subHeadingColor,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: context.sh(30)),
                ],
              ),
      ),
    );
  }

  Widget _progressBarCard(
    BuildContext context, {
    required String label,
    required double progress,
  }) {
    return SizedBox(
      width: context.sw(220),
      child: PlanContainer(
        padding: context.paddingSymmetricR(horizontal: 7, vertical: 12),
        isSelected: false,
        onTap: () {},
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            NormalText(
              titleText: label,
              titleSize: context.sp(16),
              titleWeight: FontWeight.w500,
              titleColor: AppColors.subHeadingColor,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: context.sh(8)),
            LinearSliderWidget(
              progress: progress,
              height: context.sh(12),
              animatedConHeight: context.sh(12),
            ),
          ],
        ),
      ),
    );
  }
}
