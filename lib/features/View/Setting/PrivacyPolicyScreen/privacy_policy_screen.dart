import 'package:flutter/material.dart';
import 'package:looklabs/Features/Widget/app_bar_container.dart';
import 'package:looklabs/Core/Constants/app_text.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  static List<Map<String, String>> get _sections => [
        {
          'title': AppText.privacyInfoWeCollect,
          'body': AppText.privacyInfoWeCollectBody,
        },
        {
          'title': AppText.privacyHowWeUse,
          'body': AppText.privacyHowWeUseBody,
        },
        {
          'title': AppText.privacyDataStorage,
          'body': AppText.privacyDataStorageBody,
        },
        {
          'title': AppText.privacyThirdParty,
          'body': AppText.privacyThirdPartyBody,
        },
        {
          'title': AppText.privacyPhotosAndAi,
          'body': AppText.privacyPhotosAndAiBody,
        },
        {
          'title': AppText.privacyYourRights,
          'body': AppText.privacyYourRightsBody,
        },
        {
          'title': AppText.privacySecurity,
          'body': AppText.privacySecurityBody,
        },
        {
          'title': AppText.privacyChildren,
          'body': AppText.privacyChildrenBody,
        },
        {
          'title': AppText.privacyChanges,
          'body': AppText.privacyChangesBody,
        },
        {
          'title': AppText.privacyContact,
          'body': AppText.privacyContactBody,
        },
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backGroundColor,
      body: SafeArea(
        child: ListView(
          padding: context.paddingSymmetricR(horizontal: 20),
          clipBehavior: Clip.hardEdge,
          children: [
            AppBarContainer(
              title: AppText.privacyPolicy,
              onTap: () => Navigator.pop(context),
            ),
            SizedBox(height: context.sh(20)),
            _buildParagraph(
              context,
              AppText.privacyLastUpdated,
              fontWeight: FontWeight.w600,
            ),
            SizedBox(height: context.sh(8)),
            _buildParagraph(context, AppText.privacyIntro),
            SizedBox(height: context.sh(16)),
            ..._sections.expand((section) => [
                  _buildHeading(context, section['title']!),
                  SizedBox(height: context.sh(8)),
                  _buildParagraph(context, section['body']!),
                  SizedBox(height: context.sh(16)),
                ]),
          ],
        ),
      ),
    );
  }

  Widget _buildHeading(BuildContext context, String text) {
    return Align(
      alignment: Alignment.topLeft,
      child: Text(
        text,
        style: TextStyle(
          fontSize: context.sp(18),
          fontWeight: FontWeight.w600,
          color: AppColors.headingColor,
        ),
        textAlign: TextAlign.start,
      ),
    );
  }

  Widget _buildParagraph(
    BuildContext context,
    String text, {
    FontWeight fontWeight = FontWeight.w400,
  }) {
    return Align(
      alignment: Alignment.topLeft,
      child: Text(
        text,
        style: TextStyle(
          fontSize: context.sp(12),
          fontWeight: fontWeight,
          color: AppColors.subHeadingColor,
          height: 1.4,
        ),
        textAlign: TextAlign.start,
      ),
    );
  }
}
