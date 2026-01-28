import 'package:flutter/material.dart';
import 'package:looklabs/Core/Widget/custom_button.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/View/Home/Widget/Fashion/fashion_question_screen.dart';
import 'package:looklabs/ViewModel/fashion_view_model.dart';
import 'package:provider/provider.dart';

class Fashion extends StatefulWidget {
  const Fashion({super.key});

  @override
  State<Fashion> createState() => _FashionState();
}

class _FashionState extends State<Fashion> {
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<FashionViewModel>(context);
    final isLast = vm.currentStep == vm.fashionQuestions.length - 1;

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
          itemCount: vm.fashionQuestions.length,
          itemBuilder: (_, index) {
            return FashionQuestion(index: index);
          },
        ),
      ),
    );
  }
}
