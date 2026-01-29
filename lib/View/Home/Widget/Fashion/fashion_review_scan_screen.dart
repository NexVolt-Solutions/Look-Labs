import 'package:flutter/material.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Core/Widget/app_bar_container.dart';
import 'package:looklabs/Core/Widget/camera_widget.dart';
import 'package:looklabs/Core/Widget/custom_button.dart';
import 'package:looklabs/Core/Widget/normal_text.dart';
import 'package:looklabs/Core/utils/Routes/routes_name.dart';

class FashionReviewScanScreen extends StatefulWidget {
  const FashionReviewScanScreen({super.key});

  @override
  State<FashionReviewScanScreen> createState() =>
      _FashionReviewScanScreenState();
}

class _FashionReviewScanScreenState extends State<FashionReviewScanScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backGroundColor,
      bottomNavigationBar: CustomButton(
        text: 'Continue',
        color: AppColors.pimaryColor,
        isEnabled: true,
        onTap: () {
          Navigator.pushNamed(context, RoutesName.FashionAnalyzingScreen);
        },
      ),
      body: SafeArea(
        child: ListView(
          padding: context.padSym(h: 20),
          children: [
            AppBarContainer(
              title: 'Review Scans',
              onTap: () {
                Navigator.pop(context);
              },
            ),

            SizedBox(height: context.h(60)),
            NormalText(
              crossAxisAlignment: CrossAxisAlignment.center,
              titleText: 'Capture Your Body',
              titleSize: context.text(18),
              titleWeight: FontWeight.w600,
              titleColor: AppColors.headingColor,
              subText:
                  'Take 2 photos from different angles for personalized recommendations',
              subSize: context.text(14),
              subWeight: FontWeight.w400,
              subColor: AppColors.subHeadingColor,
              sizeBoxheight: context.h(8),
              subAlign: TextAlign.center,
            ),
            SizedBox(height: context.h(12)),
            SizedBox(
              height: context.h(600),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  // mainAxisSpacing: 16,
                  // crossAxisSpacing: 16,
                  // mainAxisExtent: 2,
                  childAspectRatio: 3 / 3,
                ),
                itemCount: 2,
                // homeViewModel.gridData.length,
                itemBuilder: (context, index) {
                  // final item = homeViewModel.gridData[index];
                  return CameraWidget();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
