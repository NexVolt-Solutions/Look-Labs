// // import 'package:looklabs/Core/Constants/Widget/app_bar_container.dart';
// // import 'package:looklabs/Core/Constants/Widget/custom_check_box.dart';
// // import 'package:looklabs/Core/Constants/Widget/custom_button.dart';
// // import 'package:looklabs/Core/Constants/Widget/custom_drop_down_field.dart';
// // import 'package:looklabs/Core/Constants/Widget/neu_text_fied.dart';
// // import 'package:looklabs/Core/Constants/Widget/normal_text.dart';
// // import 'package:looklabs/Core/Constants/Widget/plan_container.dart';
// // import 'package:looklabs/Core/Constants/app_colors.dart';
// // import 'package:looklabs/Core/Constants/size_extension.dart';
// // import 'package:looklabs/Core/utils/Routes/routes_name.dart';
// // import 'package:looklabs/ViewModel/profile_view_model.dart';
// // import 'package:provider/provider.dart';
// // import 'package:flutter/material.dart';

// // class ProfileScreen extends StatefulWidget {
// //   const ProfileScreen({super.key});

// //   @override
// //   State<ProfileScreen> createState() => _ProfileScreenState();
// // }

// // class _ProfileScreenState extends State<ProfileScreen> {
// //   final ProfileViewModel profileScreen = ProfileViewModel();

// //   @override
// //   void initState() {
// //     // TODO: implement initState
// //     super.initState();
// //     profileScreen.questionWidgets;
// //   }

// //   void _nextQuestion() {
// //     setState(() {
// //       if (profileScreen.currentStep <
// //           profileScreen.questionWidgets.length - 1) {
// //         profileScreen.currentStep++;
// //       } else {
// //         // Restart cycle if needed
// //         profileScreen.currentStep = 0;
// //       }
// //     });
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final profileViewModel = Provider.of<ProfileViewModel>(context);
// //     return Scaffold(
// //       backgroundColor: AppColors.backGroundColor,
// //       bottomNavigationBar: Padding(
// //         padding: context.padSym(h: 20, v: 20),
// //         child: CustomButton(
// //           isEnabled: true,
// //           onTap: () => _nextQuestion,
// //           text: 'Next',
// //           color: AppColors.buttonColor,
// //           padding: context.padSym(h: 145, v: 17),
// //         ),
// //       ),
// //       body: SafeArea(
// //         child: ListView(
// //           padding: context.padSym(h: 20),
// //           clipBehavior: Clip.hardEdge,
// //           children: [
// //             profileViewModel.questionWidgets[profileViewModel.currentStep],
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:looklabs/Core/Constants/app_colors.dart';
// import 'package:looklabs/View/ProfileFlow/question_page.dart';
// import 'package:looklabs/ViewModel/profile_view_model.dart';
// import 'package:provider/provider.dart';

// class ProfileSetupScreen extends StatelessWidget {
//   const ProfileSetupScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (_) => ProfileViewModel(),
//       child: Consumer<ProfileViewModel>(
//         builder: (context, vm, _) {
//           return Scaffold(
//             body: PageView.builder(
//               controller: vm.pageController,
//               physics: const NeverScrollableScrollPhysics(),
//               itemCount: vm.steps.length,
//               itemBuilder: (context, index) {
//                 return QuestionPage(
//                   questions: vm.steps[index],
//                   stepIndex: index,
//                 );
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }
// }


// // Scaffold(
// //       backgroundColor: AppColors.backGroundColor,
// //       bottomNavigationBar: Padding(
// //         padding: context.padSym(h: 20, v: 20),
// //         child: CustomButton(
// //           isEnabled: true,
// //           onTap: () => _nextQuestion(profileViewModel),
// //           text:
// //               profileViewModel.currentStep ==
// //                   profileViewModel.questionWidgets.length - 1
// //               ? 'Finish'
// //               : 'Next',
// //           color: AppColors.buttonColor,
// //           padding: context.padSym(h: 145, v: 17),
// //         ),
// //       ),
// //       body: SafeArea(
// //         child: profileViewModel.questionWidgets[profileViewModel.currentStep],
// //       ),
// //     );




// //profile screen
//   //  AppBarContainer(title: 'Profile Setup'),
//   //           SizedBox(height: context.h(20)),
//   //           NeuTextField(
//   //             label: 'What is your name?',
//   //             obscure: false,
//   //             validatorType: 'name',
//   //             hintText: 'Enter Name',
//   //             keyboard: TextInputType.name,
//   //           ),
//   //           SizedBox(height: context.h(18)),
//   //           CustomDropdownField(
//   //             label: "What is your age?",
//   //             hintText: "Select Age",
//   //             items: List.generate(100, (i) => "${i + 1} years"),
//   //             onSelected: (value) {
//   //               print("Selected Age: $value");
//   //             },
//   //           ),
//   //           SizedBox(height: context.h(18)),
//   //           CustomDropdownField(
//   //             label: "What is your Weight (lb)?",
//   //             hintText: "Select Weight",
//   //             items: List.generate(301, (i) => "${i + 50} lb"),
//   //             onSelected: (value) {
//   //               print("Selected Weight: $value");
//   //             },
//   //           ),
//   //           SizedBox(height: context.h(18)),
//   //           CustomDropdownField(
//   //             label: "What is your Height (cm)?",
//   //             hintText: "Select Height",
//   //             items: List.generate(121, (i) => "${i + 100} cm"),
//   //             onSelected: (value) {
//   //               print("Selected Height: $value");
//   //             },
//   //           ),
//   //           SizedBox(height: context.h(18)),
//   //           NormalText(
//   //             crossAxisAlignment: CrossAxisAlignment.start,
//   //             titleText: 'Select gender',
//   //             titleSize: context.text(14),
//   //             titleWeight: FontWeight.w600,
//   //             titleColor: AppColors.headingColor,
//   //           ),
//   //           SizedBox(height: context.h(18)),
//   //           ...List.generate(profileViewModel.genderName.length, (index) {
//   //             final isSelected = profileViewModel.isPlanSelected(index);
//   //             final plan = profileViewModel.genderName[index];
//   //             return PlanContainer(
//   //               height: context.h(46),
//   //               isSelected: isSelected,
//   //               padding: context.padSym(h: 22, v: 12),
//   //               onTap: () => profileViewModel.selectPlan(index),
//   //               child: Text(
//   //                 plan,
//   //                 style: TextStyle(
//   //                   color: AppColors.subHeadingColor,
//   //                   fontSize: context.text(14),
//   //                   fontWeight: FontWeight.w400,
//   //                 ),
//   //               ),
//   //             );
//   //           }),





