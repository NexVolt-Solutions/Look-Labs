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
    return Padding(
      padding: context.padSym(h: 31),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(steps.length, (index) {
          final isCompleted = index < currentStep;
          final isCurrent = index == currentStep;
          final isUpcoming = index > currentStep;

          return Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Circle and line row
                Row(
                  children: [
                    // Step Circle
                    _buildStepCircle(
                      context: context,
                      index: index,
                      isCompleted: isCompleted,
                      isCurrent: isCurrent,
                      isUpcoming: isUpcoming,
                    ),

                    // Connector Line (except for last step)
                    if (index < steps.length - 1)
                      Expanded(
                        child: Container(
                          height: 1.5,
                          color: isCompleted
                              ? AppColors.pimaryColor
                              : AppColors.seconderyColor.withOpacity(0.3),
                        ),
                      ),
                  ],
                ),

                // Text label below
                SizedBox(height: context.h(6)),
                Text(
                  steps[index],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: context.text(10),
                    color: AppColors.seconderyColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildStepCircle({
    required BuildContext context,
    required int index,
    required bool isCompleted,
    required bool isCurrent,
    required bool isUpcoming,
  }) {
    return Container(
      width: context.w(20),
      height: context.w(20),
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
            offset: const Offset(5, 5),
            blurRadius: 5,
          ),
          BoxShadow(
            color: AppColors.customContinerColorDown.withOpacity(0.4),
            offset: const Offset(-5, -5),
            blurRadius: 5,
          ),
        ],
      ),
      child: Center(
        child: isCompleted
            ? Icon(Icons.check, color: Colors.white, size: context.w(12))
            : isCurrent
            ? Container(
                width: context.w(4),
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
