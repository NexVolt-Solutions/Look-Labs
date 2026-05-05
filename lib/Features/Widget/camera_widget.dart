import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:looklabs/Core/Constants/app_assets.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';

/// Figma base size for the photo card (scaled via [SizeExtension.sw] / [sh]).
const double _kReviewCardFigma = 150;

/// Scan tile for review grid: empty = grey card + camera; filled = thumb + check badge + Retake.
///
/// Renamed from [CameraWidget] so hot restart/reload is not confused with an
/// older StatefulWidget `CameraWidget` + `_CameraWidgetState` in the VM.
class ReviewScanTile extends StatelessWidget {
  const ReviewScanTile({
    super.key,
    required this.onTapCapture,
    this.onRetake,
    required this.isSelected,
    this.localImagePath,
    required this.angleTitle,
  });

  final VoidCallback onTapCapture;
  final VoidCallback? onRetake;
  final bool isSelected;
  final String? localImagePath;
  final String angleTitle;

  bool get _hasImage =>
      localImagePath != null && localImagePath!.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final cardW = context.sw(_kReviewCardFigma);
    final cardH = context.sh(_kReviewCardFigma);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: cardW,
          height: cardH,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _hasImage ? null : onTapCapture,
              borderRadius: BorderRadius.circular(context.radiusR(16)),
              child: Ink(
                decoration: BoxDecoration(
                  color: _hasImage
                      ? Colors.transparent
                      : AppColors.subHeadingColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(context.radiusR(16)),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.pimaryColor
                        : AppColors.pimaryColor.withValues(alpha: 0.55),
                    width: context.sw(1.5),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(context.radiusR(14)),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      if (_hasImage)
                        Image.file(File(localImagePath!), fit: BoxFit.cover)
                      else
                        Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: context.paddingSymmetricR(
                                  horizontal: 14,
                                  vertical: 14,
                                ),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.white,
                                  border: Border.all(
                                    color: AppColors.backGroundColor,
                                    width: context.sw(2),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.customContainerColorUp
                                          .withValues(alpha: 0.35),
                                      offset: const Offset(4, 4),
                                      blurRadius: 6,
                                    ),
                                    BoxShadow(
                                      color: AppColors.customContinerColorDown
                                          .withValues(alpha: 0.35),
                                      offset: const Offset(-4, -4),
                                      blurRadius: 6,
                                    ),
                                  ],
                                ),
                                child: SvgPicture.asset(
                                  AppAssets.cameraIcon,
                                  height: context.sh(22),
                                  width: context.sw(26),
                                  colorFilter: ColorFilter.mode(
                                    isSelected
                                        ? AppColors.pimaryColor
                                        : AppColors.notSelectedColor,
                                    BlendMode.srcIn,
                                  ),
                                  fit: BoxFit.contain,
                                ),
                              ),
                              SizedBox(height: context.sh(8)),
                              Text(
                                'Tap to Capture',
                                style: TextStyle(
                                  fontSize: context.sp(12),
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.notSelectedColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (_hasImage)
                        Positioned(
                          top: context.sh(8),
                          right: context.sw(8),
                          child: Container(
                            width: context.sw(28),
                            height: context.sw(28),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.pimaryColor,
                            ),
                            child: Icon(
                              Icons.check_rounded,
                              color: AppColors.white,
                              size: context.sw(16),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: context.sh(8)),
        SizedBox(
          width: cardW,
          child: Text(
            angleTitle,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: context.sp(14),
              fontWeight: FontWeight.w600,
              color: AppColors.subHeadingColor,
            ),
          ),
        ),
        SizedBox(height: context.sh(4)),
        if (_hasImage)
          SizedBox(
            width: cardW,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onRetake ?? onTapCapture,
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: context.sh(4)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.replay_rounded,
                        size: context.sp(16),
                        color: AppColors.notSelectedColor,
                      ),
                      SizedBox(width: context.sw(4)),
                      Text(
                        'Retake',
                        style: TextStyle(
                          fontSize: context.sp(12),
                          fontWeight: FontWeight.w600,
                          color: AppColors.notSelectedColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        else
          SizedBox(height: context.sh(24)),
      ],
    );
  }
}
