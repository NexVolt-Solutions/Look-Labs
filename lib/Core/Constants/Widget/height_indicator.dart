import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:looklabs/Core/Constants/Widget/normal_text.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';

class HeightIndicater extends StatelessWidget {
  final String? title;
  final String? per;
  final onChanged;
  //  ValueChanged<double>

  const HeightIndicater({
    super.key,
    this.onChanged,
    required this.title,
    this.per,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        NormalText(
          titleText: title ?? '',
          titleSize: context.text(14),
          titleWeight: FontWeight.w600,
          titleColor: AppColors.subHeadingColor,
        ),
        SizedBox(height: context.h(16)),

        Row(
          children: [
            // 🔹 Slider takes remaining width
            Expanded(
              child: Container(
                height: context.h(20),
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
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Active bar
                    Container(
                      height: context.h(20),
                      width: context.w(200), // later dynamic
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(context.radius(10)),
                        color: AppColors.pimaryColor,
                      ),
                    ),

                    // Thumb
                    Positioned(
                      left: context.w(180),
                      top: -context.h(4),
                      child: Container(
                        height: context.h(28),
                        width: context.w(44),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            context.radius(76),
                          ),
                          color: AppColors.backGroundColor,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.customContainerColorUp
                                  .withOpacity(0.4),
                              offset: const Offset(2.5, 2.5),
                              blurRadius: 0,
                            ),
                            BoxShadow(
                              color: AppColors.customContinerColorDown
                                  .withOpacity(0.4),
                              offset: const Offset(-2.5, -2.5),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            '|||',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              color: AppColors.pimaryColor,
                              fontSize: context.text(15),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(width: context.w(8)),

            // 🔹 Percentage text
            NormalText(
              titleText: per ?? '',
              titleSize: context.text(12),
              titleWeight: FontWeight.w600,
              titleColor: AppColors.subHeadingColor,
            ),
          ],
        ),
      ],
    );
  }
}
