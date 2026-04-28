import 'package:flutter/material.dart';
import 'package:looklabs/Features/Widget/ai_product_detail_body.dart';
import 'package:looklabs/Features/Widget/app_bar_container.dart';
 import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';

class SkinProductDetailScreen extends StatelessWidget {
  const SkinProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    Map<String, dynamic>? api;
    if (args is Map) {
      api = Map<String, dynamic>.from(args);
    }
    final data = AiProductApiFields.fromMap(api);

    return Scaffold(
      backgroundColor: AppColors.backGroundColor,
      // bottomNavigationBar: Padding(
      //   padding: EdgeInsetsGeometry.only(
      //     top: context.sh(5),
      //     left: context.sw(20),
      //     right: context.sw(20),
      //     bottom: context.sh(30),
      //   ),
      //   child: CustomButton(
      //     text: 'Add to Routine',
      //     color: AppColors.pimaryColor,
      //     isEnabled: true,
      //     onTap: () {},
      //   ),
      // ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: context.paddingSymmetricR(horizontal: 20),
              child: AppBarContainer(
                title: "Product Details",

                onTap: () => Navigator.pop(context),
              ),
            ),
            Expanded(child: AiProductDetailBody(data: data)),
          ],
        ),
      ),
    );
  }
}
