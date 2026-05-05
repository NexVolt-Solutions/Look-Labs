import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:flutter_svg/svg.dart';
import 'package:looklabs/Features/Widget/activity_consistency_widget.dart';
import 'package:looklabs/Features/Widget/app_bar_container.dart';
import 'package:looklabs/Features/Widget/custom_container.dart';
import 'package:looklabs/Features/Widget/height_widget_cont.dart';
import 'package:looklabs/Features/Widget/light_card_widget.dart';
import 'package:looklabs/Features/Widget/line_chart_widget.dart';
import 'package:looklabs/Features/Widget/linear_slider_widget.dart';
import 'package:looklabs/Features/Widget/normal_text.dart';
import 'package:looklabs/Core/Constants/app_assets.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Features/Widget/plan_container.dart';
import 'package:looklabs/Features/ViewModel/diet_progress_screen_view_model.dart';
import 'package:provider/provider.dart';

class DietProgressScreen extends StatefulWidget {
  const DietProgressScreen({super.key});

  @override
  State<DietProgressScreen> createState() => _DietProgressScreenState();
}

class _DietProgressScreenState extends State<DietProgressScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<DietProgressScreenViewModel>().initialize();
    });
  }

  Widget _metricCard(
    BuildContext context, {
    required String value,
    required String label,
    required String icon,
    String? iconUrl,
  }) {
    return SizedBox(
      width: context.sw(105),
      child: HeightWidgetCont(
        title: value,
        subTitle: label,
        imgPath: icon,
        iconUrl: iconUrl,
      ),
    );
  }

  Widget _miniProgressCard(
    BuildContext context, {
    required String title,
    required double progress,
  }) {
    return PlanContainer(
      padding: context.paddingSymmetricR(horizontal: 10, vertical: 12),
      isSelected: false,
      onTap: () {},
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NormalText(
            titleText: title,
            titleSize: context.sp(13),
            titleWeight: FontWeight.w600,
            titleColor: AppColors.subHeadingColor,
          ),
          SizedBox(height: context.sh(8)),
          LinearSliderWidget(
            progress: progress,
            height: context.sh(8),
            animatedConHeight: context.sh(8),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
              titleText: dietProgressScreenViewModel.subtitle,
              titleSize: context.sp(16),
              titleWeight: FontWeight.w600,
              titleColor: AppColors.subHeadingColor,
            ),
            SizedBox(height: context.sh(8)),
            Row(
              children: [
                ...List.generate(dietProgressScreenViewModel.topStats.length, (index) {
                  final stat = dietProgressScreenViewModel.topStats[index];
                  final icon = index == 0
                      ? AppAssets.fatLossIcon
                      : index == 1
                      ? AppAssets.consisIcon
                      : AppAssets.graphIcon;
                  return Padding(
                    padding: EdgeInsets.only(right: index == dietProgressScreenViewModel.topStats.length - 1 ? 0 : context.sw(8)),
                    child: _metricCard(
                      context,
                      value: stat['value']?.toString() ?? '',
                      label: stat['label']?.toString() ?? '',
                      icon: icon,
                      iconUrl: stat['icon_url']?.toString(),
                    ),
                  );
                }),
              ],
            ),
            SizedBox(height: context.sh(8)),

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
            SizedBox(height: context.sh(10)),
            if (dietProgressScreenViewModel.miniBars.isNotEmpty)
              Row(
                children: List.generate(dietProgressScreenViewModel.miniBars.length, (index) {
                  final item = dietProgressScreenViewModel.miniBars[index];
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: index == dietProgressScreenViewModel.miniBars.length - 1 ? 0 : context.sw(10)),
                      child: _miniProgressCard(
                        context,
                        title: item['title']?.toString() ?? '',
                        progress: item['percent'] is num
                            ? (item['percent'] as num).toDouble()
                            : 0,
                      ),
                    ),
                  );
                }),
              ),
            SizedBox(height: context.sh(16)),

            Row(
              children: List.generate(
                dietProgressScreenViewModel.buttonName.length,
                (index) {
                  final bool isSelected =
                      dietProgressScreenViewModel.selectedIndex ==
                      dietProgressScreenViewModel.buttonName[index];
                  return Expanded(
                    child: CustomContainer(
                      radius: context.radiusR(10),
                      onTap: () {
                        dietProgressScreenViewModel.selectIndex(index);
                      },
                      color: isSelected
                          ? AppColors.buttonColor.withValues(alpha: 0.11)
                          : AppColors.backGroundColor,
                      border: isSelected
                          ? Border.all(color: AppColors.pimaryColor, width: 1.5)
                          : null,
                      padding: context.paddingSymmetricR(
                        horizontal: 12,
                        vertical: 13,
                      ),
                      margin: EdgeInsets.only(
                        right: index ==
                                dietProgressScreenViewModel.buttonName.length - 1
                            ? 0
                            : 8,
                      ),
                      child: Center(
                        child: Text(
                          dietProgressScreenViewModel.buttonName[index],
                          style: TextStyle(
                            fontSize: context.sp(14),
                            fontWeight: FontWeight.w700,
                            color: AppColors.seconderyColor,
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
              padding: context.paddingSymmetricR(horizontal: 10, vertical: 10),
              margin: EdgeInsets.only(bottom: context.sh(20)),
              child: Center(
                child: LineChartWidget(
                  workoutChartData: dietProgressScreenViewModel.chartData,
                  yAxisMinimum: 0,
                  yAxisMaximum: 100,
                  valueDisplaySuffix: '%',
                ),
              ),
            ),
            ActivityConsistencyWidget(
              title: dietProgressScreenViewModel.mainConsistency['title']
                  ?.toString(),
              subtitle: dietProgressScreenViewModel.mainConsistency['subtitle']
                  ?.toString(),
              pressentage:
                  (dietProgressScreenViewModel.mainConsistency['percent'] is num)
                  ? (dietProgressScreenViewModel.mainConsistency['percent']
                            as num)
                        .toDouble()
                  : 0,
            ),
            SizedBox(height: context.sh(6)),
            if (dietProgressScreenViewModel.insightText.isNotEmpty)
              LightCardWidget(
                text: dietProgressScreenViewModel.insightText,
              ),
            SizedBox(height: context.sh(16)),
            if (dietProgressScreenViewModel.checkBoxName.isNotEmpty) ...[
              NormalText(
                titleText: 'Daily Recovery Checklist',
                titleSize: context.sp(18),
                titleWeight: FontWeight.w600,
                titleColor: AppColors.subHeadingColor,
              ),
              SizedBox(height: context.sh(16)),
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
                                color: AppColors.backGroundColor,
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
                                    dietProgressScreenViewModel
                                        .selectedChecklist[index]
                                    ? Icon(
                                        Icons.check,
                                        size: context.sh(14),
                                        color: AppColors.pimaryColor,
                                      )
                                    : null,
                              ),
                            ),
                          ),
                          SizedBox(width: context.sw(12)),
                          Expanded(
                            child: NormalText(
                              titleText:
                                  dietProgressScreenViewModel.checkBoxName[index],
                              titleSize: context.sp(14),
                              titleWeight: FontWeight.w500,
                              titleColor: AppColors.subHeadingColor,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
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
