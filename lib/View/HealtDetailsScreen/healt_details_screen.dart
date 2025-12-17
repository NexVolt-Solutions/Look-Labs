import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:looklabs/Core/Constants/Widget/custom_button.dart';
import 'package:looklabs/Core/Constants/Widget/custom_continer.dart';
import 'package:looklabs/Core/Constants/Widget/normal_text.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Core/utils/Routes/routes_name.dart';
import 'package:looklabs/ViewModel/healt_details_view_model.dart';
import 'package:provider/provider.dart';

class HealtDetailsScreen extends StatefulWidget {
  const HealtDetailsScreen({super.key});

  @override
  State<HealtDetailsScreen> createState() => _HealtDetailsScreenState();
}

class _HealtDetailsScreenState extends State<HealtDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final healtDetailsViewModel = Provider.of<HealtDetailsViewModel>(context);
    return Scaffold(
      backgroundColor: AppColors.backGroundColor,
      body: SafeArea(
        child: Padding(
          padding: context.padSym(h: 20),
          child: ListView(
            clipBehavior: Clip.hardEdge,
            children: [
              SizedBox(height: context.h(32)),
              NormalText(
                crossAxisAlignment: CrossAxisAlignment.center,
                titleText: 'Healt Details',
                titleSize: context.text(20),
                titleWeight: FontWeight.w600,
                titleColor: AppColors.headingColor,
              ),
              SizedBox(height: context.h(24)),
              CustomContiner(
                isEnabled: true,
                onTap: () {
                  healtDetailsViewModel.showSelectionBottomSheet(
                    context: context,
                    title: 'Diet Type',
                    list: healtDetailsViewModel.dietTypButtonName,
                    isDiet: true,
                  );
                },
                title1: 'Diet Type',
                title2: healtDetailsViewModel.selectedDiet,
                title2Color: AppColors.pimaryColor,
              ),

              SizedBox(height: context.h(24)),

              CustomContiner(
                isEnabled: true,
                onTap: () {
                  healtDetailsViewModel.showSelectionBottomSheet(
                    context: context,
                    title: 'Workout Frequency',
                    list: healtDetailsViewModel.workOutFreButtonName,
                    isDiet: false,
                  );
                },
                title1: 'Workout Frequency',
                title2: healtDetailsViewModel.selectedWorkout,
                title2Color: AppColors.pimaryColor,
              ),

              SizedBox(height: context.h(24)),

              // Padding(
              //   padding: context.padSym(h: 20),
              //   child: SizedBox(
              //     height: context.h(400),
              //     child: GridView.builder(
              //       shrinkWrap: true,
              //       physics: const NeverScrollableScrollPhysics(),
              //       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              //         crossAxisCount: 2,
              //         mainAxisSpacing: context.w(16),
              //         crossAxisSpacing: context.w(16),
              //         childAspectRatio: 2.5,
              //       ),
              //       itemCount: 4,
              //       itemBuilder: (context, index) {
              //         final bool isSelected =
              //             selectedIndex == buttonName[index];

              //         return GestureDetector(
              //           onTap: () {
              //             selectIndex(index);

              //             // if (buttonName[index] == 'Custom') {
              //             //   showCustomBottomSheet(context);
              //             // }
              //           },
              //           child: Container(
              //             padding: context.padSym(h: 24, v: 18),
              //             decoration: BoxDecoration(
              //               color: isSelected
              //                   ? AppColors.buttonColor.withOpacity(
              //                       0.11,
              //                     ) // selected bg
              //                   : AppColors.backGroundColor,
              //               borderRadius: BorderRadius.circular(
              //                 context.radius(16),
              //               ),
              //               border: isSelected
              //                   ? Border.all(
              //                       color: const Color(0xFF8B5CF6),
              //                       width: 1.5,
              //                     )
              //                   : null,
              //               boxShadow: isSelected
              //                   ? [
              //                       BoxShadow(
              //                         color: AppColors.buttonColor.withOpacity(
              //                           0.15,
              //                         ),
              //                         offset: const Offset(5, 5),
              //                         blurRadius: 20,
              //                         inset: true,
              //                       ),
              //                       BoxShadow(
              //                         color: AppColors.buttonColor.withOpacity(
              //                           0.15,
              //                         ),
              //                         offset: const Offset(-5, -5),
              //                         blurRadius: 20,
              //                         inset: true,
              //                       ),
              //                     ]
              //                   : [
              //                       BoxShadow(
              //                         color: AppColors.customContainerColorUp
              //                             .withOpacity(0.5),
              //                         offset: const Offset(5, 5),
              //                         blurRadius: 20,
              //                       ),
              //                       BoxShadow(
              //                         color: AppColors.customContinerColorDown,
              //                         offset: const Offset(-5, -5),
              //                         blurRadius: 20,
              //                       ),
              //                     ],
              //             ),
              //             child: Center(
              //               child: Text(
              //                 buttonName[index],
              //                 style: TextStyle(
              //                   fontSize: context.text(14),
              //                   fontWeight: FontWeight.w700,
              //                   color: isSelected
              //                       ? AppColors.headingColor
              //                       : AppColors.seconderyColor,
              //                 ),
              //               ),
              //             ),
              //           ),
              //         );
              //       },
              //     ),
              //   ),
              // ),
              SizedBox(height: context.h(305)),
              CustomButton(
                isEnabled: true,
                onTap: () =>
                    Navigator.pushNamed(context, RoutesName.GaolScreen),
                text: 'Next',
                color: AppColors.buttonColor,
                padding: context.padSym(h: 145, v: 17),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
