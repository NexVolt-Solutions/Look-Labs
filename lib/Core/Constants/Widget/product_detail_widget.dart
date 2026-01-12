import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:looklabs/Core/Constants/Widget/normal_text.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/ViewModel/top_product_view_model.dart';

class ProductDetailWidget extends StatelessWidget {
  const ProductDetailWidget({
    super.key,
    required this.topProductViewModel,
    required this.title,
    required this.description,
    required this.leftIcon,
    required this.rightIcon,
    this.rightText,
    required this.scalpTags,
    required this.onViewDetails,
  });
  final String title;
  final String description;

  final String leftIcon; // drop icon (same)
  final String rightIcon; // night / day etc
  final String? rightText; // PM / AM / null

  final List<String> scalpTags;

  final VoidCallback onViewDetails;

  final TopProductViewModel topProductViewModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// 🔹 Top Icons Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            /// Left Icon (same but from ViewModel)
            GestureDetector(
              onTap: () {},
              child: Container(
                padding: context.padSym(h: 4, v: 4),
                decoration: _boxDecoration(context),
                child: SvgPicture.asset(
                  leftIcon,
                  height: context.h(24),
                  width: context.w(24),
                ),
              ),
            ),

            /// Right Icon + Optional Text
            GestureDetector(
              onTap: () {},
              child: Container(
                padding: context.padSym(h: 6, v: 6),
                decoration: _boxDecoration(context),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      rightIcon,
                      height: context.h(24),
                      width: context.w(24),
                      color: AppColors.iconColor,
                    ),
                    if (rightText != null) ...[
                      SizedBox(width: context.w(4)),
                      NormalText(
                        titleText: rightText!,
                        titleColor: AppColors.iconColor,
                        titleSize: context.text(10),
                        titleWeight: FontWeight.w500,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: context.h(12)),

        /// 🔹 Title & Description (from ViewModel)
        NormalText(
          titleText: title,
          titleColor: AppColors.subHeadingColor,
          titleSize: context.text(16),
          titleWeight: FontWeight.w500,
          sizeBoxheight: context.h(12),
          subText: description,
          subColor: AppColors.subHeadingColor,
          subSize: context.text(12),
          subWeight: FontWeight.w600,
        ),

        SizedBox(height: context.h(12)),

        /// 🔹 Scalp Tags (List)
        Row(
          children: List.generate(topProductViewModel.scalpTags.length, (
            index,
          ) {
            return Padding(
              padding: EdgeInsets.only(
                right: index == topProductViewModel.scalpTags.length - 1
                    ? 0
                    : context.w(8),
              ),
              child: Container(
                padding: context.padSym(h: 8, v: 6),
                decoration: _boxDecoration(context),
                child: NormalText(
                  titleText: scalpTags[index],
                  titleColor: AppColors.subHeadingColor,
                  titleSize: context.text(10),
                  titleWeight: FontWeight.w600,
                ),
              ),
            );
          }),
        ),

        SizedBox(height: context.h(12)),

        /// 🔹 View Details Button (Callback from ViewModel)
        GestureDetector(
          onTap: onViewDetails,
          child: Container(
            padding: context.padSym(h: 103, v: 10),
            decoration: _boxDecoration(context),
            child: Row(
              children: [
                NormalText(
                  titleText: 'View Details',
                  titleColor: AppColors.subHeadingColor,
                  titleSize: context.text(14),
                  titleWeight: FontWeight.w500,
                ),
                SizedBox(width: context.w(4)),
                const Icon(Icons.arrow_forward_ios, size: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  BoxDecoration _boxDecoration(BuildContext context) {
    return BoxDecoration(
      color: AppColors.backGroundColor,
      borderRadius: BorderRadius.circular(context.radius(10)),
      border: Border.all(color: AppColors.white.withOpacity(0.2), width: 1.5),
      boxShadow: [
        BoxShadow(
          color: AppColors.arrowBlurColor,
          offset: const Offset(5, 5),
          blurRadius: 5,
        ),
        BoxShadow(
          color: AppColors.customContinerColorDown,
          offset: const Offset(-5, -5),
          blurRadius: 30,
        ),
      ],
    );
  }
}
