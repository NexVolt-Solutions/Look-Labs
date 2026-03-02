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
    splashScreenViewModel.addListener(_onViewModelUpdate);
    splashScreenViewModel.goTo(context);
    // Prevent IME from being requested at startup (avoids "view is not EditText" log spam).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusManager.instance.primaryFocus?.unfocus();
    });
  }

  @override
  void dispose() {
    splashScreenViewModel.removeListener(_onViewModelUpdate);
    super.dispose();
  }

  void _onViewModelUpdate() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final error = splashScreenViewModel.sessionError;

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
          if (error != null) ...[
            SizedBox(height: context.sh(28)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: context.sw(32)),
              child: Text(
                error,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.white.withOpacity(0.95),
                  fontSize: context.sp(14),
                  height: 1.4,
                ),
              ),
            ),
            SizedBox(height: context.sh(12)),
            Text(
              'Give it another try',
              style: TextStyle(
                color: AppColors.white.withOpacity(0.8),
                fontSize: context.sp(13),
              ),
            ),
            SizedBox(height: context.sh(24)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: context.sw(48)),
              child: Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(context.radiusR(16)),
                child: InkWell(
                  onTap: () => splashScreenViewModel.goTo(context),
                  borderRadius: BorderRadius.circular(context.radiusR(16)),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: context.sh(14),
                      horizontal: context.sw(24),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.refresh_rounded,
                          size: context.sp(20),
                          color: AppColors.pimaryColor,
                        ),
                        SizedBox(width: context.sw(10)),
                        Text(
                          'Retry',
                          style: TextStyle(
                            color: AppColors.pimaryColor,
                            fontSize: context.sp(16),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
