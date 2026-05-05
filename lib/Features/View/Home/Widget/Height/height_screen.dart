import 'package:flutter/material.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Features/Widget/app_bar_container.dart';
import 'package:looklabs/Features/Widget/custom_button.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Features/Widget/custom_stepper.dart';
import 'package:looklabs/Features/Widget/normal_text.dart';
import 'package:looklabs/Core/Routes/routes_name.dart';
import 'package:looklabs/Features/View/Home/Widget/Height/height_question_screen.dart';
import 'package:looklabs/Features/ViewModel/height_view_model.dart';
import 'package:provider/provider.dart';

class HeightScreen extends StatefulWidget {
  const HeightScreen({super.key});

  @override
  State<HeightScreen> createState() => _HeightScreenState();
}

class _HeightScreenState extends State<HeightScreen> {
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<HeightViewModel>(context);
    final isLast = vm.currentStep == vm.heightQuestions.length - 1;
    final index = vm.currentStep;
    final data = vm.heightQuestions[index];

    return Scaffold(
      backgroundColor: AppColors.backGroundColor,

      bottomNavigationBar: Padding(
        padding: EdgeInsetsGeometry.only(
          top: context.sh(5),
          left: context.sw(20),
          right: context.sw(20),
          bottom: context.sh(30),
        ),
        child: CustomButton(
          text: isLast ? 'Start Analysis' : 'Next',
          color: AppColors.pimaryColor,
          isEnabled: true,
          onTap: () {
            if (isLast) {
              Navigator.pushNamed(context, RoutesName.HeightResultScreen);
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
                padding: context.paddingSymmetricR(horizontal: 20),
                child: AppBarContainer(title: data['title'], onTap: vm.back),
              ),

            SizedBox(height: context.sh(10)),

            /// 🔹 Title
            if (index == 0)
              NormalText(
                crossAxisAlignment: CrossAxisAlignment.center,
                titleText: data['title'],
                titleSize: context.sp(20),
                titleWeight: FontWeight.w600,
                titleColor: AppColors.headingColor,
              ),

            SizedBox(height: context.sh(20)),

            /// 🔹 Stepper
            Padding(
              padding: context.paddingSymmetricR(horizontal: 20),
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

            SizedBox(height: context.sh(20)),

            /// 🔹 PageView
            Expanded(
              child: PageView.builder(
                controller: vm.pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: vm.setStep,
                itemCount: vm.heightQuestions.length,
                itemBuilder: (_, index) {
                  return HeightQuestion(index: index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
