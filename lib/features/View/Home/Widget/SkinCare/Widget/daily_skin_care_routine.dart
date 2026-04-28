import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:looklabs/Features/Widget/app_bar_container.dart';
import 'package:looklabs/Features/Widget/custom_container.dart';
import 'package:looklabs/Features/Widget/custom_stepper.dart';
import 'package:looklabs/Features/Widget/light_card_widget.dart';
import 'package:looklabs/Features/Widget/line_chart_widget.dart';
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
  final PageController _pageController = PageController();
  int _currentIndicatorPage = 0;

  @override
  void initState() {
    super.initState();
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

  bool _hasDisplayData(Map<String, dynamic> item) {
    final title = item['title']?.toString().trim() ?? '';
    final subTitle = item['subTitle']?.toString().trim() ?? '';
    final hasLabelData = title.isNotEmpty || subTitle.isNotEmpty;
    final hasPercentData =
        item['pers']?.toString().trim().isNotEmpty == true ||
        item['progress'] is num;
    return hasLabelData && hasPercentData;
  }

  @override
  Widget build(BuildContext context) {
    final dailySkinCareRoutineViewModel = context
        .watch<DailySkinCareRoutineViewModel>();
    final progressViewModel = context.watch<ProgressViewModel>();
    final indicatorPages = dailySkinCareRoutineViewModel.indicatorPages;
    final visiblePageIndices = <int>[];
    final visibleIndicatorPages = <List<Map<String, dynamic>>>[];
    for (var i = 0; i < indicatorPages.length; i++) {
      final filteredPage = indicatorPages[i].where(_hasDisplayData).toList();
      if (filteredPage.isEmpty) continue;
      visiblePageIndices.add(i);
      visibleIndicatorPages.add(filteredPage);
    }
    final hasVisibleIndicatorPages = visibleIndicatorPages.isNotEmpty;
    if (hasVisibleIndicatorPages &&
        _currentIndicatorPage >= visibleIndicatorPages.length) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final target = visibleIndicatorPages.length - 1;
        if (_currentIndicatorPage != target) {
          setState(() => _currentIndicatorPage = target);
        }
        if (_pageController.hasClients) {
          _pageController.jumpToPage(target);
        }
      });
    }

    return Scaffold(
      backgroundColor: AppColors.backGroundColor,
      body: SafeArea(
        child: ListView(
          padding: context.paddingSymmetricR(horizontal: 20),
          children: [
            AppBarContainer(
              title: 'Daily Skin Routine',
              onTap: () {
                Navigator.pop(context);
              },
               
            ),

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
                          border: Border.all(color: AppColors.pimaryColor,width: 2),
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

            if (hasVisibleIndicatorPages)
              CustomStepper(
                currentStep: _currentIndicatorPage.clamp(
                  0,
                  visibleIndicatorPages.length - 1,
                ),
                steps: visiblePageIndices
                    .map(
                      (i) => dailySkinCareRoutineViewModel
                          .sectionHeadingForPage(i),
                    )
                    .map((s) => s.trim().isEmpty ? ' ' : s.trim())
                    .toList(),
              ),
            // if (hasVisibleIndicatorPages)
            //   SizedBox(height: context.sh(12)),
            if (hasVisibleIndicatorPages)
              SizedBox(
                height: context.sh(265),
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    if (!mounted || _currentIndicatorPage == index) return;
                    setState(() => _currentIndicatorPage = index);
                  },
                  itemCount: visibleIndicatorPages.length,
                  itemBuilder: (_, pageIndex) {
                    final pageData = visibleIndicatorPages[pageIndex];
                    final sourcePageIndex = visiblePageIndices[pageIndex];

                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (dailySkinCareRoutineViewModel
                              .sectionHeadingForPage(sourcePageIndex)
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
                                        .sectionHeadingForPage(sourcePageIndex),
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
                        ],
                      ),
                    );
                  },
                ),
              ),

            if (hasVisibleIndicatorPages &&
                visibleIndicatorPages.length > 1) ...[
              SizedBox(height: context.sh(12)),
              Center(
                child: SmoothPageIndicator(
                  controller: _pageController,
                  count: visibleIndicatorPages.length,
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
            SizedBox(height: context.sh(12)),
            if (dailySkinCareRoutineViewModel.todayRoutine.isNotEmpty)
              NormalText(
                crossAxisAlignment: CrossAxisAlignment.start,
                titleText: 'Today’s Routine',
                titleSize: context.sp(18),
                titleWeight: FontWeight.w600,
                titleColor: AppColors.headingColor,
              ),
            SizedBox(height: context.sh(8)),
            if (dailySkinCareRoutineViewModel.todayRoutine.isNotEmpty)
              PlanContainer(
                padding: context.paddingSymmetricR(
                  horizontal: 14,
                  vertical: 14,
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
                                      color: AppColors.grey,
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

            SizedBox(height: context.sh(8)),
            NormalText(
              crossAxisAlignment: CrossAxisAlignment.start,
              titleText: 'Night’s Routine',
              titleSize: context.sp(18),
              titleWeight: FontWeight.w600,
              titleColor: AppColors.headingColor,
            ),
            SizedBox(height: context.sh(8)),
            if (dailySkinCareRoutineViewModel.nightRoutine.isNotEmpty)
              PlanContainer(
                padding: context.paddingSymmetricR(
                  horizontal: 14,
                  vertical: 14,
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
            SizedBox(height: context.sh(12)),

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
                      index <
                          dailySkinCareRoutineViewModel.extraCards.length - 1
                      ? context.sh(22)
                      : 0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (title.isNotEmpty)
                      NormalText(
                        titleText: title,
                        titleSize: context.sp(18),
                        titleWeight: FontWeight.w600,
                        titleColor: AppColors.headingColor,
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
            }),         SizedBox(height: context.sh(24)),
            if (dailySkinCareRoutineViewModel.aiMessage != null &&
                dailySkinCareRoutineViewModel.aiMessage!.isNotEmpty) ...[
              SizedBox(height: context.sh(12)),
              LightCardWidget(text: dailySkinCareRoutineViewModel.aiMessage!),
            ],
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
    if (progressViewModel.progressLoading &&
        !progressViewModel.hasProgressSnapshot) {
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
    if (pts.isNotEmpty) {
      return LineChartWidget(workoutChartData: pts);
    }

    // Fallback: graph API can return empty `scores` for all domains.
    // In that case, show domain-level overview points instead of blank space.
    final domainPts = progressViewModel.progressDomains
        .where((d) => d.hasData || d.score > 0)
        .map((d) => SalesData(d.domain, d.score.toDouble()))
        .toList();
    if (domainPts.isNotEmpty) {
      return LineChartWidget(
        workoutChartData: domainPts,
        yAxisMinimum: 0,
        yAxisMaximum: 100,
        valueDisplaySuffix: '%',
      );
    }
    return SizedBox(height: context.sh(120));
  }
}
