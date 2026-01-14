import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:looklabs/Core/Constants/Widget/normal_text.dart';
import 'package:looklabs/Core/Constants/Widget/plan_container.dart';
import 'package:looklabs/Core/Constants/app_assets.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/ViewModel/top_product_view_model.dart';

class ProductWidget extends StatelessWidget {
  final title;
  final disc;
  final onTap;
  final icon1;
  final icon2;
  final text;
  final index;

  const ProductWidget({
    super.key,
    required this.topProductViewModel,
    this.title,
    this.disc,
    this.onTap,
    this.icon1,
    this.icon2,
    this.text,
    this.index,
  });

  final TopProductViewModel topProductViewModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.w(12),
        vertical: context.h(12),
      ),
      margin: context.padSym(v: 12),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: context.padSym(h: 4, v: 4),
                // height: context.h(40),
                // width: context.w(40),
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
                    ),
                    BoxShadow(
                      color: AppColors.customContinerColorDown.withOpacity(0.4),
                      offset: const Offset(-5, -5),
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Center(
                  child: SvgPicture.asset(
                    AppAssets.dropIcon,
                    height: context.h(24),
                    width: context.w(24),
                    fit: BoxFit.scaleDown,
                  ),
                ),
              ),
              Container(
                padding: context.padSym(h: 6, v: 6),
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
                    ),
                    BoxShadow(
                      color: AppColors.customContinerColorDown.withOpacity(0.4),
                      offset: const Offset(-5, -5),
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      icon1,
                      height: context.h(24),
                      width: context.w(24),
                      color: AppColors.iconColor,
                      fit: BoxFit.scaleDown,
                    ),
                    NormalText(
                      titleText: text,
                      titleColor: AppColors.iconColor,
                      titleSize: context.text(10),
                      titleWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: context.h(12)),
          NormalText(
            titleText: title,
            titleColor: AppColors.subHeadingColor,
            titleSize: context.text(16),
            titleWeight: FontWeight.w600,
            sizeBoxheight: context.h(12),
            subText: disc,
            subColor: AppColors.subHeadingColor,
            subSize: context.text(12),
            subWeight: FontWeight.w500,
          ),
          SizedBox(height: context.h(12)),
          Wrap(
            spacing: context.w(6),
            runSpacing: context.h(6),
            children: List.generate(
              topProductViewModel.productData[index]['buttonText'].length,
              (btnIndex) {
                return PlanContainer(
                  isSelected: false,
                  onTap: () {},
                  child: NormalText(
                    titleText: topProductViewModel
                        .productData[index]['buttonText'][btnIndex],
                    titleColor: AppColors.subHeadingColor,
                    titleSize: context.text(10),
                    titleWeight: FontWeight.w600,
                  ),
                );
              },
            ),
          ),

          PlanContainer(
            isSelected: topProductViewModel.selectedIndex == index,
            onTap: () {
              topProductViewModel.selectProduct(index);
              onTap?.call();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                NormalText(
                  titleText: 'View Details',
                  titleColor: AppColors.subHeadingColor,
                  titleSize: context.text(14),
                  titleWeight: FontWeight.w500,
                ),
                SizedBox(width: context.w(4)),
                Icon(Icons.arrow_forward_ios, size: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
