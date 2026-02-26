import 'package:flutter/material.dart';
import 'package:looklabs/Features/Widget/activity_consistency_widget.dart';
import 'package:looklabs/Features/Widget/app_bar_container.dart';
import 'package:looklabs/Features/Widget/light_card_widget.dart';
import 'package:looklabs/Features/Widget/normal_text.dart';
import 'package:looklabs/Features/Widget/plan_container.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Core/Routes/routes_name.dart';

class TrackYourNutritionScreen extends StatefulWidget {
  const TrackYourNutritionScreen({super.key});

  @override
  State<TrackYourNutritionScreen> createState() =>
      _TrackYourNutritionScreenState();
}

class _TrackYourNutritionScreenState extends State<TrackYourNutritionScreen> {
  @override
  Widget build(BuildContext context) {
    // final trackYourNutritionViewModel =
    //     Provider.of<TrackYourNutritionViewModel>(context);
    return Scaffold(
      backgroundColor: AppColors.backGroundColor,

      body: SafeArea(
        child: ListView(
          padding: context.paddingSymmetricR(horizontal: 20),
          children: [
            AppBarContainer(
              title: 'Track Your Nutrition',
              onTap: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(height: context.sh(24)),

            NormalText(
              titleText: 'Today’s Progress',
              titleSize: context.sp(18),
              titleColor: AppColors.subHeadingColor,
              titleWeight: FontWeight.w600,
            ),
            SizedBox(height: context.sh(2)),
            ActivityConsistencyWidget(
              title: 'Workout Consistency',
              subtitle: '14 / 20',
              pressentage: 10,
            ),
            SizedBox(height: context.sh(14)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                NormalText(
                  titleText: 'Recent Foods',
                  titleSize: context.sp(18),
                  titleColor: AppColors.subHeadingColor,
                  titleWeight: FontWeight.w600,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, RoutesName.AllTrackedFood);
                  },
                  child: Icon(Icons.arrow_forward_ios),
                ),
              ],
            ),
            SizedBox(height: context.sh(2)),
            ...List.generate(3, (index) {
              return PlanContainer(
                padding: context.paddingSymmetricR(horizontal: 12, vertical: 12),
                isSelected: false,
                onTap: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    NormalText(
                      titleText: 'Greek Yogurt',
                      titleSize: context.sp(16),
                      titleColor: AppColors.subHeadingColor,
                      titleWeight: FontWeight.w500,
                      subText: 'Breakfast',
                      subSize: context.sp(12),
                      subWeight: FontWeight.w600,
                      subColor: AppColors.iconColor,
                    ),
                    NormalText(
                      titleText: '150 kcal',
                      titleSize: context.sp(16),
                      titleColor: AppColors.redColor,
                      titleWeight: FontWeight.w600,
                    ),
                  ],
                ),
              );
            }),
            SizedBox(height: context.sh(6)),
            LightCardWidget(
              text:
                  'Consistency improves stamina, strength & posture over time.',
            ),
            SizedBox(height: context.sh(30)),
          ],
        ),
      ),
    );
  }
}
