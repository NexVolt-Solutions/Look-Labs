import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_svg/svg.dart';
import 'package:looklabs/Core/Constants/app_assets.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Features/Widget/normal_text.dart';
import 'package:looklabs/Features/Widget/plan_container.dart';

class WarmPaletteCardSection extends StatelessWidget {
  const WarmPaletteCardSection({
    super.key,
    required this.palette,
    required this.onIconTap,
  });

  final List<String> palette;
  final VoidCallback onIconTap;

  Color _paletteColor(String hex) {
    final cleaned = hex.trim().replaceAll('#', '');
    if (cleaned.length == 6) {
      return Color(int.parse('FF$cleaned', radix: 16));
    }
    if (cleaned.length == 8) {
      return Color(int.parse(cleaned, radix: 16));
    }
    return AppColors.backGroundColor;
  }

  @override
  Widget build(BuildContext context) {
    return PlanContainer(
      margin: context.paddingSymmetricR(vertical: 0),
      padding: context.paddingSymmetricR(horizontal: 12, vertical: 12),
      isSelected: false,
      onTap: () {},
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              PlanContainer(
                margin: context.paddingSymmetricR(vertical: 0),
                padding: context.paddingSymmetricR(vertical: 4, horizontal: 4),
                isSelected: false,
                onTap: () {},
                child: GestureDetector(
                  onTap: onIconTap,
                  child: SvgPicture.asset(
                    AppAssets.themeIcon,
                    fit: BoxFit.scaleDown,
                  ),
                ),
              ),
              SizedBox(width: context.sw(11)),
              NormalText(
                crossAxisAlignment: CrossAxisAlignment.start,
                titleText: 'Your Warm Palette',
                titleSize: context.sp(14),
                titleWeight: FontWeight.w600,
                titleColor: AppColors.subHeadingColor,
              ),
            ],
          ),
          SizedBox(height: context.sh(12)),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: palette.map((item) {
              return PlanContainer(
                margin: context.paddingSymmetricR(vertical: 0),
                radius: BorderRadius.circular(context.radiusR(10)),
                padding: context.paddingSymmetricR(vertical: 20, horizontal: 20),
                isSelected: false,
                onTap: () {},
                child: ClipRRect(
                  borderRadius: BorderRadiusGeometry.circular(context.radiusR(10)),
                  child: Container(
                    height: context.sh(18),
                    width: context.sw(18),
                    color: _paletteColor(item),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
