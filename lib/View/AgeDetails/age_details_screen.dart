import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:looklabs/Core/Constants/Widget/app_bar_container.dart';
import 'package:looklabs/Core/Constants/Widget/custom_button.dart';
import 'package:looklabs/Core/Constants/Widget/custom_container.dart';
import 'package:looklabs/Core/Constants/Widget/normal_text.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/ViewModel/age_details_view_model.dart';
import 'package:provider/provider.dart';

class AgeDetailsScreen extends StatefulWidget {
  const AgeDetailsScreen({super.key});

  @override
  State<AgeDetailsScreen> createState() => _AgeDetailsScreenState();
}

class _AgeDetailsScreenState extends State<AgeDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final ageDetailsViewModel = Provider.of<AgeDetailsViewModel>(context);
    return Scaffold(
      backgroundColor: AppColors.backGroundColor,
      body: SafeArea(
        child: ListView(
          clipBehavior: Clip.hardEdge,
          padding: context.padSym(h: 20),
          children: [
            AppBarContainer(title: 'Age Details'),
            SizedBox(height: context.h(23)),
            NormalText(
              crossAxisAlignment: CrossAxisAlignment.start,
              titleText: ageDetailsViewModel.title,
              titleSize: context.text(16),
              titleWeight: FontWeight.w600,
              titleColor: AppColors.headingColor,
              subText: ageDetailsViewModel.subTitle,
              subSize: context.text(14),
              subWeight: FontWeight.w600,
              subColor: AppColors.notSelectedColor,
            ),

            // NormalText(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   titleText: 'What is your current age?',
            //   titleSize: context.text(16),
            //   titleWeight: FontWeight.w600,
            //   titleColor: AppColors.headingColor,
            //   subText: 'This helps personalize your routine',
            //   subSize: context.text(14),
            //   subWeight: FontWeight.w600,
            //   subColor: AppColors.notSelectedColor,
            // ),
            SizedBox(height: context.h(18)),
            ...List.generate(ageDetailsViewModel.currentList.length, (index) {
              final isSelected =
                  ageDetailsViewModel.selectedValue ==
                  ageDetailsViewModel.currentList[index];
              return CustomContainer(
                onTap: () {
                  ageDetailsViewModel.selectItem(index);
                },
                radius: context.radius(10),
                color: isSelected
                    ? AppColors.buttonColor.withOpacity(0.11)
                    : AppColors.backGroundColor,
                padding: context.padSym(h: 22, v: 14),
                border: isSelected
                    ? Border.all(color: AppColors.pimaryColor, width: 1.5)
                    : null,
                margin: context.padSym(v: 12),
                child: Text(
                  ageDetailsViewModel.currentList[index],
                  style: TextStyle(
                    fontSize: context.text(14),
                    fontWeight: FontWeight.w400,
                    color: AppColors.subHeadingColor,
                  ),
                ),
              );
            }),
            SizedBox(height: context.h(18)),
            NormalText(
              crossAxisAlignment: CrossAxisAlignment.start,
              titleText: 'Enter Age',
              titleSize: context.text(14),
              titleWeight: FontWeight.w600,
              titleColor: AppColors.headingColor,
            ),
            SizedBox(height: context.h(12)),
            // Container(
            //   height: context.h(54),
            //   padding: context.padSym(h: 17),
            //   decoration: BoxDecoration(
            //     color: AppColors.backGroundColor,
            //     borderRadius: BorderRadius.circular(context.radius(16)),
            //     border: Border.all(
            //       color: Colors.white.withOpacity(0.4),
            //       width: context.w(0.5),
            //     ),
            //     boxShadow: const [
            //       BoxShadow(
            //         offset: Offset(-2.5, -2.5),
            //         blurRadius: 5,
            //         color: AppColors.blurTopColor,
            //         inset: true,
            //       ),
            //       BoxShadow(
            //         offset: Offset(2.5, 2.5),
            //         blurRadius: 5,
            //         color: AppColors.blurBottomColor,
            //         inset: true,
            //       ),
            //     ],
            //   ),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       Text(
            //         ageDetailsViewModel.age.toString(), // 0 se start
            //         style: TextStyle(
            //           color: AppColors.headingColor,
            //           fontSize: context.text(14),
            //           fontWeight: FontWeight.w400,
            //         ),
            //       ),
            //       Column(
            //         children: [
            //           SizedBox(height: context.h(10)),
            //           GestureDetector(
            //             onTap: ageDetailsViewModel.incrementAge,
            //             child: Icon(
            //               Icons.keyboard_arrow_up,
            //               size: context.text(18),
            //             ),
            //           ),
            //           GestureDetector(
            //             onTap: ageDetailsViewModel.decrementAge,
            //             child: Icon(
            //               Icons.keyboard_arrow_down,
            //               size: context.text(18),
            //             ),
            //           ),
            //         ],
            //       ),
            //     ],
            //   ),
            // ),
            SizedBox(height: context.h(241)),

            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     CustomButton(
            //       isEnabled: false,
            //       // onTap: () =>
            //       // Navigator.pushNamed(context, RoutesName.OnBoardScreen),
            //       text: 'Back',
            //       color: AppColors.white,
            //       colorText: AppColors.blackColor,
            //       padding: context.padSym(v: 18, h: 59),
            //     ),
            //     CustomButton(
            //       boxShadows: [
            //         BoxShadow(
            //           color: AppColors.buttonColor.withOpacity(0.3),

            //           offset: const Offset(5, 5),
            //           blurRadius: 20,
            //           inset: false,
            //         ),
            //         BoxShadow(
            //           color: AppColors.buttonColor.withOpacity(0.1),
            //           offset: const Offset(-5, -5),
            //           blurRadius: 20,
            //           inset: false,
            //         ),
            //       ],
            //       isEnabled: false,
            //       colorText: AppColors.white,

            //       // onTap: () =>
            //       //     Navigator.pushNamed(context, RoutesName.OnBoardScreen),
            //       text: 'Next',
            //       color: AppColors.pimaryColor,
            //       padding: context.padSym(v: 18, h: 59),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}
