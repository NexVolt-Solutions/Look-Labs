import 'package:flutter/material.dart';
import 'package:looklabs/Core/Constants/Widget/custom_button.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Core/utils/Routes/routes_name.dart';
import 'package:looklabs/View/Home/Widget/SkinCare/skin_care_question_screen.dart';
import 'package:looklabs/ViewModel/skin_care_view_model.dart';
import 'package:provider/provider.dart';

class SkinCare extends StatefulWidget {
  const SkinCare({super.key});

  @override
  State<SkinCare> createState() => _SkinCareState();
}

class _SkinCareState extends State<SkinCare> {
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<SkinCareViewModel>(context);
    final isLast = vm.currentStep == vm.skinCareQuestions.length - 1;

    return Scaffold(
      backgroundColor: AppColors.backGroundColor,

      bottomNavigationBar: CustomButton(
        text: isLast ? 'Start Analysis' : 'Next',
        color: AppColors.pimaryColor,
        isEnabled: true,
        onTap: () {
          if (isLast) {
            Navigator.pushNamed(context, RoutesName.ReviewScansScreen);
          } else {
            vm.next();
          }
        },
        padding: context.padSym(v: 17),
      ),

      body: SafeArea(
        child: PageView.builder(
          controller: vm.pageController,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: vm.skinCareQuestions.length,
          itemBuilder: (_, index) {
            return SkinCareQuestionPage(index: index);
          },
        ),
      ),
    );
  }
}
