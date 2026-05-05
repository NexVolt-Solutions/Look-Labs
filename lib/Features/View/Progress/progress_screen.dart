import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:looklabs/Features/Widget/custom_container.dart';
import 'package:looklabs/Features/Widget/line_chart_widget.dart';
import 'package:looklabs/Features/Widget/normal_text.dart';
import 'package:looklabs/Core/Constants/app_assets.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Core/Routes/routes_name.dart';
import 'package:looklabs/Features/ViewModel/my_album_view_model.dart';
import 'package:looklabs/Features/ViewModel/progress_view_model.dart';
import 'package:looklabs/Features/Widget/plan_container.dart';
import 'package:provider/provider.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  Future<void> _onUploadTap(ProgressViewModel progressVM) async {
    final success = await progressVM.pickAndUploadProgressImage();
    if (!mounted) return;
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Image uploaded successfully'),
          backgroundColor: AppColors.pimaryColor,
        ),
      );
      context.read<MyAlbumViewModel>().loadAlbumImages();
      Navigator.pushNamed(context, RoutesName.MyAlbumScreen);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<ProgressViewModel>().loadProgressForWeek();
    });
  }

  @override
  Widget build(BuildContext context) {
    final progressViewModel = context.watch<ProgressViewModel>();
    return ListView(
      padding: context.paddingSymmetricR(horizontal: 20),
      clipBehavior: Clip.hardEdge,
      children: [
        SizedBox(height: context.sh(10)),

        SizedBox(
          height: context.sh(70),
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            separatorBuilder: (context, index) =>
                SizedBox(width: context.sw(0)),

            itemCount: progressViewModel.buttonName.length,
            itemBuilder: (context, index) {
              final bool isSelected =
                  progressViewModel.selectedTabIndex == index;
              return CustomContainer(
                radius: context.radiusR(10),
                onTap: () {
                  progressViewModel.selectTabAndLoad(index);
                },
                color: isSelected
                    ? AppColors.buttonColor.withValues(alpha: 0.11)
                    : AppColors.backGroundColor,
                border: isSelected
                    ? Border.all(color: AppColors.pimaryColor, width: 1.5)
                    : null,
                padding: context.paddingSymmetricR(horizontal: 34, vertical: 8),
                margin: context.paddingSymmetricR(horizontal: 8, vertical: 8),
                child: Center(
                  child: Text(
                    progressViewModel.buttonName[index],
                    style: TextStyle(
                      fontSize: context.sp(14),
                      fontWeight: FontWeight.w700,
                      color: AppColors.seconderyColor,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: context.sh(10)),

        NormalText(
          crossAxisAlignment: CrossAxisAlignment.start,
          titleText: 'Before Progress',
          titleSize: context.sp(18),
          titleWeight: FontWeight.w600,
          titleColor: AppColors.subHeadingColor,
        ),
        SizedBox(height: context.sh(20)),
        _buildBeforeProgressChart(context, progressViewModel),
        SizedBox(height: context.sh(10)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            NormalText(
              crossAxisAlignment: CrossAxisAlignment.start,
              titleText: 'After Progress',
              titleSize: context.sp(18),
              titleWeight: FontWeight.w600,
              titleColor: AppColors.subHeadingColor,
            ),
            CustomContainer(
              onTap: progressViewModel.uploadLoading
                  ? null
                  : () => _onUploadTap(progressViewModel),
              radius: context.radiusR(10),
              color: AppColors.backGroundColor,
              padding: context.paddingSymmetricR(horizontal: 9, vertical: 9),
              margin: EdgeInsets.only(
                top: context.sh(20),
                bottom: context.sh(12),
              ),
              child: Center(
                child: progressViewModel.uploadLoading
                    ? SizedBox(
                        width: 24,
                        height: 24,
                        child: CupertinoActivityIndicator(
                          color: AppColors.pimaryColor,
                        ),
                      )
                    : SvgPicture.asset(
                        AppAssets.upLoadIcon,
                        height: context.sh(24),
                        colorFilter: const ColorFilter.mode(
                          AppColors.pimaryColor,
                          BlendMode.srcIn,
                        ),
                        width: context.sw(24),
                        fit: BoxFit.contain,
                      ),
              ),
            ),
          ],
        ),
        if (progressViewModel.uploadError != null)
          Padding(
            padding: EdgeInsets.only(bottom: context.sh(8)),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    progressViewModel.uploadError ?? '',
                    style: TextStyle(
                      fontSize: context.sp(12),
                      color: AppColors.notSelectedColor,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => progressViewModel.clearUploadError(),
                  child: const Text('Dismiss'),
                ),
              ],
            ),
          ),
        SizedBox(height: context.sh(10)),
        _buildAfterProgressChart(context, progressViewModel),
        SizedBox(height: context.sh(20)),
        CustomContainer(
          radius: context.radiusR(10),
          color: AppColors.backGroundColor,
          padding: context.paddingSymmetricR(horizontal: 12, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: PlanContainer(
                  radius: BorderRadius.circular(context.radiusR(10)),
                  padding: context.paddingSymmetricR(
                    horizontal: 6,
                    vertical: 6,
                  ),
                  isSelected: false,
                  onTap: () {},
                  child: SvgPicture.asset(
                    AppAssets.graphIcon,
                    height: context.sh(24),
                    width: context.sw(24),
                    fit: BoxFit.contain,
                    colorFilter: const ColorFilter.mode(
                      AppColors.pimaryColor,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
              SizedBox(height: context.sh(12)),
              NormalText(
                crossAxisAlignment: CrossAxisAlignment.start,
                titleText: 'Great Progress!',
                titleSize: context.sp(16),
                titleWeight: FontWeight.w500,
                titleColor: AppColors.subHeadingColor,
                subText:
                    'Consistency improves posture & height appearance over time. Keep up with your daily routines!',
                subSize: context.sp(12),
                subWeight: FontWeight.w600,
                subColor: AppColors.subHeadingColor,
              ),
            ],
          ),
        ),
        SizedBox(height: context.sh(100)),
      ],
    );
  }

  Widget _buildBeforeProgressChart(
    BuildContext context,
    ProgressViewModel progressVM,
  ) {
    if (progressVM.progressLoading &&
        progressVM.progressBeforeDomains.isEmpty &&
        progressVM.progressDomains.isEmpty) {
      return CustomContainer(
        radius: context.radiusR(10),
        color: AppColors.backGroundColor,
        padding: context.paddingSymmetricR(horizontal: 10, vertical: 10),
        child: SizedBox(
          height: context.sh(120),
          child: Center(
            child: SizedBox(
              width: 24,
              height: 24,
              child: CupertinoActivityIndicator(
                color: AppColors.subHeadingColor,
              ),
            ),
          ),
        ),
      );
    }
    final beforeDomains = progressVM.progressBeforeDomains;
    return CustomContainer(
      radius: context.radiusR(10),
      color: AppColors.backGroundColor,
      padding: context.paddingSymmetricR(horizontal: 10, vertical: 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: (beforeDomains.length * 70.0).clamp(280.0, 700.0),
          height: context.sh(250),
          child: WeeklyProgressLineChart(
            days: const [],
            domains: beforeDomains,
          ),
        ),
      ),
    );
  }

  Widget _buildAfterProgressChart(
    BuildContext context,
    ProgressViewModel progressVM,
  ) {
    if (progressVM.progressLoading &&
        progressVM.progressDomains.isEmpty &&
        progressVM.progressDays.isEmpty) {
      return CustomContainer(
        radius: context.radiusR(10),
        color: AppColors.backGroundColor,
        padding: context.paddingSymmetricR(horizontal: 10, vertical: 10),
        child: SizedBox(
          height: context.sh(120),
          child: Center(
            child: SizedBox(
              width: 24,
              height: 24,
              child: CupertinoActivityIndicator(
                color: AppColors.subHeadingColor,
              ),
            ),
          ),
        ),
      );
    }
    if (progressVM.progressError != null &&
        progressVM.progressDomains.isEmpty &&
        progressVM.progressDays.isEmpty) {
      return CustomContainer(
        radius: context.radiusR(10),
        color: AppColors.backGroundColor,
        padding: context.paddingSymmetricR(horizontal: 16, vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              progressVM.progressError ?? '',
              style: TextStyle(
                fontSize: context.sp(14),
                color: AppColors.notSelectedColor,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: context.sh(12)),
            TextButton(
              onPressed: () => progressVM.retryProgress(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }
    final domains = progressVM.progressDomains;
    final days = progressVM.progressDays;
    final count = days.isNotEmpty ? days.length : domains.length;
    final chartWidth = (count * 70.0).clamp(280.0, 700.0);
    return CustomContainer(
      radius: context.radiusR(10),
      color: AppColors.backGroundColor,
      padding: context.paddingSymmetricR(horizontal: 10, vertical: 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: chartWidth,
          height: context.sh(250),
          child: WeeklyProgressLineChart(days: days, domains: domains),
        ),
      ),
    );
  }
}
