import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:flutter_svg/svg.dart';
import 'package:looklabs/Core/Constants/app_assets.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Core/Widget/app_bar_container.dart';
import 'package:looklabs/Core/Widget/custom_button.dart';
import 'package:looklabs/Core/Widget/height_widget_cont.dart';
import 'package:looklabs/Core/Widget/normal_text.dart';
import 'package:looklabs/Core/Widget/plan_container.dart';
import 'package:looklabs/Core/utils/Routes/routes_name.dart';
import 'package:looklabs/ViewModel/fashion_profile_screen_view_model.dart';

class FashionProfileScreen extends StatefulWidget {
  const FashionProfileScreen({super.key});

  @override
  State<FashionProfileScreen> createState() => _FashionProfileScreenState();
}

class _FashionProfileScreenState extends State<FashionProfileScreen> {
  bool isBestClothingSelected = false;

  final List<String> clothingFits = [
    'Fitted shirts',
    'Slim jeans',
    'Tailored jackets',
    'Casual wear',
  ];

  @override
  Widget build(BuildContext context) {
    final fashionProfileScreenViewModel = FashionProfileScreenViewModel();
    return Scaffold(
      backgroundColor: AppColors.backGroundColor,
      bottomNavigationBar: CustomButton(
        text: 'Next',
        color: AppColors.pimaryColor,
        isEnabled: true,
        onTap: () {
          Navigator.pushNamed(context, RoutesName.DailySkinCareRoutineScreen);
        },
      ),
      body: SafeArea(
        child: ListView(
          padding: context.padSym(h: 20),
          children: [
            AppBarContainer(
              title: 'Analyzing',
              onTap: () {
                Navigator.pop(context);
              },
            ),

            SizedBox(height: context.h(24)),

            NormalText(
              crossAxisAlignment: CrossAxisAlignment.start,
              titleText: 'AI analysis complete',
              titleSize: context.text(18),
              titleWeight: FontWeight.w600,
              titleColor: AppColors.subHeadingColor,
            ),

            SizedBox(
              height: context.h(140),
              child: ListView.builder(
                itemCount: 4,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return HeightWidgetCont(
                    title: '2300',
                    subTitle: 'Weekly Cal',
                    imgPath: AppAssets.fatLossIcon,
                  );
                },
              ),
            ),

            SizedBox(height: context.h(18)),

            NormalText(
              crossAxisAlignment: CrossAxisAlignment.start,
              titleText: 'AI analysis complete',
              titleSize: context.text(18),
              titleWeight: FontWeight.w600,
              titleColor: AppColors.subHeadingColor,
            ),

            SizedBox(height: context.h(8)),

            SizedBox(
              height: context.h(190),
              child: ListView.builder(
                itemCount: 3,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Container(
                        width: context.w(158),
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
                        titleWeight: FontWeight.w600,
                        titleColor: AppColors.subHeadingColor,
                      ),
                    ],
                  );
                },
              ),
            ),
            SizedBox(height: context.h(18)),

            /// 🔹 Best Clothing Fits Section
            PlanContainer(
              margin: context.padSym(v: 0),
              padding: context.padSym(h: 12, v: 12),
              isSelected: false,
              onTap: () {},
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      PlanContainer(
                        margin: context.padSym(v: 0),
                        padding: context.padSym(v: 4, h: 4),
                        isSelected: false,
                        onTap: () {},
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              isBestClothingSelected = !isBestClothingSelected;
                            });
                          },
                          child: Container(
                            height: context.h(20),
                            width: context.w(20),
                            decoration: BoxDecoration(
                              color: isBestClothingSelected
                                  ? AppColors.pimaryColor
                                  : AppColors.backGroundColor,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.customContainerColorUp
                                      .withOpacity(0.4),
                                  offset: const Offset(3, 3),
                                  blurRadius: 4,
                                  inset: true,
                                ),
                                BoxShadow(
                                  color: AppColors.customContinerColorDown
                                      .withOpacity(0.4),
                                  offset: const Offset(-3, -3),
                                  blurRadius: 4,
                                  inset: true,
                                ),
                              ],
                            ),
                            child: Center(
                              child: isBestClothingSelected
                                  ? Icon(
                                      Icons.check,
                                      size: context.h(16),
                                      color: AppColors.white,
                                    )
                                  : const SizedBox(),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: context.w(11)),
                      NormalText(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        titleText: 'Styles to Avoid',
                        titleSize: context.text(14),
                        titleWeight: FontWeight.w600,
                        titleColor: AppColors.subHeadingColor,
                      ),
                    ],
                  ),
                  SizedBox(height: context.h(12)),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: clothingFits.map((item) {
                      return PlanContainer(
                        margin: context.padSym(v: 0),
                        radius: BorderRadius.circular(context.radius(10)),
                        padding: context.padSym(v: 8, h: 12),
                        isSelected: false,
                        onTap: () {},
                        child: NormalText(
                          titleText: item,
                          titleSize: context.text(10),
                          titleWeight: FontWeight.w600,
                          titleColor: AppColors.subHeadingColor,
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

            SizedBox(height: context.h(18)),

            PlanContainer(
              margin: context.padSym(v: 0),
              padding: context.padSym(h: 12, v: 12),
              isSelected: false,
              onTap: () {},
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      PlanContainer(
                        margin: context.padSym(v: 0),

                        padding: context.padSym(v: 4, h: 4),
                        isSelected: false,
                        onTap: () {},
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              isBestClothingSelected = !isBestClothingSelected;
                            });
                          },
                          child: SvgPicture.asset(
                            AppAssets.waringIcon,
                            fit: BoxFit.scaleDown,
                          ),
                        ),
                      ),
                      SizedBox(width: context.w(11)),
                      NormalText(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        titleText: 'Best Clothing Fits',
                        titleSize: context.text(14),
                        titleWeight: FontWeight.w600,
                        titleColor: AppColors.subHeadingColor,
                      ),
                    ],
                  ),
                  SizedBox(height: context.h(12)),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: clothingFits.map((item) {
                      return PlanContainer(
                        margin: context.padSym(v: 0),
                        radius: BorderRadius.circular(context.radius(10)),
                        padding: context.padSym(v: 8, h: 12),
                        isSelected: false,
                        onTap: () {},
                        child: NormalText(
                          titleText: item,
                          titleSize: context.text(10),
                          titleWeight: FontWeight.w600,
                          titleColor: AppColors.subHeadingColor,
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            SizedBox(height: context.h(18)),
            PlanContainer(
              margin: context.padSym(v: 0),
              padding: context.padSym(h: 12, v: 12),
              isSelected: false,
              onTap: () {},
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      PlanContainer(
                        margin: context.padSym(v: 0),
                        padding: context.padSym(v: 4, h: 4),
                        isSelected: false,
                        onTap: () {},
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              isBestClothingSelected = !isBestClothingSelected;
                            });
                          },
                          child: SvgPicture.asset(
                            AppAssets.themeIcon,
                            fit: BoxFit.scaleDown,
                          ),
                        ),
                      ),
                      SizedBox(width: context.w(11)),
                      NormalText(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        titleText: 'Your Warm Palette',
                        titleSize: context.text(14),
                        titleWeight: FontWeight.w600,
                        titleColor: AppColors.subHeadingColor,
                      ),
                    ],
                  ),
                  SizedBox(height: context.h(12)),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: clothingFits.map((item) {
                      return PlanContainer(
                        margin: context.padSym(v: 0),
                        radius: BorderRadius.circular(context.radius(10)),
                        padding: context.padSym(v: 20, h: 20),
                        isSelected: false,
                        onTap: () {},
                        child: ClipRRect(
                          borderRadius: BorderRadiusGeometry.circular(
                            context.radius(10),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            SizedBox(height: context.h(18)),
            NormalText(
              crossAxisAlignment: CrossAxisAlignment.start,
              titleText: 'Weekly Plan',
              titleSize: context.text(18),
              titleWeight: FontWeight.w600,
              titleColor: AppColors.subHeadingColor,
            ),
            SizedBox(height: context.h(12)),
            PlanContainer(
              padding: context.padSym(h: 19, v: 22),
              isSelected: fashionProfileScreenViewModel.isExerciseSelected,
              onTap: () {
                fashionProfileScreenViewModel.selectExercise();

                Future.delayed(const Duration(milliseconds: 150), () {
                  Navigator.pushNamed(context, RoutesName.WeeklyPlanScreen);
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  NormalText(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    titleText: 'Style themes to keep you sharp',
                    titleSize: context.text(18),
                    titleWeight: FontWeight.w600,
                    titleColor: AppColors.headingColor,
                  ),
                  const Icon(Icons.arrow_forward_ios, size: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
