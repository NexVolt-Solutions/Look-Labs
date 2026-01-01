// import 'package:flutter/material.dart';
// import 'package:looklabs/Core/Constants/Widget/custom_button.dart';
// import 'package:looklabs/Core/Constants/Widget/custom_drop_down_field.dart';
// import 'package:looklabs/Core/Constants/Widget/neu_text_fied.dart';
// import 'package:looklabs/Core/Constants/Widget/normal_text.dart';
// import 'package:looklabs/Core/Constants/Widget/plan_container.dart';
// import 'package:looklabs/Core/Constants/app_colors.dart';
// import 'package:looklabs/Core/Constants/size_extension.dart';
// import 'package:looklabs/ViewModel/profile_view_model.dart';
// import 'package:provider/provider.dart';

// class QuestionScreen extends StatelessWidget {
//   const QuestionScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final questionViewModel = Provider.of<ProfileViewModel>(context);
//     return Scaffold(
//       bottomNavigationBar: Padding(
//         padding: context.padSym(h: 20, v: 20),
//         child: CustomButton(
//           isEnabled: false,
//           // onTap: () => vm.nextPage(totalPages),
//           text: 'Next',
//           color: AppColors.buttonColor,
//           padding: context.padSym(h: 145, v: 17),
//         ),
//       ),
//       backgroundColor: AppColors.backGroundColor,
//       body: SafeArea(
//         child: ListView(
//           padding: context.padSym(h: 20),
//           children: [
//             NormalText(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               titleText: 'Profile Setup',
//               titleSize: context.text(20),
//               titleWeight: FontWeight.w600,
//               titleColor: AppColors.headingColor,
//             ),
//             SizedBox(height: context.h(20)),
//             NeuTextField(
//               label: 'What is your name?',
//               obscure: false,
//               validatorType: 'name',
//               hintText: 'Enter Name',
//               keyboard: TextInputType.name,
//             ),
//             SizedBox(height: context.h(18)),
//             CustomDropdownField(
//               label: "What is your age?",
//               hintText: "Select Age",
//               items: List.generate(100, (i) => "${i + 1} years"),
//               onSelected: (value) {
//                 print("Selected Age: $value");
//               },
//             ),
//             SizedBox(height: context.h(18)),
//             CustomDropdownField(
//               label: "What is your Weight (lb)?",
//               hintText: "Select Weight",
//               items: List.generate(301, (i) => "${i + 50} lb"),
//               onSelected: (value) {
//                 print("Selected Weight: $value");
//               },
//             ),
//             SizedBox(height: context.h(18)),
//             CustomDropdownField(
//               label: "What is your Height (cm)?",
//               hintText: "Select Height",
//               items: List.generate(121, (i) => "${i + 100} cm"),
//               onSelected: (value) {
//                 print("Selected Height: $value");
//               },
//             ),
//             SizedBox(height: context.h(18)),
//             NormalText(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               titleText: 'What is your gender?',
//               titleSize: context.text(14),
//               titleWeight: FontWeight.w600,
//               titleColor: AppColors.subHeadingColor,
//             ),
//             SizedBox(height: context.h(18)),
//             ...List.generate(questionViewModel.genderName.length, (index) {
//               final isSelected = questionViewModel.isPlanSelected(index);
//               final plan = questionViewModel.genderName[index];
//               return PlanContainer(
//                 isSelected: isSelected,
//                 padding: context.padSym(h: 22, v: 14),
//                 onTap: () => questionViewModel.selectPlan(index),
//                 child: Text(
//                   plan,
//                   style: TextStyle(
//                     color: AppColors.subHeadingColor,
//                     fontSize: context.text(14),
//                     fontWeight: FontWeight.w400,
//                   ),
//                 ),
//               );
//             }),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:looklabs/Core/Constants/Widget/custom_button.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/View/QuestionScreen/question_page.dart';
import 'package:looklabs/ViewModel/profile_view_model.dart';
import 'package:provider/provider.dart';

class QuestionScreen extends StatelessWidget {
  const QuestionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ProfileViewModel>(context);

    return Scaffold(
      backgroundColor: AppColors.backGroundColor,

      bottomNavigationBar: Padding(
        padding: context.padSym(h: 20, v: 20),
        child: CustomButton(
          text: vm.currentStep == 4 ? 'Complete' : 'Next',
          color: AppColors.buttonColor,
          isEnabled: true,
          onTap: vm.next,
          padding: context.padSym(h: 145, v: 17),
        ),
      ),

      body: SafeArea(
        child: PageView.builder(
          controller: vm.pageController,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: vm.questionData.length,
          itemBuilder: (_, index) => QuestionPage(index: index),
        ),
      ),
    );
  }
}
