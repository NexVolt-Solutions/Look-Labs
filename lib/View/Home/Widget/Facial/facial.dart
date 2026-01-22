import 'package:flutter/material.dart';
import 'package:looklabs/Core/Constants/Widget/custom_button.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/View/Home/Widget/Facial/facial_question_screen.dart';
import 'package:looklabs/ViewModel/facial_view_model.dart';
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

    return Scaffold(
      backgroundColor: AppColors.backGroundColor,

      bottomNavigationBar: CustomButton(
        text: isLast ? 'Complete' : 'Next',
        color: AppColors.pimaryColor,
        isEnabled: true,
        onTap: () {
          if (isLast) {
            // Navigate to result screen
          } else {
            vm.next();
          }
        },
      ),

      body: SafeArea(
        child: PageView.builder(
          controller: vm.pageController,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: vm.facialQuestions.length,
          itemBuilder: (_, index) {
            return FacialQuestion(index: index);
          },
        ),
      ),
    );
  }
}
