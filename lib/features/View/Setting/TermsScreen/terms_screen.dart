import 'package:flutter/material.dart';
import 'package:looklabs/Features/Widget/app_bar_container.dart';
import 'package:looklabs/Core/Constants/app_text.dart';
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
              title: AppText.privacyPolicy,
              onTap: () => Navigator.pop(context),
            ),
            SizedBox(height: context.h(20)),

            Align(
              alignment: Alignment.topLeft,
              child: Text(
                AppText.lastUpdated,
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
                AppText.termsWelcome,
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
                AppText.acceptanceOfTerms,
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
                AppText.termsAgeConfirm,
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
                AppText.descriptionOfService,
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
                AppText.termsGenwallsDesc,
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
                AppText.userAccounts,
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
                AppText.termsAccountInfo,
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
                AppText.intellectualProperty,
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
                AppText.termsIpDesc,
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
