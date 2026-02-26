import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:looklabs/Features/Widget/app_bar_container.dart';
import 'package:looklabs/Features/Widget/custom_button.dart';
import 'package:looklabs/Features/Widget/normal_text.dart';
import 'package:looklabs/Features/Widget/plan_container.dart';
import 'package:looklabs/Features/Widget/simple_check_box.dart';
import 'package:looklabs/Features/Widget/user_info.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/app_text.dart';
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
        padding: context.paddingSymmetricR(horizontal: 20, vertical: 30),
        child: CustomButton(
          isEnabled: true,
          onTap: () =>
              Navigator.pushNamed(context, RoutesName.PaymentDetailsScreen),
          text: AppText.next,
          color: AppColors.buttonColor,
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: context.paddingSymmetricR(horizontal: 20),
          clipBehavior: Clip.hardEdge,
          children: [
            AppBarContainer(
              title: AppText.purchase,
              onTap: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(height: context.sh(24)),
            NormalText(
              crossAxisAlignment: CrossAxisAlignment.start,
              titleText: AppText.userInformation,
              titleSize: context.sp(20),
              titleWeight: FontWeight.w600,
              titleColor: AppColors.subHeadingColor,
            ),
            SizedBox(height: context.sh(20)),
            ...List.generate(
              purchaseViewModel.userInfData.length,
              (index) => UserInfo(
                name: purchaseViewModel.userInfData[index]['name'],
                subName: purchaseViewModel.userInfData[index]['subName'],
              ),
            ),
            SizedBox(height: context.sh(20)),
            NormalText(
              crossAxisAlignment: CrossAxisAlignment.start,
              titleText: AppText.selectPaymentMethod,
              titleSize: context.sp(18),
              titleWeight: FontWeight.w600,
              titleColor: AppColors.subHeadingColor,
            ),
            SizedBox(height: context.sh(8)),
            ...List.generate(purchaseViewModel.purchaseCardData.length, (
              index,
            ) {
              final plan = purchaseViewModel.purchaseCardData[index];
              final isSelected = plan['isSelected'] as bool;
              return PlanContainer(
                isSelected: isSelected,
                margin: context.paddingSymmetricR(vertical: 12),
                padding: context.paddingSymmetricR(horizontal: 24, vertical: 12),
                onTap: () => purchaseViewModel.selectPayment(index),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.asset(plan['image']),
                        SizedBox(width: context.sw(12)),
                        Text(
                          plan['title'],
                          style: TextStyle(
                            fontSize: context.sp(16),
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
