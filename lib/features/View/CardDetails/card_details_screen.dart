import 'package:flutter/material.dart';
import 'package:looklabs/Core/Constants/app_text.dart';
import 'package:looklabs/Features/Widget/app_bar_container.dart';
import 'package:looklabs/Features/Widget/custom_button.dart';
import 'package:looklabs/Features/Widget/neu_text_fied.dart';
import 'package:looklabs/Features/Widget/normal_text.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Core/Routes/routes_name.dart';

class CardDetailsScreen extends StatefulWidget {
  const CardDetailsScreen({super.key});

  @override
  State<CardDetailsScreen> createState() => _CardDetailsScreenState();
}

class _CardDetailsScreenState extends State<CardDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backGroundColor,
      bottomNavigationBar: Padding(
        padding: context.padSym(h: 20, v: 30),
        child: CustomButton(
          isEnabled: true,
          onTap: () => Navigator.pushNamed(context, RoutesName.PurchaseScreen),
          text: AppText.proceedToPay,
          color: AppColors.buttonColor,
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: context.padSym(h: 20),
          clipBehavior: Clip.hardEdge,
          children: [
            AppBarContainer(
              title: AppText.cardDetails,
              onTap: () => Navigator.pop(context),
            ),
            SizedBox(height: context.h(24)),
            NormalText(
              crossAxisAlignment: CrossAxisAlignment.start,
              titleText: AppText.securePaymentSetup,
              titleSize: context.text(20),
              titleWeight: FontWeight.w600,
              titleColor: AppColors.headingColor,
            ),
            SizedBox(height: context.h(20)),
            NeuTextField(
              label: AppText.nameOfCardHolder,
              obscure: true,
              validatorType: 'name',
              hintText: AppText.enterCardHolderName,
              keyboard: TextInputType.name,
            ),
            SizedBox(height: context.h(16)),
            NeuTextField(
              label: AppText.cardNumber,
              obscure: true,
              validatorType: 'phone',
              hintText: AppText.enterCardNumber,
              keyboard: TextInputType.name,
            ),
            SizedBox(height: context.h(16)),
            NeuTextField(
              label: AppText.cvv,
              obscure: true,
              validatorType: 'phone',
              hintText: AppText.enterCvv,
              keyboard: TextInputType.name,
            ),
            SizedBox(height: context.h(16)),
            NeuTextField(
              label: AppText.expiryDate,
              obscure: true,
              validatorType: 'phone',
              hintText: AppText.enterExpiryDate,
              keyboard: TextInputType.name,
            ),
          ],
        ),
      ),
    );
  }
}
