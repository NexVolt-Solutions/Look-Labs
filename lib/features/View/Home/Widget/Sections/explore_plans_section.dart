import 'package:flutter/cupertino.dart' show CupertinoActivityIndicator;
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:flutter_svg/svg.dart';
import 'package:looklabs/Core/Constants/app_assets.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Features/ViewModel/home_view_model.dart';
import 'package:looklabs/Features/Widget/custom_container.dart';
import 'package:looklabs/Features/Widget/network_image_with_fallback.dart';
import 'package:looklabs/Features/Widget/normal_text.dart';
import 'package:looklabs/Features/Widget/plan_container.dart';

class ExplorePlansSection extends StatelessWidget {
  const ExplorePlansSection({super.key, required this.homeViewModel});

  final HomeViewModel homeViewModel;

  Widget _buildExploreImage(String? iconUrl) {
    if (iconUrl != null && iconUrl.isNotEmpty) {
      return NetworkImageWithFallback(
        url: iconUrl,
        fit: BoxFit.cover,
        fallbackSize: 48,
      );
    }
    return Container(
      color: AppColors.backGroundColor,
      child: const Center(child: Icon(Icons.image_not_supported, size: 48)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        NormalText(
          crossAxisAlignment: CrossAxisAlignment.start,
          titleText: 'Explore your plans',
          titleSize: context.sp(18),
          titleWeight: FontWeight.w600,
          titleColor: AppColors.subHeadingColor,
        ),
        SizedBox(height: context.sh(12)),
        if (homeViewModel.domainsError != null &&
            !homeViewModel.hasExploreDomains)
          Row(
            children: [
              Expanded(
                child: Text(
                  homeViewModel.domainsError ?? 'Couldn\'t load plans',
                  style: TextStyle(
                    fontSize: context.sp(13),
                    color: AppColors.notSelectedColor,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => homeViewModel.refreshDomainsForExplore(),
                child: const Text('Retry'),
              ),
            ],
          ),
        if (homeViewModel.domainsLoading && !homeViewModel.hasExploreDomains)
          SizedBox(
            height: context.sh(200),
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
        else if (homeViewModel.gridData.isEmpty)
          SizedBox(
            height: context.sh(200),
            child: Center(
              child: Text(
                'No plans yet',
                style: TextStyle(
                  fontSize: context.sp(14),
                  color: AppColors.notSelectedColor,
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
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 3 / 4.5,
            ),
            itemCount: homeViewModel.gridData.length,
            itemBuilder: (context, index) {
              final item = homeViewModel.gridData[index];
              final key = item['key'] as String? ?? '';
              final isEnabled = homeViewModel.isDomainEnabled(key);
              final isLoading = homeViewModel.isLoadingDomain(key);
              return PlanContainer(
                padding: EdgeInsets.zero,
                isSelected: isEnabled,
                onTap: isLoading
                    ? null
                    : () async => homeViewModel.onItemTap(index, context),
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Expanded(
                          flex: 3,
                          child: CustomContainer(
                            padding: EdgeInsets.zero,
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadiusGeometry.circular(10),
                                  child: _buildExploreImage(
                                    item['iconUrl'] as String?,
                                  ),
                                ),
                                if (!isEnabled)
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        height: 28,
                                        width: 28,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            context.radiusR(11),
                                          ),
                                          gradient: LinearGradient(
                                            colors: [
                                              const Color(
                                                0xFFFFFFFF,
                                              ).withValues(alpha: 0),
                                              const Color(
                                                0xFFDBE6F2,
                                              ).withValues(alpha: 0.5),
                                              const Color(0xFF8b8c8c),
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color(
                                                0xFF123D65,
                                              ).withValues(alpha: 0.15),
                                              offset: const Offset(0, 7),
                                              blurRadius: 17,
                                            ),
                                            BoxShadow(
                                              color: AppColors.white.withValues(
                                                alpha: 0.18,
                                              ),
                                              offset: const Offset(-5, -4),
                                              blurRadius: 58,
                                            ),
                                          ],
                                        ),
                                        child: Container(
                                          margin: EdgeInsets.all(context.sw(1)),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              context.radiusR(11),
                                            ),
                                            color: const Color(0xFF8b8c8c),
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              context.radiusR(11),
                                            ),
                                            child: SvgPicture.asset(
                                              AppAssets.crownIcon,
                                              fit: BoxFit.scaleDown,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: context.sh(4)),
                        Expanded(
                          flex: 1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                item['title'] as String? ?? '',
                                style: TextStyle(
                                  fontSize: context.sp(16),
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.subHeadingColor,
                                  fontFamily: 'Raleway',
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: context.sh(2)),
                              Text(
                                item['subTitle'] as String? ?? '',
                                style: TextStyle(
                                  fontSize: context.sp(12),
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.subHeadingColor,
                                  fontFamily: 'Raleway',
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (isLoading)
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.backGroundColor.withValues(alpha: 0.7),
                            borderRadius: BorderRadius.circular(
                              context.radiusR(10),
                            ),
                          ),
                          child: Center(
                            child: SizedBox(
                              width: 28,
                              height: 28,
                              child: CupertinoActivityIndicator(
                                color: AppColors.pimaryColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
      ],
    );
  }
}
