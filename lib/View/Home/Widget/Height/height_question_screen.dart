// import 'package:flutter/material.dart';
// import 'package:looklabs/Core/Constants/Widget/app_bar_container.dart';
// import 'package:looklabs/Core/Constants/Widget/height_slider.dart';
// import 'package:looklabs/Core/Constants/Widget/normal_text.dart';
// import 'package:looklabs/Core/Constants/Widget/plan_container.dart';
// import 'package:looklabs/Core/Constants/app_colors.dart';
// import 'package:looklabs/Core/Constants/size_extension.dart';
// import 'package:looklabs/ViewModel/height_view_model.dart';
// import 'package:provider/provider.dart';

// class HeightQuestion extends StatelessWidget {
//   final int index;
//   const HeightQuestion({super.key, required this.index});

//   @override
//   Widget build(BuildContext context) {
//     final vm = Provider.of<HeightViewModel>(context);
//     final data = vm.heightQuestions[index];

//     return ListView(
//       padding: context.padSym(h: 20),
//       children: [
//         if (index != 0) AppBarContainer(title: data['title'], onTap: vm.back),

//         SizedBox(height: context.h(20)),

//         if (index == 0)
//           NormalText(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             titleText: data['title'],
//             titleSize: context.text(20),
//             titleWeight: FontWeight.w600,
//             titleColor: AppColors.headingColor,
//           ),
//         SizedBox(height: context.h(18)),
//         NormalText(
//           titleText: data['question'],
//           titleSize: context.text(18),
//           titleWeight: FontWeight.w600,
//           titleColor: AppColors.headingColor,
//         ),

//         SizedBox(height: context.h(8)),

//         ...List.generate(data['options'].length, (oIndex) {
//           return PlanContainer(
//             isSelected: vm.selectedOptions[index] == oIndex,
//             onTap: () => vm.selectOption(index, oIndex),
//             padding: context.padSym(h: 22, v: 14),
//             child: Text(
//               data['options'][oIndex],
//               style: TextStyle(
//                 fontSize: context.text(14),
//                 color: AppColors.subHeadingColor,
//               ),
//             ),
//           );
//         }),

//         if (index == vm.heightQuestions.length - 1) ...[
//           NormalText(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             titleText: 'Your Height Goals',
//             titleSize: context.text(16),
//             titleWeight: FontWeight.w600,
//             titleColor: AppColors.subHeadingColor,
//             sizeBoxheight: context.h(4),
//             subText: 'Set your current and desired height',
//             subSize: context.text(14),
//             subWeight: FontWeight.w400,
//             subColor: AppColors.subHeadingColor,
//           ),

//           SizedBox(height: context.h(18)),

//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               // Current container
//               Column(
//                 children: [
//                   NormalText(
//                     titleText: '149 cm',
//                     titleSize: context.text(12),
//                     titleWeight: FontWeight.w600,
//                     titleColor: AppColors.subHeadingColor,
//                   ),
//                   SizedBox(height: context.h(15)),
//                   Container(
//                     width: context.w(55),
//                     height: context.h(197),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.only(
//                         topLeft: Radius.circular(context.radius(10)),
//                         topRight: Radius.circular(context.radius(10)),
//                       ),
//                       border: Border.all(
//                         color: AppColors.backGroundColor,
//                         width: context.w(1.5),
//                       ),
//                       color: AppColors.backGroundColor,
//                     ),
//                   ),
//                   SizedBox(height: context.h(15)),
//                   NormalText(
//                     titleText: 'Current',
//                     titleSize: context.text(14),
//                     titleWeight: FontWeight.w600,
//                     titleColor: AppColors.subHeadingColor,
//                   ),
//                 ],
//               ),

//               SizedBox(width: context.w(16)),

//               // Goal container
//               Column(
//                 children: [
//                   NormalText(
//                     titleText: '149 cm',
//                     titleSize: context.text(12),
//                     titleWeight: FontWeight.w600,
//                     titleColor: AppColors.subHeadingColor,
//                   ),
//                   SizedBox(height: context.h(15)),
//                   Container(
//                     width: context.w(55),
//                     height: context.h(220),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.only(
//                         topLeft: Radius.circular(context.radius(10)),
//                         topRight: Radius.circular(context.radius(10)),
//                       ),
//                       border: Border.all(
//                         color: AppColors.pimaryColor,
//                         width: context.w(1.5),
//                       ),
//                       color: AppColors.pimaryColor,
//                     ),
//                   ),
//                   SizedBox(height: context.h(15)),
//                   NormalText(
//                     titleText: 'Goal',
//                     titleSize: context.text(14),
//                     titleWeight: FontWeight.w600,
//                     titleColor: AppColors.subHeadingColor,
//                   ),
//                 ],
//               ),
//             ],
//           ),

//           SizedBox(height: context.h(18)),
//           HeightSlider(title: 'Current Height', per: '149 cm'),
//           SizedBox(height: context.h(18)),
//           HeightSlider(title: 'Desired Height', per: '150 cm'),
//         ],
//       ],
//     );
//   }
// }import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:looklabs/Core/Constants/Widget/app_bar_container.dart';
import 'package:looklabs/Core/Constants/Widget/goal_activity_graph.dart';
import 'package:looklabs/Core/Constants/Widget/height_slider.dart';
import 'package:looklabs/Core/Constants/Widget/normal_text.dart';
import 'package:looklabs/Core/Constants/Widget/plan_container.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/ViewModel/height_view_model.dart';
import 'package:provider/provider.dart';

class HeightQuestion extends StatelessWidget {
  final int index;
  const HeightQuestion({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<HeightViewModel>(context);
    final data = vm.heightQuestions[index];

    final bool isLastScreen = index == vm.heightQuestions.length - 1;

    return ListView(
      padding: context.padSym(h: 20),
      children: [
        /// 🔹 APP BAR
        AppBarContainer(
          title: isLastScreen ? 'Daily Activity Level' : data['title'],
          onTap: vm.back,
        ),

        SizedBox(height: context.h(20)),

        /// ==============================
        /// 🔹 QUESTION SCREENS
        /// ==============================
        if (!isLastScreen) ...[
          if (index == 0)
            NormalText(
              crossAxisAlignment: CrossAxisAlignment.center,
              titleText: data['title'],
              titleSize: context.text(20),
              titleWeight: FontWeight.w600,
              titleColor: AppColors.headingColor,
            ),

          SizedBox(height: context.h(18)),

          NormalText(
            titleText: data['question'],
            titleSize: context.text(18),
            titleWeight: FontWeight.w600,
            titleColor: AppColors.headingColor,
          ),

          SizedBox(height: context.h(8)),

          ...List.generate(data['options'].length, (oIndex) {
            return PlanContainer(
              isSelected: vm.selectedOptions[index] == oIndex,
              onTap: () => vm.selectOption(index, oIndex),
              padding: context.padSym(h: 22, v: 14),
              child: Text(
                data['options'][oIndex],
                style: TextStyle(
                  fontSize: context.text(14),
                  color: AppColors.subHeadingColor,
                ),
              ),
            );
          }),
        ],

        /// ==============================
        /// 🔹 LAST SCREEN (HEIGHT GOAL)
        /// ==============================
        if (isLastScreen) ...[
          NormalText(
            crossAxisAlignment: CrossAxisAlignment.start,
            titleText: 'Your Height Goals',
            titleSize: context.text(16),
            titleWeight: FontWeight.w600,
            titleColor: AppColors.subHeadingColor,
            sizeBoxheight: context.h(4),
            subText: 'Set your current and desired height',
            subSize: context.text(14),
            subWeight: FontWeight.w400,
            subColor: AppColors.subHeadingColor,
          ),

          SizedBox(height: context.h(18)),

          GoalActivityGraph(
            title1: 'Current',
            title2: 'Goal',
            currentHeight: 149,
            desiredHeight: 150,
          ),

          SizedBox(height: context.h(18)),
          HeightSlider(title: 'Current Height', per: '149 cm'),
          SizedBox(height: context.h(18)),
          HeightSlider(title: 'Desired Height', per: '150 cm'),
        ],
      ],
    );
  }
}
