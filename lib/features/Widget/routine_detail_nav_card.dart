import 'package:flutter/material.dart' hide BoxShadow;
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart'
    hide BoxDecoration;
import 'package:looklabs/Features/Widget/normal_text.dart';

class RoutineDetailNavCard extends StatelessWidget {
  const RoutineDetailNavCard({
    super.key,
    required this.label,
    required this.useRemediesGradientStyle,
    required this.onTap,
  });

  final String label;
  final bool useRemediesGradientStyle;
  final VoidCallback onTap;

  static const _border = Color(0xFFE0DFE6);
  static const _remedyGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF4F2FA), Color(0xFFECE8F5)],
  );

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(context.radiusR(18));
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(context.radiusR(12)),
            color: AppColors.backGroundColor,
            boxShadow: [
              BoxShadow(
                color: AppColors.customContainerColorUp.withValues(alpha: 0.4),
                offset: const Offset(5, 5),
                blurRadius: 5,
              ),
              BoxShadow(
                color: AppColors.customContinerColorDown.withValues(alpha: 0.4),
                offset: const Offset(-5, -5),
                blurRadius: 5,
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: context.sw(20),
              vertical: context.sh(18),
            ),
            child: Row(
              children: [
                Expanded(
                  child: NormalText (
                    titleText: label,
                    titleSize: context.sp(16),
                    titleWeight: FontWeight.bold,
                    titleColor: AppColors.headingColor,
                  ),
                ),
                SizedBox(width: context.sw(8)),
                Icon(
                  Icons.chevron_right_rounded,
                  size: context.sp(26),
                  color: AppColors.notSelectedColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
