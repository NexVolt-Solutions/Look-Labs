import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:looklabs/Core/Constants/app_text.dart';
import 'package:looklabs/Features/Widget/app_bar_container.dart';
import 'package:looklabs/Features/Widget/custom_button.dart';
import 'package:looklabs/Features/Widget/normal_text.dart';
import 'package:looklabs/Features/Widget/plan_container.dart';
import 'package:looklabs/Features/Widget/simple_check_box.dart';
import 'package:looklabs/Core/Constants/app_assets.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Core/Routes/routes_name.dart';
import 'package:looklabs/Features/ViewModel/auth_view_model.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  Future<void> _handleSignIn(AuthViewModel vm) async {
    vm.clearError();
    try {
      final success = await vm.signInWithGoogle();
      if (!mounted) return;
      if (success) {
        debugPrint('[AuthScreen] Sign-in success, navigating to dashboard');
        Navigator.pushNamedAndRemoveUntil(
          context,
          RoutesName.BottomSheetBarScreen,
          (route) => false,
        );
      } else if (vm.errorMessage != null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(vm.errorMessage!)),
          );
        }
      }
    } catch (e, st) {
      debugPrint('[AuthScreen] _handleSignIn error: $e');
      debugPrint('[AuthScreen] $st');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Something went wrong: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authVm = Provider.of<AuthViewModel>(context);
    return Scaffold(
      backgroundColor: AppColors.backGroundColor,
      bottomNavigationBar: Padding(
        padding: context.padSym(h: 20, v: 30),
        child: CustomButton(
          isEnabled: !authVm.isLoading,
          onTap: () => _handleSignIn(authVm),
          text: AppText.signIn,
          color: AppColors.buttonColor,
        ),
      ),
      body: Stack(
        children: [
          SafeArea(
            child: ListView(
              clipBehavior: Clip.hardEdge,
              padding: context.padSym(h: 20),
              children: [
                AppBarContainer(title: AppText.signIn),
                SizedBox(height: context.h(224)),
                NormalText(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  titleText: AppText.welcome,
                  titleSize: context.text(18),
                  titleWeight: FontWeight.w500,
                  titleColor: AppColors.subHeadingColor,
                  sizeBoxheight: context.h(12),
                  subText: AppText.yourTransformationBegins,
                  subSize: context.text(14),
                  subWeight: FontWeight.w400,
                  subColor: AppColors.notSelectedColor,
                ),
                SizedBox(height: context.h(2)),
                PlanContainer(
                  padding: context.padSym(v: 12, h: 65),
                  margin: context.padSym(v: 10),
                  isSelected: false,
                  onTap: authVm.isLoading ? null : () => _handleSignIn(authVm),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(AppAssets.gmailIcon),
                      SizedBox(width: context.w(8)),
                      Text(
                        AppText.continueWithGoogle,
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
                  onTap: null,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(AppAssets.appaleIcon),
                      SizedBox(width: context.w(8)),
                      Text(
                        AppText.continueWithApple,
                        style: TextStyle(
                          fontSize: context.text(16),
                          fontWeight: FontWeight.w500,
                          color: AppColors.subHeadingColor,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: context.h(12)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SimpleCheckBox(
                      isSelected: authVm.isSelected,
                      onTap: authVm.toggleSubscriptionSelected,
                    ),
                    SizedBox(width: context.w(8)),
                    Text(
                      AppText.subscriptionActivated,
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
          if (authVm.isLoading)
            Container(
              color: Colors.black26,
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}
