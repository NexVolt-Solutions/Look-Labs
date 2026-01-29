import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:looklabs/Core/Widget/app_bar_container.dart';
import 'package:looklabs/Core/Widget/custom_container.dart';
import 'package:looklabs/Core/Widget/line_chart_widget.dart';
import 'package:looklabs/Core/Widget/normal_text.dart';
import 'package:looklabs/Core/Widget/plan_container.dart';
import 'package:looklabs/Core/Widget/simple_check_box.dart';
import 'package:looklabs/Core/Widget/text_and_indector_container.dart';
import 'package:looklabs/Core/Constants/app_assets.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Core/utils/Routes/routes_name.dart';
import 'package:looklabs/ViewModel/daily_skin_care_routine_view_model.dart';
import 'package:looklabs/ViewModel/progress_view_model.dart';
import 'package:provider/provider.dart';

class DailySkinCareRoutine extends StatefulWidget {
  const DailySkinCareRoutine({super.key});

  @override
  State<DailySkinCareRoutine> createState() => _DailySkinCareRoutineState();
}

class _DailySkinCareRoutineState extends State<DailySkinCareRoutine> {
  @override
  Widget build(BuildContext context) {
    final dailySkinCareRoutineViewModel =
        Provider.of<DailySkinCareRoutineViewModel>(context);
    final progressViewModel = Provider.of<ProgressViewModel>(context);

    return Scaffold(
      backgroundColor: AppColors.backGroundColor,
      body: SafeArea(
        child: ListView(
          padding: context.padSym(h: 20),
          children: [
            AppBarContainer(
              title: 'Daily Skin Routine',
              onTap: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(height: context.h(24)),
            SizedBox(
              height: context.h(190),
              child: ListView.builder(
                itemCount: 3,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: context.w(158), // ✅ FIXED WIDTH
                        padding: context.padSym(h: 1, v: 1),
                        margin: EdgeInsets.only(right: context.w(12)),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.pimaryColor),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            'assets/Picsart_25-12-27_23-56-38-946.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(height: context.h(8)),
                      NormalText(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        titleText: 'LeftSide',
                        titleSize: context.text(14),
                        titleColor: AppColors.subHeadingColor,
                        titleWeight: FontWeight.w600,
                      ),
                    ],
                  );
                },
              ),
            ),

            SizedBox(
              height: context.h(400), // PageView height
              child: PageView.builder(
                itemCount: dailySkinCareRoutineViewModel.indicatorPages.length,
                itemBuilder: (context, pageIndex) {
                  final pageData =
                      dailySkinCareRoutineViewModel.indicatorPages[pageIndex];

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 🔹 Title (FIXED - NOT SCROLLING)
                      Row(
                        children: [
                          SvgPicture.asset(
                            AppAssets.starIcon,
                            height: context.h(24),
                            width: context.w(24),
                            color: AppColors.pimaryColor,
                          ),
                          SizedBox(width: context.w(8)),
                          NormalText(
                            titleText: pageIndex == 0
                                ? 'Hair Attributes'
                                : pageIndex == 1
                                ? 'Hair Health'
                                : 'Concerns Analysis',
                            titleSize: context.text(18),
                            titleWeight: FontWeight.w600,
                            titleColor: AppColors.headingColor,
                          ),
                        ],
                      ),

                      SizedBox(height: context.h(12)),
                      Expanded(
                        child: GridView.builder(
                          scrollDirection: Axis.vertical,
                          physics: const BouncingScrollPhysics(),
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
                              progress: 80,
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            SizedBox(height: context.h(18)),
            NormalText(
              crossAxisAlignment: CrossAxisAlignment.start,
              titleText: 'Review Scans',
              titleSize: context.text(18),
              titleWeight: FontWeight.w600,
              titleColor: AppColors.headingColor,
            ),
            SizedBox(height: context.h(18)),
            NormalText(
              crossAxisAlignment: CrossAxisAlignment.start,
              titleText: 'Today’s Routine',
              titleSize: context.text(18),
              titleWeight: FontWeight.w600,
              titleColor: AppColors.headingColor,
            ),
            SizedBox(height: context.h(10)),
            PlanContainer(
              isSelected: false,
              onTap: () {},
              child: Column(
                children: List.generate(3, (index) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: context.h(10)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SimpleCheckBox(
                          isSelected: dailySkinCareRoutineViewModel.isSelected,
                          onTap: () {
                            setState(() {
                              dailySkinCareRoutineViewModel.isSelected =
                                  !dailySkinCareRoutineViewModel
                                      .isSelected; // toggle the checkbox
                            });
                          },
                        ),
                        SizedBox(width: context.w(12)),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Gentle Scalp Wash',
                                style: TextStyle(
                                  fontSize: context.text(14),
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.subHeadingColor,
                                ),
                              ),
                              SizedBox(height: context.h(4)),
                              Text(
                                'Removes excess oil and buildup without drying the scalp. '
                                'Helps maintain a clean and balanced scalp environment.',
                                style: TextStyle(
                                  fontSize: context.text(10),
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

            SizedBox(height: context.h(12)),
            NormalText(
              crossAxisAlignment: CrossAxisAlignment.start,
              titleText: 'Night’s Routine',
              titleSize: context.text(18),
              titleWeight: FontWeight.w600,
              titleColor: AppColors.headingColor,
            ),
            SizedBox(height: context.h(12)),
            PlanContainer(
              isSelected: false,
              onTap: () {},
              child: Column(
                children: List.generate(3, (index) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: context.h(10)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SimpleCheckBox(
                          isSelected: dailySkinCareRoutineViewModel.isSelected,
                          onTap: () {
                            setState(() {
                              dailySkinCareRoutineViewModel.isSelected =
                                  !dailySkinCareRoutineViewModel
                                      .isSelected; // toggle the checkbox
                            });
                          },
                        ),
                        SizedBox(width: context.w(12)),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Gentle Scalp Wash',
                                style: TextStyle(
                                  fontSize: context.text(14),
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.subHeadingColor,
                                ),
                              ),
                              SizedBox(height: context.h(4)),
                              Text(
                                'Removes excess oil and buildup without drying the scalp. '
                                'Helps maintain a clean and balanced scalp environment.',
                                style: TextStyle(
                                  fontSize: context.text(10),
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
            SizedBox(height: context.h(10)),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(progressViewModel.buttonName.length, (
                index,
              ) {
                final bool isSelected =
                    progressViewModel.selectedIndex ==
                    progressViewModel.buttonName[index];
                return CustomContainer(
                  radius: context.radius(10),
                  onTap: () {
                    progressViewModel.selectIndex(index);
                  },
                  color: isSelected
                      ? AppColors.buttonColor.withOpacity(0.11)
                      : AppColors.backGroundColor,
                  border: isSelected
                      ? Border.all(color: AppColors.pimaryColor, width: 1.5)
                      : null,
                  padding: context.padSym(h: 42, v: 12),
                  child: Center(
                    child: Text(
                      progressViewModel.buttonName[index],
                      style: TextStyle(
                        fontSize: context.text(14),
                        fontWeight: FontWeight.w700,
                        color: AppColors.seconderyColor,
                      ),
                    ),
                  ),
                );
              }),
            ),

            SizedBox(height: context.h(10)),
            PlanContainer(
              padding: context.padSym(h: 10, v: 10),
              margin: context.padSym(v: 10),
              radius: BorderRadius.circular(context.radius(10)),
              isSelected: false,
              onTap: () {},
              child: LineChartWidget(),
            ),
            SizedBox(height: context.h(10)),

            ...List.generate(
              dailySkinCareRoutineViewModel.remediesData.length,
              (index) {
                final remedies =
                    dailySkinCareRoutineViewModel.remediesData[index];
                final isSelected = remedies['isSelected'] as bool;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    NormalText(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      titleText: remedies['title'],
                      titleSize: context.text(18),
                      titleWeight: FontWeight.w600,
                      titleColor: AppColors.headingColor,
                    ),
                    PlanContainer(
                      isSelected: isSelected,
                      padding: context.padSym(h: 19, v: 23.5),
                      onTap: () {
                        dailySkinCareRoutineViewModel.selectDemedies(index);

                        if (index == 0) {
                          Navigator.pushNamed(
                            context,
                            RoutesName.SkinHomeRemediesScreen,
                          );
                        } else if (index == 1) {
                          Navigator.pushNamed(
                            context,
                            RoutesName.SkinTopProductScreen,
                          );
                        }
                      },

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SizedBox(width: context.w(12)),
                              Text(
                                remedies['subTitle'],
                                style: TextStyle(
                                  fontSize: context.text(16),
                                  fontWeight: FontWeight.w600,
                                  color:
                                      dailySkinCareRoutineViewModel.isSelected
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

            SizedBox(height: context.h(30)),
          ],
        ),
      ),
    );
  }
}
