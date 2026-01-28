import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:flutter_svg/svg.dart';
import 'package:looklabs/Core/Widget/normal_text.dart';
import 'package:looklabs/Core/Constants/app_assets.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';

// class LinearSliderWidget extends StatelessWidget {
//   final double progress;
//   final double? height;
//   final double? animatedConHeight;
//   final bool? inset;
//   final bool showPercentage;

//   const LinearSliderWidget({
//     super.key,
//     required this.progress,
//     this.height,
//     this.animatedConHeight,
//     this.inset,
//     this.showPercentage = true,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         /// Slider
//         Expanded(
//           child: Container(
//             height: height ?? context.h(20),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(context.radius(10)),
//               border: Border.all(
//                 color: AppColors.backGroundColor,
//                 width: context.w(1.5),
//               ),
//               color: AppColors.backGroundColor,
//               boxShadow: [
//                 BoxShadow(
//                   color: AppColors.customContainerColorUp.withOpacity(0.4),
//                   offset: const Offset(5, 5),
//                   blurRadius: 5,
//                   inset: inset ?? true,
//                 ),
//                 BoxShadow(
//                   color: AppColors.customContinerColorDown.withOpacity(0.4),
//                   offset: const Offset(-5, -5),
//                   blurRadius: 5,
//                   inset: inset ?? true,
//                 ),
//               ],
//             ),
//             child: LayoutBuilder(
//               builder: (context, constraints) {
//                 return Stack(
//                   children: [
//                     AnimatedContainer(
//                       duration: const Duration(milliseconds: 400),
//                       height: animatedConHeight ?? context.h(20),
//                       width: constraints.maxWidth * (progress / 100),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(context.radius(10)),
//                         color: AppColors.pimaryColor,
//                         boxShadow: [
//                           BoxShadow(
//                             color: AppColors.pimaryColor.withOpacity(0.15),
//                             offset: const Offset(3, 3),
//                             blurRadius: 4,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 );
//               },
//             ),
//           ),
//         ),
//         if (showPercentage == true)
//           /// Space
//           SizedBox(width: context.w(8)),

//         /// Percentage OR Placeholder (UI stable)
//         if (showPercentage == true)
//           SizedBox(
//             width: context.w(30), // fixed width so layout never shifts
//             child: showPercentage
//                 ? NormalText(
//                     titleText: '${progress.toInt()}%',
//                     titleSize: context.text(12),
//                     titleWeight: FontWeight.w600,
//                     titleColor: AppColors.subHeadingColor,
//                   )
//                 : const SizedBox(),
//           ),
//       ],
//     );
//   }
// }
class LinearSliderWidget extends StatelessWidget {
  final double progress; // 0-100
  final double? height;
  final double? animatedConHeight;
  final bool? inset;
  final bool showPercentage;
  final bool showTopIcon; // NEW: show icon + top percentage

  const LinearSliderWidget({
    super.key,
    required this.progress,
    this.height,
    this.animatedConHeight,
    this.inset,
    this.showPercentage = true,
    this.showTopIcon = false, // default false
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showTopIcon)
          Stack(
            alignment: Alignment.center,
            children: [
              SvgPicture.asset(
                AppAssets.sugIcon,
                width: context.w(50),
                // height: context.h(70),
              ),
              TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0, end: progress),
                duration: const Duration(milliseconds: 600),
                builder: (context, value, _) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: context.h(10)),
                    child: Text(
                      "${value.toInt()}%",
                      style: TextStyle(
                        fontSize: context.text(12),
                        fontWeight: FontWeight.w400,
                        color: AppColors.headingColor,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        SizedBox(height: context.h(4)),

        /// Main Slider Row
        Row(
          children: [
            Expanded(
              child: Container(
                height: height ?? context.h(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(context.radius(10)),
                  border: Border.all(
                    color: AppColors.backGroundColor,
                    width: context.w(1.5),
                  ),
                  color: AppColors.backGroundColor,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.customContainerColorUp.withOpacity(0.4),
                      offset: const Offset(5, 5),
                      blurRadius: 5,
                      inset: inset ?? true,
                    ),
                    BoxShadow(
                      color: AppColors.customContinerColorDown.withOpacity(0.4),
                      offset: const Offset(-5, -5),
                      blurRadius: 5,
                      inset: inset ?? true,
                    ),
                  ],
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Stack(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 400),
                          height: animatedConHeight ?? context.h(20),
                          width: constraints.maxWidth * (progress / 100),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              context.radius(10),
                            ),
                            color: AppColors.pimaryColor,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.pimaryColor.withOpacity(0.15),
                                offset: const Offset(3, 3),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            if (showPercentage) SizedBox(width: context.w(8)),
            if (showPercentage)
              SizedBox(
                width: context.w(30),
                child: NormalText(
                  titleText: '${progress.toInt()}%',
                  titleSize: context.text(12),
                  titleWeight: FontWeight.w600,
                  titleColor: AppColors.subHeadingColor,
                ),
              ),
          ],
        ),
      ],
    );
  }
}
