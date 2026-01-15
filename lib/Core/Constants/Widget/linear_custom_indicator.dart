// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:looklabs/Core/Constants/Widget/custom_container.dart';
// import 'package:looklabs/Core/Constants/app_colors.dart';
// import 'package:looklabs/Core/Constants/size_extension.dart';
// import 'package:percent_indicator/linear_percent_indicator.dart';

// class LinearCustomIndicator extends StatelessWidget {
//   final double? height;
//   final double? wedth;
//   const LinearCustomIndicator({super.key, this.height, this.wedth});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: context.padSym(h: 55.5),
//       child: Column(
//         children: [
//           SvgPicture.asset(
//             'assets/Icon/sugIcon.svg',
//             color: Colors.amber,
//             height: context.h(60),
//             width: context.w(50),
//             fit: BoxFit.fill,
//           ),
//           CustomContainer(
//             width: wedth ?? context.w(264),
//             height: height ?? context.h(10),
//             radius: context.radius(10),
//             padding: EdgeInsets.zero,
//             color: AppColors.backGroundColor,
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(context.radius(10)),
//               child: LinearPercentIndicator(
//                 padding: EdgeInsets.zero,
//                 width: context.w(250),
//                 lineHeight: context.h(10),
//                 percent: 0.5,
//                 backgroundColor: AppColors.backGroundColor,
//                 progressColor: AppColors.pimaryColor,
//                 barRadius: Radius.circular(context.radius(10)),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:looklabs/Core/Constants/Widget/custom_container.dart';
import 'package:looklabs/Core/Constants/app_assets.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class LinearCustomIndicator extends StatelessWidget {
  final double percent; // 0.0 - 1.0
  final double? height;

  const LinearCustomIndicator({super.key, required this.percent, this.height});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: context.padSym(h: 55.5),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// 🔹 ICON + CENTER TEXT (Animated)
          Stack(
            alignment: Alignment.center,
            children: [
              SvgPicture.asset(
                AppAssets.sugIcon,
                // height: context.h(70),
                width: context.w(50),
                // fit: BoxFit.contain,
              ),

              /// 🔥 Animated Percent Text
              TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0, end: percent),
                duration: const Duration(milliseconds: 600),
                builder: (context, value, _) {
                  return Padding(
                    padding: EdgeInsetsGeometry.only(bottom: context.h(10)),
                    child: Text(
                      "${(value * 100).toInt()}%",
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
          //linar indicator
          LayoutBuilder(
            builder: (context, constraints) {
              return TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0, end: percent),
                duration: const Duration(milliseconds: 600),
                builder: (context, value, _) {
                  return CustomContainer(
                    width: constraints.maxWidth,
                    height: height ?? context.h(10),
                    radius: context.radius(10),
                    padding: EdgeInsets.zero,
                    color: AppColors.backGroundColor,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(context.radius(10)),
                      child: LinearPercentIndicator(
                        padding: EdgeInsets.zero,
                        width: constraints.maxWidth,
                        lineHeight: height ?? context.h(10),
                        percent: value,
                        backgroundColor: AppColors.backGroundColor,
                        progressColor: AppColors.pimaryColor,
                        barRadius: Radius.circular(context.radius(10)),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
