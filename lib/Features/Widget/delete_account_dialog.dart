import 'package:flutter/material.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/app_text.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Features/Widget/normal_text.dart';

/// Themed delete-account confirmation dialog matching app style (background, shadows, typography).
class DeleteAccountDialog extends StatelessWidget {
  const DeleteAccountDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: BoxConstraints(maxWidth: context.sw(320)),
        padding: context.paddingSymmetricR(horizontal: 24, vertical: 24),
        decoration: BoxDecoration(
          color: AppColors.backGroundColor,
          borderRadius: BorderRadius.circular(context.radiusR(16)),
          border: Border.all(color: AppColors.white, width: 0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            NormalText(
              titleText: AppText.deleteAccountConfirmTitle,
              titleSize: context.sp(18),
              titleWeight: FontWeight.w600,
              titleColor: AppColors.subHeadingColor,
            ),
            SizedBox(height: context.sh(12)),
            NormalText(
              titleText: AppText.deleteAccountConfirmMessage,
              titleSize: context.sp(14),
              titleWeight: FontWeight.w400,
              titleColor: AppColors.notSelectedColor,
              maxLines: 6,
            ),
            SizedBox(height: context.sh(24)),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.subHeadingColor,
                    padding: context.paddingSymmetricR(
                      horizontal: 16,
                      vertical: 10,
                    ),
                  ),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: context.sp(14),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(width: context.sw(8)),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.redColor,
                    padding: context.paddingSymmetricR(
                      horizontal: 16,
                      vertical: 10,
                    ),
                  ),
                  child: Text(
                    'Delete',
                    style: TextStyle(
                      fontSize: context.sp(14),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
