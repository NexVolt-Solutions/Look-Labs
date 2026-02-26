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
import 'package:looklabs/Features/ViewModel/diet_progress_screen_view_model.dart';
import 'package:looklabs/Features/ViewModel/work_out_progress_screen_view_model.dart';
import 'package:provider/provider.dart';

class WorkOutProgressScreen extends StatefulWidget {
  const WorkOutProgressScreen({super.key});

  @override
  State<WorkOutProgressScreen> createState() => _WorkOutProgressScreenState();
}

class _WorkOutProgressScreenState extends State<WorkOutProgressScreen> {
  @override
  Widget build(BuildContext context) {
    final yourProgressScreenViewModel =
        Provider.of<WorkOutProgressScreenViewModel>(context);
    final dietProgressScreenViewModel =
        Provider.of<DietProgressScreenViewModel>(context);
    return Scaffold(
      backgroundColor: AppColors.backGroundColor,

      body: SafeArea(
        child: ListView(
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
                itemCount: 4,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return HeightWidgetCont(
                    title: '2300',
                    subTitle: 'Weekly Cal',
                    imgPath: AppAssets.fatLossIcon,
                  );
                },
              ),
            ),
            SizedBox(height: context.sh(8)),
            PlanContainer(
              padding: context.paddingSymmetricR(horizontal: 12, vertical: 12),
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
            SizedBox(height: context.sh(7)),
            Row(
              children: [
                CustomContainer(
                  padding: context.paddingSymmetricR(horizontal: 4, vertical: 4),
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
              height: context.sh(130), // ✅ SAFE HEIGHT
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 4,
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(right: context.sw(12)),
                    child: SizedBox(
                      width: context.sw(220),
                      child: PlanContainer(
                        padding: context.paddingSymmetricR(horizontal: 7, vertical: 24),
                        isSelected: false,
                        onTap: () {},
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            NormalText(
                              titleText: 'Fitness Consistency',
                              titleSize: context.sp(16),
                              titleWeight: FontWeight.w500,
                              titleColor: AppColors.subHeadingColor,
                            ),
                            SizedBox(height: context.sh(12)),
                            LinearSliderWidget(
                              progress: 10,
                              height: context.sh(12),
                              animatedConHeight: context.sh(12),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: context.sh(8)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(
                yourProgressScreenViewModel.buttonName.length,
                (index) {
                  final bool isSelected =
                      yourProgressScreenViewModel.selectedIndex ==
                      yourProgressScreenViewModel.buttonName[index];
                  return CustomContainer(
                    radius: context.radiusR(10),
                    onTap: () {
                      yourProgressScreenViewModel.selectIndex(index);
                    },
                    color: isSelected
                        ? AppColors.buttonColor.withOpacity(0.11)
                        : AppColors.backGroundColor,
                    border: isSelected
                        ? Border.all(color: AppColors.pimaryColor, width: 1.5)
                        : null,
                    padding: context.paddingSymmetricR(horizontal: 38, vertical: 12),
                    margin: context.paddingSymmetricR(horizontal: 0, vertical: 0),
                    child: Center(
                      child: Text(
                        yourProgressScreenViewModel.buttonName[index],
                        style: TextStyle(
                          fontSize: context.sp(14),
                          fontWeight: FontWeight.w700,
                          color: AppColors.seconderyColor,
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
              padding: context.paddingSymmetricR(horizontal: 10, vertical: 10),
              margin: EdgeInsets.only(bottom: context.sh(20)),
              child: Center(child: LineChartWidget()),
            ),
            ActivityConsistencyWidget(
              title: 'Workout Consistency',
              subtitle: 'Your workout activity this week',
              pressentage: 20,
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
                dietProgressScreenViewModel.checkBoxName.length,
                (index) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: context.sh(12)),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            dietProgressScreenViewModel.toggleChecklist(index);
                          },
                          child: Container(
                            height: context.sh(28),
                            width: context.sw(28),
                            decoration: BoxDecoration(
                              color:
                                  dietProgressScreenViewModel
                                      .selectedChecklist[index]
                                  ? AppColors.pimaryColor
                                  : AppColors.backGroundColor,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.customContainerColorUp
                                      .withOpacity(0.4),
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
                              child:
                                  dietProgressScreenViewModel
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
                            titleText:
                                dietProgressScreenViewModel.checkBoxName[index],
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
}
