import 'package:flutter/material.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';

class CustomStepper extends StatelessWidget {
  final int currentStep;
  final List<String> steps;

  const CustomStepper({
    Key? key,
    required this.currentStep,
    required this.steps,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// 🔹 Circles + Dividers
        Row(
          children: List.generate(steps.length * 2 - 1, (i) {
            if (i.isOdd) {
              int stepIndex = (i - 1) ~/ 2;
              bool isCompleted = stepIndex < currentStep;

              return Expanded(
                child: Container(
                  height: 1.5,
                  color: isCompleted
                      ? AppColors.pimaryColor
                      : AppColors.seconderyColor.withOpacity(0.3),
                ),
              );
            } else {
              int stepIndex = i ~/ 2;
              bool isCompleted = stepIndex < currentStep;
              bool isCurrent = stepIndex == currentStep;
              bool isUpcoming = stepIndex > currentStep;

              return _buildStepCircle(
                context: context,
                isCompleted: isCompleted,
                isCurrent: isCurrent,
                isUpcoming: isUpcoming,
              );
            }
          }),
        ),

        SizedBox(height: context.h(6)),

        /// 🔹 STEP LABELS (FIXED ONE LINE)
        Row(
          children: List.generate(steps.length * 2 - 1, (i) {
            if (i.isOdd) {
              return const Expanded(child: SizedBox());
            } else {
              int stepIndex = i ~/ 2;

              return Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    steps[stepIndex],
                    maxLines: 1,
                    softWrap: false,
                    overflow: TextOverflow.visible,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: context.text(12),
                      color: stepIndex == currentStep
                          ? AppColors.pimaryColor
                          : AppColors.seconderyColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            }
          }),
        ),
      ],
    );
  }

  Widget _buildStepCircle({
    required BuildContext context,
    required bool isCompleted,
    required bool isCurrent,
    required bool isUpcoming,
  }) {
    return Container(
      width: context.w(22),
      height: context.w(22),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isUpcoming
              ? AppColors.white.withOpacity(0.3)
              : AppColors.pimaryColor,
          width: context.w(2),
        ),
        color: isCompleted ? AppColors.pimaryColor : AppColors.backGroundColor,
        boxShadow: [
          BoxShadow(
            color: AppColors.customContainerColorUp.withOpacity(0.4),
            offset: const Offset(3, 3),
            blurRadius: 4,
          ),
          BoxShadow(
            color: AppColors.customContinerColorDown.withOpacity(0.4),
            offset: const Offset(-3, -3),
            blurRadius: 4,
          ),
        ],
      ),
      child: Center(
        child: isCompleted
            ? Icon(Icons.check, color: Colors.white, size: context.w(10))
            : isCurrent
            ? Container(
                width: context.w(4),
                height: context.w(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.pimaryColor,
                ),
              )
            : null,
      ),
    );
  }
}
