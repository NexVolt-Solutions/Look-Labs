import 'package:flutter/material.dart';
import 'package:looklabs/Core/Widget/custom_button.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
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

    return Scaffold(
      backgroundColor: AppColors.backGroundColor,

      bottomNavigationBar: CustomButton(
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

      body: SafeArea(
        child: PageView.builder(
          controller: vm.pageController,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: vm.quitPornQuestions.length,
          itemBuilder: (_, index) {
            return QuitPornQuestion(index: index);
          },
        ),
      ),
    );
  }
}
