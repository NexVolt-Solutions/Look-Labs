import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:looklabs/Features/Widget/custom_container.dart';
import 'package:looklabs/Features/Widget/line_chart_widget.dart';
import 'package:looklabs/Features/Widget/normal_text.dart';
import 'package:looklabs/Core/Constants/app_assets.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Features/Widget/plan_container.dart';
import 'package:looklabs/Core/Routes/routes_name.dart';
import 'package:looklabs/Features/ViewModel/progress_view_model.dart';
import 'package:provider/provider.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<ProgressViewModel>().loadWeeklyProgress();
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
                  progressViewModel.selectedIndex ==
                  progressViewModel.buttonName[index];
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: CustomContainer(
                  radius: context.radiusR(10),
                  onTap: () {
                    progressViewModel.selectIndex(index);
                  },
                  color: isSelected
                      ? AppColors.buttonColor.withOpacity(0.11)
                      : AppColors.backGroundColor,
                  border: isSelected
                      ? Border.all(color: AppColors.pimaryColor, width: 1.5)
                      : null,
                  padding: context.paddingSymmetricR(horizontal: 38),
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
                ),
              );
            },
          ),
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            NormalText(
              crossAxisAlignment: CrossAxisAlignment.start,
              titleText: 'Before Progress',
              titleSize: context.sp(18),
              titleWeight: FontWeight.w600,
              titleColor: AppColors.subHeadingColor,
            ),
            CustomContainer(
              onTap: () {
                Navigator.pushNamed(context, RoutesName.MyAlbumScreen);
              },
              radius: context.radiusR(10),
              color: AppColors.backGroundColor,
              padding: context.paddingSymmetricR(horizontal: 9, vertical: 9),
              margin: EdgeInsets.only(
                top: context.sh(20),
                bottom: context.sh(12),
              ),
              child: Center(
                child: SvgPicture.asset(
                  AppAssets.upLoadIcon,
                  height: context.sh(24),
                  width: context.sw(24),
                  color: AppColors.pimaryColor,

                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: context.sh(10)),
        CustomContainer(
          radius: context.radiusR(10),
          color: AppColors.backGroundColor,
          padding: context.paddingSymmetricR(horizontal: 10, vertical: 10),
          child: Center(child: LineChartWidget()),
        ),
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
              onTap: () {
                Navigator.pushNamed(context, RoutesName.MyAlbumScreen);
              },
              radius: context.radiusR(10),
              color: AppColors.backGroundColor,
              padding: context.paddingSymmetricR(horizontal: 9, vertical: 9),
              margin: EdgeInsets.only(
                top: context.sh(20),
                bottom: context.sh(12),
              ),
              child: Center(
                child: SvgPicture.asset(
                  AppAssets.upLoadIcon,
                  height: context.sh(24),
                  color: AppColors.pimaryColor,
                  width: context.sw(24),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
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
                    color: AppColors.pimaryColor,
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

  Widget _buildAfterProgressChart(
    BuildContext context,
    ProgressViewModel progressVM,
  ) {
    if (progressVM.weeklyProgressLoading && progressVM.weeklyProgress == null) {
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
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.subHeadingColor,
              ),
            ),
          ),
        ),
      );
    }
    if (progressVM.weeklyProgressError != null &&
        progressVM.weeklyProgress == null) {
      return CustomContainer(
        radius: context.radiusR(10),
        color: AppColors.backGroundColor,
        padding: context.paddingSymmetricR(horizontal: 16, vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              progressVM.weeklyProgressError ?? '',
              style: TextStyle(
                fontSize: context.sp(14),
                color: AppColors.notSelectedColor,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: context.sh(12)),
            TextButton(
              onPressed: () => progressVM.retryWeeklyProgress(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }
    return CustomContainer(
      radius: context.radiusR(10),
      color: AppColors.backGroundColor,
      padding: context.paddingSymmetricR(horizontal: 10, vertical: 10),
      child: Center(
        child: WeeklyProgressLineChart(
          days: progressVM.weeklyProgressDays,
        ),
      ),
    );
  }
}
