import 'package:flutter/material.dart';
import 'package:looklabs/Core/Constants/Widget/bar_container.dart';
import 'package:looklabs/Core/Constants/Widget/custom_button.dart';
import 'package:looklabs/Core/Constants/Widget/neu_text_fied.dart';
import 'package:looklabs/Core/Constants/Widget/normal_text.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Core/utils/Routes/routes_name.dart';

class PurchaseScreen extends StatefulWidget {
  const PurchaseScreen({super.key});

  @override
  State<PurchaseScreen> createState() => _PurchaseScreenState();
}

class _PurchaseScreenState extends State<PurchaseScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backGroundColor,
      body: SafeArea(
        child: Padding(
          padding: context.padSym(h: 20),
          child: ListView(
            clipBehavior: Clip.hardEdge,
            children: [
              BarContainer(title: 'Purchase'),
              SizedBox(height: context.h(30.89)),
              NormalText(
                crossAxisAlignment: CrossAxisAlignment.start,
                titleText: 'User Information',
                titleSize: context.text(20),
                titleWeight: FontWeight.w600,
                titleColor: AppColors.headingColor,
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: context.h(20),
                  bottom: context.h(14),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'E-mail',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppColors.seconderyColor,
                        fontSize: context.text(12),
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Raleway',
                      ),
                      textAlign: TextAlign.start,
                    ),
                    Text(
                      'amnauxstudio@gmail.com',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppColors.subHeadingColor,
                        fontSize: context.text(12),
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Raleway',
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
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
      ),
    );
  }
}
