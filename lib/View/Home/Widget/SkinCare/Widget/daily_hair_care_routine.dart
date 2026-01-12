import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:looklabs/Core/Constants/Widget/app_bar_container.dart';
import 'package:looklabs/Core/Constants/Widget/custom_button.dart';
import 'package:looklabs/Core/Constants/Widget/normal_text.dart';
import 'package:looklabs/Core/Constants/Widget/plan_container.dart';
import 'package:looklabs/Core/Constants/Widget/simple_check_box.dart';
import 'package:looklabs/Core/Constants/Widget/text_and_indector_container.dart';
import 'package:looklabs/Core/Constants/app_assets.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Core/utils/Routes/routes_name.dart';
import 'package:looklabs/ViewModel/daily_hair_care_routine_view_model.dart';
import 'package:provider/provider.dart';

class DailyHairCareRoutine extends StatefulWidget {
  const DailyHairCareRoutine({super.key});

  @override
  State<DailyHairCareRoutine> createState() => _DailyHairCareRoutineState();
}

class _DailyHairCareRoutineState extends State<DailyHairCareRoutine> {
  @override
  Widget build(BuildContext context) {
    final dailyHairCareRoutineViewModel =
        Provider.of<DailyHairCareRoutineViewModel>(context);
    return Scaffold(
      backgroundColor: AppColors.backGroundColor,
      // bottomNavigationBar: CustomButton(
      //   text: 'next',
      //   color: AppColors.pimaryColor,
      //   isEnabled: true,
      //   onTap: () {
      //     Navigator.pushNamed(context, RoutesName.HomeRemediesScreen);
      //   },
      //   padding: context.padSym(h: 145, v: 17),
      // ),
      body: SafeArea(
        child: ListView(
          padding: context.padSym(h: 20),
          children: [
            AppBarContainer(
              title: 'Daily Hair Routine',
              onTap: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(height: context.h(24)),
            Row(
              children: [
                SvgPicture.asset(
                  AppAssets.starIcon,
                  height: context.h(24),
                  width: context.w(24),
                  color: AppColors.pimaryColor,
                  fit: BoxFit.scaleDown,
                ),
                SizedBox(width: context.w(8)),
                NormalText(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  titleText: 'Analyzing your hair ',
                  titleSize: context.text(18),
                  titleWeight: FontWeight.w600,
                  titleColor: AppColors.headingColor,
                ),
              ],
            ),
            SizedBox(
              height: context.h(290),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  // mainAxisSpacing: 16,
                  // crossAxisSpacing: 16,
                  // mainAxisExtent: 2,
                  childAspectRatio: 4 / 3,
                ),
                itemCount: 4,
                // homeViewModel.gridData.length,
                itemBuilder: (context, index) {
                  // final item = homeViewModel.gridData[index];
                  return TextAndIndectorContiner();
                },
              ),
            ),
            SizedBox(height: context.h(12)),
            NormalText(
              crossAxisAlignment: CrossAxisAlignment.start,
              titleText: 'Today’s Routine',
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
                        SimpleCheckBox(isSelected: false, onTap: () {}),
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
                        SimpleCheckBox(isSelected: false, onTap: () {}),
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
            SizedBox(height: context.h(20)),

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
                      titleSize: context.text(18),
                      titleWeight: FontWeight.w600,
                      titleColor: AppColors.headingColor,
                    ),
                    PlanContainer(
                      isSelected: isSelected,
                      padding: context.padSym(h: 19, v: 23.5),
                      onTap: () {
                        dailyHairCareRoutineViewModel.selectDemedies(index);

                        if (index == 0) {
                          Navigator.pushNamed(
                            context,
                            RoutesName.HomeRemediesScreen,
                          );
                        } else if (index == 1) {
                          Navigator.pushNamed(
                            context,
                            RoutesName.TopProductScreen,
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
            SizedBox(height: context.h(30)),
          ],
        ),
      ),
    );
  }
}
