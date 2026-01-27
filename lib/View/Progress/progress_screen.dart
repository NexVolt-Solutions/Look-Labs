import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:looklabs/Core/Constants/Widget/custom_container.dart';
import 'package:looklabs/Core/Constants/Widget/line_chart_widget.dart';
import 'package:looklabs/Core/Constants/Widget/normal_text.dart';
import 'package:looklabs/Core/Constants/Widget/plan_container.dart';
import 'package:looklabs/Core/Constants/app_assets.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Core/utils/Routes/routes_name.dart';
import 'package:looklabs/ViewModel/progress_view_model.dart';
import 'package:provider/provider.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  @override
  Widget build(BuildContext context) {
    final progressViewModel = Provider.of<ProgressViewModel>(context);
    return Scaffold(
      backgroundColor: AppColors.backGroundColor,
      body: SafeArea(
        child: ListView(
          padding: context.padSym(h: 20),
          clipBehavior: Clip.hardEdge,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(progressViewModel.buttonName.length, (
                index,
              ) {
                final bool isSelected =
                    progressViewModel.selectedIndex ==
                    progressViewModel.buttonName[index];
                return CustomContainer(
                  radius: context.radius(10),
                  onTap: () {
                    progressViewModel.selectIndex(index);
                  },
                  color: isSelected
                      ? AppColors.buttonColor.withOpacity(0.11)
                      : AppColors.backGroundColor,
                  border: isSelected
                      ? Border.all(color: AppColors.pimaryColor, width: 1.5)
                      : null,
                  padding: context.padSym(h: 42, v: 12),
                  child: Center(
                    child: Text(
                      progressViewModel.buttonName[index],
                      style: TextStyle(
                        fontSize: context.text(14),
                        fontWeight: FontWeight.w700,
                        color: AppColors.seconderyColor,
                      ),
                    ),
                  ),
                );
              }),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                NormalText(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  titleText: 'Before Progress',
                  titleSize: context.text(18),
                  titleWeight: FontWeight.w600,
                  titleColor: AppColors.subHeadingColor,
                ),
                CustomContainer(
                  onTap: () {
                    Navigator.pushNamed(context, RoutesName.MyAlbumScreen);
                  },
                  radius: context.radius(10),
                  color: AppColors.backGroundColor,
                  padding: context.padSym(h: 9, v: 9),
                  margin: EdgeInsets.only(
                    top: context.h(20),
                    bottom: context.h(12),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      AppAssets.upLoadIcon,
                      height: context.h(24),
                      width: context.w(24),
                      color: AppColors.pimaryColor,

                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: context.h(10)),

            CustomContainer(
              radius: context.radius(10),
              color: AppColors.backGroundColor,
              padding: context.padSym(h: 10, v: 10),
              child: Center(child: LineChartWidget()),
            ),
            SizedBox(height: context.h(10)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                NormalText(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  titleText: 'After Progress',
                  titleSize: context.text(18),
                  titleWeight: FontWeight.w600,
                  titleColor: AppColors.subHeadingColor,
                ),
                CustomContainer(
                  onTap: () {
                    Navigator.pushNamed(context, RoutesName.MyAlbumScreen);
                  },
                  radius: context.radius(10),
                  color: AppColors.backGroundColor,
                  padding: context.padSym(h: 9, v: 9),
                  margin: EdgeInsets.only(
                    top: context.h(20),
                    bottom: context.h(12),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      AppAssets.upLoadIcon,
                      height: context.h(24),
                      color: AppColors.pimaryColor,

                      width: context.w(24),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: context.h(10)),
            CustomContainer(
              radius: context.radius(10),
              color: AppColors.backGroundColor,
              padding: context.padSym(h: 10, v: 10),
              child: Center(child: LineChartWidget()),
            ),
            SizedBox(height: context.h(20)),
            CustomContainer(
              radius: context.radius(10),
              color: AppColors.backGroundColor,
              padding: context.padSym(h: 12, v: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: PlanContainer(
                      radius: BorderRadius.circular(context.radius(10)),
                      padding: context.padSym(h: 6, v: 6),
                      isSelected: false,
                      onTap: () {},
                      child: SvgPicture.asset(
                        AppAssets.graphIcon,
                        height: context.h(24),
                        width: context.w(24),
                        fit: BoxFit.contain,
                        color: AppColors.pimaryColor,
                      ),
                    ),
                  ),
                  SizedBox(height: context.h(12)),
                  NormalText(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    titleText: 'Great Progress!',
                    titleSize: context.text(16),
                    titleWeight: FontWeight.w500,
                    titleColor: AppColors.subHeadingColor,
                    subText:
                        'Consistency improves posture & height appearance over time. Keep up with your daily routines!',
                    subSize: context.text(12),
                    subWeight: FontWeight.w600,
                    subColor: AppColors.subHeadingColor,
                  ),
                ],
              ),
            ),
            SizedBox(height: context.h(250)),
          ],
        ),
      ),
    );
  }
}
