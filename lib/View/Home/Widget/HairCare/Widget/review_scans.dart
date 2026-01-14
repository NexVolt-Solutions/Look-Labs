import 'package:flutter/material.dart';
import 'package:looklabs/Core/Constants/Widget/app_bar_container.dart';
import 'package:looklabs/Core/Constants/Widget/camera_widget.dart';
import 'package:looklabs/Core/Constants/Widget/custom_button.dart';
import 'package:looklabs/Core/Constants/Widget/normal_text.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Core/utils/Routes/routes_name.dart';

class ReviewScans extends StatefulWidget {
  const ReviewScans({super.key});

  @override
  State<ReviewScans> createState() => _ReviewScansState();
}

class _ReviewScansState extends State<ReviewScans> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backGroundColor,
      bottomNavigationBar: CustomButton(
        text: 'Continue',
        color: AppColors.pimaryColor,
        isEnabled: true,
        onTap: () {
          Navigator.pushNamed(context, RoutesName.AnalyzingScreen);
        },
        padding: context.padSym(h: 145, v: 17),
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

            SizedBox(height: context.h(20)),
            NormalText(
              crossAxisAlignment: CrossAxisAlignment.center,
              titleText: 'Capture Your Hair',
              titleSize: context.text(18),
              titleWeight: FontWeight.w600,
              titleColor: AppColors.headingColor,
              subText:
                  'Take 4 photos from different angles for personalized recommendations',
              subSize: context.text(14),
              subWeight: FontWeight.w400,
              subColor: AppColors.subHeadingColor,
              sizeBoxheight: context.h(8),
              subAlign: TextAlign.center,
            ),
            SizedBox(height: context.h(12)),
            SizedBox(
              height: context.h(1150),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  // mainAxisSpacing: 16,
                  // crossAxisSpacing: 16,
                  // mainAxisExtent: 2,
                  childAspectRatio: 2.5 / 3,
                ),
                itemCount: 4,
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
