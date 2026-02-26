import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:looklabs/Features/Widget/normal_text.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';

class ScanFoodWidget extends StatelessWidget {
  final String? text;
  final String? icon;
  final onTap;

  const ScanFoodWidget({super.key, this.text, this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: context.sh(93),
          width: context.sw(120),
          // padding: context.paddingSymmetricR(horizontal: 21, vertical: 12),
          margin: EdgeInsets.only(right: context.sw(20), bottom: context.sh(12)),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(context.radiusR(16)),
            border: Border.all(color: AppColors.white, width: context.sw(1.5)),
            color: AppColors.white,
            boxShadow: [
              BoxShadow(
                color: AppColors.customContinerColorDown.withOpacity(0.4),
                offset: const Offset(5, 5),
                blurRadius: 20,
              ),
              BoxShadow(
                color: AppColors.customContinerColorDown.withOpacity(0.4),
                offset: const Offset(-5, -5),
                blurRadius: 20,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: context.sh(28),
                width: context.sw(28),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(context.radiusR(10)),
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
                child: SvgPicture.asset(icon ?? '', fit: BoxFit.scaleDown),
              ),
              SizedBox(height: context.sh(15)),
              NormalText(
                titleText: text ?? '',
                titleSize: context.sp(14),
                titleWeight: FontWeight.w600,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
