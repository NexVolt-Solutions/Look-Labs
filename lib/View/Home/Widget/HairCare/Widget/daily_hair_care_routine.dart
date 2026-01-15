import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:flutter_svg/svg.dart';
import 'package:looklabs/Core/Constants/Widget/app_bar_container.dart';
import 'package:looklabs/Core/Constants/Widget/normal_text.dart';
import 'package:looklabs/Core/Constants/Widget/plan_container.dart';
import 'package:looklabs/Core/Constants/Widget/simple_check_box.dart';
import 'package:looklabs/Core/Constants/Widget/speed_meter_widget.dart';
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

            // SizedBox(
            //   height: context.h(350),
            //   child: PageView.builder(
            //     itemCount: dailyHairCareRoutineViewModel.indicatorPages.length,
            //     itemBuilder: (context, pageIndex) {
            //       final pageData =
            //           dailyHairCareRoutineViewModel.indicatorPages[pageIndex];

            //       return Column(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           Row(
            //             children: [
            //               SvgPicture.asset(
            //                 AppAssets.starIcon,
            //                 height: context.h(24),
            //                 width: context.w(24),
            //                 color: AppColors.pimaryColor,
            //               ),
            //               SizedBox(width: context.w(8)),
            //               NormalText(
            //                 titleText: pageIndex == 0
            //                     ? 'Hair Attributes'
            //                     : pageIndex == 1
            //                     ? 'Hair Health'
            //                     : 'Concerns Analysis',
            //                 titleSize: context.text(18),
            //                 titleWeight: FontWeight.w600,
            //                 titleColor: AppColors.headingColor,
            //               ),
            //             ],
            //           ),
            //           SizedBox(height: context.h(12)),

            //           GridView.builder(
            //             shrinkWrap: true,
            //             physics: const NeverScrollableScrollPhysics(),
            //             gridDelegate:
            //                 const SliverGridDelegateWithFixedCrossAxisCount(
            //                   crossAxisCount: 2,
            //                   childAspectRatio: 4 / 3,
            //                 ),
            //             itemCount: pageData.length,
            //             itemBuilder: (context, index) {
            //               final item = pageData[index];
            //               return TextAndIndectorContiner(
            //                 title: item['title'],
            //                 subTitle: item['subTitle'],
            //                 pers: item['pers'],
            //               );
            //             },
            //           ),
            //         ],
            //       );
            //     },
            //   ),
            // ),
            // Column(
            //   children: [
            //     // 🔹 TOP ROW (2 containers)
            //     Row(
            //       children: [
            //         Expanded(
            //           child: TextAndIndectorContiner(
            //             title: 'Hairloss',
            //             subTitle: 'None',
            //             pers: '10',
            //           ),
            //         ),
            //         SizedBox(width: context.w(12)),
            //         Expanded(
            //           child: TextAndIndectorContiner(
            //             title: 'Hairloss',
            //             subTitle: 'None',
            //             pers: '10',
            //           ),
            //         ),
            //       ],
            //     ),
            //     SizedBox(height: context.h(16)),
            //     Container(
            //       padding: context.padSym(h: 20, v: 12),
            //       decoration: BoxDecoration(
            //         borderRadius: BorderRadius.circular(context.radius(16)),
            //         color: AppColors.backGroundColor,
            //         boxShadow: [
            //           BoxShadow(
            //             color: AppColors.customContainerColorUp.withOpacity(
            //               0.4,
            //             ),
            //             offset: const Offset(5, 5),
            //             blurRadius: 5,
            //             inset: false,
            //           ),
            //           BoxShadow(
            //             color: AppColors.customContinerColorDown.withOpacity(
            //               0.4,
            //             ),
            //             offset: const Offset(-5, -5),
            //             blurRadius: 5,
            //             inset: false,
            //           ),
            //         ],
            //       ),
            //       child: Row(
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         // crossAxisAlignment: CrossAxisAlignment.center,
            //         mainAxisSize: MainAxisSize.max,
            //         children: [
            //           Column(
            //             crossAxisAlignment: CrossAxisAlignment.start,
            //             children: [
            //               NormalText(
            //                 titleText: 'Hairloss Stage',
            //                 titleSize: context.text(16),
            //                 titleWeight: FontWeight.w500,
            //                 titleColor: AppColors.subHeadingColor,
            //               ),
            //               Divider(thickness: 1, indent: 0, endIndent: 10),
            //               NormalText(
            //                 titleText: 'Hairloss',
            //                 titleSize: context.text(12),
            //                 titleWeight: FontWeight.w500,
            //                 titleColor: AppColors.subHeadingColor,
            //                 subText: 'None',
            //                 subSize: context.text(14),
            //                 subWeight: FontWeight.w600,
            //                 subColor: AppColors.subHeadingColor,
            //               ),
            //             ],
            //           ),
            //           Center(child: _getRadialGauge()),
            //         ],
            //       ),
            //     ),
            //   ],
            // ),
            SizedBox(
              height: context.h(310),
              child: PageView.builder(
                itemCount: dailyHairCareRoutineViewModel.indicatorPages.length,
                itemBuilder: (context, pageIndex) {
                  final pageData =
                      dailyHairCareRoutineViewModel.indicatorPages[pageIndex];
                  final isLastPage =
                      pageIndex ==
                      dailyHairCareRoutineViewModel.indicatorPages.length - 1;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 🔹 Page Title Row
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
                      // SizedBox(height: context.h(12)),

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

            // SizedBox(height: context.h(12)),
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
