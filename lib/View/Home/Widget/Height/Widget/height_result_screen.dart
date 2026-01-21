import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:flutter_svg/svg.dart';
import 'package:looklabs/Core/Constants/Widget/app_bar_container.dart';
import 'package:looklabs/Core/Constants/Widget/custom_button.dart';
import 'package:looklabs/Core/Constants/Widget/height_widget_cont.dart';
import 'package:looklabs/Core/Constants/Widget/linear_slider_widget.dart';
import 'package:looklabs/Core/Constants/Widget/normal_text.dart';
import 'package:looklabs/Core/Constants/Widget/plan_container.dart';
import 'package:looklabs/Core/Constants/app_assets.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Core/utils/Routes/routes_name.dart';
import 'package:looklabs/ViewModel/height_screen_view_model.dart';
import 'package:provider/provider.dart';

class HeightResultScreen extends StatefulWidget {
  const HeightResultScreen({super.key});

  @override
  State<HeightResultScreen> createState() => _HeightResultScreenState();
}

class _HeightResultScreenState extends State<HeightResultScreen> {
  Widget build(BuildContext context) {
    final heightViewModel = Provider.of<HeightScreenViewModel>(context);
    double progress = 30;
    return Scaffold(
      backgroundColor: AppColors.backGroundColor,
      bottomNavigationBar: CustomButton(
        isEnabled: true,
        onTap: () =>
            Navigator.pushNamed(context, RoutesName.DailyHeightRoutineScreen),
        text: 'Get Started',
        color: AppColors.pimaryColor,
        padding: context.padSym(v: 17),
      ),
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
                  // padding: context.padSym(h: 11.5, v: 14.5),
                  title: '19 cm',
                  subTitle: 'Current Height',
                  imgPath: AppAssets.heightIcon,
                );
              }),
            ),
            SizedBox(height: context.h(10)),
            PlanContainer(
              padding: context.padSym(h: 12, v: 12),
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
                        height: context.h(44.16),
                        width: context.w(46),
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
                    titleText: 'Progress',
                    titleSize: context.text(14),
                    titleWeight: FontWeight.w600,
                    titleColor: AppColors.subHeadingColor,
                  ),
                  SizedBox(height: context.h(16)),
                  LinearSliderWidget(progress: progress),
                  SizedBox(height: context.h(12)),
                ],
              ),
            ),
            PlanContainer(
              padding: context.padSym(h: 12, v: 12),
              isSelected: false,
              onTap: () {},
              child: Row(
                children: [
                  Container(
                    height: context.h(28),
                    width: context.w(28),
                    decoration: BoxDecoration(
                      color: AppColors.backGroundColor,
                      borderRadius: BorderRadius.circular(context.radius(10)),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.customContainerColorUp.withOpacity(
                            0.4,
                          ),
                          offset: const Offset(3, 3),
                          blurRadius: 4,
                        ),
                        BoxShadow(
                          color: AppColors.customContinerColorDown.withOpacity(
                            0.4,
                          ),
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
                          'Good posture can instantly improve your height appearance by up to 2–3 cm',
                      titleSize: context.text(12),
                      titleWeight: FontWeight.w600,
                      titleColor: AppColors.subHeadingColor,
                      maxLines: 3,
                    ),
                  ),
                ],
              ),
            ),
            PlanContainer(
              padding: context.padSym(h: 12, v: 12),
              isSelected: false,
              onTap: () {},
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  NormalText(
                    titleText: 'Today\'s Focus',
                    titleSize: context.text(16),
                    titleWeight: FontWeight.w600,
                    titleColor: AppColors.subHeadingColor,
                    maxLines: 3,
                  ),
                  SizedBox(height: context.h(10)),
                  Column(
                    children: List.generate(
                      heightViewModel.heightRoutineList.length,
                      (index) {
                        final item = heightViewModel.heightRoutineList[index];

                        return Padding(
                          padding: EdgeInsets.only(bottom: context.h(8)),
                          child: PlanContainer(
                            isSelected: heightViewModel.isPlanSelected(index),
                            onTap: () {
                              heightViewModel.selectPlan(index);
                            },
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
                                    child: NormalText(
                                      titleText: '${index + 1}',
                                      titleSize: context.text(14),
                                      titleWeight: FontWeight.w600,
                                      titleColor: AppColors.subHeadingColor,
                                    ),
                                  ),
                                ),

                                SizedBox(width: context.w(9)),

                                /// Text
                                NormalText(
                                  titleText: item['time'],
                                  titleSize: context.text(14),
                                  titleWeight: FontWeight.w500,
                                  titleColor: AppColors.subHeadingColor,
                                  subText: item['activity'],
                                  subSize: context.text(10),
                                  subWeight: FontWeight.w400,
                                  subColor: AppColors.subHeadingColor,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
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
