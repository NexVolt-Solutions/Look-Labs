import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:looklabs/Core/Constants/Widget/custom_container.dart';
import 'package:looklabs/Core/Constants/Widget/line_chart_widget.dart';
import 'package:looklabs/Core/Constants/Widget/normal_text.dart';
import 'package:looklabs/Core/Constants/app_assets.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
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
            SizedBox(height: context.h(8)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      height: context.h(40),
                      width: context.w(40),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.white,
                          width: context.w(1.5),
                        ),
                        image: const DecorationImage(
                          image: AssetImage(AppAssets.circleIcon),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: context.w(12)),
                    NormalText(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      titleText: 'hi Shehzad',
                      titleSize: context.text(16),
                      titleWeight: FontWeight.w600,
                      titleColor: AppColors.subHeadingColor,
                      subText: 'Good Morning',
                      subSize: context.text(14),
                      subColor: AppColors.notSelectedColor,
                      subWeight: FontWeight.w400,
                    ),
                  ],
                ),
                Row(
                  children: [
                    CustomContainer(
                      radius: context.radius(32),
                      color: AppColors.backGroundColor,
                      padding: context.padSym(h: 11, v: 3),
                      margin: context.padSym(h: 0, v: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            AppAssets.fireIcon,
                            height: context.h(20),
                            width: context.w(20),
                            color: AppColors.fireColor,
                            fit: BoxFit.fill,
                          ),
                          SizedBox(width: context.w(4)),
                          Text(
                            '12',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: AppColors.headingColor,
                              fontSize: context.text(15),
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Raleway',
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: context.w(10)),
                    CustomContainer(
                      radius: context.radius(33),
                      color: AppColors.backGroundColor,
                      padding: context.padSym(h: 6, v: 3),
                      margin: context.padSym(h: 0, v: 20),
                      child: Center(
                        child: SvgPicture.asset(
                          AppAssets.notificationIcon,
                          height: context.h(24),
                          width: context.w(24),
                          color: AppColors.notSelectedColor,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: context.h(11)),
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
                      ? AppColors.buttonColor.withOpacity(0.11) // selected bg
                      : AppColors.backGroundColor,
                  border: isSelected
                      ? Border.all(color: AppColors.pimaryColor, width: 1.5)
                      : null,
                  padding: context.padSym(h: 27, v: 12),
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
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            ),
            CustomContainer(
              radius: context.radius(10),
              color: AppColors.backGroundColor,
              padding: context.padSym(h: 10, v: 10),
              margin: EdgeInsets.only(bottom: context.h(20)),
              child: Center(child: LineChartWidget()),
            ),
            NormalText(
              crossAxisAlignment: CrossAxisAlignment.start,
              titleText: 'After Progress',
              titleSize: context.text(18),
              titleWeight: FontWeight.w600,
              titleColor: AppColors.subHeadingColor,
            ),
            CustomContainer(
              radius: context.radius(10),
              color: AppColors.backGroundColor,
              padding: context.padSym(h: 10, v: 10),
              margin: EdgeInsets.only(
                bottom: context.h(20),
                top: context.h(12),
              ),
              child: Center(child: LineChartWidget()),
            ),
            CustomContainer(
              radius: context.radius(10),
              color: AppColors.backGroundColor,
              padding: context.padSym(h: 12, v: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: CustomContainer(
                      radius: context.radius(10),
                      color: AppColors.backGroundColor,
                      child: SvgPicture.asset(
                        AppAssets.graphIcon,
                        height: context.h(24),
                        width: context.w(24),
                        fit: BoxFit.contain,
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
            SizedBox(height: context.h(100)),
          ],
        ),
      ),
    );
  }
}
