import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart' show BoxDecoration;
import 'package:looklabs/Core/Constants/app_assets.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Features/ViewModel/fashion_profile_screen_view_model.dart';
import 'package:looklabs/Features/Widget/height_widget_cont.dart';
import 'package:looklabs/Features/Widget/network_image_with_fallback.dart';
import 'package:looklabs/Features/Widget/normal_text.dart';

class ProfileOverviewSection extends StatelessWidget {
  const ProfileOverviewSection({super.key, required this.viewModel});

  final FashionProfileScreenViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        NormalText(
          crossAxisAlignment: CrossAxisAlignment.start,
          titleText: viewModel.subtitle,
          titleSize: context.sp(18),
          titleWeight: FontWeight.w500,
          titleColor: AppColors.subHeadingColor,
        ),
        SizedBox(
          height: context.sh(140),
          child: ListView.builder(
            itemCount: viewModel.profileTraits.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final trait = viewModel.profileTraits[index];
              return HeightWidgetCont(
                title: trait['value']?.toString() ?? '',
                subTitle: trait['label']?.toString() ?? '',
                imgPath: AppAssets.fatLossIcon,
              );
            },
          ),
        ),
        SizedBox(height: context.sh(18)),
        NormalText(
          crossAxisAlignment: CrossAxisAlignment.start,
          titleText: 'Review Scans',
          titleSize: context.sp(18),
          titleWeight: FontWeight.w600,
          titleColor: AppColors.subHeadingColor,
        ),
        SizedBox(height: context.sh(8)),
        SizedBox(
          height: context.sh(190),
          child: ListView.builder(
            itemCount: viewModel.reviewScans.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final scan = viewModel.reviewScans[index];
              return Column(
                children: [
                  Container(
                    width: context.sw(158),
                    padding: context.paddingSymmetricR(horizontal: 1, vertical: 1),
                    margin: EdgeInsets.only(right: context.sw(12)),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.pimaryColor),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: NetworkImageWithFallback(
                        url: scan['url']?.toString() ?? '',
                        fit: BoxFit.cover,
                        width: context.sw(158),
                        height: context.sh(150),
                      ),
                    ),
                  ),
                  SizedBox(height: context.sh(8)),
                  NormalText(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    titleText: scan['label']?.toString() ?? '',
                    titleSize: context.sp(14),
                    titleWeight: FontWeight.w600,
                    titleColor: AppColors.subHeadingColor,
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
