import 'package:flutter/material.dart';
import 'package:looklabs/Core/Constants/app_text.dart';
import 'package:looklabs/Features/Widget/app_bar_container.dart';
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
  @override
  void initState() {
    super.initState();
    // Clear focus so the system doesn't request keyboard (avoids "view is not EditText" IME churn).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusManager.instance.primaryFocus?.unfocus();
    });
  }

  Future<void> _handleSignIn(AuthViewModel vm) async {
    vm.clearError();
    try {
      final success = await vm.signInWithGoogle();
      if (!mounted) return;
      if (success) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          RoutesName.BottomSheetBarScreen,
          (route) => false,
        );
      } else if (vm.errorMessage != null) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(vm.errorMessage!)));
        }
      }
    } catch (e, _) {
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

      body: Stack(
        children: [
          SafeArea(
            child: ListView(
              clipBehavior: Clip.hardEdge,
              padding: context.paddingSymmetricR(horizontal: 20),
              children: [
                AppBarContainer(title: AppText.signIn),
                SizedBox(height: context.sh(224)),
                NormalText(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  titleText: AppText.welcome,
                  titleSize: context.sp(18),
                  titleWeight: FontWeight.w500,
                  titleColor: AppColors.subHeadingColor,
                  sizeBoxheight: context.sh(12),
                  subText: AppText.yourTransformationBegins,
                  subSize: context.sp(14),
                  subWeight: FontWeight.w400,
                  subColor: AppColors.notSelectedColor,
                ),
                SizedBox(height: context.sh(2)),
                PlanContainer(
                  padding: context.paddingSymmetricR(
                    vertical: 12,
                    horizontal: 65,
                  ),
                  margin: context.paddingSymmetricR(vertical: 10),
                  isSelected: false,
                  onTap: authVm.isLoading ? null : () => _handleSignIn(authVm),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(AppAssets.gmailIcon),
                      SizedBox(width: context.sw(8)),
                      Text(
                        AppText.continueWithGoogle,
                        style: TextStyle(
                          fontSize: context.sp(16),
                          fontWeight: FontWeight.w500,
                          color: AppColors.subHeadingColor,
                        ),
                      ),
                    ],
                  ),
                ),
                PlanContainer(
                  height: context.sh(50),
                  width: context.sw(double.infinity),
                  isSelected: false,
                  onTap: null,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(AppAssets.appaleIcon),
                      SizedBox(width: context.sw(8)),
                      Text(
                        AppText.continueWithApple,
                        style: TextStyle(
                          fontSize: context.sp(16),
                          fontWeight: FontWeight.w500,
                          color: AppColors.subHeadingColor,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: context.sh(12)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SimpleCheckBox(
                      isSelected: authVm.isSelected,
                      onTap: authVm.toggleSubscriptionSelected,
                    ),
                    SizedBox(width: context.sw(8)),
                    Text(
                      AppText.subscriptionActivated,
                      style: TextStyle(
                        fontSize: context.sp(14),
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
