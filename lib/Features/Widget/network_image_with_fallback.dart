import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:looklabs/Core/Constants/app_assets.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';

/// Network image that shows a fallback on load error (502, 404, etc.).
/// Maps known API domain icons to local assets when URL fails.
class NetworkImageWithFallback extends StatelessWidget {
  const NetworkImageWithFallback({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.fallbackSize = 48,
    this.errorWidget,
  });

  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final double fallbackSize;
  /// When set, used instead of the default icon when the image fails to load (e.g. network error).
  final Widget? errorWidget;

  /// Local asset for known API icon paths (e.g. SkinCare.jpg, Workout.jpg).
  static String? _localAssetForUrl(String url) {
    final lower = url.toLowerCase();
    if (lower.contains('skincare')) return AppAssets.skinCare;
    if (lower.contains('workout')) return AppAssets.workOut;
    if (lower.contains('hair')) return AppAssets.hair;
    if (lower.contains('diet')) return AppAssets.diet;
    if (lower.contains('facial')) return AppAssets.facial;
    if (lower.contains('fashion')) return AppAssets.fashion;
    if (lower.contains('height')) return AppAssets.height;
    if (lower.contains('quitporn') || lower.contains('quit_porn')) {
      return AppAssets.quitPorn;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final localAsset = _localAssetForUrl(url);
    return LayoutBuilder(
      builder: (context, constraints) {
        final w =
            width ??
            (constraints.maxWidth.isFinite ? constraints.maxWidth : null);
        final h =
            height ??
            (constraints.maxHeight.isFinite ? constraints.maxHeight : null);
        final loadingW = w ?? context.sw(fallbackSize);
        final loadingH = h ?? context.sh(fallbackSize);
        return Image.network(
          url,
          width: width,
          height: height,
          fit: fit,
          loadingBuilder: (_, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return SizedBox(
              width: loadingW,
              height: loadingH,
              child: Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CupertinoActivityIndicator(
                    color: AppColors.pimaryColor,
                  ),
                ),
              ),
            );
          },
          errorBuilder: (_, _, _) {
            if (errorWidget != null) return errorWidget!;
            if (localAsset != null) {
              return Image.asset(
                localAsset,
                width: width,
                height: height,
                fit: fit,
                errorBuilder: (_, _, _) => _buildIconFallback(context),
              );
            }
            return _buildIconFallback(context);
          },
        );
      },
    );
  }

  Widget _buildIconFallback(BuildContext context) {
    return SizedBox(
      width: width ?? context.sw(fallbackSize),
      height: height ?? context.sh(fallbackSize),
      child: Icon(
        Icons.image_not_supported,
        size: fallbackSize * 0.5,
        color: AppColors.subHeadingColor.withValues(alpha: 0.5),
      ),
    );
  }
}
