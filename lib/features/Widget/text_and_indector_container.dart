import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:looklabs/features/Widget/linear_slider_widget.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';

class TextAndIndectorContiner extends StatelessWidget {
  final String? title;
  final String? subTitle;
  final String? pers;
  final double? progress;
  const TextAndIndectorContiner({
    super.key,
    this.title,
    this.subTitle,
    this.pers,
    this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: context.padSym(h: 25, v: 13),
      margin: context.padSym(h: 8, v: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(context.radius(16)),
        color: AppColors.backGroundColor,
        boxShadow: [
          BoxShadow(
            color: AppColors.customContainerColorUp.withOpacity(0.4),
            offset: const Offset(5, 5),
            blurRadius: 5,
            inset: false,
          ),
          BoxShadow(
            color: AppColors.customContinerColorDown.withOpacity(0.4),
            offset: const Offset(-5, -5),
            blurRadius: 5,
            inset: false,
          ),
        ],
      ),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title ?? '',
            style: TextStyle(
              fontSize: context.text(16.32),
              fontWeight: FontWeight.w600,
              color: AppColors.notSelectedColor,
            ),
          ),
          Text(
            subTitle ?? '',
            style: TextStyle(
              fontSize: context.text(16.32),
              fontWeight: FontWeight.w600,
              color: AppColors.subHeadingColor,
            ),
          ),
          SizedBox(height: context.h(10)),
          LinearSliderWidget(
            showTopIcon: false,
            progress: progress ?? 10,
            inset: true,
            height: context.h(8.16),
            animatedConHeight: context.h(8.16),
            showPercentage: true,
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     Expanded(
          //       child: Container(
          //         height: context.h(10),
          //         // padding: context.padSym(h: 15.3),
          //         decoration: BoxDecoration(
          //           borderRadius: BorderRadius.circular(context.radius(20)),
          //           color: AppColors.backGroundColor,
          //           boxShadow: [
          //             BoxShadow(
          //               color: AppColors.customContainerColorUp.withOpacity(
          //                 0.4,
          //               ),
          //               offset: const Offset(5, 5),
          //               blurRadius: 5,
          //               inset: true,
          //             ),
          //             BoxShadow(
          //               color: AppColors.customContinerColorDown.withOpacity(
          //                 0.4,
          //               ),
          //               offset: const Offset(-5, -5),
          //               blurRadius: 5,
          //               inset: true,
          //             ),
          //           ],
          //         ),
          //         child: ClipRRect(
          //           borderRadius: BorderRadius.circular(context.radius(20)),
          //           child: LinearPercentIndicator(
          //             padding: EdgeInsets.zero,
          //             lineHeight: context.h(8),
          //             percent: 0.5,
          //             backgroundColor: AppColors.backGroundColor,
          //             progressColor: AppColors.pimaryColor,
          //             barRadius: Radius.circular(context.radius(20)),
          //           ),
          //         ),
          //       ),
          //     ),
          //     SizedBox(width: context.w(8)),
          //     Text(
          //       '${pers}%',
          //       style: TextStyle(
          //         fontSize: context.text(12),
          //         fontWeight: FontWeight.w600,
          //         color: AppColors.subHeadingColor,
          //       ),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }
}
