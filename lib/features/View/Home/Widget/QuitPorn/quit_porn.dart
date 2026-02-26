import 'package:flutter/material.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Features/Widget/app_bar_container.dart';
import 'package:looklabs/Features/Widget/custom_button.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Features/Widget/custom_stepper.dart';
import 'package:looklabs/Features/Widget/normal_text.dart';
import 'package:looklabs/Core/Routes/routes_name.dart';
import 'package:looklabs/Features/View/Home/Widget/QuitPorn/quit_porn_question_screen.dart';
import 'package:looklabs/Features/ViewModel/quit_porn_view_model.dart';
import 'package:provider/provider.dart';

class QuitPorn extends StatefulWidget {
  const QuitPorn({super.key});

  @override
  State<QuitPorn> createState() => _QuitPornState();
}

class _QuitPornState extends State<QuitPorn> {
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<QuitPornViewModel>(context);
    final isLast = vm.currentStep == vm.quitPornQuestions.length - 1;
    final index = vm.currentStep;
    final data = vm.quitPornQuestions[index];

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
          text: isLast ? 'Complete' : 'Next',
          color: AppColors.pimaryColor,
          isEnabled: true,
          onTap: () {
            if (isLast) {
              Navigator.pushNamed(context, RoutesName.RecoveryPathScreen);
            } else {
              vm.next();
            }
          },
        ),
      ),

      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
            Padding(
              padding: context.paddingSymmetricR(horizontal: 20),
              child: NormalText(
                titleText: data['question'],
                titleSize: context.sp(18),
                titleWeight: FontWeight.w600,
                titleColor: AppColors.headingColor,
              ),
            ),

            /// 🔹 PageView
            Expanded(
              child: PageView.builder(
                controller: vm.pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: vm.setStep,
                itemCount: vm.quitPornQuestions.length,
                itemBuilder: (_, index) {
                  return QuitPornQuestion(index: index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
