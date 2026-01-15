import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:flutter_svg/svg.dart';
import 'package:looklabs/Core/Constants/Widget/normal_text.dart';
import 'package:looklabs/Core/Constants/Widget/plan_container.dart';
import 'package:looklabs/Core/Constants/app_assets.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';

class ProductWidget extends StatelessWidget {
  final String? title;
  final String? disc;
  final VoidCallback? onTap;
  final String? icon1;
  final String? text;
  final int index;

  final dynamic viewmodel;

  const ProductWidget({
    super.key,
    required this.index,
    this.title,
    this.disc,
    this.onTap,
    this.icon1,
    this.text,
    this.viewmodel,
  });

  @override
  Widget build(BuildContext context) {
    /// ✅ Active ViewModel (Hair ya Skin)

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.w(12),
        vertical: context.h(12),
      ),
      margin: context.padSym(v: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(context.radius(10)),
        color: AppColors.backGroundColor,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔹 HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: context.padSym(h: 4, v: 4),
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
                child: SvgPicture.asset(
                  AppAssets.dropIcon,
                  height: context.h(24),
                  width: context.w(24),
                ),
              ),
              Container(
                padding: context.padSym(h: 6, v: 6),
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
                child: Row(
                  children: [
                    SvgPicture.asset(
                      icon1 ?? '',
                      height: context.h(20),
                      width: context.w(20),
                    ),
                    SizedBox(width: context.w(4)),
                    NormalText(
                      titleText: text,
                      titleSize: context.text(10),
                      titleColor: AppColors.iconColor,
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: context.h(12)),

          /// 🔹 TITLE + DESC
          NormalText(
            titleText: title,
            subText: disc,
            titleSize: context.text(16),
            subSize: context.text(12),
            titleWeight: FontWeight.w600,
            subWeight: FontWeight.w500,
          ),

          SizedBox(height: context.h(12)),

          /// 🔹 BUTTON TAGS
          Wrap(
            spacing: context.w(6),
            runSpacing: context.h(6),
            children: List.generate(viewmodel.productData.length.toInt(), (
              btnIndex,
            ) {
              return PlanContainer(
                isSelected: false,
                onTap: () {},
                child: NormalText(
                  titleText:
                      viewmodel!.productData[index]['buttonText'][btnIndex],
                  titleSize: context.text(10),
                  titleWeight: FontWeight.w600,
                ),
              );
            }),
          ),

          SizedBox(height: context.h(12)),

          /// 🔹 VIEW DETAILS
          PlanContainer(
            isSelected: viewmodel?.selectedIndex == index,
            onTap: () {
              viewmodel?.selectProduct(index);
              onTap?.call();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('View Details'),
                SizedBox(width: 4),
                Icon(Icons.arrow_forward_ios, size: 18),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
