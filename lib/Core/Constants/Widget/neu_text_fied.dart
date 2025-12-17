import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';

class NeuTextField extends StatelessWidget {
  final String validatorType;
  final bool obscure;

  final String? hintText;
  final String? label;

  final TextEditingController? controller;
  final TextInputType? keyboard;

  const NeuTextField({
    super.key,
    required this.validatorType,
    this.obscure = false,
    this.hintText,
    this.label,
    this.controller,
    this.keyboard,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Text(
            label ?? "label",
            style: TextStyle(
              color: AppColors.headingColor,
              fontSize: context.text(14),
              fontWeight: FontWeight.w500,
            ),
          ),
        SizedBox(height: context.h(8)),
        Container(
          height: context.h(54),
          // padding: context.padSym(v: 8, h: 2),
          // margin: context.padSym(v: 8, h: 2),
          decoration: BoxDecoration(
            color: AppColors.backGroundColor,
            borderRadius: BorderRadius.circular(context.radius(16)),
            border: Border.all(
              color: Colors.white.withOpacity(0.4),
              width: context.w(0.5),
            ),
            boxShadow: const [
              BoxShadow(
                offset: Offset(-2.5, -2.5),
                blurRadius: 5,
                color: AppColors.blurTopColor,
                inset: true,
              ),
              BoxShadow(
                offset: Offset(2.5, 2.5),
                blurRadius: 5,
                color: AppColors.blurBottomColor,
                inset: true,
              ),
            ],
          ),
          child: TextFormField(
            controller: controller,
            obscureText: obscure,

            keyboardType: keyboard,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return "This field is required";
              }

              if (validatorType == "name" && value.length < 3) {
                return "Enter a valid name";
              }

              if (validatorType == "phone" &&
                  !RegExp(r'^[0-9]{10,13}$').hasMatch(value)) {
                return "Enter a valid phone number";
              }

              if (validatorType == "email" &&
                  !RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$").hasMatch(value)) {
                return "Enter a valid email";
              }

              return null;
            },
            decoration: InputDecoration(
              fillColor: AppColors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(context.radius(16)),
                borderSide: BorderSide(
                  color: Colors.white.withOpacity(0.4),
                  width: context.w(0.5),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(context.radius(16)),
                borderSide: BorderSide(
                  color: Colors.white.withOpacity(0.4),
                  width: context.w(0.5),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(context.radius(16)),
                borderSide: BorderSide(
                  color: Colors.white.withOpacity(0.4),
                  width: context.w(0.5),
                ),
              ),
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.grey.shade600),
            ),
          ),
        ),
      ],
    );
  }
}
