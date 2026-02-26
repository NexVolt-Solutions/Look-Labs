import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:flutter_svg/svg.dart';
import 'package:looklabs/Features/Widget/app_bar_container.dart';
import 'package:looklabs/Features/Widget/custom_button.dart';
import 'package:looklabs/Features/Widget/height_widget_cont.dart';
import 'package:looklabs/Features/Widget/light_card_widget.dart';
import 'package:looklabs/Features/Widget/linear_slider_widget.dart';
import 'package:looklabs/Features/Widget/normal_text.dart';
import 'package:looklabs/Features/Widget/plan_container.dart';
import 'package:looklabs/Core/Constants/app_assets.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Core/Routes/routes_name.dart';
import 'package:looklabs/Features/ViewModel/height_screen_view_model.dart';
import 'package:provider/provider.dart';

class HeightResultScreen extends StatefulWidget {
  const HeightResultScreen({super.key});

  @override
  State<HeightResultScreen> createState() => _HeightResultScreenState();
}

class _HeightResultScreenState extends State<HeightResultScreen> {
  Widget build(BuildContext context) {
    final heightResultViewModel = Provider.of<HeightScreenViewModel>(context);
    double progress = 30;
    return Scaffold(
      backgroundColor: AppColors.backGroundColor,
      bottomNavigationBar: Padding(
        padding: EdgeInsetsGeometry.only(
          top: context.sh(5),
          left: context.sw(20),
          right: context.sw(20),
          bottom: context.sh(30),
        ),
        child: CustomButton(
          isEnabled: true,
          onTap: () =>
              Navigator.pushNamed(context, RoutesName.DailyHeightRoutineScreen),
          text: 'Get Started',
          color: AppColors.pimaryColor,
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: context.paddingSymmetricR(horizontal: 20),
          children: [
            AppBarContainer(
              title: 'Height',
              onTap: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(height: context.sh(24)),
            NormalText(
              crossAxisAlignment: CrossAxisAlignment.start,
              titleText: 'Improve posture & track your height progress',
              titleSize: context.sp(16),
              titleWeight: FontWeight.w600,
              titleColor: AppColors.subHeadingColor,
            ),
            SizedBox(height: context.sh(18)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(2, (index) {
                return HeightWidgetCont(
                  // padding: context.paddingSymmetricR(horizontal: 11.5, vertical: 14.5),
                  title: '19 cm',
                  subTitle: 'Current Height',
                  imgPath: AppAssets.heightIcon,
                );
              }),
            ),
            SizedBox(height: context.sh(10)),
            PlanContainer(
              padding: context.paddingSymmetricR(horizontal: 12, vertical: 12),
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
                            titleSize: context.sp(15),
                            titleWeight: FontWeight.w600,
                            titleColor: AppColors.iconColor,
                          ),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: '213',
                                  style: TextStyle(
                                    fontSize: context.sp(26),
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.subHeadingColor,
                                  ),
                                ),
                                TextSpan(
                                  text: 'cm',
                                  style: TextStyle(
                                    fontSize: context.sp(16),
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
                        height: context.sh(44.16),
                        width: context.sw(46),
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
                              AppAssets.heightIncreaseIcon,
                              fit: BoxFit.scaleDown,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: context.sh(12)),
                  Divider(
                    color: AppColors.iconColor.withOpacity(0.2),
                    thickness: 0.5,
                    height: context.sh(0.5),
                  ),
                  SizedBox(height: context.sh(12)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset(
                            AppAssets.liftingUpIcon,
                            height: context.sh(24),
                            width: context.sw(24),
                            color: AppColors.iconColor,
                            fit: BoxFit.scaleDown,
                          ),
                          NormalText(
                            titleText: 'BMI Status',
                            titleSize: context.sp(12),
                            titleWeight: FontWeight.w400,
                            titleColor: AppColors.iconColor,
                          ),
                        ],
                      ),
                      PlanContainer(
                        isSelected: false,
                        padding: context.paddingSymmetricR(horizontal: 14.5, vertical: 8),
                        radius: BorderRadius.circular(context.radiusR(16)),
                        onTap: () {},
                        child: NormalText(
                          titleText: 'Normal',
                          titleSize: context.sp(10),
                          titleWeight: FontWeight.w600,
                          titleColor: AppColors.subHeadingColor,
                        ),
                      ),
                    ],
                  ),
                  NormalText(
                    titleText: 'Progress',
                    titleSize: context.sp(14),
                    titleWeight: FontWeight.w600,
                    titleColor: AppColors.subHeadingColor,
                  ),
                  SizedBox(height: context.sh(16)),
                  LinearSliderWidget(progress: progress),
                  SizedBox(height: context.sh(12)),
                ],
              ),
            ),
            SizedBox(height: context.sh(12)),
            LightCardWidget(
              text:
                  'Consistency improves stamina, strength & posture over time.',
            ),
            SizedBox(height: context.sh(6)),
            PlanContainer(
              padding: context.paddingSymmetricR(horizontal: 12, vertical: 12),
              isSelected: false,
              onTap: () {},
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  NormalText(
                    titleText: 'Today\'s Focus',
                    titleSize: context.sp(16),
                    titleWeight: FontWeight.w600,
                    titleColor: AppColors.subHeadingColor,
                    maxLines: 3,
                  ),
                  // SizedBox(height: context.sh(10)),
                  ...List.generate(
                    heightResultViewModel.heightRoutineList.length,
                    (index) {
                      final item =
                          heightResultViewModel.heightRoutineList[index];
                      final bool isSelected = heightResultViewModel
                          .isPlanSelected(index);

                      return Center(
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: double.infinity,
                          padding: context.paddingSymmetricR(vertical: 8, horizontal: 20),
                          margin: context.paddingSymmetricR(vertical: 11),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.pimaryColor
                                  : AppColors.backGroundColor,
                              width: context.sw(1.5),
                            ),
                            color: isSelected
                                ? AppColors.pimaryColor.withOpacity(0.15)
                                : AppColors.backGroundColor,

                            boxShadow: [
                              BoxShadow(
                                color: AppColors.customContainerColorUp
                                    .withOpacity(0.4),
                                offset: const Offset(5, 5),
                                blurRadius: 5,
                              ),
                              BoxShadow(
                                color: AppColors.customContinerColorDown
                                    .withOpacity(0.4),
                                offset: const Offset(-5, -5),
                                blurRadius: 5,
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              /// Header
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          heightResultViewModel.selectPlan(
                                            index,
                                          );
                                        },
                                        child: Container(
                                          height: context.sh(28),
                                          width: context.sw(28),
                                          decoration: BoxDecoration(
                                            color: AppColors.backGroundColor,
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: AppColors
                                                    .customContainerColorUp
                                                    .withOpacity(0.4),
                                                offset: const Offset(3, 3),
                                                blurRadius: 4,
                                                inset: true,
                                              ),
                                              BoxShadow(
                                                color: AppColors
                                                    .customContinerColorDown
                                                    .withOpacity(0.4),
                                                offset: const Offset(-3, -3),
                                                blurRadius: 4,
                                                inset: true,
                                              ),
                                            ],
                                          ),
                                          child: Center(
                                            child:
                                                heightResultViewModel
                                                    .isPlanSelected(index)
                                                ? Icon(
                                                    Icons.check,
                                                    size: context.sh(16),
                                                    color:
                                                        AppColors.pimaryColor,
                                                  )
                                                : NormalText(
                                                    titleText: '${index + 1}',
                                                  ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: context.sw(9)),
                                      NormalText(
                                        titleText: item['time'],
                                        titleSize: context.sp(14),
                                        titleWeight: FontWeight.w500,
                                        titleColor: AppColors.subHeadingColor,
                                        subText: item['activity'],
                                        subSize: context.sp(10),
                                        subWeight: FontWeight.w400,
                                        subColor: AppColors.subHeadingColor,
                                      ),
                                    ],
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      heightResultViewModel.toggleExpand(index);
                                    },
                                    child: Icon(
                                      heightResultViewModel.isExpanded(index)
                                          ? Icons.keyboard_arrow_up
                                          : Icons.keyboard_arrow_down,
                                      size: context.sh(24),
                                    ),
                                  ),
                                ],
                              ),

                              /// Expand Section
                              AnimatedCrossFade(
                                firstChild: const SizedBox(),
                                secondChild: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: context.sh(12)),
                                    NormalText(
                                      titleText: item['details'],
                                      titleSize: context.sp(12),
                                      titleWeight: FontWeight.w600,
                                      titleColor: AppColors.iconColor,
                                    ),
                                    SizedBox(height: context.sh(6)),
                                    NormalText(
                                      titleText: "• Do exercises slowly",
                                      titleSize: context.sp(12),
                                      titleWeight: FontWeight.w600,
                                      titleColor: AppColors.iconColor,
                                    ),
                                    SizedBox(height: context.sh(6)),
                                    NormalText(
                                      titleText: "• Maintain proper breathing",
                                      titleSize: context.sp(12),
                                      titleWeight: FontWeight.w600,
                                      titleColor: AppColors.iconColor,
                                    ),
                                  ],
                                ),
                                crossFadeState:
                                    heightResultViewModel.isExpanded(index)
                                    ? CrossFadeState.showSecond
                                    : CrossFadeState.showFirst,
                                duration: const Duration(milliseconds: 300),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            SizedBox(height: context.sh(30)),
          ],
        ),
      ),
    );
  }
}
