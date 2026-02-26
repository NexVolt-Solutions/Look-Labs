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
      body: Center(
        child: Padding(
          padding: context.paddingSymmetricR(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              NormalText(
                titleText: vm.flowError ?? 'Something went wrong',
                titleSize: context.sp(16),
                titleColor: AppColors.subHeadingColor,
              ),
              SizedBox(height: context.sh(16)),
              CustomButton(
                text: 'Retry',
                color: AppColors.pimaryColor,
                isEnabled: true,
                onTap: () => vm.loadAllQuestionsForCurrentStep(),
              ),
            ],
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
        padding: context.paddingSymmetricR(horizontal: 20, vertical: 30),
        child: CustomButton(
          text: isLastStep ? 'Complete' : 'Next',
          color: AppColors.pimaryColor,
          isEnabled: !vm.isLoadingFlow,
          onTap: () async {
            if (isLastStep) {
              if (context.mounted) {
                Navigator.pushNamed(context, RoutesName.GaolScreen);
              }
              return;
            }
            await vm.nextStep();
            if (context.mounted) {
              // If we moved to last step and it has no questions, still show Complete
              if (vm.isFlowComplete && !vm.hasFlowQuestions) {
                Navigator.pushNamed(context, RoutesName.GaolScreen);
              }
            }
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: context.sh(12)),
            if (vm.currentStepIndex > 0)
              Padding(
                padding: context.paddingSymmetricR(horizontal: 20),
                child: AppBarContainer(
                  title: vm.flowStepTitle,
                  onTap: () => vm.backStep(),
                ),
              )
            else
              Padding(
                padding: context.paddingSymmetricR(horizontal: 20),
                child: NormalText(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  titleText: vm.flowStepTitle,
                  titleSize: context.sp(20),
                  titleWeight: FontWeight.w600,
                  titleColor: AppColors.headingColor,
                ),
              ),
            SizedBox(height: context.sh(20)),
            Padding(
              padding: context.paddingSymmetricR(horizontal: 20),
              child: CustomStepper(
                currentStep: vm.flowStepperIndex,
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
                              for (int i = 0;
                                  i < vm.currentStepQuestions.length;
                                  i++) ...[
                                FlowQuestionContent(
                                    question: vm.currentStepQuestions[i]),
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
