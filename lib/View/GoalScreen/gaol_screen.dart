import 'package:flutter/material.dart';
import 'package:looklabs/Core/Constants/Widget/custom_button.dart';
import 'package:looklabs/Core/Constants/Widget/normal_text.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';

class GaolScreen extends StatefulWidget {
  const GaolScreen({super.key});

  @override
  State<GaolScreen> createState() => _GaolScreenState();
}

class _GaolScreenState extends State<GaolScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backGroundColor,
      body: SafeArea(
        child: Padding(
          padding: context.padSym(h: 20),

          child: ListView(
            clipBehavior: Clip.none,
            children: [
              SizedBox(height: context.h(32)),
              NormalText(
                crossAxisAlignment: CrossAxisAlignment.center,
                titleText: 'Choose Goal',
                titleSize: context.text(20),
                titleWeight: FontWeight.w600,
                titleColor: AppColors.headingColor,
              ),
              SizedBox(height: context.h(24)),

              SizedBox(height: context.h(24)),
              CustomButton(
                isEnabled: false,
                text: 'Next',
                color: AppColors.pimaryColor,
                padding: context.padSym(h: 145, v: 17),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
