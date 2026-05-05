import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:looklabs/Features/Widget/normal_text.dart';
import 'package:looklabs/Core/Constants/app_assets.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';

class HeightWidgetCont extends StatelessWidget {
  final String? title;
  final String? subTitle;
  final String? imgPath;
  final EdgeInsets? padding;
  final String? iconUrl;

  const HeightWidgetCont({
    super.key,
    this.title,
    this.subTitle,
    this.imgPath,
    this.padding,
    this.iconUrl,
  });

  static bool _isSvg(String path) {
    final lower = path.toLowerCase();
    return lower.endsWith('.svg');
  }

  Widget _buildImage(BuildContext context, String path) {
    if (_isSvg(path)) {
      return SvgPicture.asset(
        path,
        fit: BoxFit.scaleDown,
        colorFilter: const ColorFilter.mode(
          AppColors.pimaryColor,
          BlendMode.srcIn,
        ),
      );
    }
    return Image.asset(path, fit: BoxFit.scaleDown);
  }

  Widget _buildNetworkImage(BuildContext context, String url) {
    return Image.network(
      url,
      fit: BoxFit.scaleDown,
      errorBuilder: (_, error, stackTrace) {
        return _buildImage(context, imgPath ?? AppAssets.heightIcon);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: context.sh(128),
        width: context.sw(150),

        margin: EdgeInsetsGeometry.only(right: context.sw(12)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(context.radiusR(16)),
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
          padding: EdgeInsetsGeometry.only(top: context.sh(10)),
          child: Column(
            children: [
              Container(
                height: context.sh(44),
                width: context.sw(44),
                decoration: BoxDecoration(
                  color: AppColors.backGroundColor,
                  borderRadius: BorderRadius.circular(context.radiusR(10)),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.customContainerColorUp.withValues(alpha: 0.4),
                      offset: const Offset(3, 3),
                      blurRadius: 4,
                    ),
                    BoxShadow(
                      color: AppColors.customContinerColorDown.withValues(alpha: 0.4),
                      offset: const Offset(-3, -3),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Center(
                  child: SizedBox(
                    height: context.sh(20),
                    width: context.sw(20),
                    child: (iconUrl != null && iconUrl!.trim().isNotEmpty)
                        ? _buildNetworkImage(context, iconUrl!)
                        : _buildImage(
                            context,
                            imgPath ?? AppAssets.heightIcon,
                          ),
                  ),
                ),
              ),
              SizedBox(height: context.sh(6)),
              NormalText(
                crossAxisAlignment: CrossAxisAlignment.center,
                titleText: title ?? 'title',
                titleSize: context.sp(13),
                titleWeight: FontWeight.w600,
                titleColor: AppColors.subHeadingColor,
                sizeBoxheight: context.sh(2),
                subText: subTitle ?? 'subTitle',
                subSize: context.sp(11),
                subWeight: FontWeight.w400,
                subColor: AppColors.iconColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
