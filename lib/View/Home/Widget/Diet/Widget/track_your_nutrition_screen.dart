import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:looklabs/Core/Constants/Widget/activity_consistency_widget.dart';
import 'package:looklabs/Core/Constants/Widget/app_bar_container.dart';
import 'package:looklabs/Core/Constants/Widget/custom_button.dart';
import 'package:looklabs/Core/Constants/Widget/light_widget_continer.dart';
import 'package:looklabs/Core/Constants/Widget/normal_text.dart';
import 'package:looklabs/Core/Constants/Widget/plan_container.dart';
import 'package:looklabs/Core/Constants/app_assets.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Core/utils/Routes/routes_name.dart';
import 'package:looklabs/ViewModel/track_your_nutrition_view_model.dart';
import 'package:provider/provider.dart';

class TrackYourNutritionScreen extends StatefulWidget {
  const TrackYourNutritionScreen({super.key});

  @override
  State<TrackYourNutritionScreen> createState() =>
      _TrackYourNutritionScreenState();
}

class _TrackYourNutritionScreenState extends State<TrackYourNutritionScreen> {
  @override
  Widget build(BuildContext context) {
    final trackYourNutritionViewModel =
        Provider.of<TrackYourNutritionViewModel>(context);
    return Scaffold(
      backgroundColor: AppColors.backGroundColor,
      bottomNavigationBar: CustomButton(
        text: 'Next',
        color: AppColors.pimaryColor,
        isEnabled: true,
        onTap: () {
          Navigator.pushNamed(context, RoutesName.DietProgressScreen);
        },
      ),

      body: SafeArea(
        child: ListView(
          padding: context.padSym(h: 20),
          children: [
            AppBarContainer(
              title: 'Track Your Nutrition',
              onTap: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(height: context.h(24)),
            NormalText(
              titleText: 'Quick Action',
              titleSize: context.text(18),
              titleColor: AppColors.subHeadingColor,
              titleWeight: FontWeight.w600,
            ),
            SizedBox(height: context.h(12)),
            PlanContainer(
              padding: context.padSym(h: 20, v: 15),
              isSelected: false,
              onTap: () {},
              child: Row(
                children: [
                  Container(
                    height: context.h(28),
                    width: context.w(28),
                    decoration: BoxDecoration(
                      color: AppColors.backGroundColor,
                      borderRadius: BorderRadius.circular(context.radius(10)),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.customContainerColorUp.withOpacity(
                            0.4,
                          ),
                          offset: const Offset(3, 3),
                          blurRadius: 4,
                        ),
                        BoxShadow(
                          color: AppColors.customContinerColorDown.withOpacity(
                            0.4,
                          ),
                          offset: const Offset(-3, -3),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Center(
                      child: SizedBox(
                        height: context.h(32),
                        width: context.w(32),
                        child: SvgPicture.asset(
                          AppAssets.cameraIcon,
                          fit: BoxFit.scaleDown,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: context.w(11)),
                  NormalText(
                    titleText: 'Scan Food',
                    titleSize: context.text(18),
                    titleColor: AppColors.subHeadingColor,
                    titleWeight: FontWeight.w600,
                    subText: 'Take a photo or scan barcode',
                    subSize: context.text(12),
                    subWeight: FontWeight.w500,
                    subColor: AppColors.subHeadingColor,
                  ),
                ],
              ),
            ),
            SizedBox(height: context.h(24)),
            NormalText(
              titleText: 'Today’s Progress',
              titleSize: context.text(18),
              titleColor: AppColors.subHeadingColor,
              titleWeight: FontWeight.w600,
            ),
            SizedBox(height: context.h(2)),
            ActivityConsistencyWidget(
              title: 'Workout Consistency',
              subtitle: '14 / 20',
              pressentage: 10,
            ),
            SizedBox(height: context.h(24)),
            NormalText(
              titleText: 'Recent Foods',
              titleSize: context.text(18),
              titleColor: AppColors.subHeadingColor,
              titleWeight: FontWeight.w600,
            ),
            SizedBox(height: context.h(12)),
            ...List.generate(3, (index) {
              return PlanContainer(
                padding: context.padSym(h: 12, v: 12),
                isSelected: false,
                onTap: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    NormalText(
                      titleText: 'Greek Yogurt',
                      titleSize: context.text(16),
                      titleColor: AppColors.subHeadingColor,
                      titleWeight: FontWeight.w500,
                      subText: 'Breakfast',
                      subSize: context.text(12),
                      subWeight: FontWeight.w600,
                      subColor: AppColors.iconColor,
                    ),
                    NormalText(
                      titleText: '150 kcal',
                      titleSize: context.text(16),
                      titleColor: AppColors.redColor,
                      titleWeight: FontWeight.w600,
                    ),
                  ],
                ),
              );
            }),
            SizedBox(height: context.h(14)),
            LightWidgetContiner(
              text:
                  'Consistency improves stamina, strength & metabolism over time. Keep pushing!',
            ),
            SizedBox(height: context.h(200)),
          ],
        ),
      ),
    );
  }
}
