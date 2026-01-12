import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:looklabs/Core/Constants/Widget/app_bar_container.dart';
import 'package:looklabs/Core/Constants/Widget/normal_text.dart';
import 'package:looklabs/Core/Constants/Widget/plan_container.dart';
import 'package:looklabs/Core/Constants/app_assets.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/ViewModel/top_product_view_model.dart';
import 'package:provider/provider.dart';

class TopProduct extends StatelessWidget {
  const TopProduct({super.key});

  @override
  Widget build(BuildContext context) {
    final topProductViewModel = Provider.of<TopProductViewModel>(context);
    return Scaffold(
      backgroundColor: AppColors.backGroundColor,

      body: SafeArea(
        child: ListView(
          padding: context.padSym(h: 20),
          children: [
            AppBarContainer(
              title: 'Recommended Products',
              onTap: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(height: context.h(20)),
            NormalText(
              crossAxisAlignment: CrossAxisAlignment.start,
              titleText: 'Curated for your hair & scalp concerns',
              titleSize: context.text(18),
              titleWeight: FontWeight.w600,
              titleColor: AppColors.headingColor,
            ),
            SizedBox(height: context.h(20)),
            PlanContainer(
              padding: context.padSym(h: 12, v: 12),
              isSelected: false,
              onTap: () {},
              child: ProductDetailWidget(
                topProductViewModel: topProductViewModel,
              ),
            ),
            SizedBox(height: context.h(16)),
            NormalText(
              crossAxisAlignment: CrossAxisAlignment.start,
              titleText: 'Saftey Tips:',
              titleSize: context.text(18),
              titleWeight: FontWeight.w600,
              titleColor: AppColors.headingColor,
            ),
            SizedBox(height: context.h(12)),
          ],
        ),
      ),
    );
  }
}

class ProductDetailWidget extends StatelessWidget {
  const ProductDetailWidget({super.key, required this.topProductViewModel});

  final TopProductViewModel topProductViewModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {},
              child: Container(
                padding: context.padSym(h: 4, v: 4),
                // height: context.h(40),
                // width: context.w(40),
                decoration: BoxDecoration(
                  color: AppColors.backGroundColor,
                  borderRadius: BorderRadius.circular(context.radius(10)),
                  border: Border.all(
                    color: AppColors.white.withOpacity(0.2),
                    width: 1.5,
                  ),
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
            ),
            GestureDetector(
              onTap: () {},
              child: Container(
                padding: context.padSym(h: 6, v: 6),
                decoration: BoxDecoration(
                  color: AppColors.backGroundColor,
                  borderRadius: BorderRadius.circular(context.radius(10)),
                  border: Border.all(
                    color: AppColors.white.withOpacity(0.2),
                    width: 1.5,
                  ),
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
                ),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      AppAssets.nightIcon,
                      height: context.h(24),
                      width: context.w(24),
                      color: AppColors.iconColor,
                      fit: BoxFit.scaleDown,
                    ),
                    NormalText(
                      titleText: 'PM',
                      titleColor: AppColors.iconColor,
                      titleSize: context.text(10),
                      titleWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: context.h(12)),
        NormalText(
          // crossAxisAlignment: CrossAxisAlignment.start,
          titleText: 'Oil-Control Shampoo',
          titleColor: AppColors.subHeadingColor,
          titleSize: context.text(16),
          titleWeight: FontWeight.w500,
          sizeBoxheight: context.h(12),
          subText: 'Controls excess oil while keeping scalp healthy',
          subColor: AppColors.subHeadingColor,
          subSize: context.text(12),
          subWeight: FontWeight.w600,
        ),
        SizedBox(height: context.h(12)),
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
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  padding: context.padSym(h: 8, v: 6),
                  decoration: BoxDecoration(
                    color: AppColors.backGroundColor,
                    borderRadius: BorderRadius.circular(context.radius(10)),
                    border: Border.all(
                      color: AppColors.white.withOpacity(0.2),
                      width: 1.5,
                    ),
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
                  ),
                  child: NormalText(
                    titleText: topProductViewModel.scalpTags[index],
                    titleColor: AppColors.subHeadingColor,
                    titleSize: context.text(10),
                    titleWeight: FontWeight.w600,
                  ),
                ),
              ),
            );
          }),
        ),
        SizedBox(height: context.h(12)),
        GestureDetector(
          onTap: () {},
          child: Container(
            padding: context.padSym(h: 103, v: 10),
            decoration: BoxDecoration(
              color: AppColors.backGroundColor,
              borderRadius: BorderRadius.circular(context.radius(10)),
              border: Border.all(
                color: AppColors.white.withOpacity(0.2),
                width: 1.5,
              ),
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
            ),
            child: Row(
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
        ),
      ],
    );
  }
}
