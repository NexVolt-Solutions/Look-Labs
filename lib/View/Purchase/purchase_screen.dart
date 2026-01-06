import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:looklabs/Core/Constants/Widget/app_bar_container.dart';
import 'package:looklabs/Core/Constants/Widget/custom_button.dart';
import 'package:looklabs/Core/Constants/Widget/normal_text.dart';
import 'package:looklabs/Core/Constants/Widget/plan_container.dart';
import 'package:looklabs/Core/Constants/Widget/simple_check_box.dart';
import 'package:looklabs/Core/Constants/Widget/user_info.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Core/utils/Routes/routes_name.dart';
import 'package:looklabs/ViewModel/purchase_view_model.dart';
import 'package:provider/provider.dart';

class PurchaseScreen extends StatefulWidget {
  const PurchaseScreen({super.key});

  @override
  State<PurchaseScreen> createState() => _PurchaseScreenState();
}

class _PurchaseScreenState extends State<PurchaseScreen> {
  @override
  Widget build(BuildContext context) {
    final purchaseViewModel = Provider.of<PurchaseViewModel>(context);
    // final isSelected = purchaseViewModel.isPlanSelected(index);

    return Scaffold(
      backgroundColor: AppColors.backGroundColor,
      bottomNavigationBar: CustomButton(
        isEnabled: true,
        onTap: () => Navigator.pushNamed(context, RoutesName.AuthScreen),
        text: 'Next',
        color: AppColors.buttonColor,
        padding: context.padSym(v: 17),
      ),
      body: SafeArea(
        child: ListView(
          padding: context.padSym(h: 20),
          clipBehavior: Clip.hardEdge,
          children: [
            AppBarContainer(title: 'Purchase'),
            SizedBox(height: context.h(30.89)),
            NormalText(
              crossAxisAlignment: CrossAxisAlignment.start,
              titleText: 'User Information',
              titleSize: context.text(20),
              titleWeight: FontWeight.w600,
              titleColor: AppColors.subHeadingColor,
            ),
            SizedBox(height: context.h(20)),
            ...List.generate(
              purchaseViewModel.userInfData.length,
              (index) => UserInfo(
                name: purchaseViewModel.userInfData[index]['name'],
                subName: purchaseViewModel.userInfData[index]['subName'],
              ),
            ),
            SizedBox(height: context.h(20)),
            NormalText(
              crossAxisAlignment: CrossAxisAlignment.start,
              titleText: 'Select Payment Method',
              titleSize: context.text(18),
              titleWeight: FontWeight.w600,
              titleColor: AppColors.subHeadingColor,
            ),
            SizedBox(height: context.h(20)),
            ...List.generate(purchaseViewModel.purchaseCardData.length, (
              index,
            ) {
              final plan = purchaseViewModel.purchaseCardData[index];
              final isSelected = plan['isSelected'] as bool;
              return PlanContainer(
                isSelected: isSelected,
                // padding: context.padSym(h: 24, v: 12),
                onTap: () => purchaseViewModel.selectPayment(index),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.asset(plan['image']),
                        SizedBox(width: context.w(12)),
                        Text(
                          plan['title'],
                          style: TextStyle(
                            fontSize: context.text(16),
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? AppColors.subHeadingColor
                                : AppColors.notSelectedColor,
                          ),
                        ),
                      ],
                    ),
                    SimpleCheckBox(
                      isSelected: isSelected,
                      onTap: () => purchaseViewModel.selectPayment(index),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
