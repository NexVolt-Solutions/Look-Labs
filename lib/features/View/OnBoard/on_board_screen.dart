import 'package:flutter/material.dart';
import 'package:looklabs/Features/Widget/app_bar_container.dart';
import 'package:looklabs/Features/Widget/custom_button.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/apptext.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import '../../../Core/Routes/routes_name.dart';

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
      bottomNavigationBar: Padding(
        padding: context.padSym(h: 20, v: 30),
        child: CustomButton(
          isEnabled: true,
          onTap: () =>
              Navigator.pushNamed(context, RoutesName.SubscriptionPlanScreen),
          text: AppText.next,
          color: AppColors.buttonColor,
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: context.padSym(h: 24),
          clipBehavior: Clip.hardEdge,
          children: [
            SizedBox(height: context.h(7.11)),
            AppBarContainer(
              title: AppText.onBoard,
              onTap: () => Navigator.pop(context),
            ),
            SizedBox(height: context.h(20)),
            ClipRRect(
              borderRadius: BorderRadiusGeometry.circular(context.radius(10)),
              child: Container(
                height: context.h(550),
                width: context.w(335),
                decoration: BoxDecoration(
                  color: AppColors.blurBottomColor,
                  borderRadius: BorderRadius.circular(context.radius(12)),
                  shape: BoxShape.rectangle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
