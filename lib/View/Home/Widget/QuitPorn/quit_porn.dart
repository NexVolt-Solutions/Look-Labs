import 'package:flutter/material.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Core/Widget/app_bar_container.dart';
import 'package:looklabs/Core/Widget/custom_button.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Widget/custom_stepper.dart';
import 'package:looklabs/Core/Widget/normal_text.dart';
import 'package:looklabs/Core/utils/Routes/routes_name.dart';
import 'package:looklabs/View/Home/Widget/QuitPorn/quit_porn_question_screen.dart';
import 'package:looklabs/ViewModel/quit_porn_view_model.dart';
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
            Padding(
              padding: context.padSym(h: 20),
              child: NormalText(
                titleText: data['question'],
                titleSize: context.text(18),
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
