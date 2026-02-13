import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:looklabs/features/Widget/app_bar_container.dart';
import 'package:looklabs/features/Widget/linear_slider_widget.dart';
import 'package:looklabs/features/Widget/normal_text.dart';
import 'package:looklabs/features/Widget/plan_container.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Core/utils/Routes/routes_name.dart';
import 'package:looklabs/features/ViewModel/style_profile_screen_view_model.dart';
import 'package:provider/provider.dart';

class StyleProfileScreen extends StatefulWidget {
  const StyleProfileScreen({super.key});

  @override
  State<StyleProfileScreen> createState() => _StyleProfileScreenState();
}

class _StyleProfileScreenState extends State<StyleProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final styleProfileScreenViewModel =
        Provider.of<StyleProfileScreenViewModel>(context);
    return Scaffold(
      backgroundColor: AppColors.backGroundColor,

      body: SafeArea(
        child: ListView(
          padding: context.padSym(h: 20),
          children: [
            AppBarContainer(
              title: 'Your Style Profile',
              onTap: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(height: context.h(20)),

            NormalText(
              crossAxisAlignment: CrossAxisAlignment.start,
              titleText: 'Feature Scores',
              titleSize: context.text(18),
              titleWeight: FontWeight.w600,
              titleColor: AppColors.headingColor,
            ),
            SizedBox(height: context.h(18)),
            PlanContainer(
              padding: context.padSym(h: 12, v: 12),
              isSelected: false,
              onTap: () {},
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  NormalText(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    titleText: 'Overall Score',
                    titleSize: context.text(18),
                    titleWeight: FontWeight.w600,
                    titleColor: AppColors.headingColor,
                  ),
                  SizedBox(height: context.h(12)),

                  LinearSliderWidget(
                    showTopIcon: true,
                    progress: 20,
                    inset: false,
                    height: context.h(10),
                    animatedConHeight: context.h(10),
                    showPercentage: false,
                  ),
                ],
              ),
            ),
            SizedBox(height: context.h(18)),
            PlanContainer(
              padding: context.padSym(h: 12, v: 12),
              isSelected: false,
              onTap: () {},
              child: Column(
                children: List.generate(
                  styleProfileScreenViewModel.facialData.length,
                  (index) {
                    final item = styleProfileScreenViewModel.facialData[index];

                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              padding: context.padSym(h: 4, v: 4),
                              // margin: context.padSym(v: 14),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  context.radius(10),
                                ),
                                border: Border.all(
                                  color: AppColors.backGroundColor,
                                  width: context.w(2),
                                ),
                                color: AppColors.backGroundColor,
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
                              child: SvgPicture.asset(
                                item['image'],
                                height: context.h(18.05),
                                width: context.w(22.56),
                                color: AppColors.pimaryColor,
                                fit: BoxFit.contain,
                              ),
                            ),
                            SizedBox(width: context.w(11)),
                            NormalText(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              titleText: item['title'],
                              titleSize: context.text(14),
                              titleWeight: FontWeight.w500,
                              titleColor: AppColors.headingColor,
                              titleAlign: TextAlign.start,
                              subText: item['subtitle'],
                              subSize: context.text(10),
                              subWeight: FontWeight.w400,
                              subColor: AppColors.iconColor,
                              sizeBoxheight: context.h(4),
                              subAlign: TextAlign.start,
                            ),
                          ],
                        ),
                        SizedBox(height: context.h(10)),
                        LinearSliderWidget(
                          progress: item['per'].toDouble(),
                          height: context.h(12),
                          animatedConHeight: context.h(12),
                        ),
                        SizedBox(height: context.h(12)),
                      ],
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: context.h(18)),
            NormalText(
              crossAxisAlignment: CrossAxisAlignment.start,
              titleText: 'Daily Exercises',
              titleSize: context.text(18),
              titleWeight: FontWeight.w600,
              titleColor: AppColors.headingColor,
            ),
            SizedBox(height: context.h(18)),
            PlanContainer(
              padding: context.padSym(h: 19, v: 22),
              isSelected: styleProfileScreenViewModel.isExerciseSelected,
              onTap: () {
                styleProfileScreenViewModel.selectExercise();

                Future.delayed(const Duration(milliseconds: 150), () {
                  Navigator.pushNamed(
                    context,
                    RoutesName.PersonalizedExerciseScreen,
                  );
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  NormalText(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    titleText: 'View your personalized exercises',
                    titleSize: context.text(18),
                    titleWeight: FontWeight.w600,
                    titleColor: AppColors.headingColor,
                  ),
                  const Icon(Icons.arrow_forward_ios, size: 20),
                ],
              ),
            ),

            SizedBox(height: context.h(100)),
          ],
        ),
      ),
    );
  }
}
