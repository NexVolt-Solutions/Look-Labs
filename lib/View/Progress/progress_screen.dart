import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:looklabs/Core/Constants/Widget/custom_container.dart';
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
                      titleText: 'hi Amana',
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
                    Container(
                      height: context.h(27),
                      width: context.w(61),
                      // margin: context.padSym(v: 14),
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(context.radius(32)),
                        border: Border.all(
                          color: AppColors.backGroundColor,
                          width: context.w(1.5),
                        ),
                        color: AppColors.backGroundColor,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.customContainerColorUp.withOpacity(
                              0.4,
                            ),
                            offset: const Offset(5, 5),
                            blurRadius: 5,
                          ),
                          BoxShadow(
                            color: AppColors.customContinerColorDown
                                .withOpacity(0.4),
                            offset: const Offset(-5, -5),
                            blurRadius: 5,
                          ),
                        ],
                      ),
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
                    Container(
                      height: context.h(36),
                      width: context.w(36),
                      // margin: context.padSym(v: 14),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.backGroundColor,
                          width: context.w(1.5),
                        ),
                        color: AppColors.backGroundColor,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.customContainerColorUp.withOpacity(
                              0.4,
                            ),
                            offset: const Offset(5, 5),
                            blurRadius: 5,
                          ),
                          BoxShadow(
                            color: AppColors.customContinerColorDown
                                .withOpacity(0.4),
                            offset: const Offset(-5, -5),
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: SvgPicture.asset(
                        AppAssets.notificationIcon,
                        height: context.h(24),
                        width: context.w(24),
                        color: AppColors.notSelectedColor,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: context.h(11)),
            Row(
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
                  height: context.h(40),
                  width: context.w(90),
                  margin: context.padSym(h: 10, v: 20),
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
                  height: context.h(42),
                  width: context.w(42),
                  margin: context.padSym(h: 1, v: 20),
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
              height: context.h(215),
              width: context.w(335),
              margin: context.padSym(h: 1, v: 1),
              // child: Center(
              //   child: SvgPicture.asset(
              //     AppAssets.upLoadIcon,
              //     height: context.h(24),
              //     width: context.w(24),
              //     fit: BoxFit.contain,
              //   ),
              // ),
            ),
          ],
        ),
      ),
    );
  }
}
