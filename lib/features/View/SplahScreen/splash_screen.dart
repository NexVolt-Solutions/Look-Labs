import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:looklabs/Core/Constants/app_assets.dart';
import 'package:looklabs/Core/Constants/app_text.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Features/ViewModel/splash_view_model.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final SplashViewModel splashScreenViewModel = SplashViewModel();

  @override
  void initState() {
    super.initState();
    splashScreenViewModel.goTo(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pimaryColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: SizedBox(
              height: context.sh(120),
              width: context.sw(120),
              child: SvgPicture.asset(AppAssets.splashIcon, fit: BoxFit.fill),
            ),
          ),
          SizedBox(height: context.sh(12)),
          Center(
            child: Text(
              AppText.appName,
              style: TextStyle(
                color: AppColors.white,
                fontSize: context.sp(24),
                fontFamily: 'Raleway',
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
