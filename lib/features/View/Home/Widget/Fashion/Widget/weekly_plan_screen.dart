import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:flutter_svg/svg.dart';
import 'package:looklabs/Core/Constants/app_assets.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Features/Widget/app_bar_container.dart';
import 'package:looklabs/Features/Widget/button_card_widget.dart';
import 'package:looklabs/Features/Widget/custom_container.dart';
import 'package:looklabs/Features/Widget/normal_text.dart';
import 'package:looklabs/Features/Widget/plan_container.dart';
import 'package:looklabs/Features/ViewModel/weekly_plan_screen_view_model.dart';
import 'package:provider/provider.dart';

class WeeklyPlanScreen extends StatefulWidget {
  const WeeklyPlanScreen({super.key});

  @override
  State<WeeklyPlanScreen> createState() => _WeeklyPlanScreenState();
}

class _WeeklyPlanScreenState extends State<WeeklyPlanScreen> {
  @override
  Widget build(BuildContext context) {
    final weeklyPlanScreenViewModel = Provider.of<WeeklyPlanScreenViewModel>(
      context,
    );
    return Scaffold(
      backgroundColor: AppColors.backGroundColor,
      body: SafeArea(
        child: ListView(
          padding: context.paddingSymmetricR(horizontal: 20),
          children: [
            AppBarContainer(
              title: 'Weekly Plan',
              onTap: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(height: context.sh(24)),
            NormalText(
              crossAxisAlignment: CrossAxisAlignment.start,
              titleText: 'Daily style themes to keep you sharp',
              titleSize: context.sp(18),
              titleWeight: FontWeight.w600,
              titleColor: AppColors.subHeadingColor,
            ),
            SizedBox(height: context.sh(8)),
            ...List.generate(
              weeklyPlanScreenViewModel.heightRoutineList.length,
              (index) {
                final item = weeklyPlanScreenViewModel.heightRoutineList[index];
                weeklyPlanScreenViewModel.isPlanSelected(index);

                return Center(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: double.infinity,
                    padding: context.paddingSymmetricR(horizontal: 20),
                    margin: context.paddingSymmetricR(vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppColors.backGroundColor,
                        width: context.sw(1.5),
                      ),
                      color: AppColors.backGroundColor,

                      boxShadow: [
                        BoxShadow(
                          color: AppColors.customContainerColorUp.withOpacity(
                            0.4,
                          ),
                          offset: const Offset(5, 5),
                          blurRadius: 5,
                        ),
                        BoxShadow(
                          color: AppColors.customContinerColorDown.withOpacity(
                            0.4,
                          ),
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                PlanContainer(
                                  padding: context.paddingSymmetricR(horizontal: 6, vertical: 6),
                                  isSelected: false,
                                  onTap: () {},
                                  child: Center(
                                    child: SvgPicture.asset(
                                      AppAssets.sunIcon,
                                      color: AppColors.fireColor,
                                      fit: BoxFit.scaleDown,
                                    ),
                                  ),
                                ),
                                SizedBox(width: context.sw(11)),
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
                                weeklyPlanScreenViewModel.toggleExpand(index);
                              },
                              child: Icon(
                                weeklyPlanScreenViewModel.isExpanded(index)
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
                              weeklyPlanScreenViewModel.isExpanded(index)
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
            SizedBox(height: context.sh(8)),
            NormalText(
              titleText: 'Seasonal Style',
              titleSize: context.sp(16),
              titleWeight: FontWeight.w600,
              titleColor: AppColors.subHeadingColor,
              subText: 'Weather-appropriate recommendations',
              subSize: context.sp(14),
              subWeight: FontWeight.w600,
              subColor: AppColors.iconColor,
              sizeBoxheight: context.sh(8),
            ),
            SizedBox(height: context.sh(8)),
            Wrap(
              spacing: context.sw(8), // horizontal gap
              runSpacing: context.sh(8), // vertical gap
              children: List.generate(
                weeklyPlanScreenViewModel.buttonName.length,
                (index) {
                  final bool isSelected =
                      weeklyPlanScreenViewModel.selectedIndex == index;

                  return CustomContainer(
                    onTap: () {
                      weeklyPlanScreenViewModel.selectIndex(index);
                    },
                    radius: context.radiusR(10),
                    padding: context.paddingSymmetricR(horizontal: 19, vertical: 11),
                    color: isSelected
                        ? AppColors.buttonColor.withOpacity(0.11)
                        : AppColors.backGroundColor,
                    border: isSelected
                        ? Border.all(color: AppColors.pimaryColor, width: 1.5)
                        : null,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          weeklyPlanScreenViewModel.buttonName[index]['image'],
                          fit: BoxFit.scaleDown,
                        ),
                        SizedBox(width: context.sw(4)),
                        Text(
                          weeklyPlanScreenViewModel.buttonName[index]['title'],
                          style: TextStyle(
                            fontSize: context.sp(13),
                            fontWeight: FontWeight.w700,
                            color: AppColors.seconderyColor,
                            fontFamily: 'Raleway',
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: context.sh(8)),
            if (weeklyPlanScreenViewModel.showClothingCard)
              ButtonCard(
                title: weeklyPlanScreenViewModel
                    .titleData[weeklyPlanScreenViewModel.selectedIndex],
                listData: weeklyPlanScreenViewModel.clothingFits,
              ),
          ],
        ),
      ),
    );
  }
}
