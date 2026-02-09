// // import 'package:flutter/material.dart';
// // import 'package:looklabs/Core/Widget/custom_button.dart';
// // import 'package:looklabs/Core/Constants/app_colors.dart';
// // import 'package:looklabs/Core/utils/Routes/routes_name.dart';
// // import 'package:looklabs/View/Home/Widget/HairCare/hair_care_question_screen.dart';
// // import 'package:looklabs/ViewModel/hair_care_view_model.dart';
// // import 'package:provider/provider.dart';

// // class HairCare extends StatefulWidget {
// //   const HairCare({super.key});

// //   @override
// //   State<HairCare> createState() => _HairCareState();
// // }

// // class _HairCareState extends State<HairCare> {
// //   @override
// //   Widget build(BuildContext context) {
// //     final vm = Provider.of<HairCareViewModel>(context);
// //     final isLast = vm.currentStep == vm.hairCareQuestions.length - 1;

// //     return Scaffold(
// //       backgroundColor: AppColors.backGroundColor,

// //       bottomNavigationBar: CustomButton(
// //         text: isLast ? 'Complete' : 'Next',
// //         color: AppColors.pimaryColor,
// //         isEnabled: true,
// //         onTap: () {
// //           if (isLast) {
// //             Navigator.pushNamed(context, RoutesName.HairReviewScansScreen);
// //           } else {
// //             vm.next();
// //           }
// //         },
// //       ),

// //       body: SafeArea(
// //         child: Column(
// //           children: [
// //             Expanded(
// //               child: PageView.builder(
// //                 controller: vm.pageController,
// //                 physics: const NeverScrollableScrollPhysics(),
// //                 itemCount: vm.hairCareQuestions.length,
// //                 itemBuilder: (_, index) {
// //                   return HairCareQuestion(index: index);
// //                 },
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// //   //  if (vm.pageController != 0)
// //   //             ...List.generate(data.length, (index) {
// //   //               return AppBarContainer(
// //   //                 title: data[index]['title'],
// //   //                 onTap: vm.back,
// //   //               );
// //   //             }),
// //   //           SizedBox(height: context.h(20)),

// //   //           if (vm.pageController == 0)
// //   //             ...List.generate(data.length, (index) {
// //   //               return NormalText(
// //   //                 crossAxisAlignment: CrossAxisAlignment.center,
// //   //                 titleText: data[index]["title"].toString(),
// //   //                 titleSize: context.text(20),
// //   //                 titleWeight: FontWeight.w600,
// //   //                 titleColor: AppColors.headingColor,
// //   //               );
// //   //             }),

// //   //           SizedBox(height: context.h(20)),
// //   //           ...List.generate(data.length, (index) {
// //   //             return CustomStepper(
// //   //               currentStep: index, // Dynamic step based on current page index
// //   //               steps: const [
// //   //                 'Haircare',
// //   //                 'History',
// //   //                 'Hair',
// //   //                 'Scalp',
// //   //                 'Concern',
// //   //                 'Routine',
// //   //               ],
// //   //             );
// //   //           }),

// import 'package:flutter/material.dart';
// import 'package:looklabs/Core/Constants/app_colors.dart';
// import 'package:looklabs/Core/Constants/size_extension.dart';
// import 'package:looklabs/Core/Widget/app_bar_container.dart';
// import 'package:looklabs/Core/Widget/custom_button.dart';
// import 'package:looklabs/Core/Widget/custom_stepper.dart';
// import 'package:looklabs/Core/Widget/normal_text.dart';
// import 'package:looklabs/Core/utils/Routes/routes_name.dart';
// import 'package:looklabs/View/Home/Widget/HairCare/hair_care_question_screen.dart';
// import 'package:looklabs/ViewModel/hair_care_view_model.dart';
// import 'package:provider/provider.dart';

// class HairCare extends StatefulWidget {
//   const HairCare({super.key});

//   @override
//   State<HairCare> createState() => _HairCareState();
// }

// class _HairCareState extends State<HairCare> {
//   @override
//   Widget build(BuildContext context) {
//     final vm = Provider.of<HairCareViewModel>(context);
//     final index = vm.currentStep;
//     final data = vm.hairCareQuestions[index];
//     final isLast = index == vm.hairCareQuestions.length - 1;

//     return Scaffold(
//       backgroundColor: AppColors.backGroundColor,

//       bottomNavigationBar: CustomButton(
//         text: isLast ? 'Complete' : 'Next',
//         color: AppColors.pimaryColor,
//         isEnabled: true,
//         onTap: () {
//           if (isLast) {
//             Navigator.pushNamed(context, RoutesName.HairReviewScansScreen);
//           } else {
//             vm.next();
//           }
//         },
//       ),

//       body: SafeArea(
//         child: Column(
//           children: [
//             /// 🔹 AppBar (except first page)
//             if (index != 0)
//               AppBarContainer(title: data['title'], onTap: vm.back),

//             SizedBox(height: context.h(20)),

//             /// 🔹 Title (only first page)
//             if (index == 0)
//               NormalText(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 titleText: data['title'],
//                 titleSize: context.text(20),
//                 titleWeight: FontWeight.w600,
//                 titleColor: AppColors.headingColor,
//               ),

//             SizedBox(height: context.h(20)),

//             /// 🔹 Stepper
//             CustomStepper(
//               currentStep: index,
//               steps: const [
//                 'Haircare',
//                 'History',
//                 'Hair',
//                 'Scalp',
//                 'Concern',
//                 'Routine',
//               ],
//             ),

//             SizedBox(height: context.h(20)),

//             /// 🔹 PageView (ONLY questions)
//             Expanded(
//               child: PageView.builder(
//                 controller: vm.pageController,
//                 physics: const NeverScrollableScrollPhysics(),
//                 onPageChanged: vm.setStep,
//                 itemCount: vm.hairCareQuestions.length,
//                 itemBuilder: (_, index) {
//                   return HairCareQuestion(index: index);
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:looklabs/Core/utils/Routes/routes_name.dart';
import 'package:looklabs/View/Home/Widget/HairCare/hair_care_question_screen.dart';
import 'package:provider/provider.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Core/Widget/app_bar_container.dart';
import 'package:looklabs/Core/Widget/custom_stepper.dart';
import 'package:looklabs/Core/Widget/normal_text.dart';
import 'package:looklabs/Core/Widget/custom_button.dart';
import 'package:looklabs/ViewModel/hair_care_view_model.dart';

class HairCare extends StatefulWidget {
  const HairCare({super.key});

  @override
  State<HairCare> createState() => _HairCareState();
}

class _HairCareState extends State<HairCare> {
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<HairCareViewModel>(context);
    final index = vm.currentStep;
    final data = vm.hairCareQuestions[index];
    final isLast = index == vm.hairCareQuestions.length - 1;

    return Scaffold(
      backgroundColor: AppColors.backGroundColor,

      bottomNavigationBar: CustomButton(
        text: isLast ? 'Complete' : 'Next',
        color: AppColors.pimaryColor,
        isEnabled: true,
        onTap: () {
          if (isLast) {
            Navigator.pushNamed(context, RoutesName.HairReviewScansScreen);
          } else {
            vm.next();
          }
        },
      ),

      body: SafeArea(
        child: Column(
          children: [
            /// 🔹 AppBar
            if (index != 0)
              Padding(
                padding: context.padSym(h: 20),
                child: AppBarContainer(title: data['title'], onTap: vm.back),
              ),

            SizedBox(height: context.h(20)),

            /// 🔹 Title
            if (index == 0)
              NormalText(
                crossAxisAlignment: CrossAxisAlignment.center,
                titleText: data['title'],
                titleSize: context.text(20),
                titleWeight: FontWeight.w600,
                titleColor: AppColors.headingColor,
              ),

            SizedBox(height: context.h(20)),

            /// 🔹 Stepper
            Padding(
              padding: context.padSym(h: 20),
              child: CustomStepper(
                currentStep: index,
                steps: const [
                  'Haircare',
                  'History',
                  'Hair',
                  'Scalp',
                  'Concern',
                  'Routine',
                ],
              ),
            ),

            SizedBox(height: context.h(20)),

            /// 🔹 PageView
            Expanded(
              child: PageView.builder(
                controller: vm.pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: vm.setStep,
                itemCount: vm.hairCareQuestions.length,
                itemBuilder: (_, index) {
                  return HairCareQuestion(index: index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
