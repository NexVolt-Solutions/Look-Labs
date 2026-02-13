import 'package:flutter/material.dart';
import 'package:looklabs/Features/Widget/app_bar_container.dart';
import 'package:looklabs/Features/Widget/custom_button.dart';
import 'package:looklabs/Features/Widget/normal_text.dart';
import 'package:looklabs/Features/Widget/user_info.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/apptext.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Core/Routes/routes_name.dart';
import 'package:looklabs/Features/ViewModel/payment_details_vie_model.dart';
import 'package:provider/provider.dart';

class PaymentDetailsScreen extends StatefulWidget {
  const PaymentDetailsScreen({super.key});

  @override
  State<PaymentDetailsScreen> createState() => _PaymentDetailsScreenState();
}

class _PaymentDetailsScreenState extends State<PaymentDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final paymentViewModel = Provider.of<PaymentDetailsVieModel>(context);
    return Scaffold(
      backgroundColor: AppColors.backGroundColor,
      bottomNavigationBar: Padding(
        padding: context.padSym(h: 20, v: 30),
        child: CustomButton(
          isEnabled: true,
          onTap: () => Navigator.pushNamed(context, RoutesName.AuthScreen),
          text: AppText.pay,
          color: AppColors.buttonColor,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: context.padSym(h: 20),
          child: ListView(
            clipBehavior: Clip.hardEdge,
            children: [
              AppBarContainer(
                title: AppText.paymentDetails,
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              SizedBox(height: context.h(24)),
              NormalText(
                crossAxisAlignment: CrossAxisAlignment.start,
                titleText: AppText.userInformation,
                titleSize: context.text(20),
                titleWeight: FontWeight.w600,
                titleColor: AppColors.subHeadingColor,
              ),
              SizedBox(height: context.h(20)),
              ...List.generate(
                paymentViewModel.userInfData.length,
                (index) => UserInfo(
                  name: paymentViewModel.userInfData[index]['name'],
                  subName: paymentViewModel.userInfData[index]['subName'],
                ),
              ),
              SizedBox(height: context.h(20)),
              NormalText(
                crossAxisAlignment: CrossAxisAlignment.start,
                titleText: AppText.cardDetailsSection,
                titleSize: context.text(18),
                titleWeight: FontWeight.w600,
                titleColor: AppColors.subHeadingColor,
              ),
              SizedBox(height: context.h(20)),
              ...List.generate(
                paymentViewModel.cardDetails.length,
                (index) => UserInfo(
                  name: paymentViewModel.cardDetails[index]['name'],
                  subName: paymentViewModel.cardDetails[index]['subName'],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
