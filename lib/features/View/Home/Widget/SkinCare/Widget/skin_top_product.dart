import 'package:flutter/material.dart';
import 'package:looklabs/Features/Widget/app_bar_container.dart';
import 'package:looklabs/Features/Widget/normal_text.dart';
import 'package:looklabs/Features/Widget/product_widget.dart';
import 'package:looklabs/Core/Constants/app_assets.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Core/Routes/routes_name.dart';
import 'package:looklabs/Features/ViewModel/skin_top_product_view_model.dart';
import 'package:provider/provider.dart';

class SkinTopProduct extends StatefulWidget {
  const SkinTopProduct({super.key});

  @override
  State<SkinTopProduct> createState() => _SkinTopProductState();
}

class _SkinTopProductState extends State<SkinTopProduct> {
  @override
  Widget build(BuildContext context) {
    final skinTopProductViewModel = Provider.of<SkinTopProductViewModel>(
      context,
    );
    return Scaffold(
      backgroundColor: AppColors.backGroundColor,

      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: context.paddingSymmetricR(horizontal: 20),
              child: AppBarContainer(
                title: 'Recommended Products',
                onTap: () => Navigator.pop(context),
                showHeart: true,
                onHeartTap: () {},
              ),
            ),
            SizedBox(height: context.sh(20)),

            Padding(
              padding: context.paddingSymmetricR(horizontal: 20),
              child: NormalText(
                crossAxisAlignment: CrossAxisAlignment.start,
                titleText: 'Curated for your Skin & scalp concerns',
                titleSize: context.sp(18),
                titleWeight: FontWeight.w600,
                titleColor: AppColors.headingColor,
              ),
            ),

            SizedBox(height: context.sh(20)),

            Expanded(
              child: ListView.builder(
                padding: context.paddingSymmetricR(horizontal: 20),
                itemCount: skinTopProductViewModel.productData.length,
                itemBuilder: (context, index) {
                  final product = skinTopProductViewModel.productData[index];

                  final bool isFirstIndex = index == 0;

                  return ProductWidget(
                    index: index,
                    title: product['title'],
                    disc: product['description'],

                    /// 🔹 ICON (same for all)
                    icon1: product['rightIcon'],

                    /// 🔹 SECOND ICON (only index 1 & 2)
                    secondIcon: isFirstIndex ? null : AppAssets.sunIcon,

                    /// 🔹 TEXT (only index 0)
                    text: isFirstIndex ? product['rightText'] : null,

                    /// 🔹 GRADIENT (always ON)
                    showGradient: isFirstIndex ? false : true,

                    viewmodel: skinTopProductViewModel,

                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        RoutesName.SkinProductDetailScreen,
                        arguments: product['title'],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
