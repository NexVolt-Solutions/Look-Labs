import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/ViewModel/profile_view_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';

class CheckBox extends StatelessWidget {
  final String? genderName;

  const CheckBox({super.key, this.genderName});

  @override
  Widget build(BuildContext context) {
    final signInViewModel = Provider.of<ProfileViewModel>(context);
    final bool isSelected = signInViewModel.selectedGender == genderName;

    return Row(
      children: [
        GestureDetector(
          onTap: () => signInViewModel.selectGender(genderName!),
          child: Container(
            height: context.h(26),
            width: context.w(26),
            margin: context.padSym(v: 12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.white, width: context.w(0.5)),
              color: isSelected
                  ? AppColors.pimaryColor
                  : AppColors.backGroundColor,
              boxShadow: isSelected
                  ? []
                  : [
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
            child: isSelected
                ? Icon(Icons.check, color: AppColors.blurTopColor, size: 18)
                : const SizedBox(),
          ),
        ),
        SizedBox(width: context.w(12)),
        Text(
          genderName!,
          style: TextStyle(
            color: AppColors.headingColor,
            fontSize: context.text(14),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
