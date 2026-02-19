import 'package:flutter/material.dart';
import 'package:looklabs/Features/Widget/app_bar_container.dart';
import 'package:looklabs/Core/Constants/app_text.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  static List<Map<String, String>> get _sections => [
        {'title': AppText.acceptanceOfTerms, 'body': AppText.termsAgeConfirm},
        {'title': AppText.descriptionOfService, 'body': AppText.termsServiceDesc},
        {'title': AppText.userAccounts, 'body': AppText.termsAccountInfo},
        {'title': AppText.intellectualProperty, 'body': AppText.termsIpDesc},
        {'title': AppText.termsSubscription, 'body': AppText.termsSubscriptionBody},
        {'title': AppText.termsUserContent, 'body': AppText.termsUserContentBody},
        {'title': AppText.termsDisclaimers, 'body': AppText.termsDisclaimersBody},
        {'title': AppText.termsLimitation, 'body': AppText.termsLimitationBody},
        {'title': AppText.termsTermination, 'body': AppText.termsTerminationBody},
        {'title': AppText.termsGoverningLaw, 'body': AppText.termsGoverningLawBody},
        {'title': AppText.termsContact, 'body': AppText.termsContactBody},
      ];

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
              title: AppText.termsOfService,
              onTap: () => Navigator.pop(context),
            ),
            SizedBox(height: context.h(20)),
            _buildParagraph(
              context,
              AppText.termsLastUpdated,
              fontWeight: FontWeight.w600,
            ),
            SizedBox(height: context.h(8)),
            _buildParagraph(context, AppText.termsWelcome),
            SizedBox(height: context.h(16)),
            ..._sections.expand((section) => [
                  _buildHeading(context, section['title']!),
                  SizedBox(height: context.h(8)),
                  _buildParagraph(context, section['body']!),
                  SizedBox(height: context.h(16)),
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
          fontSize: context.text(18),
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
          fontSize: context.text(12),
          fontWeight: fontWeight,
          color: AppColors.subHeadingColor,
          height: 1.4,
        ),
        textAlign: TextAlign.start,
      ),
    );
  }
}
