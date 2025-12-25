import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:looklabs/Core/Constants/Widget/app_bar_container.dart';
import 'package:looklabs/Core/Constants/Widget/custom_container.dart';
import 'package:looklabs/Core/Constants/Widget/normal_text.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/apptext.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/ViewModel/age_details_view_model.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';

class AgeDetailsScreen extends StatefulWidget {
  const AgeDetailsScreen({super.key});

  @override
  State<AgeDetailsScreen> createState() => _AgeDetailsScreenState();
}

class _AgeDetailsScreenState extends State<AgeDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    String selectedEnergy = 'Energetic';
    String selectedSleep = '6-7 hours';
    String selectedWater = '1.5 - 2.5 liters';
    final ageDetailsViewModel = Provider.of<AgeDetailsViewModel>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () {},
                    ),
                  ),
                  const Expanded(
                    child: Text(
                      'Daily Lifestyle',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),

            // Progress Indicator
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 16.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildProgressStep('Gender', true, true),
                  _buildProgressLine(true),
                  _buildProgressStep('Hair', true, false),
                  _buildProgressLine(true),
                  _buildProgressStep('Age', true, false),
                  _buildProgressLine(false),
                  _buildProgressStep('Scalp', false, false),
                  _buildProgressLine(false),
                  _buildProgressStep('Concern', false, false),
                  _buildProgressLine(false),
                  _buildProgressStep('Routine', false, false),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Question 1
                    const Text(
                      'How do you usually feel during day?',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Your energy level helps us adjust routines',
                      style: TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    _buildOption(
                      'Low / Tired',
                      selectedEnergy == 'Low / Tired',
                      () => setState(() => selectedEnergy = 'Low / Tired'),
                    ),
                    const SizedBox(height: 12),
                    _buildOption(
                      'Average',
                      selectedEnergy == 'Average',
                      () => setState(() => selectedEnergy = 'Average'),
                    ),
                    const SizedBox(height: 12),
                    _buildOption(
                      'Energetic',
                      selectedEnergy == 'Energetic',
                      () => setState(() => selectedEnergy = 'Energetic'),
                    ),

                    const SizedBox(height: 32),

                    // Question 2
                    const Text(
                      'How many hours do you usually sleep?',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Sleep impacts skin, hair, fitness & focus',
                      style: TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    _buildOption(
                      'Less than 6 hours',
                      selectedSleep == 'Less than 6 hours',
                      () => setState(() => selectedSleep = 'Less than 6 hours'),
                    ),
                    const SizedBox(height: 12),
                    _buildOption(
                      '6-7 hours',
                      selectedSleep == '6-7 hours',
                      () => setState(() => selectedSleep = '6-7 hours'),
                    ),
                    const SizedBox(height: 12),
                    _buildOption(
                      '7-8 hours',
                      selectedSleep == '7-8 hours',
                      () => setState(() => selectedSleep = '7-8 hours'),
                    ),

                    const SizedBox(height: 32),

                    // Question 3
                    const Text(
                      'How much water do you drink daily?',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Hydration is key for glow & recovery',
                      style: TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    _buildOption(
                      'Less than 1 liter',
                      selectedWater == 'Less than 1 liter',
                      () => setState(() => selectedWater = 'Less than 1 liter'),
                    ),
                    const SizedBox(height: 12),
                    _buildOption(
                      '1.5 - 2.5 liters',
                      selectedWater == '1.5 - 2.5 liters',
                      () => setState(() => selectedWater = '1.5 - 2.5 liters'),
                    ),
                    const SizedBox(height: 12),
                    _buildOption(
                      'More than 2.5 liters',
                      selectedWater == 'More than 2.5 liters',
                      () => setState(
                        () => selectedWater = 'More than 2.5 liters',
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // Bottom Buttons
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: Colors.grey),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Back',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7C3AED),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Next',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    // Scaffold(
    //   backgroundColor: AppColors.backGroundColor,
    //   body: SafeArea(
    //     child: ListView(
    //       clipBehavior: Clip.hardEdge,
    //       padding: context.padSym(h: 20),
    //       children: [
    //         AppBarContainer(title: AppText.buildYourProfile),
    //         SizedBox(height: context.h(23)),
    //         NormalText(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           titleText: ageDetailsViewModel.title,
    //           titleSize: context.text(16),
    //           titleWeight: FontWeight.w600,
    //           titleColor: AppColors.headingColor,
    //           subText: ageDetailsViewModel.subTitle,
    //           subSize: context.text(14),
    //           subWeight: FontWeight.w600,
    //           subColor: AppColors.notSelectedColor,
    //         ),

    //         // NormalText(
    //         //   crossAxisAlignment: CrossAxisAlignment.start,
    //         //   titleText: 'What is your current age?',
    //         //   titleSize: context.text(16),
    //         //   titleWeight: FontWeight.w600,
    //         //   titleColor: AppColors.headingColor,
    //         //   subText: 'This helps personalize your routine',
    //         //   subSize: context.text(14),
    //         //   subWeight: FontWeight.w600,
    //         //   subColor: AppColors.notSelectedColor,
    //         // ),
    //         SizedBox(height: context.h(18)),
    //         ...List.generate(ageDetailsViewModel.currentList.length, (index) {
    //           final isSelected =
    //               ageDetailsViewModel.selectedValue ==
    //               ageDetailsViewModel.currentList[index];

    //           return CustomContainer(
    //             onTap: () => ageDetailsViewModel.selectItem(index),
    //             radius: context.radius(10),
    //             padding: context.padSym(h: 22, v: 14),
    //             margin: context.padSym(v: 12),
    //             color: isSelected
    //                 ? AppColors.buttonColor.withOpacity(0.11)
    //                 : AppColors.backGroundColor,
    //             border: isSelected
    //                 ? Border.all(color: AppColors.pimaryColor, width: 1.5)
    //                 : null,
    //             child: Text(ageDetailsViewModel.currentList[index]),
    //           );
    //         }),
    //         SizedBox(height: context.h(18)),
    //         NormalText(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           titleText: 'Enter Age',
    //           titleSize: context.text(14),
    //           titleWeight: FontWeight.w600,
    //           titleColor: AppColors.headingColor,
    //         ),
    //         SizedBox(height: context.h(12)),
    //         Container(
    //           height: context.h(54),
    //           padding: context.padSym(h: 17),
    //           decoration: BoxDecoration(
    //             color: AppColors.backGroundColor,
    //             borderRadius: BorderRadius.circular(context.radius(16)),
    //             border: Border.all(
    //               color: Colors.white.withOpacity(0.4),
    //               width: context.w(0.5),
    //             ),
    //             boxShadow: const [
    //               BoxShadow(
    //                 offset: Offset(-2.5, -2.5),
    //                 blurRadius: 5,
    //                 color: AppColors.blurTopColor,
    //                 inset: true,
    //               ),
    //               BoxShadow(
    //                 offset: Offset(2.5, 2.5),
    //                 blurRadius: 5,
    //                 color: AppColors.blurBottomColor,
    //                 inset: true,
    //               ),
    //             ],
    //           ),
    //           child: DropdownButtonHideUnderline(
    //             child: DropdownButton<int>(
    //               value: ageDetailsViewModel.selectedAge,
    //               isExpanded: true,
    //               icon: Icon(
    //                 Icons.keyboard_arrow_down,
    //                 color: AppColors.headingColor,
    //               ),
    //               style: TextStyle(
    //                 color: AppColors.headingColor,
    //                 fontSize: context.text(14),
    //                 fontWeight: FontWeight.w400,
    //               ),
    //               dropdownColor: AppColors.backGroundColor,
    //               items: ageDetailsViewModel.ageList
    //                   .map(
    //                     (age) => DropdownMenuItem<int>(
    //                       value: age,
    //                       child: Text(age.toString()),
    //                     ),
    //                   )
    //                   .toList(),
    //               onChanged: (value) {
    //                 if (value != null) {
    //                   ageDetailsViewModel.changeAge(value);
    //                 }
    //               },
    //             ),
    //           ),
    //         ),
    //         SizedBox(height: context.h(20)),

    //         // Row(
    //         //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //         //   children: [
    //         //     CustomButton(
    //         //       isEnabled: false,
    //         //       // onTap: () =>
    //         //       // Navigator.pushNamed(context, RoutesName.OnBoardScreen),
    //         //       text: 'Back',
    //         //       color: AppColors.white,
    //         //       colorText: AppColors.blackColor,
    //         //       padding: context.padSym(v: 18, h: 59),
    //         //     ),
    //         //     CustomButton(
    //         //       boxShadows: [
    //         //         BoxShadow(
    //         //           color: AppColors.buttonColor.withOpacity(0.3),

    //         //           offset: const Offset(5, 5),
    //         //           blurRadius: 20,
    //         //           inset: false,
    //         //         ),
    //         //         BoxShadow(
    //         //           color: AppColors.buttonColor.withOpacity(0.1),
    //         //           offset: const Offset(-5, -5),
    //         //           blurRadius: 20,
    //         //           inset: false,
    //         //         ),
    //         //       ],
    //         //       isEnabled: false,
    //         //       colorText: AppColors.white,

    //         //       // onTap: () =>
    //         //       //     Navigator.pushNamed(context, RoutesName.OnBoardScreen),
    //         //       text: 'Next',
    //         //       color: AppColors.pimaryColor,
    //         //       padding: context.padSym(v: 18, h: 59),
    //         //     ),
    //         //   ],
    //         // ),
    //         Column(
    //           children: [
    //             Container(
    //               height: context.h(132),
    //               width: context.w(158),
    //               decoration: BoxDecoration(
    //                 borderRadius: BorderRadius.circular(context.radius(10)),
    //                 color: AppColors.backGroundColor,
    //                 boxShadow: [
    //                   BoxShadow(
    //                     color: AppColors.customContainerColorUp.withOpacity(
    //                       0.4,
    //                     ),
    //                     offset: const Offset(5, 5),
    //                     blurRadius: 5,
    //                     inset: false,
    //                   ),
    //                   BoxShadow(
    //                     color: AppColors.customContinerColorDown.withOpacity(
    //                       0.4,
    //                     ),
    //                     offset: const Offset(-5, -5),
    //                     blurRadius: 5,
    //                     inset: false,
    //                   ),
    //                 ],
    //               ),

    //               child: Column(
    //                 mainAxisAlignment: MainAxisAlignment.center,
    //                 mainAxisSize: MainAxisSize.max,
    //                 children: [],
    //               ),
    //             ),
    //           ],
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}

// CustomContainer(
//   width: context.w(264),
//   height: context.h(10),
//   radius: context.radius(10),
//   padding: context.padSym(h: 50.05, v: 8.0),
//   color: AppColors.backGroundColor,
//   child: ClipRRect(
//     borderRadius: BorderRadius.circular(
//       context.radius(10),
//     ),
//     child: LinearPercentIndicator(
//       padding: EdgeInsets.zero,
//       width: context.w(264),
//       lineHeight: context.h(10),
//       percent: 0.5,
//       backgroundColor: AppColors.backGroundColor,
//       progressColor: AppColors.pimaryColor,
//       barRadius: Radius.circular(context.radius(10)),
//     ),
//   ),
// ),
// CustomContainer(
//   width: context.w(264),
//   height: context.h(10),
//   radius: context.radius(10),
//   padding: context.padSym(h: 50.05, v: 8.0),
//   color: AppColors.backGroundColor,
//   child: ClipRRect(
//     borderRadius: BorderRadius.circular(
//       context.radius(10),
//     ),
//     child: LinearPercentIndicator(
//       padding: EdgeInsets.zero,
//       width: context.w(264),
//       lineHeight: context.h(10),
//       percent: 0.5,
//       backgroundColor: AppColors.backGroundColor,
//       progressColor: AppColors.pimaryColor,
//       barRadius: Radius.circular(context.radius(10)),
//     ),
//   ),
// ),
Widget _buildProgressStep(String label, bool isCompleted, bool isFirst) {
  return Column(
    children: [
      Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isCompleted ? const Color(0xFF7C3AED) : Colors.white,
          border: Border.all(
            color: isCompleted ? const Color(0xFF7C3AED) : Colors.grey.shade300,
            width: 2,
          ),
        ),
        child: isCompleted
            ? const Icon(Icons.check, color: Colors.white, size: 14)
            : null,
      ),
      const SizedBox(height: 4),
      Text(
        label,
        style: TextStyle(
          fontSize: 10,
          color: isCompleted ? Colors.black : Colors.grey,
        ),
      ),
    ],
  );
}

Widget _buildProgressLine(bool isCompleted) {
  return Expanded(
    child: Container(
      height: 2,
      margin: const EdgeInsets.only(bottom: 18),
      color: isCompleted ? const Color(0xFF7C3AED) : Colors.grey.shade300,
    ),
  );
}

Widget _buildOption(String text, bool isSelected, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFEDE9FE) : Colors.white,
        border: Border.all(
          color: isSelected ? const Color(0xFF7C3AED) : Colors.grey.shade300,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 15,
          color: isSelected ? const Color(0xFF7C3AED) : Colors.black87,
          fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
        ),
      ),
    ),
  );
}
