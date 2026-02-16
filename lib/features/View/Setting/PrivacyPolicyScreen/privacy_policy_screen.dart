import 'package:flutter/material.dart';
import 'package:looklabs/Features/Widget/app_bar_container.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

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
                '[App Name] values your privacy and is committed to protecting your personal information. When you use our app, we may collect certain personal information such as your name, email address, username, and account details to allow you to sign up, log in, and personalize your experience.We may also collect non-personal information including device type, operating system, language preferences, and app usage data to improve app performance and stability. Any prompts, preferences, or content you submit within the app may be temporarily stored for processing and service improvement, but will not be shared with third parties for advertising or resale.We do not sell, trade, or rent your personal information. Your data may only be shared with trusted service providers that help operate the app or if required by law. Data is retained only as long as necessary to provide the service, after which it is securely deleted. You can request deletion of your account and related data at any time by contacting us.We take appropriate technical and organizational measures to protect your information from unauthorized access, loss, or misuse, but please understand that no digital system can be completely secure.[App Name] is intended for general audiences and does not knowingly collect data from children under 13 years of age. If such data is discovered, it will be deleted immediately.By using [App Name], you consent to the collection and use of information as described in this policy. We may update this Privacy Policy periodically, and the updated version will be available in the app. Continued use of the app after updates means you accept the revised terms.For any questions, concerns, or requests regarding your privacy, please contact us at [Your Support Email].',
                style: TextStyle(
                  fontSize: context.text(12),
                  fontWeight: FontWeight.w400,
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
