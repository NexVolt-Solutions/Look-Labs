import 'package:flutter/material.dart';
import 'package:looklabs/Core/Constants/Widget/app_bar_container.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backGroundColor,
      body: SafeArea(
        child: ListView(
          padding: context.padSym(h: 20),
          clipBehavior: Clip.hardEdge,
          children: [
            AppBarContainer(
              title: 'Privacy Policy',
              onTap: () => Navigator.pop(context),
            ),
            SizedBox(height: context.h(20)),

            Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Last updated: [Insert Date]",
                style: TextStyle(
                  fontSize: context.text(12),
                  fontWeight: FontWeight.w600,
                  color: AppColors.subHeadingColor,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            SizedBox(height: context.h(8)),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Welcome to [App Name] (“we”, “our”, “us”). These Terms of Use govern your use of our mobile application (the “Service”). By accessing or using [App Name], you agree to be bound by these Terms.',
                style: TextStyle(
                  fontSize: context.text(12),
                  fontWeight: FontWeight.w400,
                  color: AppColors.subHeadingColor,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            SizedBox(height: context.h(8)),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Acceptance of Terms',
                style: TextStyle(
                  fontSize: context.text(20),
                  fontWeight: FontWeight.w600,
                  color: AppColors.headingColor,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            SizedBox(height: context.h(8)),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                'By registering or using our Service, you confirm that you are at least 13 years of age and you agree to these Terms and our Privacy Policy. If you do not agree, please discontinue use of the Service.',
                style: TextStyle(
                  fontSize: context.text(12),
                  fontWeight: FontWeight.w400,
                  color: AppColors.subHeadingColor,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            SizedBox(height: context.h(8)),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Description of Service',
                style: TextStyle(
                  fontSize: context.text(20),
                  fontWeight: FontWeight.w600,
                  color: AppColors.headingColor,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            SizedBox(height: context.h(8)),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                'GENWALLS is an AI-powered wallpaper generator that allows users to create unique, high-quality digital images and wallpapers using text prompts, customization features, and style options. Users can:  ➤ Enter custom prompts to generate wallpapers  ➤ Explore AI-suggested prompts for inspiration  ➤ Select different image sizes and aspect ratios  ➤ Choose from multiple artistic styles and themes  ➤ Download wallpapers for personal use',
                style: TextStyle(
                  fontSize: context.text(12),
                  fontWeight: FontWeight.w400,
                  color: AppColors.subHeadingColor,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            SizedBox(height: context.h(8)),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                'User Accounts',
                style: TextStyle(
                  fontSize: context.text(20),
                  fontWeight: FontWeight.w600,
                  color: AppColors.headingColor,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            SizedBox(height: context.h(8)),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                'When creating an account, you must provide accurate and complete information. You are responsible for maintaining the confidentiality of your login credentials and all activity conducted under your account.',
                style: TextStyle(
                  fontSize: context.text(12),
                  fontWeight: FontWeight.w400,
                  color: AppColors.subHeadingColor,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            SizedBox(height: context.h(8)),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Intellectual Property',
                style: TextStyle(
                  fontSize: context.text(20),
                  fontWeight: FontWeight.w600,
                  color: AppColors.headingColor,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            SizedBox(height: context.h(8)),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                'All content, design, branding, and features within [App Name] are the exclusive property of our company. You may not copy, modify, reverse engineer, or redistribute any part of the Service without prior permission.',
                style: TextStyle(
                  fontSize: context.text(12),
                  fontWeight: FontWeight.w400,
                  color: AppColors.subHeadingColor,
                ),
                textAlign: TextAlign.start,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
