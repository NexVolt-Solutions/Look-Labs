import 'package:flutter/material.dart';
import 'package:looklabs/features/Widget/app_bar_container.dart';
import 'package:looklabs/features/Widget/camera_widget.dart';
import 'package:looklabs/features/Widget/custom_button.dart';
import 'package:looklabs/features/Widget/custom_stepper.dart';
import 'package:looklabs/features/Widget/normal_text.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Core/utils/Routes/routes_name.dart';

class HairReviewScans extends StatefulWidget {
  const HairReviewScans({super.key});

  @override
  State<HairReviewScans> createState() => _HairReviewScansState();
}

class _HairReviewScansState extends State<HairReviewScans> {
  int currentStep = 0; // track step index

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backGroundColor,
      bottomNavigationBar: Padding(
        padding: EdgeInsetsGeometry.only(
          top: context.h(5),
          left: context.w(20),
          right: context.w(20),
          bottom: context.h(30),
        ),
        child: CustomButton(
          text: 'Continue',
          color: AppColors.pimaryColor,
          isEnabled: true,
          onTap: () {
            Navigator.pushNamed(context, RoutesName.HairAnalyzingScreen);
          },
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: context.padSym(h: 20),
          children: [
            AppBarContainer(
              title: 'Review Scans',
              onTap: () => Navigator.pop(context),
            ),
            SizedBox(height: context.h(24)),
            CustomStepper(
              currentStep: currentStep,
              steps: const ['Front', 'Back', 'Left', 'Right'],
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
                  childAspectRatio: 3.5 / 3.5,
                ),
                itemCount: 4,
                itemBuilder: (context, index) {
                  return CameraWidget(
                    onTapFun: () {
                      setState(() {
                        currentStep = index;
                      });
                    },
                    isSelected: currentStep == index,
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

// class HairReviewScans extends StatefulWidget {
//   const HairReviewScans({super.key});

//   @override
//   State<HairReviewScans> createState() => _HairReviewScansState();
// }

// class _HairReviewScansState extends State<HairReviewScans> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.backGroundColor,
//       bottomNavigationBar: CustomButton(
//         text: 'Continue',
//         color: AppColors.pimaryColor,
//         isEnabled: true,
//         onTap: () {
//           Navigator.pushNamed(context, RoutesName.HairAnalyzingScreen);
//         },
//       ),
//       body: SafeArea(
//         child: ListView(
//           padding: context.padSym(h: 20),
//           children: [
//             AppBarContainer(
//               title: 'Review Scans',
//               onTap: () {
//                 Navigator.pop(context);
//               },
//             ),

//             // CustomStepper(
//             //   currentStep: index,
//             //   steps: const [
//             //     'Haircare',
//             //     'History',
//             //     'Hair',
//             //     'Scalp',
//             //     'Concern',
//             //     'Routine',
//             //   ],
//             // ),
//             SizedBox(height: context.h(20)),
//             NormalText(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               titleText: 'Capture Your Hair',
//               titleSize: context.text(18),
//               titleWeight: FontWeight.w600,
//               titleColor: AppColors.headingColor,
//               subText:
//                   'Take 4 photos from different angles for personalized recommendations',
//               subSize: context.text(14),
//               subWeight: FontWeight.w400,
//               subColor: AppColors.subHeadingColor,
//               sizeBoxheight: context.h(8),
//               subAlign: TextAlign.center,
//             ),
//             SizedBox(height: context.h(12)),
//             SizedBox(
//               height: context.h(1150),
//               child: GridView.builder(
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 padding: EdgeInsets.zero,
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2,
//                   // mainAxisSpacing: 16,
//                   // crossAxisSpacing: 16,
//                   // mainAxisExtent: 2,
//                   childAspectRatio: 3.5 / 3.5,
//                 ),
//                 itemCount: 4,
//                 // homeViewModel.gridData.length,
//                 itemBuilder: (context, index) {
//                   // final item = homeViewModel.gridData[index];
//                   return CameraWidget();
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
