// import 'package:flutter/material.dart';
// import 'package:looklabs/Core/Widget/app_bar_container.dart';
// import 'package:looklabs/Core/Widget/custom_stepper.dart';
// import 'package:looklabs/Core/Widget/normal_text.dart';
// import 'package:looklabs/Core/Widget/plan_container.dart';
// import 'package:looklabs/Core/Constants/app_colors.dart';
// import 'package:looklabs/Core/Constants/size_extension.dart';
// import 'package:looklabs/ViewModel/hair_care_view_model.dart';
// import 'package:provider/provider.dart';

// class HairCareQuestion extends StatelessWidget {
//   final int index;
//   const HairCareQuestion({super.key, required this.index});

//   @override
//   Widget build(BuildContext context) {
//     final vm = Provider.of<HairCareViewModel>(context);
//     final data = vm.hairCareQuestions[index];

//     return ListView(
//       padding: context.paddingSymmetricR(horizontal: 20),
//       children: [
//         // if (index != 0) AppBarContainer(title: data['title'], onTap: vm.back),

//         // SizedBox(height: context.sh(20)),

//         // if (index == 0)
//         //   NormalText(
//         //     crossAxisAlignment: CrossAxisAlignment.center,
//         //     titleText: data['title'],
//         //     titleSize: context.sp(20),
//         //     titleWeight: FontWeight.w600,
//         //     titleColor: AppColors.headingColor,
//         //   ),

//         // SizedBox(height: context.sh(20)),

//         // CustomStepper(
//         //   currentStep: index, // Dynamic step based on current page index
//         //   steps: const [
//         //     'Haircare',
//         //     'History',
//         //     'Hair',
//         //     'Scalp',
//         //     'Concern',
//         //     'Routine',
//         //   ],
//         // ),
//         // SizedBox(height: context.sh(20)),

//         // NormalText(
//         //   titleText: data['question'],
//         //   titleSize: context.sp(18),
//         //   titleWeight: FontWeight.w600,
//         //   titleColor: AppColors.headingColor,
//         // ),
//         SizedBox(height: context.sh(8)),

//         ...List.generate(data['options'].length, (oIndex) {
//           return PlanContainer(
//             margin: context.paddingSymmetricR(vertical: 10),
//             isSelected: vm.selectedOptions[index] == oIndex,
//             onTap: () => vm.selectOption(index, oIndex),
//             padding: context.paddingSymmetricR(horizontal: 22, vertical: 14),
//             child: Text(
//               data['options'][oIndex],
//               style: TextStyle(
//                 fontSize: context.sp(14),
//                 color: AppColors.subHeadingColor,
//               ),
//             ),
//           );
//         }),
//       ],
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Features/Widget/normal_text.dart';
import 'package:looklabs/Features/Widget/plan_container.dart';
import 'package:looklabs/Features/ViewModel/hair_care_view_model.dart';

class HairCareQuestion extends StatelessWidget {
  final int index;
  const HairCareQuestion({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<HairCareViewModel>(context);
    final data = vm.hairCareQuestions[index];

    return ListView(
      padding: context.paddingSymmetricR(horizontal: 20),
      children: [
        NormalText(
          crossAxisAlignment: CrossAxisAlignment.start,
          titleText: data['question'],
          titleSize: context.sp(18),
          titleWeight: FontWeight.w600,
          titleColor: AppColors.headingColor,
        ),
        ...List.generate(data['options'].length, (oIndex) {
          return PlanContainer(
            margin: context.paddingSymmetricR(vertical: 10),
            isSelected: vm.selectedOptions[index] == oIndex,
            onTap: () => vm.selectOption(index, oIndex),
            padding: context.paddingSymmetricR(horizontal: 22, vertical: 14),
            child: Text(
              data['options'][oIndex],
              style: TextStyle(
                fontSize: context.sp(14),
                color: AppColors.subHeadingColor,
              ),
            ),
          );
        }),
      ],
    );
  }
}
