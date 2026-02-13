import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:looklabs/Features/Widget/app_bar_container.dart';
import 'package:looklabs/Features/Widget/custom_button.dart';
import 'package:looklabs/Features/Widget/normal_text.dart';
import 'package:looklabs/Features/Widget/plan_container.dart';
import 'package:looklabs/Features/Widget/simple_check_box.dart';
import 'package:looklabs/Features/Widget/user_info.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Core/Routes/routes_name.dart';
import 'package:looklabs/Features/ViewModel/purchase_view_model.dart';
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
      bottomNavigationBar: Padding(
        padding: context.padSym(h: 20, v: 30),
        child: CustomButton(
          isEnabled: true,
          onTap: () =>
              Navigator.pushNamed(context, RoutesName.PaymentDetailsScreen),
          text: 'Next',
          color: AppColors.buttonColor,
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: context.padSym(h: 20),
          clipBehavior: Clip.hardEdge,
          children: [
            AppBarContainer(
              title: 'Purchase',
              onTap: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(height: context.h(24)),
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
            SizedBox(height: context.h(8)),
            ...List.generate(purchaseViewModel.purchaseCardData.length, (
              index,
            ) {
              final plan = purchaseViewModel.purchaseCardData[index];
              final isSelected = plan['isSelected'] as bool;
              return PlanContainer(
                isSelected: isSelected,
                margin: context.padSym(v: 12),
                padding: context.padSym(h: 24, v: 12),
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
