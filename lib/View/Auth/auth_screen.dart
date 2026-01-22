import 'package:flutter/material.dart';
import 'package:looklabs/Core/Constants/Widget/app_bar_container.dart';
import 'package:looklabs/Core/Constants/Widget/custom_button.dart';
import 'package:looklabs/Core/Constants/Widget/normal_text.dart';
import 'package:looklabs/Core/Constants/Widget/plan_container.dart';
import 'package:looklabs/Core/Constants/Widget/simple_check_box.dart';
import 'package:looklabs/Core/Constants/app_assets.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Core/utils/Routes/routes_name.dart';
import 'package:looklabs/ViewModel/auth_view_model.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    final authScreenViewMdel = Provider.of<AuthViewModel>(context);
    return Scaffold(
      backgroundColor: AppColors.backGroundColor,
      bottomNavigationBar: CustomButton(
        isEnabled: true,
        onTap: () =>
            Navigator.pushNamed(context, RoutesName.BottomSheetBarScreen),
        text: 'Sign In',
        color: AppColors.buttonColor,
      ),
      body: SafeArea(
        child: ListView(
          clipBehavior: Clip.hardEdge,
          padding: context.padSym(h: 20),
          children: [
            AppBarContainer(title: 'Sign In'),
            SizedBox(height: context.h(265)),
            NormalText(
              crossAxisAlignment: CrossAxisAlignment.center,
              titleText: 'Welcome',
              titleSize: context.text(18),
              titleWeight: FontWeight.w500,
              titleColor: AppColors.subHeadingColor,
              sizeBoxheight: context.h(12),
              subText: 'Your Transformation begins now',
              subSize: context.text(14),
              subWeight: FontWeight.w400,
              subColor: AppColors.notSelectedColor,
            ),
            SizedBox(height: context.h(12)),
            PlanContainer(
              height: context.h(50),
              width: context.w(double.infinity),
              isSelected: false,
              onTap: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(AppAssets.gmailIcon),
                  SizedBox(width: context.w(8)),
                  Text(
                    'Continue with Google ',
                    style: TextStyle(
                      fontSize: context.text(16),
                      fontWeight: FontWeight.w500,
                      color: AppColors.subHeadingColor,
                    ),
                  ),
                ],
              ),
            ),
            PlanContainer(
              height: context.h(50),
              width: context.w(double.infinity),
              isSelected: false,
              onTap: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(AppAssets.appaleIcon),
                  SizedBox(width: context.w(8)),
                  Text(
                    'Continue with Apple ',
                    style: TextStyle(
                      fontSize: context.text(16),
                      fontWeight: FontWeight.w500,
                      color: AppColors.subHeadingColor,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SimpleCheckBox(
                  isSelected: authScreenViewMdel.isSelected,
                  onTap: () {},
                ),
                SizedBox(width: context.w(8)),
                Text(
                  'Subscription activated',
                  style: TextStyle(
                    fontSize: context.text(14),
                    fontWeight: FontWeight.w400,
                    color: AppColors.notSelectedColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
