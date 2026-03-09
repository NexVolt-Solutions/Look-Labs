import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';

class GridData extends StatelessWidget {
  final String? title;
  final String? subTitle;
  final String? image;
  final String? iconUrl;

  const GridData({
    super.key,
    this.title,
    this.subTitle,
    this.image,
    this.iconUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: context.paddingSymmetricR(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(context.radiusR(16)),
        color: AppColors.backGroundColor,
        boxShadow: [
          BoxShadow(
            color: AppColors.customContainerColorUp.withOpacity(0.4),
            offset: const Offset(5, 5),
            blurRadius: 5,
          ),
          BoxShadow(
            color: AppColors.customContinerColorDown.withOpacity(0.4),
            offset: const Offset(-5, -5),
            blurRadius: 5,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: context.paddingSymmetricR(horizontal: 4, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.backGroundColor,
              borderRadius: BorderRadius.circular(context.radiusR(10)),
              boxShadow: [
                BoxShadow(
                  color: AppColors.customContainerColorUp.withOpacity(0.4),
                  offset: const Offset(3, 3),
                  blurRadius: 4,
                ),
                BoxShadow(
                  color: AppColors.customContinerColorDown.withOpacity(0.4),
                  offset: const Offset(-3, -3),
                  blurRadius: 4,
                ),
              ],
            ),
            child: iconUrl != null && iconUrl!.isNotEmpty
                ? Image.network(
                    iconUrl!,
                    fit: BoxFit.scaleDown,
                    loadingBuilder: (_, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return SizedBox(
                        width: 32,
                        height: 32,
                        child: Center(
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CupertinoActivityIndicator(
                              color: AppColors.pimaryColor,
                            ),
                          ),
                        ),
                      );
                    },
                    errorBuilder: (_, __, ___) =>
                        Icon(Icons.image_not_supported, size: 32),
                  )
                : (image != null && image!.isNotEmpty)
                ? Image.asset(image!, fit: BoxFit.scaleDown)
                : Icon(Icons.image_not_supported, size: 32),
          ),
          SizedBox(width: context.sw(6)),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final maxH = constraints.maxHeight.isFinite
                    ? constraints.maxHeight
                    : null;
                final titleWidget = Text(
                  title ?? '',
                  style: TextStyle(
                    fontSize: context.sp(14),
                    fontWeight: FontWeight.w600,
                    color: AppColors.subHeadingColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                );
                final subtitleWidget = Text(
                  ((subTitle ?? '').trim().isEmpty) ? '—' : (subTitle ?? ''),
                  style: TextStyle(
                    fontSize: context.sp(12),
                    fontWeight: FontWeight.w400,
                    color: AppColors.notSelectedColor,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                );
                if (maxH == null) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      titleWidget,
                      SizedBox(height: context.sh(4)),
                      subtitleWidget,
                    ],
                  );
                }
                return SizedBox(
                  height: maxH,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      titleWidget,
                      SizedBox(height: context.sh(4)),
                      Flexible(child: subtitleWidget),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
