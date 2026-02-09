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
        // Circles and Lines Row
        Row(
          children: List.generate(steps.length * 2 - 1, (i) {
            if (i.isOdd) {
              // Line between circles
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
              // Circle
              int stepIndex = i ~/ 2;
              bool isCompleted = stepIndex < currentStep;
              bool isCurrent = stepIndex == currentStep;
              bool isUpcoming = stepIndex > currentStep;

              return _buildStepCircle(
                context: context,
                index: stepIndex,
                isCompleted: isCompleted,
                isCurrent: isCurrent,
                isUpcoming: isUpcoming,
              );
            }
          }),
        ),

        SizedBox(height: context.h(6)),

        // Labels below circles - aligned to start
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(steps.length * 2 - 1, (i) {
            if (i.isOdd) {
              // Empty space for the line
              return Expanded(child: SizedBox());
            } else {
              // Text label
              int stepIndex = i ~/ 2;
              return SizedBox(
                width: context.w(50), // Increased width to fit text on one line
                child: Text(
                  steps[stepIndex],
                  maxLines: 1,
                  overflow: TextOverflow.visible,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: context.text(10),
                    color: AppColors.seconderyColor,
                    fontWeight: FontWeight.w400,
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
    required int index,
    required bool isCompleted,
    required bool isCurrent,
    required bool isUpcoming,
  }) {
    return Container(
      width: context.w(25),
      height: context.w(25),
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
// class CustomStepper extends StatelessWidget {
//   final int currentStep;
//   final List<String> steps;

//   const CustomStepper({
//     Key? key,
//     required this.currentStep,
//     required this.steps,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisAlignment: MainAxisAlignment.start, // center everything
//           children: List.generate(steps.length * 2 - 1, (i) {
//             // alternate: step, divider, step, divider...
//             if (i.isOdd) {
//               // Divider between steps
//               int stepIndex = (i - 1) ~/ 2;
//               bool isCompleted = stepIndex < currentStep;
//               return Expanded(
//                 child: Padding(
//                   padding: EdgeInsetsGeometry.only(top: 3),
//                   child: Divider(
//                     thickness: 1.5,
//                     color: isCompleted
//                         ? AppColors.pimaryColor
//                         : AppColors.seconderyColor.withOpacity(0.3),
//                   ),
//                 ),
//               );
//             } else {
//               // Step Circle
//               int stepIndex = i ~/ 2;
//               bool isCompleted = stepIndex < currentStep;
//               bool isCurrent = stepIndex == currentStep;
//               bool isUpcoming = stepIndex > currentStep;
//               return _buildStepCircle(
//                 context: context,
//                 index: stepIndex,
//                 isCompleted: isCompleted,
//                 isCurrent: isCurrent,
//                 isUpcoming: isUpcoming,
//               );
//             }
//           }),
//         ),
//         Row(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.center, // center everything
//           children: List.generate(steps.length * 2 - 1, (i) {
//             // alternate: step, divider, step, divider...
//             if (i.isOdd) {
//               // Divider between steps
//               return Expanded(
//                 child: Padding(
//                   padding: EdgeInsetsGeometry.only(top: 3),
//                   child: Text(""),
//                 ),
//               );
//             } else {
//               // Step Circle

//               return Padding(
//                 padding: EdgeInsetsGeometry.only(top: 3),
//                 child: Text(
//                   steps[index],
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     fontSize: context.text(10),
//                     color: AppColors.seconderyColor,
//                     fontWeight: FontWeight.w400,
//                   ),
//                 ),
//               );
//             }
//           }),
//         ),
//       ],
//     );
//   }

//   Widget _buildStepCircle({
//     required BuildContext context,
//     required int index,
//     required bool isCompleted,
//     required bool isCurrent,
//     required bool isUpcoming,
//   }) {
//     return Container(
//       width: context.w(20),
//       height: context.w(20),
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         border: Border.all(
//           color: isUpcoming
//               ? AppColors.white.withOpacity(0.3)
//               : AppColors.pimaryColor,
//           width: context.w(2),
//         ),
//         color: isCompleted ? AppColors.pimaryColor : AppColors.backGroundColor,
//         boxShadow: [
//           BoxShadow(
//             color: AppColors.customContainerColorUp.withOpacity(0.4),
//             offset: const Offset(5, 5),
//             blurRadius: 5,
//           ),
//           BoxShadow(
//             color: AppColors.customContinerColorDown.withOpacity(0.4),
//             offset: const Offset(-5, -5),
//             blurRadius: 3,
//           ),
//         ],
//       ),
//       child: Center(
//         child: isCompleted
//             ? Icon(Icons.check, color: Colors.white, size: context.w(12))
//             : isCurrent
//             ? Container(
//                 width: context.w(4),
//                 height: context.w(4),
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: AppColors.pimaryColor,
//                 ),
//               )
//             : null,
//       ),
//     );
//   }
// }

// class CustomStepper extends StatelessWidget {
//   final int currentStep;
//   final List<String> steps;

//   const CustomStepper({
//     Key? key,
//     required this.currentStep,
//     required this.steps,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         /// 🔹 Circles + Dividers
//         Row(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: List.generate(steps.length * 2 - 1, (i) {
//             if (i.isOdd) {
//               // Divider between circles
//               int stepIndex = (i - 1) ~/ 2;
//               bool isCompleted = stepIndex < currentStep;
//               return Expanded(
//                 child: Divider(
//                   thickness: 2,
//                   color: isCompleted
//                       ? AppColors.pimaryColor
//                       : AppColors.seconderyColor.withOpacity(0.3),
//                 ),
//               );
//             } else {
//               // Circle
//               int stepIndex = i ~/ 2;
//               bool isCompleted = stepIndex < currentStep;
//               bool isCurrent = stepIndex == currentStep;
//               bool isUpcoming = stepIndex > currentStep;

//               return _buildStepCircle(
//                 context: context,
//                 index: stepIndex,
//                 isCompleted: isCompleted,
//                 isCurrent: isCurrent,
//                 isUpcoming: isUpcoming,
//               );
//             }
//           }),
//         ),

//         SizedBox(height: context.h(6)),

//         /// 🔹 Labels below circles
//         Row(
//           mainAxisAlignment:
//               MainAxisAlignment.spaceBetween, // align labels under circles
//           children: List.generate(steps.length, (index) {
//             return Flexible(
//               fit: FlexFit.tight,
//               child: Text(
//                 steps[index], // dynamic text
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: context.text(10),
//                   color: AppColors.seconderyColor,
//                   fontWeight: FontWeight.w400,
//                 ),
//               ),
//             );
//           }),
//         ),
//       ],
//     );
//   }

//   Widget _buildStepCircle({
//     required BuildContext context,
//     required int index,
//     required bool isCompleted,
//     required bool isCurrent,
//     required bool isUpcoming,
//   }) {
//     return Container(
//       width: context.w(20),
//       height: context.w(20),
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         border: Border.all(
//           color: isUpcoming
//               ? AppColors.white.withOpacity(0.3)
//               : AppColors.pimaryColor,
//           width: context.w(2),
//         ),
//         color: isCompleted ? AppColors.pimaryColor : AppColors.backGroundColor,
//         boxShadow: [
//           BoxShadow(
//             color: AppColors.customContainerColorUp.withOpacity(0.4),
//             offset: const Offset(5, 5),
//             blurRadius: 5,
//           ),
//           BoxShadow(
//             color: AppColors.customContinerColorDown.withOpacity(0.4),
//             offset: const Offset(-5, -5),
//             blurRadius: 3,
//           ),
//         ],
//       ),
//       child: Center(
//         child: isCompleted
//             ? Icon(Icons.check, color: Colors.white, size: context.w(12))
//             : isCurrent
//             ? Container(
//                 width: context.w(4),
//                 height: context.w(4),
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: AppColors.pimaryColor,
//                 ),
//               )
//             : null,
//       ),
//     );
//   }
// }
