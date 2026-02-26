import 'package:flutter/material.dart';
import 'package:looklabs/Features/Widget/app_bar_container.dart';
import 'package:looklabs/Features/Widget/custom_button.dart';
import 'package:looklabs/Features/Widget/height_widget_cont.dart';
import 'package:looklabs/Features/Widget/light_card_widget.dart';
import 'package:looklabs/Features/Widget/neu_text_fied.dart';
import 'package:looklabs/Features/Widget/normal_text.dart';
import 'package:looklabs/Core/Constants/app_assets.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Features/ViewModel/daily_diet_routine_screen_view_model.dart';

import 'package:provider/provider.dart';

class DietDetailsScreen extends StatefulWidget {
  const DietDetailsScreen({super.key});

  @override
  State<DietDetailsScreen> createState() => _DietDetailsScreenState();
}

class _DietDetailsScreenState extends State<DietDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final dailyDietRoutineScreenViewModel =
        Provider.of<DailyDietRoutineScreenViewModel>(context);
    return Scaffold(
      backgroundColor: AppColors.backGroundColor,
      bottomNavigationBar: Padding(
        padding: EdgeInsetsGeometry.only(
          top: context.sh(5),
          left: context.sw(20),
          right: context.sw(20),
          bottom: context.sh(30),
        ),
        child: CustomButton(
          text: 'Scan another food',
          color: AppColors.pimaryColor,
          isEnabled: true,
          onTap: () {
            dailyDietRoutineScreenViewModel.showTransparentDialog(context);
          },
        ),
      ),

      body: SafeArea(
        child: ListView(
          padding: context.paddingSymmetricR(horizontal: 20),
          children: [
            AppBarContainer(
              title: 'Food Details',
              onTap: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(height: context.sh(24)),
            ClipRRect(
              borderRadius: BorderRadiusGeometry.circular(context.radiusR(10)),
              child: Container(
                height: 251,
                width: context.sw(336),
                decoration: BoxDecoration(color: AppColors.black),
              ),
            ),
            SizedBox(height: context.sh(24)),
            NeuTextField(
              label: 'Food Name',
              obscure: true,
              validatorType: 'name',
              hintText: 'Enter food name',
              keyboard: TextInputType.name,
            ),
            SizedBox(height: context.sh(24)),
            NeuTextField(
              label: 'Portion Size',
              obscure: true,
              validatorType: 'name',
              hintText: 'Enter portion size',
              keyboard: TextInputType.name,
            ),
            SizedBox(height: context.sh(24)),
            NormalText(
              titleText: 'Nutrition Facts',
              titleSize: context.sp(18),
              titleWeight: FontWeight.w600,
              titleColor: AppColors.subHeadingColor,
            ),
            SizedBox(height: context.sh(12)),
            SizedBox(
              height: context.sh(135),
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
            SizedBox(height: context.sh(24)),
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
