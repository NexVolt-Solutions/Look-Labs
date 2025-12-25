import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';

class CustomSpinKit extends StatelessWidget {
  const CustomSpinKit({super.key});

  @override
  Widget build(BuildContext context) {
    return SpinKitFadingCircle(
      size: context.w(40),
      itemBuilder: (context, index) {
        return DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.pimaryColor,
            shape: BoxShape.circle, // force round
          ),
        );
      },
    );
  }
}
