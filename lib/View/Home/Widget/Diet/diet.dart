import 'package:flutter/material.dart';
import 'package:looklabs/Core/Constants/Widget/custom_button.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/View/Home/Widget/Diet/diet_question_screen.dart';
import 'package:looklabs/ViewModel/diet_view_model.dart';
import 'package:provider/provider.dart';

class DietScreen extends StatefulWidget {
  const DietScreen({super.key});

  @override
  State<DietScreen> createState() => _DietScreenState();
}

class _DietScreenState extends State<DietScreen> {
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<DietViewModel>(context);
    final isLast = vm.currentStep == vm.dietQuestions.length - 1;

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
          itemCount: vm.dietQuestions.length,
          itemBuilder: (_, index) {
            return DietQuestion(index: index);
          },
        ),
      ),
    );
  }
}
