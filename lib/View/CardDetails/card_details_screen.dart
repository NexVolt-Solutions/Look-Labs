import 'package:flutter/material.dart';
import 'package:looklabs/Core/Constants/Widget/app_bar_container.dart';
import 'package:looklabs/Core/Constants/Widget/custom_button.dart';
import 'package:looklabs/Core/Constants/Widget/neu_text_fied.dart';
import 'package:looklabs/Core/Constants/Widget/normal_text.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Core/utils/Routes/routes_name.dart';

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
      body: SafeArea(
        child: ListView(
          padding: context.padSym(h: 20),
          clipBehavior: Clip.hardEdge,
          children: [
            AppBarContainer(title: 'Card Details'),
            SizedBox(height: context.h(30.89)),
            NormalText(
              crossAxisAlignment: CrossAxisAlignment.start,
              titleText: 'Secure Payment Setup',
              titleSize: context.text(20),
              titleWeight: FontWeight.w600,
              titleColor: AppColors.headingColor,
            ),
            SizedBox(height: context.h(20)),
            NeuTextField(
              label: 'Name of Card Holder',
              obscure: true,
              validatorType: 'name',
              hintText: 'Enter card holder name',
              keyboard: TextInputType.name,
            ),
            SizedBox(height: context.h(16)),
            NeuTextField(
              label: 'Card Number',
              obscure: true,
              validatorType: 'phone',
              hintText: 'Enter card number',
              keyboard: TextInputType.name,
            ),
            SizedBox(height: context.h(16)),
            NeuTextField(
              label: 'CVV',
              obscure: true,
              validatorType: 'phone',
              hintText: 'Enter CVV',
              keyboard: TextInputType.name,
            ),
            SizedBox(height: context.h(16)),
            NeuTextField(
              label: 'Expiry Date',
              obscure: true,
              validatorType: 'phone',
              hintText: 'Enter expiry date',
              keyboard: TextInputType.name,
            ),

            SizedBox(height: context.h(241)),
            CustomButton(
              isEnabled: true,
              onTap: () =>
                  Navigator.pushNamed(context, RoutesName.PurchaseScreen),
              text: 'Proceed to Pay',
              color: AppColors.buttonColor,
              padding: context.padSym(v: 17),
            ),
          ],
        ),
      ),
    );
  }
}
