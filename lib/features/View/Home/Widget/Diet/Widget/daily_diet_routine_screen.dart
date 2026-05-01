import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:looklabs/Features/Widget/app_bar_container.dart';
import 'package:looklabs/Features/Widget/custom_button.dart';
import 'package:looklabs/Features/Widget/light_card_widget.dart';
import 'package:looklabs/Features/Widget/normal_text.dart';
import 'package:looklabs/Features/Widget/plan_container.dart';
import 'package:looklabs/Core/Constants/app_assets.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Core/Routes/routes_name.dart';
import 'package:looklabs/Features/ViewModel/daily_diet_routine_screen_view_model.dart';
import 'package:provider/provider.dart';

class DailyDietRoutineScreen extends StatefulWidget {
  const DailyDietRoutineScreen({super.key});

  @override
  State<DailyDietRoutineScreen> createState() => _DailyDietRoutineScreenState();
}

class _DailyDietRoutineScreenState extends State<DailyDietRoutineScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<DailyDietRoutineScreenViewModel>().initialize();
    });
  }

  Widget _buildRoutineSection(
    BuildContext context,
    DailyDietRoutineScreenViewModel vm, {
    required String sectionKey,
    required String title,
    required Widget icon,
    required List<Map<String, dynamic>> items,
  }) {
    return PlanContainer(
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
                  borderRadius: BorderRadius.circular(context.radiusR(10)),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.customContainerColorUp.withValues(
                        alpha: 0.4,
                      ),
                      offset: const Offset(3, 3),
                      blurRadius: 4,
                    ),
                    BoxShadow(
                      color: AppColors.customContinerColorDown.withValues(
                        alpha: 0.4,
                      ),
                      offset: const Offset(-3, -3),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Center(child: icon),
              ),
              SizedBox(width: context.sw(11)),
              Expanded(
                child: NormalText(
                  titleText: title,
                  titleSize: context.sp(14),
                  titleWeight: FontWeight.w600,
                  titleColor: AppColors.subHeadingColor,
                ),
              ),
            ],
          ),
          ...List.generate(items.length, (index) {
            final item = items[index];
            final key = '${sectionKey}_$index';
            final selected = vm.isPlanSelected(key);
            final expanded = vm.isExpanded(key);
            return AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              width: double.infinity,
              padding: context.paddingSymmetricR(vertical: 8, horizontal: 16),
              margin: context.paddingSymmetricR(vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: selected
                      ? AppColors.pimaryColor
                      : AppColors.backGroundColor,
                  width: context.sw(1.2),
                ),
                color: selected
                    ? AppColors.pimaryColor.withValues(alpha: 0.12)
                    : AppColors.backGroundColor,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.customContainerColorUp.withValues(
                      alpha: 0.4,
                    ),
                    offset: const Offset(5, 5),
                    blurRadius: 5,
                  ),
                  BoxShadow(
                    color: AppColors.customContinerColorDown.withValues(
                      alpha: 0.4,
                    ),
                    offset: const Offset(-5, -5),
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => vm.togglePlanDone(key),
                        child: Container(
                          height: context.sh(28),
                          width: context.sw(28),
                          decoration: BoxDecoration(
                            color: selected
                                ? AppColors.pimaryColor
                                : AppColors.backGroundColor,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: selected
                                ? Icon(
                                    Icons.check,
                                    size: context.sh(16),
                                    color: AppColors.white,
                                  )
                                : NormalText(titleText: '${index + 1}'),
                          ),
                        ),
                      ),
                      SizedBox(width: context.sw(9)),
                      Expanded(
                        child: NormalText(
                          titleText: item['title']?.toString() ?? '',
                          titleSize: context.sp(14),
                          titleWeight: FontWeight.w500,
                          titleColor: AppColors.subHeadingColor,
                          subText: item['subtitle']?.toString() ?? '',
                          subSize: context.sp(10),
                          subWeight: FontWeight.w400,
                          subColor: AppColors.subHeadingColor,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => vm.toggleExpand(key),
                        child: Icon(
                          expanded
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          size: context.sh(24),
                        ),
                      ),
                    ],
                  ),
                  AnimatedCrossFade(
                    firstChild: const SizedBox(),
                    secondChild: Padding(
                      padding: context.paddingSymmetricR(vertical: 8),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: NormalText(
                          titleText: item['details']?.toString() ?? '',
                          titleSize: context.sp(12),
                          titleWeight: FontWeight.w500,
                          titleColor: AppColors.iconColor,
                        ),
                      ),
                    ),
                    crossFadeState: expanded
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    duration: const Duration(milliseconds: 220),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dailyDietRoutineScreenViewModel =
        Provider.of<DailyDietRoutineScreenViewModel>(context);

    return Scaffold(
      backgroundColor: AppColors.backGroundColor,
      floatingActionButton: PlanContainer(
        padding: context.paddingSymmetricR(horizontal: 8, vertical: 8),
        radius: BorderRadius.circular(context.radiusR(10)),
        isSelected: false,
        onTap: () {
          dailyDietRoutineScreenViewModel.showTransparentDialog(context);
        },
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsetsGeometry.only(
          top: context.sh(5),
          left: context.sw(20),
          right: context.sw(20),
          bottom: context.sh(30),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: PlanContainer(
                padding: context.paddingSymmetricR(horizontal: 12, vertical: 18),
                radius: BorderRadius.circular(context.radiusR(16)),
                isSelected: false,
                onTap: () {
                  Navigator.pushNamed(context, RoutesName.AllTrackedFood);
                },
                child: NormalText(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  titleText: 'Track Nutrition',
                  titleSize: context.sp(14),
                  titleColor: AppColors.subHeadingColor,
                  titleWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(width: context.sw(12)),
            Expanded(
              child: CustomButton(
                padding: context.paddingSymmetricR(horizontal: 12),
                isEnabled: true,
                onTap: () => Navigator.pushNamed(
                  context,
                  RoutesName.DietProgressScreen,
                ),
                text: 'Your Progress',
                color: AppColors.pimaryColor,
              ),
            ),
          ],
        ),
      ),

      body: SafeArea(
        child: ListView(
          padding: context.paddingSymmetricR(horizontal: 20),
          children: [
            AppBarContainer(
              title: 'Daily Diet Routine',
              onTap: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(height: context.sh(24)),
            NormalText(
              crossAxisAlignment: CrossAxisAlignment.start,
              titleText: dailyDietRoutineScreenViewModel.routineSubtitle.isNotEmpty
                  ? dailyDietRoutineScreenViewModel.routineSubtitle
                  : 'Healthy eating habits for better nutrition & energy',
              titleSize: context.sp(16),
              titleWeight: FontWeight.w600,
              titleColor: AppColors.subHeadingColor,
            ),

            SizedBox(height: context.sh(10)),
            _buildRoutineSection(
              context,
              dailyDietRoutineScreenViewModel,
              sectionKey: 'morning',
              title: 'Morning Plan',
              icon: SizedBox(
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
              items: dailyDietRoutineScreenViewModel.morningPlan,
            ),
            SizedBox(height: context.sh(8)),
            _buildRoutineSection(
              context,
              dailyDietRoutineScreenViewModel,
              sectionKey: 'evening',
              title: 'Evening Plan',
              icon: SizedBox(
                height: context.sh(32),
                width: context.sw(32),
                child: SvgPicture.asset(
                  AppAssets.nightIcon,
                  fit: BoxFit.scaleDown,
                ),
              ),
              items: dailyDietRoutineScreenViewModel.eveningPlan,
            ),
            SizedBox(height: context.sh(6)),
            if (dailyDietRoutineScreenViewModel.insightText.isNotEmpty)
              LightCardWidget(
                text: dailyDietRoutineScreenViewModel.insightText,
              ),
            SizedBox(height: context.sh(30)),
          ],
        ),
      ),
    );
  }
}
