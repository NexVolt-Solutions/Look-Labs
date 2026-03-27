import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Core/Network/api_error_handler.dart';
import 'package:looklabs/Core/Routes/routes_name.dart';
import 'package:looklabs/Features/View/DomainQuestion/domain_question_content.dart';
import 'package:looklabs/Features/ViewModel/domain_question_view_model.dart';
import 'package:looklabs/Features/Widget/app_bar_container.dart';
import 'package:looklabs/Features/Widget/custom_button.dart';
import 'package:looklabs/Features/Widget/custom_stepper.dart';
import 'package:looklabs/Features/Widget/normal_text.dart';
import 'package:looklabs/Repository/domain_questions_repository.dart';
import 'package:provider/provider.dart';

class DomainQuestionScreen extends StatefulWidget {
  const DomainQuestionScreen({super.key, required this.domain});

  final String domain;

  @override
  State<DomainQuestionScreen> createState() => _DomainQuestionScreenState();
}

class _DomainQuestionScreenState extends State<DomainQuestionScreen> {
  bool _isProcessing = false;
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

  void _navigateToResult(Map<String, dynamic> data) {
    Navigator.pop(context);
    final route = RoutesName.routeForDomain(widget.domain);
    if (!mounted || route == null) return;
    final args =
        (route == RoutesName.WorkOutResultScreen ||
            route == RoutesName.HeightResultScreen ||
            route == RoutesName.RecoveryPathScreen)
        ? data
        : null;
    Navigator.pushNamed(context, route, arguments: args);
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DomainQuestionViewModel>();

    if (vm.loading && !vm.hasQuestion) {
      return Scaffold(
        backgroundColor: AppColors.backGroundColor,
        body: Center(
          child: CupertinoActivityIndicator(color: AppColors.pimaryColor),
        ),
      );
    }

    if (vm.error != null && !vm.hasQuestion) {
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

    if (!vm.hasQuestion) {
      if (_isProcessing) {
        return Scaffold(
          backgroundColor: AppColors.backGroundColor,
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CupertinoActivityIndicator(
                  color: AppColors.pimaryColor,
                  radius: context.sw(20),
                ),
                SizedBox(height: context.sh(16)),
                NormalText(
                  titleText: 'Processing your answers...',
                  titleSize: context.sp(16),
                  titleWeight: FontWeight.w500,
                  titleColor: AppColors.subHeadingColor,
                ),
              ],
            ),
          ),
        );
      }
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

    final totalQuestions = vm.totalQuestions;
    final answeredCount = vm.answeredCount;

    return Stack(
      children: [
        Scaffold(
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
                  text: vm.submitting
                      ? 'Submitting...'
                      : (vm.isOnLastQuestion ? 'Start analysis' : 'Next'),
                  color: AppColors.pimaryColor,
                  isEnabled: vm.isCurrentStepComplete && !vm.submitting,
                  onTap: () async {
                    if (!vm.isCurrentStepComplete) {
                      ApiErrorHandler.showSnackBar(
                        context,
                        fallback:
                            vm.currentStepQuestions.any(
                              (q) =>
                                  q.type == 'choice' ||
                                  q.type == 'multi_choice' ||
                                  q.type == 'multi-choice',
                            )
                            ? 'Please select all options before continuing.'
                            : 'Please answer all questions before continuing.',
                      );
                      return;
                    }
                    final (success, responseData) = await vm
                        .submitCurrentAnswer();
                    if (!context.mounted || !success) return;
                    if (responseData != null) {
                      final status = responseData['status']?.toString() ?? '';
                      if (status == 'processing') {
                        setState(() => _isProcessing = true);
                        final completed = await DomainQuestionsRepository
                            .instance
                            .pollDomainFlowUntilCompleted(
                              widget.domain,
                              lastKnownResponse: responseData,
                            );
                        if (!mounted) return;
                        setState(() => _isProcessing = false);
                        if (completed == null) {
                          ApiErrorHandler.showSnackBar(
                            context,
                            fallback: 'Processing timed out. Please try again.',
                          );
                          return;
                        }
                        _navigateToResult(completed);
                      } else {
                        _navigateToResult(responseData);
                      }
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
                SizedBox(height: context.sh(12)),
                Padding(
                  padding: context.paddingSymmetricR(horizontal: 20),
                  child: answeredCount > 0
                      ? AppBarContainer(
                          title: vm.currentStepTitle,
                          onTap: () {
                            ApiErrorHandler.showSnackBar(
                              context,
                              fallback:
                                  "You can't go back after moving to the next step.",
                            );
                          },
                        )
                      : AppBarContainer(
                          title: _domainTitle,
                          onTap: () => Navigator.pop(context),
                        ),
                ),
                SizedBox(height: context.sh(20)),
                if (totalQuestions > 0)
                  Padding(
                    padding: context.paddingSymmetricR(horizontal: 20),
                    child: CustomStepper(
                      currentStep: vm.stepperLabels.isNotEmpty
                          ? vm.stepperCurrentStepIndex
                          : answeredCount,
                      steps: vm.stepperLabels.isNotEmpty
                          ? vm.stepperLabels
                          : List.generate(
                              totalQuestions,
                              (i) => 'Step ${i + 1}',
                            ),
                    ),
                  ),
                SizedBox(height: context.sh(20)),
                Expanded(
                  child: vm.currentStepQuestions.isEmpty
                      ? const SizedBox.shrink()
                      : SingleChildScrollView(
                          padding: context.paddingSymmetricR(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              for (
                                var i = 0;
                                i < vm.currentStepQuestions.length;
                                i++
                              ) ...[
                                DomainFlowQuestionContent(
                                  question: vm.currentStepQuestions[i],
                                ),
                                if (i < vm.currentStepQuestions.length - 1)
                                  SizedBox(height: context.sh(24)),
                              ],
                            ],
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
        if (_isProcessing)
          Positioned.fill(
            child: Container(
              color: AppColors.backGroundColor.withOpacity(0.9),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CupertinoActivityIndicator(
                      color: AppColors.pimaryColor,
                      radius: context.sw(20),
                    ),
                    SizedBox(height: context.sh(16)),
                    NormalText(
                      titleText: 'Processing your answers...',
                      titleSize: context.sp(16),
                      titleWeight: FontWeight.w500,
                      titleColor: AppColors.subHeadingColor,
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
