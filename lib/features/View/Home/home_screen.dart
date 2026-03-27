import 'package:flutter/cupertino.dart' show CupertinoActivityIndicator;
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:flutter_svg/svg.dart';
import 'package:looklabs/Features/Widget/custom_container.dart';
import 'package:looklabs/Features/Widget/gird_data.dart';
import 'package:looklabs/Features/Widget/network_image_with_fallback.dart';
import 'package:looklabs/Features/Widget/normal_text.dart';
import 'package:looklabs/Features/Widget/plan_container.dart';
import 'package:looklabs/Core/Constants/app_assets.dart';
import 'package:looklabs/Core/Constants/app_text.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Features/ViewModel/home_view_model.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Widget _buildProgressImage(
    BuildContext context,
    String? iconUrl,
    double size,
  ) {
    if (iconUrl != null && iconUrl.isNotEmpty) {
      return NetworkImageWithFallback(
        url: iconUrl,
        height: context.sh(size),
        width: context.sw(size),
        fit: BoxFit.cover,
        fallbackSize: size,
      );
    }
    return SizedBox(
      height: context.sh(size),
      width: context.sw(size),
      child: Icon(Icons.image_not_supported, size: size * 0.5),
    );
  }

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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final vm = context.read<HomeViewModel>();
      // First paint: explore grid only to reduce first-frame jank.
      vm.loadDomainsForExplore();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 120), () {
        if (!mounted) return;
        context.read<HomeViewModel>().loadWellness();
      });
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 280), () {
        if (!mounted) return;
        context.read<HomeViewModel>().loadWeeklyProgress();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final homeViewModel = Provider.of<HomeViewModel>(context);
    final overviewLoading =
        homeViewModel.wellnessLoading && homeViewModel.wellness == null;
    final overviewError =
        homeViewModel.wellnessError != null && homeViewModel.wellness == null;

    return ListView(
      padding: context.paddingSymmetricR(horizontal: 20),
      clipBehavior: Clip.hardEdge,
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
          SizedBox(
            child: GridView.builder(
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
                  Color(0xFF000000).withValues(alpha: 0.9),
                  Color(0xFF000000).withValues(alpha: 0.7),
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
        NormalText(
          crossAxisAlignment: CrossAxisAlignment.start,
          titleText: AppText.weeklyProgressScore,
          titleSize: context.sp(18),
          titleWeight: FontWeight.w600,
          titleColor: AppColors.subHeadingColor,
        ),
        if (homeViewModel.weeklyProgressError != null &&
            homeViewModel.weeklyProgress == null)
          Padding(
            padding: EdgeInsets.only(bottom: context.sh(8)),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    homeViewModel.weeklyProgressError ?? '',
                    style: TextStyle(
                      fontSize: context.sp(12),
                      color: AppColors.notSelectedColor,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => homeViewModel.loadWeeklyProgress(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        if (homeViewModel.weeklyProgressLoading &&
            homeViewModel.weeklyProgress == null)
          SizedBox(
            height: context.sh(80),
            child: Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CupertinoActivityIndicator(
                  color: AppColors.subHeadingColor,
                ),
              ),
            ),
          )
        else if (homeViewModel.listViewData.isEmpty)
          SizedBox(
            height: context.sh(80),
            child: Center(
              child: Text(
                'No data yet',
                style: TextStyle(
                  fontSize: context.sp(14),
                  color: AppColors.notSelectedColor,
                ),
              ),
            ),
          )
        else
          SizedBox(
            height: context.sh(170),
            child: ListView.builder(
              padding: EdgeInsets.zero,
              scrollDirection: Axis.horizontal,
              itemCount: homeViewModel.listViewData.length,
              itemBuilder: (context, index) {
                final item = homeViewModel.listViewData[index];
                return Container(
                  margin: EdgeInsets.only(
                    right: context.sw(13),
                    left: context.sw(5),
                    top: context.sh(16),
                    bottom: context.sh(16),
                  ),
                  padding: context.paddingSymmetricR(horizontal: 28),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(context.radiusR(16)),
                    color: AppColors.backGroundColor,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.customContainerColorUp.withValues(alpha: 
                          0.4,
                        ),
                        offset: const Offset(5, 5),
                        blurRadius: 5,
                      ),
                      BoxShadow(
                        color: AppColors.customContinerColorDown.withValues(alpha: 
                          0.4,
                        ),
                        offset: const Offset(-5, -5),
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            context.radiusR(12),
                          ),
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFFFFFFFF).withValues(alpha: 0.9),
                              Color(0xffDBE6F2).withValues(alpha: 0.5),
                              Color(0xFF8F9FAE).withValues(alpha: 0.3),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.white.withValues(alpha: 0.4),
                              offset: const Offset(3, 3),
                              blurRadius: 2,
                            ),
                            BoxShadow(
                              color: AppColors.white.withValues(alpha: 0.4),
                              offset: const Offset(-3, -3),
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        child: Container(
                          margin: EdgeInsets.all(context.sw(3)), // Border width
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              context.radiusR(14),
                            ),
                            color: AppColors.backGroundColor,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                              context.radiusR(14),
                            ),
                            child: _buildProgressImage(
                              context,
                              item['iconUrl'] as String?,
                              45,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: context.sh(8)),
                      Text(
                        item['title'],
                        style: TextStyle(
                          fontSize: context.sp(12),
                          fontWeight: FontWeight.w600,
                          color: AppColors.subHeadingColor,
                        ),
                      ),
                      SizedBox(height: context.sh(2)),
                      Text(
                        item['subTitle'],
                        style: TextStyle(
                          fontSize: context.sp(10),
                          fontWeight: FontWeight.w400,
                          color: AppColors.notSelectedColor,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
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
                    : () async {
                        await homeViewModel.onItemTap(index, context);
                      },
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
                                  borderRadius: BorderRadiusGeometry.circular(
                                    10,
                                  ),
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
                                              Color(0xFFFFFFFF).withValues(alpha: 0),
                                              Color(
                                                0xFFDBE6F2,
                                              ).withValues(alpha: 0.5),
                                              Color(0xFF8b8c8c),
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Color(
                                                0xFF123D65,
                                              ).withValues(alpha: 0.15),
                                              offset: const Offset(0, 7),
                                              blurRadius: 17,
                                            ),
                                            BoxShadow(
                                              color: AppColors.white
                                                  .withValues(alpha: 0.18),
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
                                            color: Color(0xFF8b8c8c),
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
