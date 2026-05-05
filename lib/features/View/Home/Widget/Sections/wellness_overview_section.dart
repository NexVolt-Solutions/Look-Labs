import 'package:flutter/cupertino.dart' show CupertinoActivityIndicator;
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/app_text.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Features/ViewModel/home_view_model.dart';
import 'package:looklabs/Features/Widget/gird_data.dart';
import 'package:looklabs/Features/Widget/normal_text.dart';

class WellnessOverviewSection extends StatelessWidget {
  const WellnessOverviewSection({super.key, required this.homeViewModel});

  final HomeViewModel homeViewModel;

  @override
  Widget build(BuildContext context) {
    final overviewLoading =
        homeViewModel.wellnessLoading && homeViewModel.wellness == null;
    final overviewError =
        homeViewModel.wellnessError != null && homeViewModel.wellness == null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        NormalText(
          crossAxisAlignment: CrossAxisAlignment.start,
          titleText: AppText.wellnessOverview,
          titleSize: context.sp(18),
          titleWeight: FontWeight.w600,
          titleColor: AppColors.subHeadingColor,
        ),
        SizedBox(height: context.sh(10)),
        if (overviewError)
          Padding(
            padding: EdgeInsets.only(bottom: context.sh(12)),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    homeViewModel.wellnessError ?? 'Couldn\'t load wellness',
                    style: TextStyle(
                      fontSize: context.sp(13),
                      color: AppColors.notSelectedColor,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => homeViewModel.loadWellness(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        if (overviewLoading)
          SizedBox(
            height: context.sh(120),
            child: Center(
              child: SizedBox(
                width: 28,
                height: 28,
                child: CupertinoActivityIndicator(
                  color: AppColors.subHeadingColor,
                ),
              ),
            ),
          )
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 2.2,
            ),
            itemCount: homeViewModel.homeOverViewData.length,
            itemBuilder: (context, index) {
              final item = homeViewModel.homeOverViewData[index];
              return GridData(
                title: item['title'],
                subTitle: item['subTitle'],
                iconUrl: item['iconUrl'],
              );
            },
          ),
        SizedBox(height: context.sh(24)),
        Container(
          padding: context.paddingSymmetricR(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.backGroundColor,
            borderRadius: BorderRadius.circular(context.radiusR(14)),
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
          child: Container(
            padding: context.paddingSymmetricR(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(context.radiusR(14)),
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF000000).withValues(alpha: 0.9),
                  const Color(0xFF000000).withValues(alpha: 0.7),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Text(
              homeViewModel.wellness?.dailyQuote ?? '',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: context.sp(24),
                fontStyle: FontStyle.italic,
                color: AppColors.white,
              ),
            ),
          ),
        ),
        SizedBox(height: context.sh(24)),
      ],
    );
  }
}
