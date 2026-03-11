import 'package:flutter/material.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Core/Network/models/onboarding_flow_response.dart';
import 'package:looklabs/Features/Widget/goal_activity_graph.dart';
import 'package:looklabs/Features/Widget/height_indicator.dart';
import 'package:looklabs/Features/Widget/neu_text_fied.dart';
import 'package:looklabs/Features/Widget/normal_text.dart';
import 'package:looklabs/Features/Widget/plan_container.dart';
import 'package:looklabs/Features/ViewModel/domain_question_view_model.dart';
import 'package:provider/provider.dart';

/// Renders a single [FlowQuestion] for domain questions, using [DomainQuestionViewModel].
class DomainFlowQuestionContent extends StatelessWidget {
  final FlowQuestion question;

  const DomainFlowQuestionContent({super.key, required this.question});

  @override
  Widget build(BuildContext context) {
    if (question.type == 'text') {
      return _buildTextQuestion(context);
    }
    if (question.isHeightGoalsInput) {
      return _buildHeightGoalsQuestion(context);
    }
    if (question.type == 'number' || question.type == 'numeric') {
      return _buildNumberQuestion(context);
    }
    if (question.type == 'multi_choice' || question.type == 'multi-choice') {
      return _buildMultiChoiceQuestion(context);
    }
    return _buildOptionsQuestion(context);
  }

  Widget _buildHeightGoalsQuestion(BuildContext context) {
    final vm = context.read<DomainQuestionViewModel>();
    final min = question.minConstraint ?? 100;
    final max = question.maxConstraint ?? 250;
    final unit = question.unitConstraint ?? 'cm';
    final (current, desired) = vm.getFlowHeightValues(question.id);
    final currentCm = current ?? 170;
    final desiredCm = desired ?? 178;
    final currentValue = ((currentCm - min) / (max - min)).clamp(0.0, 1.0);
    final desiredValue = ((desiredCm - min) / (max - min)).clamp(0.0, 1.0);

    if (current == null || desired == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        vm.setFlowHeightAnswer(question.id, currentCm, desiredCm);
      });
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        NormalText(
          crossAxisAlignment: CrossAxisAlignment.start,
          titleText: question.question,
          titleSize: context.sp(16),
          titleWeight: FontWeight.w600,
          titleColor: AppColors.subHeadingColor,
          sizeBoxheight: context.sh(4),
          subText: 'Set your current and desired height',
          subSize: context.sp(14),
          subWeight: FontWeight.w400,
          subColor: AppColors.subHeadingColor,
        ),
        SizedBox(height: context.sh(18)),
        GoalActivityGraph(
          title1: 'Current',
          title2: 'Goal',
          currentHeight: currentCm.toDouble(),
          desiredHeight: desiredCm.toDouble(),
          unit: unit,
          minValue: min.toDouble(),
          maxValue: max.toDouble(),
        ),
        SizedBox(height: context.sh(18)),
        HeightIndicater(
          title: 'Current Height',
          initialValue: currentValue,
          valueFormatter: (v) =>
              '${(v * (max - min) + min).round()} $unit',
          onChanged: (value) {
            final cm = (value * (max - min) + min).round();
            vm.setFlowHeightAnswer(question.id, cm, desiredCm);
          },
        ),
        SizedBox(height: context.sh(18)),
        HeightIndicater(
          title: 'Desired Height',
          initialValue: desiredValue,
          valueFormatter: (v) =>
              '${(v * (max - min) + min).round()} $unit',
          onChanged: (value) {
            final cm = (value * (max - min) + min).round();
            vm.setFlowHeightAnswer(question.id, currentCm, cm);
          },
        ),
      ],
    );
  }

  Widget _buildTextQuestion(BuildContext context) {
    final vm = context.read<DomainQuestionViewModel>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        NormalText(
          titleText: question.question,
          titleSize: context.sp(16),
          titleWeight: FontWeight.w600,
          titleColor: AppColors.subHeadingColor,
        ),
        SizedBox(height: context.sh(12)),
        NeuTextField(
          hintText: 'Enter your answer',
          keyboard: TextInputType.text,
          validatorType: '',
          onChanged: (v) => vm.setFlowTextAnswer(question.id, v),
        ),
      ],
    );
  }

  Widget _buildNumberQuestion(BuildContext context) {
    final vm = context.read<DomainQuestionViewModel>();
    final min = question.minConstraint;
    final max = question.maxConstraint;
    String hint = 'Enter number';
    if (min != null && max != null) {
      hint = 'Between $min and $max';
    } else if (min != null) {
      hint = 'Min $min';
    } else if (max != null) {
      hint = 'Max $max';
    } else if (question.question.toLowerCase().contains('weight') ||
        question.question.toLowerCase().contains('physique')) {
      hint = 'e.g. 70 kg or target weight';
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        NormalText(
          titleText: question.question,
          titleSize: context.sp(16),
          titleWeight: FontWeight.w600,
          titleColor: AppColors.subHeadingColor,
        ),
        SizedBox(height: context.sh(12)),
        NeuTextField(
          hintText: hint,
          keyboard: TextInputType.number,
          validatorType: '',
          onChanged: (v) => vm.setFlowTextAnswer(question.id, v),
        ),
      ],
    );
  }

  Widget _buildOptionsQuestion(BuildContext context) {
    final options = question.optionsAsStrings;
    if (options.isEmpty) {
      return NormalText(
        titleText: question.question,
        titleSize: context.sp(16),
        titleWeight: FontWeight.w600,
        titleColor: AppColors.subHeadingColor,
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        NormalText(
          titleText: question.question,
          titleSize: context.sp(16),
          titleWeight: FontWeight.w600,
          titleColor: AppColors.subHeadingColor,
        ),
        SizedBox(height: context.sh(12)),
        ...options.asMap().entries.map((entry) {
          final oIndex = entry.key;
          final optionText = entry.value;
          return Padding(
            padding: context.paddingSymmetricR(vertical: 10),
            child: _DomainOptionTile(
              questionId: question.id,
              optionIndex: oIndex,
              optionText: optionText,
              multiChoice: false,
            ),
          );
        }),
      ],
    );
  }

  Widget _buildMultiChoiceQuestion(BuildContext context) {
    final options = question.optionsAsStrings;
    if (options.isEmpty) {
      return NormalText(
        titleText: question.question,
        titleSize: context.sp(16),
        titleWeight: FontWeight.w600,
        titleColor: AppColors.subHeadingColor,
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        NormalText(
          titleText: question.question,
          titleSize: context.sp(16),
          titleWeight: FontWeight.w600,
          titleColor: AppColors.subHeadingColor,
        ),
        SizedBox(height: context.sh(12)),
        ...options.asMap().entries.map((entry) {
          final oIndex = entry.key;
          final optionText = entry.value;
          return Padding(
            padding: context.paddingSymmetricR(vertical: 10),
            child: _DomainOptionTile(
              questionId: question.id,
              optionIndex: oIndex,
              optionText: optionText,
              multiChoice: true,
            ),
          );
        }),
      ],
    );
  }
}

class _DomainOptionTile extends StatelessWidget {
  final int questionId;
  final int optionIndex;
  final String optionText;
  final bool multiChoice;

  const _DomainOptionTile({
    required this.questionId,
    required this.optionIndex,
    required this.optionText,
    this.multiChoice = false,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<DomainQuestionViewModel>(
      builder: (context, vm, _) {
        final isSelected = multiChoice
            ? vm.isFlowMultiOptionSelected(questionId, optionIndex)
            : vm.isFlowOptionSelected(questionId, optionIndex);
        return SizedBox(
          width: double.infinity,
          child: PlanContainer(
            margin: EdgeInsets.zero,
            isSelected: isSelected,
            onTap: () {
              if (multiChoice) {
                vm.toggleFlowMultiOption(questionId, optionIndex);
              } else {
                vm.selectFlowOption(questionId, optionIndex);
              }
            },
            padding: context.paddingSymmetricR(horizontal: 22, vertical: 14),
            child: Text(
              optionText,
              style: TextStyle(
                color: AppColors.subHeadingColor,
                fontSize: context.sp(14),
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        );
      },
    );
  }
}
