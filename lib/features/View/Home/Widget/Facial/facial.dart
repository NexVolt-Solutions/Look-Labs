import 'package:flutter/material.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/features/Widget/app_bar_container.dart';
import 'package:looklabs/features/Widget/custom_button.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/features/Widget/custom_stepper.dart';
import 'package:looklabs/features/Widget/normal_text.dart';
import 'package:looklabs/Core/Routes/routes_name.dart';
import 'package:looklabs/features/View/Home/Widget/Facial/facial_question_screen.dart';
import 'package:looklabs/features/ViewModel/facial_view_model.dart';
import 'package:provider/provider.dart';

class Facial extends StatefulWidget {
  const Facial({super.key});

  @override
  State<Facial> createState() => _FacialState();
}

class _FacialState extends State<Facial> {
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<FacialViewModel>(context);
    final isLast = vm.currentStep == vm.facialQuestions.length - 1;
    final index = vm.currentStep;
    final data = vm.facialQuestions[index];

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
          text: isLast ? 'Complete' : 'Next',
          color: AppColors.pimaryColor,
          isEnabled: true,
          onTap: () {
            if (isLast) {
              Navigator.pushNamed(context, RoutesName.FacialReviewScansScreen);
            } else {
              vm.next();
            }
          },
        ),
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

            SizedBox(height: context.h(10)),

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
                  'Hydration',
                  'Acne',
                  'Skin',
                  'Sun',
                  'Routine',
                  'Sense',
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
                itemCount: vm.facialQuestions.length,
                itemBuilder: (_, index) {
                  return FacialQuestion(index: index);
                },
              ),
            ),
          ],
        ),
      ),
    );
    // final vm = Provider.of<FacialViewModel>(context);
    // final isLast = vm.currentStep == vm.facialQuestions.length - 1;

    // return Scaffold(
    //   backgroundColor: AppColors.backGroundColor,

    //   bottomNavigationBar: CustomButton(
    //     text: isLast ? 'Complete' : 'Next',
    //     color: AppColors.pimaryColor,
    //     isEnabled: true,
    //     onTap: () {
    //       if (isLast) {
    //         Navigator.pushNamed(context, RoutesName.FacialReviewScansScreen);
    //       } else {
    //         vm.next();
    //       }
    //     },
    //   ),

    //   body: SafeArea(
    //     child: PageView.builder(
    //       controller: vm.pageController,
    //       physics: const NeverScrollableScrollPhysics(),
    //       itemCount: vm.facialQuestions.length,
    //       itemBuilder: (_, index) {
    //         return FacialQuestion(index: index);
    //       },
    //     ),
    //   ),
    // );
  }
}
