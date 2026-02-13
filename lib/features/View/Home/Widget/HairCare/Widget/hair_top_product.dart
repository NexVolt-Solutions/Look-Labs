import 'package:flutter/material.dart';
import 'package:looklabs/features/Widget/app_bar_container.dart';
import 'package:looklabs/features/Widget/normal_text.dart';
import 'package:looklabs/features/Widget/product_widget.dart';
import 'package:looklabs/Core/Constants/app_assets.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Core/utils/Routes/routes_name.dart';
import 'package:looklabs/features/ViewModel/hair_top_product_view_model.dart';
import 'package:provider/provider.dart';

class HairTopProduct extends StatefulWidget {
  const HairTopProduct({super.key});

  @override
  State<HairTopProduct> createState() => _HairTopProductState();
}

class _HairTopProductState extends State<HairTopProduct> {
  @override
  Widget build(BuildContext context) {
    final hairTopProductViewModel = Provider.of<HairTopProductViewModel>(
      context,
    );
    return Scaffold(
      backgroundColor: AppColors.backGroundColor,

      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: context.padSym(h: 20),
              child: AppBarContainer(
                title: 'Recommended Products',
                onTap: () => Navigator.pop(context),
                showHeart: true,
                onHeartTap: () {},
              ),
            ),
            SizedBox(height: context.h(20)),

            Padding(
              padding: context.padSym(h: 20),
              child: NormalText(
                crossAxisAlignment: CrossAxisAlignment.start,
                titleText: 'Curated for your hair & scalp concerns',
                titleSize: context.text(18),
                titleWeight: FontWeight.w600,
                titleColor: AppColors.headingColor,
              ),
            ),

            SizedBox(height: context.h(20)),

            Expanded(
              child: ListView.builder(
                padding: context.padSym(h: 20),
                itemCount: hairTopProductViewModel.productData.length,
                itemBuilder: (context, index) {
                  final product = hairTopProductViewModel.productData[index];

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

                    viewmodel: hairTopProductViewModel,

                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        RoutesName.HairProductDetailScreen,
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

    // final hairTopProductViewModel = Provider.of<HairTopProductViewModel>(
    //   context,
    // );
    // return Scaffold(
    //   backgroundColor: AppColors.backGroundColor,

    //   body: SafeArea(
    //     child: Column(
    //       children: [
    //         Padding(
    //           padding: context.padSym(h: 20),
    //           child: AppBarContainer(
    //             title: 'Recommended Products',
    //             onTap: () => Navigator.pop(context),
    //           ),
    //         ),
    //         SizedBox(height: context.h(20)),
    //         Padding(
    //           padding: context.padSym(h: 20),
    //           child: NormalText(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             titleText: 'Curated for your hair & scalp concerns',
    //             titleSize: context.text(18),
    //             titleWeight: FontWeight.w600,
    //             titleColor: AppColors.headingColor,
    //           ),
    //         ),
    //         SizedBox(height: context.h(20)),

    //         Expanded(
    //           child: ListView.builder(
    //             padding: context.padSym(h: 20),
    //             itemCount: hairTopProductViewModel.HairproductData.length,
    //             itemBuilder: (context, index) {
    //               final product =
    //                   hairTopProductViewModel.HairproductData[index];

    //               final bool isFirstIndex = index == 0;

    //               return ProductWidget(
    //                 index: index,
    //                 title: product['title'],
    //                 disc: product['description'],

    //                 /// 🔹 ICON (same for all)
    //                 icon1: product['rightIcon'],

    //                 /// 🔹 SECOND ICON (only index 1 & 2)
    //                 secondIcon: isFirstIndex ? null : AppAssets.sunIcon,

    //                 /// 🔹 TEXT (only index 0)
    //                 text: isFirstIndex ? product['rightText'] : null,

    //                 /// 🔹 GRADIENT (always ON)
    //                 showGradient: isFirstIndex ? false : true,

    //                 viewmodel: hairTopProductViewModel,

    //                 onTap: () {
    //                   Navigator.pushNamed(
    //                     context,
    //                     RoutesName.HairProductScreen,
    //                     arguments: product['title'],
    //                   );
    //                 },
    //               );
    //             },
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}
