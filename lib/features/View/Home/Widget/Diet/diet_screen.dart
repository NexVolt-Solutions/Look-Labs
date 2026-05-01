import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Features/Widget/normal_text.dart';
import 'package:looklabs/Core/Routes/routes_name.dart';

class DietScreen extends StatefulWidget {
  const DietScreen({super.key});

  @override
  State<DietScreen> createState() => _DietScreenState();
}

class _DietScreenState extends State<DietScreen> {
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _navigated) return;
      _navigated = true;
      Navigator.pushReplacementNamed(
        context,
        RoutesName.DomainQuestionScreen,
        arguments: 'diet',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backGroundColor,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CupertinoActivityIndicator(
              color: AppColors.pimaryColor,
              radius: context.sw(16),
            ),
            SizedBox(height: context.sh(12)),
            NormalText(
              titleText: 'Loading diet questions...',
              titleSize: context.sp(14),
              titleWeight: FontWeight.w500,
              titleColor: AppColors.subHeadingColor,
            ),
          ],
        ),
      ),
    );
  }
}
