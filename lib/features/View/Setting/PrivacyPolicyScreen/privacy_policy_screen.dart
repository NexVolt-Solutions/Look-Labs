import 'package:flutter/material.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/app_text.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Features/ViewModel/privacy_policy_view_model.dart';
import 'package:looklabs/Features/Widget/app_bar_container.dart';
import 'package:provider/provider.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<PrivacyPolicyViewModel>().load();
    });
  }

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
            _buildBody(context),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final vm = context.watch<PrivacyPolicyViewModel>();

    if (vm.loading && vm.sections.isEmpty) {
      return Padding(
        padding: EdgeInsets.only(top: context.sh(40)),
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    if (vm.error != null && vm.sections.isEmpty) {
      return Padding(
        padding: EdgeInsets.only(top: context.sh(40)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              vm.error!,
              style: TextStyle(
                fontSize: context.sp(14),
                color: AppColors.subHeadingColor,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: context.sh(16)),
            TextButton(
              onPressed: () => vm.retry(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return _buildContent(context, vm);
  }

  Widget _buildContent(BuildContext context, PrivacyPolicyViewModel vm) {
    final lastUpdated = vm.policy?.lastUpdated ?? '';
    final sections = vm.sections;
    if (sections.isEmpty) return const SizedBox.shrink();

    final children = <Widget>[];

    if (lastUpdated.isNotEmpty) {
      children.addAll([
        _buildParagraph(context, 'Last updated: $lastUpdated',
            fontWeight: FontWeight.w600),
        SizedBox(height: context.sh(16)),
      ]);
    }

    for (final section in sections) {
      if (section.body.isEmpty) continue;
      if (section.title.isNotEmpty) {
        children.addAll([
          _buildHeading(context, section.title),
          SizedBox(height: context.sh(8)),
        ]);
      }
      children.addAll([
        _buildParagraph(context, section.body),
        SizedBox(height: context.sh(16)),
      ]);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
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
