import 'package:flutter/material.dart';
import 'package:looklabs/Core/Widget/app_bar_container.dart';
import 'package:looklabs/Core/Widget/custom_button.dart';
import 'package:looklabs/Core/Widget/height_widget_cont.dart';
import 'package:looklabs/Core/Widget/light_card_widget.dart';
import 'package:looklabs/Core/Widget/neu_text_fied.dart';
import 'package:looklabs/Core/Widget/normal_text.dart';
import 'package:looklabs/Core/Constants/app_assets.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Core/utils/Routes/routes_name.dart';
import 'package:looklabs/ViewModel/diet_details_screen_view_model.dart';
import 'package:provider/provider.dart';

class DietDetailsScreen extends StatefulWidget {
  const DietDetailsScreen({super.key});

  @override
  State<DietDetailsScreen> createState() => _DietDetailsScreenState();
}

class _DietDetailsScreenState extends State<DietDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final dietDetailsScreenViewModel = Provider.of<DietDetailsScreenViewModel>(
      context,
    );
    return Scaffold(
      backgroundColor: AppColors.backGroundColor,
      bottomNavigationBar: CustomButton(
        text: 'Scan another food',
        color: AppColors.pimaryColor,
        isEnabled: true,
        onTap: () {
          Navigator.pushNamed(context, RoutesName.TrackYourNutritionScreen);
        },
      ),

      body: SafeArea(
        child: ListView(
          padding: context.padSym(h: 20),
          children: [
            AppBarContainer(
              title: 'Food Details',
              onTap: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(height: context.h(24)),
            ClipRRect(
              borderRadius: BorderRadiusGeometry.circular(context.radius(10)),
              child: Container(
                height: 251,
                width: context.w(336),
                decoration: BoxDecoration(color: AppColors.black),
              ),
            ),
            SizedBox(height: context.h(24)),
            NeuTextField(
              label: 'Food Name',
              obscure: true,
              validatorType: 'name',
              hintText: 'Enter food name',
              keyboard: TextInputType.name,
            ),
            SizedBox(height: context.h(24)),
            NeuTextField(
              label: 'Portion Size',
              obscure: true,
              validatorType: 'name',
              hintText: 'Enter portion size',
              keyboard: TextInputType.name,
            ),
            SizedBox(height: context.h(24)),
            NormalText(
              titleText: 'Nutrition Facts',
              titleSize: context.text(18),
              titleWeight: FontWeight.w600,
              titleColor: AppColors.subHeadingColor,
            ),
            SizedBox(height: context.h(12)),
            SizedBox(
              height: context.h(135),
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
            SizedBox(height: context.h(24)),
            LightCardWidget(
              text:
                  'Consistency improves stamina, strength & posture over time.',
            ),
            SizedBox(height: context.h(200)),
          ],
        ),
      ),
    );
  }
}
