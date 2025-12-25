import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class TextAndIndectorContiner extends StatelessWidget {
  const TextAndIndectorContiner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.h(132),
      width: context.w(158),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(context.radius(10)),
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
            'Density',
            style: TextStyle(
              fontSize: context.text(16.32),
              fontWeight: FontWeight.w600,
              color: AppColors.notSelectedColor,
            ),
          ),
          SizedBox(height: context.h(10)),
          Text(
            'Height',
            style: TextStyle(
              fontSize: context.text(16.32),
              fontWeight: FontWeight.w600,
              color: AppColors.subHeadingColor,
            ),
          ),
          SizedBox(height: context.h(10)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              Container(
                height: context.h(10),
                width: context.w(92),
                padding: EdgeInsets.zero,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(context.radius(20)),
                  color: AppColors.backGroundColor,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.customContainerColorUp.withOpacity(0.4),
                      offset: const Offset(5, 5),
                      blurRadius: 5,
                      inset: true,
                    ),
                    BoxShadow(
                      color: AppColors.customContinerColorDown.withOpacity(0.4),
                      offset: const Offset(-5, -5),
                      blurRadius: 5,
                      inset: true,
                    ),
                  ],
                ),

                /// 🔹 Progress inside 40 height
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(context.radius(20)),
                  child: LinearPercentIndicator(
                    padding: EdgeInsets.zero,
                    lineHeight: context.h(8),
                    percent: 0.5,
                    backgroundColor: AppColors.backGroundColor,
                    progressColor: AppColors.pimaryColor,
                    barRadius: Radius.circular(context.radius(20)),
                  ),
                ),
              ),
              SizedBox(width: context.w(8)),
              Text(
                '5%',
                style: TextStyle(
                  fontSize: context.text(12),
                  fontWeight: FontWeight.w600,
                  color: AppColors.subHeadingColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
