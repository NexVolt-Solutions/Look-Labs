import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:flutter_svg/svg.dart';
import 'package:looklabs/Core/Constants/Widget/custom_container.dart';
import 'package:looklabs/Core/Constants/Widget/gird_data.dart';
import 'package:looklabs/Core/Constants/Widget/normal_text.dart';
import 'package:looklabs/Core/Constants/app_assets.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/ViewModel/home_view_model.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final homeViewModel = Provider.of<HomeViewModel>(context);
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
            NormalText(
              crossAxisAlignment: CrossAxisAlignment.start,
              titleText: 'Wellness Overview',
              titleSize: context.text(18),
              titleWeight: FontWeight.w600,
              titleColor: AppColors.subHeadingColor,
            ),
            SizedBox(height: context.h(20)),
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
                    image: item['image'],
                  );
                },
              ),
            ),
            SizedBox(height: context.h(24)),
            Container(
              padding: context.padSym(h: 8, v: 8),
              decoration: BoxDecoration(
                color: AppColors.backGroundColor,
                borderRadius: BorderRadius.circular(context.radius(14)),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.customContainerColorUp.withOpacity(0.4),
                    offset: const Offset(3, 3),
                    blurRadius: 4,
                  ),
                  BoxShadow(
                    color: AppColors.customContinerColorDown.withOpacity(0.4),
                    offset: const Offset(-3, -3),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Image.asset(AppAssets.homeConIcon, fit: BoxFit.contain),
            ),
            SizedBox(height: context.h(24)),
            NormalText(
              crossAxisAlignment: CrossAxisAlignment.start,
              titleText: 'Weekly Progress Score',
              titleSize: context.text(18),
              titleWeight: FontWeight.w600,
              titleColor: AppColors.subHeadingColor,
            ),
            SizedBox(
              height: context.h(150),
              width: context.w(double.infinity),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                scrollDirection: Axis.horizontal,
                itemCount: homeViewModel.listViewData.length,
                itemBuilder: (context, index) {
                  final item = homeViewModel.listViewData[index];
                  return CustomContainer(
                    onTap: () {},
                    border: null,
                    height: context.h(94),
                    width: context.w(76),
                    margin: context.padSym(h: 12, v: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: context.h(40),
                          width: context.w(40),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.backGroundColor,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.customContainerColorUp
                                    .withOpacity(0.4),
                                offset: const Offset(3, 3),
                                blurRadius: 4,
                              ),
                              BoxShadow(
                                color: AppColors.customContinerColorDown
                                    .withOpacity(0.4),
                                offset: const Offset(-3, -3),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: Center(
                            child: SizedBox(
                              height: context.h(20),
                              width: context.w(20),
                              child: SvgPicture.asset(
                                item['image'],
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: context.h(9)),
                        Text(
                          item['title'],
                          style: TextStyle(
                            fontSize: context.text(14),
                            fontWeight: FontWeight.w600,
                            color: AppColors.subHeadingColor,
                          ),
                        ),
                        SizedBox(height: context.h(6)),
                        Text(
                          item['subTitle'],
                          style: TextStyle(
                            fontSize: context.text(12),
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
              titleSize: context.text(18),
              titleWeight: FontWeight.w600,
              titleColor: AppColors.subHeadingColor,
            ),
            SizedBox(height: context.h(5)),
            SizedBox(
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  // mainAxisSpacing: 5,
                  // crossAxisSpacing: 5,
                  // mainAxisExtent: 2,
                  // childAspectRatio: 3 / 4,
                ),
                itemCount: homeViewModel.homeOverViewData.length,
                itemBuilder: (context, index) {
                  final item = homeViewModel.homeOverViewData[index];
                  return CustomContainer(
                    onTap: () {},
                    border: null,
                    height: context.h(166),
                    width: context.w(159.5),
                    margin: context.padSym(h: 10, v: 10),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
