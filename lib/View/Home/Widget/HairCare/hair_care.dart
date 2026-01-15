import 'package:flutter/material.dart';
import 'package:looklabs/Core/Constants/Widget/custom_button.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Core/utils/Routes/routes_name.dart';
import 'package:looklabs/View/Home/Widget/HairCare/hair_care_question_screen.dart';
import 'package:looklabs/ViewModel/hair_care_view_model.dart';
import 'package:provider/provider.dart';

class HairCare extends StatefulWidget {
  const HairCare({super.key});

  @override
  State<HairCare> createState() => _HairCareState();
}

class _HairCareState extends State<HairCare> {
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<HairCareViewModel>(context);
    final isLast = vm.currentStep == vm.hairCareQuestions.length - 1;

    return Scaffold(
      backgroundColor: AppColors.backGroundColor,

      bottomNavigationBar: CustomButton(
        text: isLast ? 'Complete' : 'Next',
        color: AppColors.pimaryColor,
        isEnabled: true,
        onTap: () {
          if (isLast) {
            Navigator.pushNamed(context, RoutesName.HairReviewScansScreen);
          } else {
            vm.next();
          }
        },
        padding: context.padSym(h: 145, v: 17),
      ),

      body: SafeArea(
        child: PageView.builder(
          controller: vm.pageController,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: vm.hairCareQuestions.length,
          itemBuilder: (_, index) {
            return HairCareQuestion(index: index);
          },
        ),
      ),
    );
  }
}
