import 'package:flutter/cupertino.dart' show CupertinoActivityIndicator;
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/app_text.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Features/ViewModel/home_view_model.dart';
import 'package:looklabs/Features/Widget/network_image_with_fallback.dart';
import 'package:looklabs/Features/Widget/normal_text.dart';

class WeeklyProgressSection extends StatelessWidget {
  const WeeklyProgressSection({super.key, required this.homeViewModel});

  final HomeViewModel homeViewModel;

  Widget _buildProgressImage(BuildContext context, String? iconUrl, double size) {
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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                              const Color(0xFFFFFFFF).withValues(alpha: 0.9),
                              const Color(0xffDBE6F2).withValues(alpha: 0.5),
                              const Color(0xFF8F9FAE).withValues(alpha: 0.3),
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
                          margin: EdgeInsets.all(context.sw(3)),
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
      ],
    );
  }
}
