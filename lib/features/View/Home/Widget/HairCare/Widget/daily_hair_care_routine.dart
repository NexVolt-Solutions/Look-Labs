import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_svg/svg.dart';
import 'package:looklabs/Features/Widget/app_bar_container.dart';
import 'package:looklabs/Features/Widget/custom_container.dart';
import 'package:looklabs/Features/Widget/custom_stepper.dart';
import 'package:looklabs/Features/Widget/line_chart_widget.dart';
import 'package:looklabs/Features/Widget/normal_text.dart';
import 'package:looklabs/Features/Widget/plan_container.dart';
import 'package:looklabs/Features/Widget/simple_check_box.dart';
import 'package:looklabs/Features/Widget/speed_meter_widget.dart';
import 'package:looklabs/Features/Widget/text_and_indector_container.dart';
import 'package:looklabs/Core/Constants/app_assets.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Core/Routes/routes_name.dart';
import 'package:looklabs/Features/ViewModel/daily_hair_care_routine_view_model.dart';
import 'package:looklabs/Features/ViewModel/progress_view_model.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class DailyHairCareRoutine extends StatefulWidget {
  const DailyHairCareRoutine({super.key});

  @override
  State<DailyHairCareRoutine> createState() => _DailyHairCareRoutineState();
}

class _DailyHairCareRoutineState extends State<DailyHairCareRoutine> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dailyHairCareRoutineViewModel =
        Provider.of<DailyHairCareRoutineViewModel>(context);
    final progressViewModel = Provider.of<ProgressViewModel>(context);

    return Scaffold(
      backgroundColor: AppColors.backGroundColor,

      body: SafeArea(
        child: ListView(
          padding: context.paddingSymmetricR(horizontal: 20),
          children: [
            AppBarContainer(
              title: 'Daily Hair Routine',
              onTap: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(height: context.sh(24)),

            SizedBox(
              height: context.sh(400),
              child: PageView.builder(
                controller: _pageController,

                itemCount: dailyHairCareRoutineViewModel.indicatorPages.length,
                itemBuilder: (context, pageIndex) {
                  final pageData =
                      dailyHairCareRoutineViewModel.indicatorPages[pageIndex];
                  final isLastPage =
                      pageIndex ==
                      dailyHairCareRoutineViewModel.indicatorPages.length - 1;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomStepper(
                        currentStep: pageIndex,
                        steps: const ['Attributes', 'Health', 'Concerns'],
                      ),
                      Row(
                        children: [
                          SvgPicture.asset(
                            AppAssets.starIcon,
                            height: context.sh(24),
                            width: context.sw(24),
                            color: AppColors.pimaryColor,
                          ),
                          SizedBox(width: context.sw(8)),
                          NormalText(
                            titleText: pageIndex == 0
                                ? 'Hair Attributes'
                                : pageIndex == 1
                                ? 'Hair Health'
                                : 'Concerns Analysis',
                            titleSize: context.sp(18),
                            titleWeight: FontWeight.w600,
                            titleColor: AppColors.headingColor,
                          ),
                        ],
                      ),

                      // 🔹 Show GridView only if NOT last page
                      if (!isLastPage)
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 4 / 3,
                              ),
                          itemCount: pageData.length,
                          itemBuilder: (context, index) {
                            final item = pageData[index];
                            return TextAndIndectorContiner(
                              title: item['title'],
                              subTitle: item['subTitle'],
                              pers: item['pers'],
                            );
                          },
                        ),

                      if (isLastPage)
                        SpeedMeterWidget(
                          box1Title: 'HairLoss',
                          box1subTitle: 'None',
                          box1per: '10%',
                          box2Title: 'HairLoss',
                          box2subTitle: 'None',
                          box2per: '10%',
                          smHTitle: 'Hair Loss',
                          smTitle: 'Hair loss',
                          smsSubTitle: 'None',
                        ),
                    ],
                  );
                },
              ),
            ),
            SizedBox(height: context.sh(12)),
            Center(
              child: SmoothPageIndicator(
                controller: _pageController,
                count: dailyHairCareRoutineViewModel.indicatorPages.length,
                effect: ExpandingDotsEffect(
                  dotHeight: context.sh(8),
                  dotWidth: context.sw(8),
                  expansionFactor: 3,
                  spacing: 6,
                  activeDotColor: AppColors.pimaryColor,
                  dotColor: AppColors.pimaryColor.withOpacity(0.3),
                ),
              ),
            ),
            NormalText(
              crossAxisAlignment: CrossAxisAlignment.start,
              titleText: 'Today’s Routine',
              titleSize: context.sp(18),
              titleWeight: FontWeight.w600,
              titleColor: AppColors.headingColor,
            ),
            PlanContainer(
              padding: context.paddingSymmetricR(horizontal: 14, vertical: 18),
              isSelected: false,
              onTap: () {},
              child: Column(
                children: List.generate(3, (index) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SimpleCheckBox(
                        isSelected: dailyHairCareRoutineViewModel.isSelected,
                        onTap: () {
                          setState(() {
                            dailyHairCareRoutineViewModel.isSelected =
                                !dailyHairCareRoutineViewModel
                                    .isSelected; // toggle the checkbox
                          });
                        },
                      ),
                      SizedBox(width: context.sw(12)),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Gentle Scalp Wash',
                              style: TextStyle(
                                fontSize: context.sp(14),
                                fontWeight: FontWeight.w500,
                                color: AppColors.subHeadingColor,
                              ),
                            ),
                            SizedBox(height: context.sh(4)),
                            Text(
                              'Removes excess oil and buildup without drying the scalp. '
                              'Helps maintain a clean and balanced scalp environment.',
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
                  );
                }),
              ),
            ),
            SizedBox(height: context.sh(10)),
            NormalText(
              crossAxisAlignment: CrossAxisAlignment.start,
              titleText: 'Night’s Routine',
              titleSize: context.sp(18),
              titleWeight: FontWeight.w600,
              titleColor: AppColors.headingColor,
            ),
            PlanContainer(
              padding: context.paddingSymmetricR(horizontal: 14, vertical: 18),

              isSelected: false,
              onTap: () {},
              child: Column(
                children: List.generate(3, (index) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: context.sh(10)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SimpleCheckBox(
                          isSelected: dailyHairCareRoutineViewModel.isSelected,
                          onTap: () {
                            setState(() {
                              dailyHairCareRoutineViewModel.isSelected =
                                  !dailyHairCareRoutineViewModel
                                      .isSelected; // toggle the checkbox
                            });
                          },
                        ),
                        SizedBox(width: context.sw(12)),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Gentle Scalp Wash',
                                style: TextStyle(
                                  fontSize: context.sp(14),
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.subHeadingColor,
                                ),
                              ),
                              SizedBox(height: context.sh(4)),
                              Text(
                                'Removes excess oil and buildup without drying the scalp. '
                                'Helps maintain a clean and balanced scalp environment.',
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
                }),
              ),
            ),
            SizedBox(height: context.sh(10)),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(progressViewModel.buttonName.length, (
                index,
              ) {
                final bool isSelected =
                    progressViewModel.selectedIndex ==
                    progressViewModel.buttonName[index];
                return CustomContainer(
                  radius: context.radiusR(10),
                  onTap: () {
                    progressViewModel.selectIndex(index);
                  },
                  color: isSelected
                      ? AppColors.buttonColor.withOpacity(0.11)
                      : AppColors.backGroundColor,
                  border: isSelected
                      ? Border.all(color: AppColors.pimaryColor, width: 1.5)
                      : null,
                  padding: context.paddingSymmetricR(horizontal: 38, vertical: 12),
                  margin: context.paddingSymmetricR(horizontal: 0, vertical: 0),
                  child: Center(
                    child: Text(
                      progressViewModel.buttonName[index],
                      style: TextStyle(
                        fontSize: context.sp(14),
                        fontWeight: FontWeight.w700,
                        color: AppColors.seconderyColor,
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
              child: LineChartWidget(),
            ),
            SizedBox(height: context.sh(4)),
            ...List.generate(
              dailyHairCareRoutineViewModel.remediesData.length,
              (index) {
                final remedies =
                    dailyHairCareRoutineViewModel.remediesData[index];
                final isSelected = remedies['isSelected'] as bool;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    NormalText(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      titleText: remedies['title'],
                      titleSize: context.sp(18),
                      titleWeight: FontWeight.w600,
                      titleColor: AppColors.headingColor,
                    ),
                    SizedBox(height: context.sh(4)),
                    PlanContainer(
                      isSelected: isSelected,
                      padding: context.paddingSymmetricR(horizontal: 19, vertical: 24),
                      onTap: () {
                        dailyHairCareRoutineViewModel.selectDemedies(index);

                        if (index == 0) {
                          Navigator.pushNamed(
                            context,
                            RoutesName.HairHomeRemediesScreen,
                          );
                        } else if (index == 1) {
                          Navigator.pushNamed(
                            context,

                            RoutesName.HairTopProductScreen,
                          );
                        }
                      },

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SizedBox(width: context.sw(12)),
                              Text(
                                remedies['subTitle'],
                                style: TextStyle(
                                  fontSize: context.sp(16),
                                  fontWeight: FontWeight.w600,
                                  color:
                                      dailyHairCareRoutineViewModel.isSelected
                                      ? AppColors.subHeadingColor
                                      : AppColors.subHeadingColor,
                                ),
                              ),
                            ],
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 24,
                            // color: AppColors.headingColor,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
            SizedBox(height: context.sh(30)),
          ],
        ),
      ),
    );
  }
}
