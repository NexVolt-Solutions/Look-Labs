import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:flutter_svg/svg.dart';
import 'package:looklabs/Core/Constants/Widget/app_bar_container.dart';
import 'package:looklabs/Core/Constants/Widget/height_widget_cont.dart';
import 'package:looklabs/Core/Constants/Widget/linear_custom_indicator.dart';
import 'package:looklabs/Core/Constants/Widget/normal_text.dart';
import 'package:looklabs/Core/Constants/Widget/plan_container.dart';
import 'package:looklabs/Core/Constants/app_assets.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';

class DailyHeightRoutineScreen extends StatefulWidget {
  const DailyHeightRoutineScreen({super.key});

  @override
  State<DailyHeightRoutineScreen> createState() =>
      _DailyHeightRoutineScreenState();
}

class _DailyHeightRoutineScreenState extends State<DailyHeightRoutineScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backGroundColor,
      body: SafeArea(
        child: ListView(
          padding: context.padSym(h: 20),
          children: [
            AppBarContainer(
              title: 'Height',
              onTap: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(height: context.h(24)),
            NormalText(
              crossAxisAlignment: CrossAxisAlignment.start,
              titleText: 'Improve posture & track your height progress',
              titleSize: context.text(16),
              titleWeight: FontWeight.w600,
              titleColor: AppColors.subHeadingColor,
            ),
            SizedBox(height: context.h(18)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(2, (index) {
                return HeightWidgetCont(
                  title: '19 cm',
                  subTitle: 'Current Height',
                  imgPath: AppAssets.heightIcon,
                );
              }),
            ),
            SizedBox(height: context.h(18)),
            PlanContainer(
              isSelected: false,
              onTap: () {},
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          NormalText(
                            titleText: 'Current Height',
                            titleSize: context.text(15),
                            titleWeight: FontWeight.w600,
                            titleColor: AppColors.iconColor,
                          ),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: '213',
                                  style: TextStyle(
                                    fontSize: context.text(26),
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.subHeadingColor,
                                  ),
                                ),
                                TextSpan(
                                  text: 'cm',
                                  style: TextStyle(
                                    fontSize: context.text(16),
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.subHeadingColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: context.h(44),
                        width: context.w(44),
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
                              AppAssets.heightIncreaseIcon,
                              fit: BoxFit.scaleDown,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: context.h(12)),
                  Divider(
                    color: AppColors.iconColor.withOpacity(0.2),
                    thickness: 0.5,
                    height: context.h(0.5),
                  ),
                  SizedBox(height: context.h(12)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset(
                            AppAssets.liftingUpIcon,
                            height: context.h(24),
                            width: context.w(24),
                            color: AppColors.iconColor,
                            fit: BoxFit.scaleDown,
                          ),
                          NormalText(
                            titleText: 'BMI Status',
                            titleSize: context.text(12),
                            titleWeight: FontWeight.w400,
                            titleColor: AppColors.iconColor,
                          ),
                        ],
                      ),
                      PlanContainer(
                        isSelected: false,
                        padding: context.padSym(h: 14.5, v: 8),
                        radius: BorderRadius.circular(context.radius(16)),
                        onTap: () {},
                        child: NormalText(
                          titleText: 'Normal',
                          titleSize: context.text(10),
                          titleWeight: FontWeight.w600,
                          titleColor: AppColors.subHeadingColor,
                        ),
                      ),
                    ],
                  ),
                  NormalText(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    titleText: 'Progress',
                    titleSize: context.text(14),
                    titleWeight: FontWeight.w600,
                    titleColor: AppColors.subHeadingColor,
                  ),
                  Row(
                    children: [
                      // 🔹 Slider takes remaining width
                      Expanded(
                        child: Container(
                          height: context.h(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              context.radius(10),
                            ),
                            border: Border.all(
                              color: AppColors.backGroundColor,
                              width: context.w(1.5),
                            ),
                            color: AppColors.backGroundColor,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.customContainerColorUp
                                    .withOpacity(0.4),
                                offset: const Offset(5, 5),
                                blurRadius: 5,
                                inset: true,
                              ),
                              BoxShadow(
                                color: AppColors.customContinerColorDown
                                    .withOpacity(0.4),
                                offset: const Offset(-5, -5),
                                blurRadius: 5,
                                inset: true,
                              ),
                            ],
                          ),
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              // Active bar
                              Container(
                                height: context.h(20),
                                width: context.w(200), // later dynamic
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    context.radius(10),
                                  ),
                                  color: AppColors.pimaryColor,
                                ),
                              ),

                              // Thumb
                              Positioned(
                                left: context.w(180),
                                top: -context.h(4),
                                child: Container(
                                  height: context.h(28),
                                  width: context.w(44),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      context.radius(76),
                                    ),
                                    color: AppColors.backGroundColor,
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.customContainerColorUp
                                            .withOpacity(0.4),
                                        offset: const Offset(2.5, 2.5),
                                        blurRadius: 0,
                                      ),
                                      BoxShadow(
                                        color: AppColors.customContinerColorDown
                                            .withOpacity(0.4),
                                        offset: const Offset(-2.5, -2.5),
                                        blurRadius: 10,
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Text(
                                      '|||',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.pimaryColor,
                                        fontSize: context.text(15),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(width: context.w(8)),

                      // 🔹 Percentage text
                      NormalText(
                        titleText: '105',
                        titleSize: context.text(12),
                        titleWeight: FontWeight.w600,
                        titleColor: AppColors.subHeadingColor,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
