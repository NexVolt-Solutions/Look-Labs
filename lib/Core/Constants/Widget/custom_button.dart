import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';

class CustomButton extends StatelessWidget {
  final String? text;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final VoidCallback? onTap;
  final bool isEnabled;
  const CustomButton({
    super.key,
    this.text,
    this.padding,
    this.color,
    this.onTap,
    required this.isEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(context.radius(16)),
          boxShadow: [
            BoxShadow(
              color: AppColors.buttonColor.withOpacity(0.3),
              offset: const Offset(5, 5),
              blurRadius: 20,
              inset: false,
            ),
            BoxShadow(
              color: AppColors.buttonColor.withOpacity(0.1),
              offset: const Offset(-5, -5),
              blurRadius: 20,
              inset: false,
            ),
          ],
        ),
        child: Text(
          text!,
          style: TextStyle(
            color: AppColors.blurTopColor,
            fontSize: context.text(20),
            fontWeight: FontWeight.w700,
            fontFamily: 'Raleway',
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
