import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:looklabs/Features/Widget/app_bar_container.dart';
import 'package:looklabs/Features/Widget/custom_container.dart';
import 'package:looklabs/Features/Widget/custom_stepper.dart';
import 'package:looklabs/Features/Widget/line_chart_widget.dart';
import 'package:looklabs/Features/Widget/speed_meter_widget.dart';
import 'package:looklabs/Features/Widget/normal_text.dart';
import 'package:looklabs/Features/Widget/plan_container.dart';
import 'package:looklabs/Features/Widget/routine_detail_nav_card.dart';
import 'package:looklabs/Features/Widget/simple_check_box.dart';
import 'package:looklabs/Features/Widget/text_and_indector_container.dart';
import 'package:looklabs/Core/Constants/app_assets.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Core/Routes/routes_name.dart';
import 'package:looklabs/Features/ViewModel/daily_skin_care_routine_view_model.dart';
import 'package:looklabs/Features/ViewModel/progress_view_model.dart';
import 'package:looklabs/Model/sales_data.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class DailySkinCareRoutine extends StatefulWidget {
  const DailySkinCareRoutine({super.key});

  @override
  State<DailySkinCareRoutine> createState() => _DailySkinCareRoutineState();
}

class _DailySkinCareRoutineState extends State<DailySkinCareRoutine> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<ProgressViewModel>().loadProgressForWeek();
      context.read<DailySkinCareRoutineViewModel>().loadSkincareRoutine();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  String _formatPercent(dynamic pers) {
    final s = pers?.toString().trim() ?? '';
    if (s.isEmpty) return '';
    if (s.contains('%')) return s;
    return '$s%';
  }

  @override
  Widget build(BuildContext context) {
    final dailySkinCareRoutineViewModel = context
        .watch<DailySkinCareRoutineViewModel>();
    final progressViewModel = context.watch<ProgressViewModel>();

    return Scaffold(
      backgroundColor: AppColors.backGroundColor,
      body: SafeArea(
        child: ListView(
          padding: context.paddingSymmetricR(horizontal: 20),
          children: [
            AppBarContainer(
              title: 'Daily Skin Care Routine',
              onTap: () {
                Navigator.pop(context);
              },
              onRescanTap: () {
                Navigator.pushReplacementNamed(
                  context,
                  RoutesName.SkinReviewScansScreen,
                );
              },
            ),
            if (dailySkinCareRoutineViewModel.showRoutineRefreshing)
              Padding(
                padding: EdgeInsets.only(top: context.sh(12)),
                child: LinearProgressIndicator(
                  color: AppColors.pimaryColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            if (dailySkinCareRoutineViewModel.loadError != null)
              Padding(
                padding: EdgeInsets.only(top: context.sh(8)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      dailySkinCareRoutineViewModel.loadError!,
                      style: TextStyle(
                        color: AppColors.redColor,
                        fontSize: context.sp(12),
                      ),
                    ),
                    TextButton(
                      onPressed: () =>
                          dailySkinCareRoutineViewModel.loadSkincareRoutine(),
                      child: Text(
                        'Retry',
                        style: TextStyle(
                          color: AppColors.pimaryColor,
                          fontSize: context.sp(14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            if (dailySkinCareRoutineViewModel.aiMessage != null &&
                dailySkinCareRoutineViewModel.aiMessage!.trim().isNotEmpty)
              Padding(
                padding: EdgeInsets.only(top: context.sh(12)),
                child: Text(
                  dailySkinCareRoutineViewModel.aiMessage!,
                  style: TextStyle(
                    fontSize: context.sp(13),
                    color: AppColors.subHeadingColor,
                  ),
                ),
              ),
            if (dailySkinCareRoutineViewModel.flowProgressPercent != null ||
                (dailySkinCareRoutineViewModel.flowProgressSummary != null &&
                    dailySkinCareRoutineViewModel
                        .flowProgressSummary!
                        .isNotEmpty))
              Padding(
                padding: EdgeInsets.only(top: context.sh(8)),
                child: Text(
                  [
                    if (dailySkinCareRoutineViewModel.flowProgressPercent !=
                        null)
                      '${dailySkinCareRoutineViewModel.flowProgressPercent!.toStringAsFixed(0)}%',
                    if (dailySkinCareRoutineViewModel.flowProgressSummary !=
                            null &&
                        dailySkinCareRoutineViewModel
                            .flowProgressSummary!
                            .isNotEmpty)
                      dailySkinCareRoutineViewModel.flowProgressSummary!,
                  ].join(' · '),
                  style: TextStyle(
                    fontSize: context.sp(12),
                    color: AppColors.subHeadingColor,
                  ),
                ),
              ),
            if (dailySkinCareRoutineViewModel.flowStatus != null &&
                dailySkinCareRoutineViewModel.flowStatus!.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(top: context.sh(4)),
                child: Text(
                  'Status: ${dailySkinCareRoutineViewModel.flowStatus}',
                  style: TextStyle(
                    fontSize: context.sp(11),
                    color: AppColors.subHeadingColor.withValues(alpha: 0.85),
                  ),
                ),
              ),
            SizedBox(height: context.sh(24)),

            if (dailySkinCareRoutineViewModel.hasIndicatorGrid)
              SizedBox(
                height: context.sh(400),
                child: PageView.builder(
                  controller: _pageController,
                  itemCount:
                      dailySkinCareRoutineViewModel.indicatorPages.length,
                  itemBuilder: (_, pageIndex) {
                    final pageData =
                        dailySkinCareRoutineViewModel.indicatorPages[pageIndex];
                    final isLastPage =
                        pageIndex ==
                        dailySkinCareRoutineViewModel.indicatorPages.length - 1;
                    final showConcernsMeter =
                        isLastPage && pageData.length >= 2;

                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CustomStepper(
                            currentStep: pageIndex,
                            steps: dailySkinCareRoutineViewModel
                                .indicatorStepperLabels,
                          ),
                          SizedBox(height: context.sh(12)),
                          if (dailySkinCareRoutineViewModel
                              .sectionHeadingForPage(pageIndex)
                              .isNotEmpty)
                            Row(
                              children: [
                                SvgPicture.asset(
                                  AppAssets.starIcon,
                                  height: context.sh(24),
                                  width: context.sw(24),
                                  colorFilter: const ColorFilter.mode(
                                    AppColors.pimaryColor,
                                    BlendMode.srcIn,
                                  ),
                                ),
                                SizedBox(width: context.sw(8)),
                                Expanded(
                                  child: Text(
                                    dailySkinCareRoutineViewModel
                                        .sectionHeadingForPage(pageIndex),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: context.sp(18),
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.headingColor,
                                      fontFamily: 'Raleway',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          if (!showConcernsMeter)
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 4 / 3,
                                  ),
                              itemCount: pageData.length,
                              itemBuilder: (_, index) {
                                final item = pageData[index];
                                final raw = item['progress'];
                                final progress = raw is num
                                    ? raw.toDouble()
                                    : double.tryParse(raw?.toString() ?? '');
                                return TextAndIndectorContiner(
                                  title: item['title']?.toString(),
                                  subTitle: item['subTitle']?.toString(),
                                  pers: item['pers']?.toString(),
                                  progress: progress,
                                  usePlaceholderProgress: false,
                                );
                              },
                            ),
                          if (showConcernsMeter)
                            SpeedMeterWidget(
                              box1Title: pageData[0]['title']?.toString(),
                              box1subTitle: pageData[0]['subTitle']?.toString(),
                              box2Title: pageData[1]['title']?.toString(),
                              box2subTitle: pageData[1]['subTitle']?.toString(),
                              box1per: _formatPercent(pageData[0]['pers']),
                              box2per: _formatPercent(pageData[1]['pers']),
                              smHTitle: dailySkinCareRoutineViewModel
                                  .concernsMeterHeading,
                              smTitle: pageData[0]['title']?.toString() ?? '',
                              smsSubTitle:
                                  pageData[0]['subTitle']?.toString() ?? '',
                              gaugeNeedleValue:
                                  SpeedMeterWidget.needleFromConcernRows(
                                pageData,
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),

            if (dailySkinCareRoutineViewModel.hasIndicatorGrid &&
                dailySkinCareRoutineViewModel.indicatorPages.length > 1) ...[
              SizedBox(height: context.sh(12)),
              Center(
                child: SmoothPageIndicator(
                  controller: _pageController,
                  count: dailySkinCareRoutineViewModel.indicatorPages.length,
                  effect: ExpandingDotsEffect(
                    dotHeight: context.sh(8),
                    dotWidth: context.sw(8),
                    expansionFactor: 3,
                    spacing: 6,
                    activeDotColor: AppColors.pimaryColor,
                    dotColor: AppColors.pimaryColor.withValues(alpha: 0.3),
                  ),
                ),
              ),
            ],

            SizedBox(height: context.sh(18)),
            SizedBox(
              height: context.sh(210),
              child: ListView.builder(
                itemCount: dailySkinCareRoutineViewModel.scanTiles.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final tiles = dailySkinCareRoutineViewModel.scanTiles;
                  final label = index < tiles.length
                      ? (tiles[index]['label'] ?? '')
                      : '';
                  final url = index < tiles.length
                      ? (tiles[index]['url'] ?? '')
                      : '';
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: context.sw(158),
                        height: context.sh(158),
                        padding: context.paddingSymmetricR(
                          horizontal: 1,
                          vertical: 1,
                        ),
                        margin: EdgeInsets.only(right: context.sw(12)),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.pimaryColor),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: url.isNotEmpty
                              ? Image.network(
                                  url,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      ColoredBox(
                                        color: AppColors.white,
                                        child: Icon(
                                          Icons.face_retouching_natural,
                                          size: context.sw(48),
                                          color: AppColors.pimaryColor
                                              .withValues(alpha: 0.5),
                                        ),
                                      ),
                                )
                              : ColoredBox(
                                  color: AppColors.white,
                                  child: Icon(
                                    Icons.add_a_photo_outlined,
                                    size: context.sw(40),
                                    color: AppColors.subHeadingColor.withValues(
                                      alpha: 0.6,
                                    ),
                                  ),
                                ),
                        ),
                      ),
                      SizedBox(height: context.sh(8)),
                      NormalText(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        titleText: label,
                        titleSize: context.sp(14),
                        titleColor: AppColors.subHeadingColor,
                        titleWeight: FontWeight.w600,
                      ),
                    ],
                  );
                },
              ),
            ),

            SizedBox(height: context.sh(18)),
            NormalText(
              crossAxisAlignment: CrossAxisAlignment.start,
              titleText: 'Today’s Routine',
              titleSize: context.sp(18),
              titleWeight: FontWeight.w600,
              titleColor: AppColors.headingColor,
            ),
            SizedBox(height: context.sh(10)),
            if (dailySkinCareRoutineViewModel.todayRoutine.isNotEmpty)
              PlanContainer(
                padding: context.paddingSymmetricR(
                  horizontal: 14,
                  vertical: 18,
                ),
                isSelected: false,
                onTap: () {},
                child: Column(
                  children: List.generate(
                    dailySkinCareRoutineViewModel.todayRoutine.length,
                    (index) {
                      final item =
                          dailySkinCareRoutineViewModel.todayRoutine[index];
                      final checked =
                          index <
                              dailySkinCareRoutineViewModel.todayChecked.length
                          ? dailySkinCareRoutineViewModel.todayChecked[index]
                          : false;
                      return Padding(
                        padding: EdgeInsets.only(bottom: context.sh(10)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SimpleCheckBox(
                              isSelected: checked,
                              onTap: () => dailySkinCareRoutineViewModel
                                  .toggleTodayCheck(index),
                            ),
                            SizedBox(width: context.sw(12)),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['title'] ?? '',
                                    style: TextStyle(
                                      fontSize: context.sp(14),
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.subHeadingColor,
                                    ),
                                  ),
                                  SizedBox(height: context.sh(4)),
                                  Text(
                                    item['subtitle'] ?? '',
                                    style: TextStyle(
                                      fontSize: context.sp(10),
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.subHeadingColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),

            SizedBox(height: context.sh(12)),
            NormalText(
              crossAxisAlignment: CrossAxisAlignment.start,
              titleText: 'Night’s Routine',
              titleSize: context.sp(18),
              titleWeight: FontWeight.w600,
              titleColor: AppColors.headingColor,
            ),
            SizedBox(height: context.sh(12)),
            if (dailySkinCareRoutineViewModel.nightRoutine.isNotEmpty)
              PlanContainer(
                padding: context.paddingSymmetricR(
                  horizontal: 14,
                  vertical: 18,
                ),
                isSelected: false,
                onTap: () {},
                child: Column(
                  children: List.generate(
                    dailySkinCareRoutineViewModel.nightRoutine.length,
                    (index) {
                      final item =
                          dailySkinCareRoutineViewModel.nightRoutine[index];
                      final checked =
                          index <
                              dailySkinCareRoutineViewModel.nightChecked.length
                          ? dailySkinCareRoutineViewModel.nightChecked[index]
                          : false;
                      return Padding(
                        padding: EdgeInsets.only(bottom: context.sh(10)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SimpleCheckBox(
                              isSelected: checked,
                              onTap: () => dailySkinCareRoutineViewModel
                                  .toggleNightCheck(index),
                            ),
                            SizedBox(width: context.sw(12)),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['title'] ?? '',
                                    style: TextStyle(
                                      fontSize: context.sp(14),
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.subHeadingColor,
                                    ),
                                  ),
                                  SizedBox(height: context.sh(4)),
                                  Text(
                                    item['subtitle'] ?? '',
                                    style: TextStyle(
                                      fontSize: context.sp(10),
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.subHeadingColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            SizedBox(height: context.sh(10)),

            Row(
              children: List.generate(progressViewModel.buttonName.length, (
                index,
              ) {
                final bool isSelected =
                    progressViewModel.selectedIndex ==
                    progressViewModel.buttonName[index];
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: context.sw(4)),
                    child: CustomContainer(
                      radius: context.radiusR(10),
                      onTap: () {
                        progressViewModel.selectIndex(index);
                      },
                      color: isSelected
                          ? AppColors.buttonColor.withValues(alpha: 0.11)
                          : AppColors.backGroundColor,
                      border: isSelected
                          ? Border.all(color: AppColors.pimaryColor, width: 1.5)
                          : null,
                      padding: context.paddingSymmetricR(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      margin: context.paddingSymmetricR(
                        horizontal: 0,
                        vertical: 0,
                      ),
                      child: Center(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.center,
                          child: Text(
                            progressViewModel.buttonName[index],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: context.sp(14),
                              fontWeight: FontWeight.w700,
                              color: AppColors.seconderyColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),

            SizedBox(height: context.sh(10)),
            PlanContainer(
              padding: context.paddingSymmetricR(horizontal: 10, vertical: 10),
              margin: context.paddingSymmetricR(vertical: 10),
              radius: BorderRadius.circular(context.radiusR(10)),
              isSelected: false,
              onTap: () {},
              child: _SkincareRoutineProgressChart(
                progressViewModel: progressViewModel,
              ),
            ),
            SizedBox(height: context.sh(10)),

            ...List.generate(dailySkinCareRoutineViewModel.extraCards.length, (
              index,
            ) {
              final card = dailySkinCareRoutineViewModel.extraCards[index];
              final title = card.title.trim();
              final subtitle = card.subtitle.trim();
              return Padding(
                padding: EdgeInsets.only(
                  bottom:
                      index < dailySkinCareRoutineViewModel.extraCards.length - 1
                      ? context.sh(22)
                      : 0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (title.isNotEmpty)
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: context.sp(16),
                          fontWeight: FontWeight.w600,
                          color: AppColors.headingColor,
                        ),
                      ),
                    if (title.isNotEmpty) SizedBox(height: context.sh(10)),
                    RoutineDetailNavCard(
                      label: subtitle.isNotEmpty ? subtitle : title,
                      useRemediesGradientStyle: card.isRemediesNav,
                      onTap: () {
                        if (card.isRemediesNav) {
                          Navigator.pushNamed(
                            context,
                            RoutesName.SkinHomeRemediesScreen,
                          );
                        } else {
                          Navigator.pushNamed(
                            context,
                            RoutesName.SkinTopProductScreen,
                          );
                        }
                      },
                    ),
                  ],
                ),
              );
            }),
            SizedBox(height: context.sh(30)),
          ],
        ),
      ),
    );
  }
}

/// Uses [ProgressViewModel.progressDays] from `GET users/me/progress/graph` (no demo chart data).
class _SkincareRoutineProgressChart extends StatelessWidget {
  const _SkincareRoutineProgressChart({required this.progressViewModel});

  final ProgressViewModel progressViewModel;

  @override
  Widget build(BuildContext context) {
    if (progressViewModel.progressLoading) {
      return SizedBox(
        height: context.sh(200),
        child: Center(
          child: CircularProgressIndicator(color: AppColors.pimaryColor),
        ),
      );
    }
    if (progressViewModel.progressError != null) {
      return Padding(
        padding: context.paddingSymmetricR(vertical: 24),
        child: Text(
          progressViewModel.progressError!,
          style: TextStyle(fontSize: context.sp(12), color: AppColors.redColor),
        ),
      );
    }
    final pts = progressViewModel.progressDays
        .map((d) => SalesData(d.day, d.score.toDouble()))
        .toList();
    if (pts.isEmpty) {
      return SizedBox(height: context.sh(120));
    }
    return LineChartWidget(workoutChartData: pts);
  }
}
