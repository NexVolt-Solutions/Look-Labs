import 'package:flutter/material.dart';
import 'package:looklabs/Core/Constants/Widget/app_bar_container.dart';
import 'package:looklabs/Core/Constants/Widget/custom_button.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import '../../Core/utils/Routes/routes_name.dart';

class OnBoardScreen extends StatefulWidget {
  const OnBoardScreen({super.key});

  @override
  State<OnBoardScreen> createState() => _OnBoardScreenState();
}

class _OnBoardScreenState extends State<OnBoardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backGroundColor,
      body: SafeArea(
        child: ListView(
          padding: context.padSym(h: 20),
          clipBehavior: Clip.hardEdge,
          children: [
            SizedBox(height: context.h(7.11)),
            AppBarContainer(title: 'OnBoard'),
            SizedBox(height: context.h(44.89)),
            Container(
              height: context.h(594),
              width: context.w(335),
              decoration: BoxDecoration(
                color: AppColors.blurBottomColor,
                borderRadius: BorderRadius.circular(context.radius(12)),
                shape: BoxShape.rectangle,
              ),
            ),
            SizedBox(height: context.h(22)),
            CustomButton(
              isEnabled: true,
              onTap: () => Navigator.pushNamed(
                context,
                RoutesName.SubscriptionPlanScreen,
              ),
              text: 'Next',
              color: AppColors.buttonColor,
              padding: context.padSym(v: 17),
            ),
          ],
        ),
      ),
    );
  }
}
