import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:looklabs/Features/Widget/app_bar_container.dart';
import 'package:looklabs/Features/Widget/linear_slider_widget.dart';
import 'package:looklabs/Features/Widget/normal_text.dart';
import 'package:looklabs/Features/Widget/plan_container.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Core/Routes/routes_name.dart';
import 'package:looklabs/Features/ViewModel/style_profile_screen_view_model.dart';
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
          padding: context.paddingSymmetricR(horizontal: 20),
          children: [
            AppBarContainer(
              title: 'Your Style Profile',
              onTap: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(height: context.sh(20)),

            NormalText(
              crossAxisAlignment: CrossAxisAlignment.start,
              titleText: 'Feature Scores',
              titleSize: context.sp(18),
              titleWeight: FontWeight.w600,
              titleColor: AppColors.headingColor,
            ),
            SizedBox(height: context.sh(18)),
            PlanContainer(
              padding: context.paddingSymmetricR(horizontal: 12, vertical: 12),
              isSelected: false,
              onTap: () {},
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  NormalText(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    titleText: 'Overall Score',
                    titleSize: context.sp(18),
                    titleWeight: FontWeight.w600,
                    titleColor: AppColors.headingColor,
                  ),
                  SizedBox(height: context.sh(12)),

                  LinearSliderWidget(
                    showTopIcon: true,
                    progress: 20,
                    inset: false,
                    height: context.sh(10),
                    animatedConHeight: context.sh(10),
                    showPercentage: false,
                  ),
                ],
              ),
            ),
            SizedBox(height: context.sh(18)),
            PlanContainer(
              padding: context.paddingSymmetricR(horizontal: 12, vertical: 12),
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
                              padding: context.paddingSymmetricR(horizontal: 4, vertical: 4),
                              // margin: context.paddingSymmetricR(vertical: 14),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  context.radiusR(10),
                                ),
                                border: Border.all(
                                  color: AppColors.backGroundColor,
                                  width: context.sw(2),
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
                                height: context.sh(18.05),
                                width: context.sw(22.56),
                                color: AppColors.pimaryColor,
                                fit: BoxFit.contain,
                              ),
                            ),
                            SizedBox(width: context.sw(11)),
                            NormalText(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              titleText: item['title'],
                              titleSize: context.sp(14),
                              titleWeight: FontWeight.w500,
                              titleColor: AppColors.headingColor,
                              titleAlign: TextAlign.start,
                              subText: item['subtitle'],
                              subSize: context.sp(10),
                              subWeight: FontWeight.w400,
                              subColor: AppColors.iconColor,
                              sizeBoxheight: context.sh(4),
                              subAlign: TextAlign.start,
                            ),
                          ],
                        ),
                        SizedBox(height: context.sh(10)),
                        LinearSliderWidget(
                          progress: item['per'].toDouble(),
                          height: context.sh(12),
                          animatedConHeight: context.sh(12),
                        ),
                        SizedBox(height: context.sh(12)),
                      ],
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: context.sh(18)),
            NormalText(
              crossAxisAlignment: CrossAxisAlignment.start,
              titleText: 'Daily Exercises',
              titleSize: context.sp(18),
              titleWeight: FontWeight.w600,
              titleColor: AppColors.headingColor,
            ),
            SizedBox(height: context.sh(18)),
            PlanContainer(
              padding: context.paddingSymmetricR(horizontal: 19, vertical: 22),
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
                    titleSize: context.sp(18),
                    titleWeight: FontWeight.w600,
                    titleColor: AppColors.headingColor,
                  ),
                  const Icon(Icons.arrow_forward_ios, size: 20),
                ],
              ),
            ),

            SizedBox(height: context.sh(100)),
          ],
        ),
      ),
    );
  }
}
