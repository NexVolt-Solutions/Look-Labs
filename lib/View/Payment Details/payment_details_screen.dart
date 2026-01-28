import 'package:flutter/material.dart';
import 'package:looklabs/Core/Widget/app_bar_container.dart';
import 'package:looklabs/Core/Widget/custom_button.dart';
import 'package:looklabs/Core/Widget/normal_text.dart';
import 'package:looklabs/Core/Widget/user_info.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Core/utils/Routes/routes_name.dart';
import 'package:looklabs/ViewModel/payment_details_vie_model.dart';
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
      body: SafeArea(
        child: Padding(
          padding: context.padSym(h: 20),
          child: ListView(
            clipBehavior: Clip.hardEdge,
            children: [
              AppBarContainer(title: 'Payment Details'),
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
                paymentViewModel.userInfData.length,
                (index) => UserInfo(
                  name: paymentViewModel.userInfData[index]['name'],
                  subName: paymentViewModel.userInfData[index]['subName'],
                ),
              ),
              SizedBox(height: context.h(20)),
              NormalText(
                crossAxisAlignment: CrossAxisAlignment.start,
                titleText: 'Card Details',
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
              SizedBox(height: context.h(378)),
              CustomButton(
                isEnabled: true,
                onTap: () => Navigator.pushNamed(
                  context,
                  RoutesName.PaymentDetailsScreen,
                ),
                text: 'Play',
                color: AppColors.buttonColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
