import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:flutter_svg/svg.dart';
import 'package:looklabs/Core/Widget/activity_consistency_widget.dart';
import 'package:looklabs/Core/Widget/app_bar_container.dart';
import 'package:looklabs/Core/Widget/custom_container.dart';
import 'package:looklabs/Core/Widget/height_widget_cont.dart';
import 'package:looklabs/Core/Widget/light_card_widget.dart';
import 'package:looklabs/Core/Widget/line_chart_widget.dart';
import 'package:looklabs/Core/Widget/linear_slider_widget.dart';
import 'package:looklabs/Core/Widget/normal_text.dart';
import 'package:looklabs/Core/Constants/app_assets.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Core/Widget/plan_container.dart';
import 'package:looklabs/ViewModel/diet_progress_screen_view_model.dart';
import 'package:provider/provider.dart';

class DietProgressScreen extends StatefulWidget {
  const DietProgressScreen({super.key});

  @override
  State<DietProgressScreen> createState() => _DietProgressScreenState();
}

class _DietProgressScreenState extends State<DietProgressScreen> {
  @override
  Widget build(BuildContext context) {
    final dietProgressScreenViewModel =
        Provider.of<DietProgressScreenViewModel>(context);
    return Scaffold(
      backgroundColor: AppColors.backGroundColor,

      body: SafeArea(
        child: ListView(
          padding: context.padSym(h: 20),
          children: [
            AppBarContainer(
              title: 'Your Progress',
              onTap: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(height: context.h(24)),
            NormalText(
              crossAxisAlignment: CrossAxisAlignment.start,
              titleText:
                  'Track your fitness, consistency, and recovery over time',
              titleSize: context.text(16),
              titleWeight: FontWeight.w600,
              titleColor: AppColors.subHeadingColor,
            ),
            SizedBox(height: context.h(8)),
            SizedBox(
              height: context.h(135),
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
            SizedBox(height: context.h(8)),

            Row(
              children: [
                CustomContainer(
                  padding: context.padSym(h: 4, v: 4),
                  radius: context.radius(10),
                  color: AppColors.backGroundColor,
                  child: SvgPicture.asset(
                    AppAssets.graphIcon,
                    height: context.h(24),
                    width: context.w(24),
                    fit: BoxFit.scaleDown,
                  ),
                ),
                SizedBox(width: context.w(12)),
                NormalText(
                  titleText: 'Your Progress',
                  titleSize: context.text(18),
                  titleWeight: FontWeight.w600,
                  titleColor: AppColors.subHeadingColor,
                ),
              ],
            ),
            SizedBox(height: context.h(2)),
            SizedBox(
              height: context.h(130), // ✅ SAFE HEIGHT
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 4,
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(right: context.w(15)),
                    child: SizedBox(
                      width: context.w(220),
                      child: PlanContainer(
                        padding: context.padSym(h: 7, v: 24),
                        isSelected: false,
                        onTap: () {},
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            NormalText(
                              titleText: 'Fitness Consistency',
                              titleSize: context.text(16),
                              titleWeight: FontWeight.w500,
                              titleColor: AppColors.subHeadingColor,
                            ),
                            SizedBox(height: context.h(12)),
                            LinearSliderWidget(
                              progress: 10,
                              height: context.h(12),
                              animatedConHeight: context.h(12),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: context.h(16)),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(
                dietProgressScreenViewModel.buttonName.length,
                (index) {
                  final bool isSelected =
                      dietProgressScreenViewModel.selectedIndex ==
                      dietProgressScreenViewModel.buttonName[index];
                  return CustomContainer(
                    radius: context.radius(10),
                    onTap: () {
                      dietProgressScreenViewModel.selectIndex(index);
                    },
                    color: isSelected
                        ? AppColors.buttonColor.withOpacity(0.11)
                        : AppColors.backGroundColor,
                    border: isSelected
                        ? Border.all(color: AppColors.pimaryColor, width: 1.5)
                        : null,
                    padding: context.padSym(h: 37, v: 13),
                    margin: EdgeInsets.only(right: 8),
                    child: Center(
                      child: Text(
                        dietProgressScreenViewModel.buttonName[index],
                        style: TextStyle(
                          fontSize: context.text(14),
                          fontWeight: FontWeight.w700,
                          color: AppColors.seconderyColor,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: context.h(16)),
            CustomContainer(
              radius: context.radius(10),
              color: AppColors.backGroundColor,
              padding: context.padSym(h: 10, v: 10),
              margin: EdgeInsets.only(bottom: context.h(20)),
              child: Center(child: LineChartWidget()),
            ),
            ActivityConsistencyWidget(
              title: 'Workout Consistency',
              subtitle: 'Your workout activity this week',
              pressentage: 20,
            ),
            SizedBox(height: context.h(6)),
            LightCardWidget(
              text:
                  'Consistency improves stamina, strength & posture over time.',
            ),
            SizedBox(height: context.h(16)),
            NormalText(
              titleText: 'Daily Recovery Checklist',
              titleSize: context.text(18),
              titleWeight: FontWeight.w600,
              titleColor: AppColors.subHeadingColor,
            ),
            SizedBox(height: context.h(16)),
            Column(
              children: List.generate(
                dietProgressScreenViewModel.checkBoxName.length,
                (index) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: context.h(12)),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            dietProgressScreenViewModel.toggleChecklist(index);
                          },
                          child: Container(
                            height: context.h(28),
                            width: context.w(28),
                            decoration: BoxDecoration(
                              color: AppColors.backGroundColor,
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
                                      size: context.h(16),
                                      color: AppColors.pimaryColor,
                                    )
                                  : NormalText(
                                      titleText: '${index + 1}',
                                      titleSize: context.text(12),
                                    ),
                            ),
                          ),
                        ),

                        SizedBox(width: context.w(12)),

                        Expanded(
                          child: NormalText(
                            titleText:
                                dietProgressScreenViewModel.checkBoxName[index],
                            titleSize: context.text(16),
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
            SizedBox(height: context.h(30)),
          ],
        ),
      ),
    );
  }
}
