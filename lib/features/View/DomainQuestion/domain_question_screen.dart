import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/app_text.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Core/Routes/routes_name.dart';
import 'package:looklabs/Features/View/DomainQuestion/domain_question_content.dart';
import 'package:looklabs/Features/ViewModel/domain_question_view_model.dart';
import 'package:looklabs/Features/Widget/app_bar_container.dart';
import 'package:looklabs/Features/Widget/custom_button.dart';
import 'package:looklabs/Features/Widget/normal_text.dart';
import 'package:provider/provider.dart';

class DomainQuestionScreen extends StatefulWidget {
  const DomainQuestionScreen({super.key, required this.domain});

  final String domain;

  @override
  State<DomainQuestionScreen> createState() => _DomainQuestionScreenState();
}

class _DomainQuestionScreenState extends State<DomainQuestionScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<DomainQuestionViewModel>().loadQuestions();
    });
  }

  String get _domainTitle {
    final d = widget.domain;
    if (d.isEmpty) return 'Questions';
    if (d.length == 1) return d.toUpperCase();
    return '${d[0].toUpperCase()}${d.substring(1).replaceAll('_', ' ')}';
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DomainQuestionViewModel>();

    if (vm.loading && !vm.hasQuestions) {
      return Scaffold(
        backgroundColor: AppColors.backGroundColor,
        body: Center(
          child: CupertinoActivityIndicator(color: AppColors.pimaryColor),
        ),
      );
    }

    if (vm.error != null && !vm.hasQuestions) {
      return Scaffold(
        backgroundColor: AppColors.backGroundColor,
        body: SafeArea(
          child: Padding(
            padding: context.paddingSymmetricR(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.cloud_off_rounded,
                  size: context.sw(64),
                  color: AppColors.subHeadingColor.withOpacity(0.6),
                ),
                SizedBox(height: context.sh(20)),
                NormalText(
                  titleText: 'Couldn\'t load questions',
                  titleSize: context.sp(18),
                  titleWeight: FontWeight.w600,
                  titleColor: AppColors.headingColor,
                ),
                SizedBox(height: context.sh(12)),
                NormalText(
                  titleText: vm.error ?? 'Please try again.',
                  titleSize: context.sp(14),
                  titleColor: AppColors.subHeadingColor,
                ),
                SizedBox(height: context.sh(28)),
                CustomButton(
                  text: 'Try again',
                  color: AppColors.pimaryColor,
                  isEnabled: true,
                  onTap: () => vm.loadQuestions(),
                ),
                SizedBox(height: context.sh(16)),
                CustomButton(
                  text: 'Go back',
                  color: AppColors.notSelectedColor,
                  isEnabled: true,
                  onTap: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (!vm.hasQuestions) {
      return Scaffold(
        backgroundColor: AppColors.backGroundColor,
        body: Center(
          child: NormalText(
            titleText: 'No questions available',
            titleSize: context.sp(16),
            titleColor: AppColors.subHeadingColor,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.backGroundColor,
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          top: context.sh(5),
          left: context.sw(20),
          right: context.sw(20),
          bottom: context.sh(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (vm.submitError != null) ...[
              Padding(
                padding: EdgeInsets.only(bottom: context.sh(8)),
                child: Text(
                  vm.submitError!,
                  style: TextStyle(
                    color: AppColors.redColor,
                    fontSize: context.sp(13),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
            CustomButton(
              crossAxisAlignment: CrossAxisAlignment.center,

              text: vm.submitting ? 'Submitting...' : AppText.complete,
              color: AppColors.pimaryColor,
              isEnabled: vm.allAnswered && !vm.submitting,
              onTap: () async {
                final success = await vm.submitAnswers();
                if (!context.mounted || !success) return;
                Navigator.pop(context);
                final route = RoutesName.routeForDomain(widget.domain);
                if (context.mounted && route != null) {
                  Navigator.pushNamed(context, route);
                }
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: context.paddingSymmetricR(horizontal: 20),
              child: AppBarContainer(
                title: _domainTitle,
                onTap: () => Navigator.pop(context),
              ),
            ),
            SizedBox(height: context.sh(32)),

            Expanded(
              child: ListView(
                padding: context.paddingSymmetricR(horizontal: 20),
                children: vm.questions
                    .map(
                      (q) => Padding(
                        padding: EdgeInsets.only(bottom: context.sh(24)),
                        child: DomainFlowQuestionContent(question: q),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
