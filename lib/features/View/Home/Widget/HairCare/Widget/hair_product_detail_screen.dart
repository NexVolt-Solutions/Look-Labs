import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:looklabs/Features/Widget/app_bar_container.dart';
import 'package:looklabs/Features/Widget/custom_button.dart';
import 'package:looklabs/Features/Widget/normal_text.dart';
import 'package:looklabs/Features/Widget/plan_container.dart';
import 'package:looklabs/Core/Constants/app_assets.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Features/ViewModel/recommended_product_view_model.dart';
import 'package:provider/provider.dart';

class HairProductDetailScreen extends StatefulWidget {
  const HairProductDetailScreen({super.key});

  @override
  State<HairProductDetailScreen> createState() =>
      _HairProductDetailScreenState();
}

class _HairProductDetailScreenState extends State<HairProductDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<RecommendedProductViewModel>(context);
    final String title = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      backgroundColor: AppColors.backGroundColor,

      bottomNavigationBar: Padding(
        padding: EdgeInsetsGeometry.only(
          top: context.h(5),
          left: context.w(20),
          right: context.w(20),
          bottom: context.h(30),
        ),
        child: CustomButton(
          text: 'Add to Routine',
          color: AppColors.pimaryColor,
          isEnabled: true,
          onTap: () {
            // Navigator.pushNamed(context, RoutesName.ReviewScansScreen);
          },
        ),
      ),

      body: SafeArea(
        child: ListView(
          padding: context.padSym(h: 20),
          children: [
            AppBarContainer(
              title: 'Recommendedssss Product',
              onTap: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(height: context.h(20)),

            // Product Title
            NormalText(
              crossAxisAlignment: CrossAxisAlignment.start,
              titleText: title,
              titleSize: context.text(18),
              titleWeight: FontWeight.w600,
              titleColor: AppColors.headingColor,
            ),

            // Product Image
            SizedBox(
              height: context.h(220),
              width: context.w(220),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  AppAssets.shampoo,
                  height: context.h(220),
                  width: context.w(220),
                  fit: BoxFit.scaleDown,
                ),
              ),
            ),
            SizedBox(height: context.h(20)),

            // Product Overview
            NormalText(
              crossAxisAlignment: CrossAxisAlignment.start,
              titleText: 'Product Overview',
              titleSize: context.text(18),
              titleWeight: FontWeight.w600,
              titleColor: AppColors.headingColor,
              sizeBoxheight: context.h(12),
              subText:
                  'Oil-Control Shampoo is a gentle, scalp-balancing cleanser designed to remove excess oil without stripping natural moisture.'
                  'It helps keep the scalp fresh, reduces greasiness, and supports a clean environment for healthy hair growth.'
                  'This product is AI-recommended based on your scalp analysis and detected concerns.',
              subSize: context.text(12),
              subColor: AppColors.subHeadingColor,
              subWeight: FontWeight.w400,
            ),
            SizedBox(height: context.h(12)),
            NormalText(
              crossAxisAlignment: CrossAxisAlignment.start,
              titleText: 'How to Use:',
              titleSize: context.text(18),
              titleWeight: FontWeight.w600,
              titleColor: AppColors.headingColor,
              sizeBoxheight: context.h(12),
            ),
            ...List.generate(vm.usageSteps.length, (index) {
              return Padding(
                padding: EdgeInsets.only(bottom: context.h(6)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '• ', // Dot bullet
                      style: TextStyle(
                        fontSize: context.text(12),
                        fontWeight: FontWeight.w500,
                        color: AppColors.subHeadingColor,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        vm.usageSteps[index],
                        style: TextStyle(
                          fontSize: context.text(12),
                          fontWeight: FontWeight.w400,
                          color: AppColors.subHeadingColor,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
            SizedBox(height: context.h(12)),
            NormalText(
              crossAxisAlignment: CrossAxisAlignment.start,
              titleText: 'When to Use:',
              titleSize: context.text(18),
              titleWeight: FontWeight.w600,
              titleColor: AppColors.headingColor,
              sizeBoxheight: context.h(12),
            ),
            ...List.generate(1, (index) {
              return Padding(
                padding: EdgeInsets.only(bottom: context.h(6)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '• ', // Dot bullet
                      style: TextStyle(
                        fontSize: context.text(12),
                        fontWeight: FontWeight.w500,
                        color: AppColors.subHeadingColor,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'AM or PM (during hair wash)',
                        style: TextStyle(
                          fontSize: context.text(12),
                          fontWeight: FontWeight.w400,
                          color: AppColors.subHeadingColor,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
            SizedBox(height: context.h(12)),
            Row(
              children: [
                SvgPicture.asset(
                  AppAssets.starIcon,
                  height: context.h(24),
                  width: context.w(24),
                  color: AppColors.pimaryColor,
                  fit: BoxFit.scaleDown,
                ),
                SizedBox(width: context.w(8)),
                NormalText(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  titleText: 'Don’t Use With',
                  titleSize: context.text(18),
                  titleWeight: FontWeight.w600,
                  titleColor: AppColors.headingColor,
                ),
              ],
            ),
            Wrap(
              spacing: context.w(6),
              runSpacing: context.h(6),

              children: List.generate(4, (index) {
                return PlanContainer(
                  isSelected: false,
                  onTap: () {},
                  child: NormalText(
                    titleText: 'Button1',
                    titleColor: AppColors.subHeadingColor,
                    titleSize: context.text(10),
                    titleWeight: FontWeight.w600,
                  ),
                );
              }),
            ),

            SizedBox(height: context.h(12)),
          ],
        ),
      ),
    );
  }
}
