import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:flutter_svg/svg.dart';
import 'package:looklabs/Core/Constants/app_assets.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Features/Widget/app_bar_container.dart';
import 'package:looklabs/Features/Widget/height_widget_cont.dart';
import 'package:looklabs/Features/Widget/network_image_with_fallback.dart';
import 'package:looklabs/Features/Widget/normal_text.dart';
import 'package:looklabs/Features/Widget/plan_container.dart';
import 'package:looklabs/Core/Routes/routes_name.dart';
import 'package:looklabs/Features/ViewModel/fashion_profile_screen_view_model.dart';
import 'package:provider/provider.dart';

class FashionProfileScreen extends StatefulWidget {
  const FashionProfileScreen({super.key, this.resultData});

  final Map<String, dynamic>? resultData;

  @override
  State<FashionProfileScreen> createState() => _FashionProfileScreenState();
}

class _FashionProfileScreenState extends State<FashionProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<FashionProfileScreenViewModel>().initializeFromResult(
        widget.resultData,
      );
    });
  }

  Color _paletteColor(String hex) {
    final cleaned = hex.trim().replaceAll('#', '');
    if (cleaned.length == 6) {
      return Color(int.parse('FF$cleaned', radix: 16));
    }
    if (cleaned.length == 8) {
      return Color(int.parse(cleaned, radix: 16));
    }
    return AppColors.backGroundColor;
  }

  @override
  Widget build(BuildContext context) {
    final fashionProfileScreenViewModel =
        context.watch<FashionProfileScreenViewModel>();
    return Scaffold(
      backgroundColor: AppColors.backGroundColor,
      // bottomNavigationBar: CustomButton(
      //   text: 'Next',
      //   color: AppColors.pimaryColor,
      //   isEnabled: true,
      //   onTap: () {
      //     Navigator.pushNamed(context, RoutesName.DailySkinCareRoutineScreen);
      //   },
      // ),
      body: SafeArea(
        child: ListView(
          padding: context.paddingSymmetricR(horizontal: 20),
          children: [
            AppBarContainer(
              title: fashionProfileScreenViewModel.profileTitle,
              onTap: () {
                Navigator.pop(context);
              },
            ),

            SizedBox(height: context.sh(24)),

            NormalText(
              crossAxisAlignment: CrossAxisAlignment.start,
              titleText: fashionProfileScreenViewModel.subtitle,
              titleSize: context.sp(18),
              titleWeight: FontWeight.w600,
              titleColor: AppColors.subHeadingColor,
            ),

            SizedBox(
              height: context.sh(140),
              child: ListView.builder(
                itemCount: fashionProfileScreenViewModel.profileTraits.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final trait = fashionProfileScreenViewModel.profileTraits[index];
                  return HeightWidgetCont(
                    title: trait['value']?.toString() ?? '',
                    subTitle: trait['label']?.toString() ?? '',
                    imgPath: AppAssets.fatLossIcon,
                  );
                },
              ),
            ),

            SizedBox(height: context.sh(18)),

            NormalText(
              crossAxisAlignment: CrossAxisAlignment.start,
              titleText: 'Review Scans',
              titleSize: context.sp(18),
              titleWeight: FontWeight.w600,
              titleColor: AppColors.subHeadingColor,
            ),

            SizedBox(height: context.sh(8)),

            SizedBox(
              height: context.sh(190),
              child: ListView.builder(
                itemCount: fashionProfileScreenViewModel.reviewScans.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final scan = fashionProfileScreenViewModel.reviewScans[index];
                  return Column(
                    children: [
                      Container(
                        width: context.sw(158),
                        padding: context.paddingSymmetricR(horizontal: 1, vertical: 1),
                        margin: EdgeInsets.only(right: context.sw(12)),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.pimaryColor),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: NetworkImageWithFallback(
                            url: scan['url']?.toString() ?? '',
                            fit: BoxFit.cover,
                            width: context.sw(158),
                            height: context.sh(150),
                          ),
                        ),
                      ),
                      SizedBox(height: context.sh(8)),
                      NormalText(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        titleText: scan['label']?.toString() ?? '',
                        titleSize: context.sp(14),
                        titleWeight: FontWeight.w600,
                        titleColor: AppColors.subHeadingColor,
                      ),
                    ],
                  );
                },
              ),
            ),
            SizedBox(height: context.sh(18)),

            /// 🔹 Best Clothing Fits Section
            PlanContainer(
              margin: context.paddingSymmetricR(vertical: 0),
              padding: context.paddingSymmetricR(horizontal: 12, vertical: 12),
              isSelected: false,
              onTap: () {},
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      PlanContainer(
                        margin: context.paddingSymmetricR(vertical: 0),
                        padding: context.paddingSymmetricR(vertical: 4, horizontal: 4),
                        isSelected: false,
                        onTap: () {},
                        child: GestureDetector(
                          onTap:
                              fashionProfileScreenViewModel
                                  .toggleBestClothingSelection,
                          child: Container(
                            height: context.sh(20),
                            width: context.sw(20),
                            decoration: BoxDecoration(
                              color: fashionProfileScreenViewModel
                                      .isBestClothingSelected
                                  ? AppColors.pimaryColor
                                  : AppColors.backGroundColor,
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
                              child: fashionProfileScreenViewModel
                                      .isBestClothingSelected
                                  ? Icon(
                                      Icons.check,
                                      size: context.sh(16),
                                      color: AppColors.white,
                                    )
                                  : const SizedBox(),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: context.sw(11)),
                      NormalText(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        titleText: 'Styles to Avoid',
                        titleSize: context.sp(14),
                        titleWeight: FontWeight.w600,
                        titleColor: AppColors.subHeadingColor,
                      ),
                    ],
                  ),
                  SizedBox(height: context.sh(12)),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: fashionProfileScreenViewModel.stylesToAvoid.map((item) {
                      return PlanContainer(
                        margin: context.paddingSymmetricR(vertical: 0),
                        radius: BorderRadius.circular(context.radiusR(10)),
                        padding: context.paddingSymmetricR(vertical: 8, horizontal: 12),
                        isSelected: false,
                        onTap: () {},
                        child: NormalText(
                          titleText: item,
                          titleSize: context.sp(10),
                          titleWeight: FontWeight.w600,
                          titleColor: AppColors.subHeadingColor,
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

            SizedBox(height: context.sh(18)),

            PlanContainer(
              margin: context.paddingSymmetricR(vertical: 0),
              padding: context.paddingSymmetricR(horizontal: 12, vertical: 12),
              isSelected: false,
              onTap: () {},
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      PlanContainer(
                        margin: context.paddingSymmetricR(vertical: 0),

                        padding: context.paddingSymmetricR(vertical: 4, horizontal: 4),
                        isSelected: false,
                        onTap: () {},
                        child: GestureDetector(
                          onTap:
                              fashionProfileScreenViewModel
                                  .toggleBestClothingSelection,
                          child: SvgPicture.asset(
                            AppAssets.waringIcon,
                            fit: BoxFit.scaleDown,
                          ),
                        ),
                      ),
                      SizedBox(width: context.sw(11)),
                      NormalText(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        titleText: 'Best Clothing Fits',
                        titleSize: context.sp(14),
                        titleWeight: FontWeight.w600,
                        titleColor: AppColors.subHeadingColor,
                      ),
                    ],
                  ),
                  SizedBox(height: context.sh(12)),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: fashionProfileScreenViewModel.bestClothingFits.map((item) {
                      return PlanContainer(
                        margin: context.paddingSymmetricR(vertical: 0),
                        radius: BorderRadius.circular(context.radiusR(10)),
                        padding: context.paddingSymmetricR(vertical: 8, horizontal: 12),
                        isSelected: false,
                        onTap: () {},
                        child: NormalText(
                          titleText: item,
                          titleSize: context.sp(10),
                          titleWeight: FontWeight.w600,
                          titleColor: AppColors.subHeadingColor,
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            SizedBox(height: context.sh(18)),
            PlanContainer(
              margin: context.paddingSymmetricR(vertical: 0),
              padding: context.paddingSymmetricR(horizontal: 12, vertical: 12),
              isSelected: false,
              onTap: () {},
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      PlanContainer(
                        margin: context.paddingSymmetricR(vertical: 0),
                        padding: context.paddingSymmetricR(vertical: 4, horizontal: 4),
                        isSelected: false,
                        onTap: () {},
                        child: GestureDetector(
                          onTap:
                              fashionProfileScreenViewModel
                                  .toggleBestClothingSelection,
                          child: SvgPicture.asset(
                            AppAssets.themeIcon,
                            fit: BoxFit.scaleDown,
                          ),
                        ),
                      ),
                      SizedBox(width: context.sw(11)),
                      NormalText(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        titleText: 'Your Warm Palette',
                        titleSize: context.sp(14),
                        titleWeight: FontWeight.w600,
                        titleColor: AppColors.subHeadingColor,
                      ),
                    ],
                  ),
                  SizedBox(height: context.sh(12)),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: fashionProfileScreenViewModel.warmPalette.map((item) {
                      return PlanContainer(
                        margin: context.paddingSymmetricR(vertical: 0),
                        radius: BorderRadius.circular(context.radiusR(10)),
                        padding: context.paddingSymmetricR(vertical: 20, horizontal: 20),
                        isSelected: false,
                        onTap: () {},
                        child: ClipRRect(
                          child: Container(
                            height: context.sh(18),
                            width: context.sw(18),
                            color: _paletteColor(item),
                          ),
                          borderRadius: BorderRadiusGeometry.circular(
                            context.radiusR(10),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            SizedBox(height: context.sh(18)),
            NormalText(
              crossAxisAlignment: CrossAxisAlignment.start,
              titleText: fashionProfileScreenViewModel.weeklyTitle,
              titleSize: context.sp(18),
              titleWeight: FontWeight.w600,
              titleColor: AppColors.subHeadingColor,
            ),
            SizedBox(height: context.sh(12)),
            PlanContainer(
              padding: context.paddingSymmetricR(horizontal: 19, vertical: 22),
              isSelected: fashionProfileScreenViewModel.isExerciseSelected,
              onTap: () {
                fashionProfileScreenViewModel.selectExercise();

                Future.delayed(const Duration(milliseconds: 150), () {
                          if (!context.mounted) return;
                  Navigator.pushNamed(
                    context,
                    RoutesName.WeeklyPlanScreen,
                    arguments: {'daily_plan': fashionProfileScreenViewModel.dailyPlan},
                  );
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  NormalText(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    titleText: fashionProfileScreenViewModel.weeklySubtitle,
                    titleSize: context.sp(18),
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
