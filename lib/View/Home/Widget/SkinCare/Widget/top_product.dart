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
            SizedBox(height: context.h(8)),
            Container(
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
                          borderRadius: BorderRadius.circular(
                            context.radius(10),
                          ),
                          border: Border.all(
                            color: AppColors.backGroundColor,
                            width: context.w(1.5),
                          ),
                          color: AppColors.backGroundColor,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.customContainerColorUp
                                  .withOpacity(0.4),
                              offset: const Offset(5, 5),
                              blurRadius: 5,
                            ),
                            BoxShadow(
                              color: AppColors.customContinerColorDown
                                  .withOpacity(0.4),
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
                          borderRadius: BorderRadius.circular(
                            context.radius(10),
                          ),
                          border: Border.all(
                            color: AppColors.backGroundColor,
                            width: context.w(1.5),
                          ),
                          color: AppColors.backGroundColor,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.customContainerColorUp
                                  .withOpacity(0.4),
                              offset: const Offset(5, 5),
                              blurRadius: 5,
                            ),
                            BoxShadow(
                              color: AppColors.customContinerColorDown
                                  .withOpacity(0.4),
                              offset: const Offset(-5, -5),
                              blurRadius: 5,
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
                    ],
                  ),
                  SizedBox(height: context.h(12)),
                  NormalText(
                    titleText: 'title',
                    titleColor: AppColors.subHeadingColor,
                    titleSize: context.text(16),
                    titleWeight: FontWeight.w600,
                    sizeBoxheight: context.h(12),
                    subText: 'hhhhhhhhhhhhhhh',
                    subColor: AppColors.subHeadingColor,
                    subSize: context.text(12),
                    subWeight: FontWeight.w500,
                  ),
                  SizedBox(height: context.h(12)),
                  Row(
                    children: List.generate(
                      topProductViewModel.scalpTags.length,
                      (index) {
                        return PlanContainer(
                          isSelected: false,
                          onTap: () {},
                          child: NormalText(
                            titleText: topProductViewModel.scalpTags[index],
                            titleColor: AppColors.subHeadingColor,
                            titleSize: context.text(10),
                            titleWeight: FontWeight.w600,
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: context.h(12)),
                  PlanContainer(
                    isSelected: false,
                    onTap: () {},
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
            ),
            SizedBox(height: context.h(16)),

            SizedBox(height: context.h(12)),
          ],
        ),
      ),
    );
  }
}
