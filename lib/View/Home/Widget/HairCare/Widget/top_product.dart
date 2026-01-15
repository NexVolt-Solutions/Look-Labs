import 'package:flutter/material.dart';
import 'package:looklabs/Core/Constants/Widget/app_bar_container.dart';
import 'package:looklabs/Core/Constants/Widget/normal_text.dart';
import 'package:looklabs/Core/Constants/Widget/product_widget.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Core/utils/Routes/routes_name.dart';
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
        child: Column(
          children: [
            Padding(
              padding: context.padSym(h: 20),
              child: AppBarContainer(
                title: 'Recommended Products',
                onTap: () => Navigator.pop(context),
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

            SizedBox(height: context.h(12)),

            Expanded(
              child: ListView.builder(
                padding: context.padSym(h: 20),
                itemCount: topProductViewModel.productData.length,
                itemBuilder: (context, index) {
                  final product = topProductViewModel.productData[index];

                  return ProductWidget(
                    icon1: product['rightIcon'],
                    text: product['rightText'],
                    title: product['title'],
                    disc: product['description'],
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        RoutesName.HairProductScreen,
                        arguments: product['title'], // ✅ pass title
                      );
                    },

                    topProductViewModel: topProductViewModel,
                    index: index, // ✅ FIXED
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
