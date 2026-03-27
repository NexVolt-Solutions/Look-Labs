import 'package:flutter/material.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Features/Widget/app_bar_container.dart';
import 'package:looklabs/Features/Widget/camera_widget.dart';
import 'package:looklabs/Features/Widget/custom_button.dart';
import 'package:looklabs/Features/Widget/custom_stepper.dart';
import 'package:looklabs/Features/Widget/normal_text.dart';
import 'package:looklabs/Core/Routes/routes_name.dart';
import 'package:looklabs/Features/ViewModel/review_scans_view_model.dart';
import 'package:provider/provider.dart';

class FashionReviewScanScreen extends StatelessWidget {
  const FashionReviewScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ReviewScansViewModel>();
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
          text: 'Continue',
          color: AppColors.pimaryColor,
          isEnabled: true,
          onTap: () {
            Navigator.pushNamed(context, RoutesName.FashionAnalyzingScreen);
          },
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: context.paddingSymmetricR(horizontal: 20),
          children: [
            AppBarContainer(
              title: 'Review Scans',
              onTap: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(height: context.sh(24)),

            CustomStepper(
              currentStep: viewModel.currentStep,
              steps: const ['Front', 'Back', 'Left', 'Right'],
            ),
            SizedBox(height: context.sh(20)),
            NormalText(
              crossAxisAlignment: CrossAxisAlignment.center,
              titleText: 'Capture Your Body',
              titleSize: context.sp(18),
              titleWeight: FontWeight.w600,
              titleColor: AppColors.headingColor,
              subText:
                  'Take 2 photos from different angles for personalized recommendations',
              subSize: context.sp(14),
              subWeight: FontWeight.w400,
              subColor: AppColors.subHeadingColor,
              sizeBoxheight: context.sh(8),
              subAlign: TextAlign.center,
            ),
            SizedBox(height: context.sh(12)),
            SizedBox(
              height: context.sh(1150),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3.5 / 3.5,
                ),
                itemCount: 4,
                itemBuilder: (context, index) {
                  return CameraWidget(
                    onTapFun: () => viewModel.selectStep(index),
                    isSelected: viewModel.currentStep == index,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
