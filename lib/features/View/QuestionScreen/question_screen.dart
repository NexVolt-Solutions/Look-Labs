import 'package:flutter/material.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Features/Widget/app_bar_container.dart';
import 'package:looklabs/Features/Widget/custom_button.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Features/Widget/custom_stepper.dart';
import 'package:looklabs/Features/Widget/normal_text.dart';
import 'package:looklabs/Core/Routes/routes_name.dart';
import 'package:looklabs/Features/View/QuestionScreen/flow_question_content.dart';
import 'package:looklabs/Repository/onboarding_repository.dart';
import 'package:looklabs/features/ViewModel/question_answer_view_model.dart';
import 'package:provider/provider.dart';

class QuestionScreen extends StatefulWidget {
  const QuestionScreen({super.key});

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  bool _isCompleting = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<QuestionAnswerViewModel>().loadAllQuestionsForCurrentStep();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<QuestionAnswerViewModel>(context);
    final hasSession = OnboardingRepository.sessionId != null;

    if (!hasSession) {
      return _buildNoSessionUi(context);
    }

    if (vm.isLoadingFlow && !vm.flowLoadAttempted) {
      return Scaffold(
        backgroundColor: AppColors.backGroundColor,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (vm.flowError != null && !vm.hasFlowQuestions) {
      return _buildErrorUi(context, vm);
    }

    return _buildFlowUi(context, vm);
  }

  Widget _buildNoSessionUi(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backGroundColor,
      body: Center(
        child: Padding(
          padding: context.paddingSymmetricR(horizontal: 24),
          child: NormalText(
            titleText: 'No session. Please start from the beginning.',
            titleSize: context.sp(16),
            titleColor: AppColors.subHeadingColor,
          ),
        ),
      ),
    );
  }

  Widget _buildErrorUi(BuildContext context, QuestionAnswerViewModel vm) {
    return Scaffold(
      backgroundColor: AppColors.backGroundColor,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: context.paddingSymmetricR(horizontal: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
                  titleText:
                      vm.flowError ?? 'Something went wrong. Please try again.',
                  titleSize: context.sp(14),
                  titleColor: AppColors.subHeadingColor,
                ),
                SizedBox(height: context.sh(28)),
                SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    text: 'Try again',
                    color: AppColors.pimaryColor,
                    isEnabled: true,
                    onTap: () => vm.loadAllQuestionsForCurrentStep(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFlowUi(BuildContext context, QuestionAnswerViewModel vm) {
    final bool isLastStep = vm.isFlowComplete;

    return Scaffold(
      backgroundColor: AppColors.backGroundColor,
      bottomNavigationBar: Padding(
        padding: context.paddingOnly(top: 20, left: 20, right: 20, bottom: 20),
        child: CustomButton(
          text: isLastStep ? 'Complete' : 'Next',
          color: AppColors.pimaryColor,
          isEnabled: !vm.isLoadingFlow,
          onTap: () async {
            if (!vm.isCurrentStepComplete) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    vm.currentStepQuestions.any(
                          (q) => q.type == 'choice' || q.type == 'multi_choice',
                        )
                        ? 'Please select all options before continuing.'
                        : 'Please answer all questions before continuing.',
                  ),
                  behavior: SnackBarBehavior.floating,
                ),
              );
              return;
            }
            final submitted = await vm.submitCurrentStepAnswers();
            if (!context.mounted) return;
            if (!submitted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    vm.flowError ??
                        'Failed to submit answers. Please try again.',
                  ),
                  behavior: SnackBarBehavior.floating,
                ),
              );
              return;
            }
            if (isLastStep) {
              setState(() => _isCompleting = true);
              await Future.delayed(const Duration(milliseconds: 400));
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, RoutesName.GaolScreen);
                if (mounted) setState(() => _isCompleting = false);
              }
              return;
            }
            await vm.nextStep();
            // Do not auto-navigate to Goal when API returns completed with no questions.
            // Show Planning step (with empty content if completed); user taps Complete to go to Goal.
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: context.sh(12)),
            Padding(
              padding: context.paddingSymmetricR(horizontal: 20),
              child: vm.currentStepIndex > 0
                  ? AppBarContainer(
                      title: vm.flowStepTitle,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "You can't go back after submitting a step.",
                            ),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: context.sh(48),
                          color: Colors.transparent,
                        ),
                        Expanded(
                          child: Center(
                            child: NormalText(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              titleText: vm.flowStepTitle,
                              titleSize: context.sp(20),
                              titleWeight: FontWeight.w600,
                              titleColor: AppColors.headingColor,
                            ),
                          ),
                        ),
                        SizedBox(height: context.sh(40), width: context.sw(40)),
                      ],
                    ),
            ),
            SizedBox(height: context.sh(20)),
            Padding(
              padding: context.paddingSymmetricR(horizontal: 20),
              child: CustomStepper(
                currentStep: _isCompleting
                    ? QuestionAnswerViewModel.flowStepperLabels.length
                    : vm.flowStepperIndex,
                steps: QuestionAnswerViewModel.flowStepperLabels,
              ),
            ),
            SizedBox(height: context.sh(20)),
            Expanded(
              child: vm.isLoadingFlow
                  ? const Center(child: CircularProgressIndicator())
                  : vm.hasFlowQuestions
                  ? SingleChildScrollView(
                      padding: context.paddingSymmetricR(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (
                            int i = 0;
                            i < vm.currentStepQuestions.length;
                            i++
                          ) ...[
                            FlowQuestionContent(
                              question: vm.currentStepQuestions[i],
                            ),
                            if (i < vm.currentStepQuestions.length - 1)
                              SizedBox(height: context.sh(24)),
                          ],
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
