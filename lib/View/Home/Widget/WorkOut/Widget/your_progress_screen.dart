import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:looklabs/Core/Constants/Widget/app_bar_container.dart';
import 'package:looklabs/Core/Constants/Widget/custom_container.dart';
import 'package:looklabs/Core/Constants/Widget/height_widget_cont.dart';
import 'package:looklabs/Core/Constants/Widget/linear_slider_widget.dart';
import 'package:looklabs/Core/Constants/Widget/normal_text.dart';
import 'package:looklabs/Core/Constants/Widget/plan_container.dart';
import 'package:looklabs/Core/Constants/app_assets.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';

class YourProgressScreen extends StatefulWidget {
  const YourProgressScreen({super.key});

  @override
  State<YourProgressScreen> createState() => _YourProgressScreenState();
}

class _YourProgressScreenState extends State<YourProgressScreen> {
  @override
  Widget build(BuildContext context) {
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
            PlanContainer(
              padding: context.padSym(h: 12, v: 12),
              isSelected: false,
              onTap: () {},
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        height: context.h(28),
                        width: context.w(28),
                        decoration: BoxDecoration(
                          color: AppColors.backGroundColor,
                          borderRadius: BorderRadius.circular(
                            context.radius(10),
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
                            height: context.h(32),
                            width: context.w(32),
                            child: SvgPicture.asset(
                              AppAssets.lightBulbIcon,
                              fit: BoxFit.scaleDown,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: context.w(11)),
                      Expanded(
                        child: NormalText(
                          titleText:
                              'Small daily workouts create big long-term results. You\'re doing great—keep up the momentum.',
                          titleSize: context.text(12),
                          titleWeight: FontWeight.w600,
                          titleColor: AppColors.subHeadingColor,
                          // subText: 'Best done after waking up',
                          // subSize: context.text(10),
                          // subWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: context.h(7)),
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
            PlanContainer(
              padding: context.padSym(h: 12, v: 12),
              isSelected: false,
              onTap: () {},
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  NormalText(
                    titleText: 'Workout Consistency',
                    titleSize: context.text(18),
                    titleWeight: FontWeight.w600,
                    titleColor: AppColors.subHeadingColor,
                    sizeBoxheight: context.h(12),
                    subText: 'Your workout activity this week',
                    subWeight: FontWeight.w600,
                    subColor: AppColors.iconColor,
                    subSize: context.text(14),
                  ),
                  SizedBox(height: context.h(16)),

                  LinearSliderWidget(
                    progress: 10,
                    height: context.h(10),
                    animatedConHeight: context.h(10),
                  ),
                  SizedBox(height: context.h(12)),
                ],
              ),
            ),
            NormalText(
              titleText: 'Daily Recovery Checklist',
              titleSize: context.text(18),
              titleWeight: FontWeight.w600,
              titleColor: AppColors.subHeadingColor,
            ),
          ],
        ),
      ),
    );
  }
}
