import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:looklabs/Core/Widget/custom_container.dart';
import 'package:looklabs/Core/Widget/gird_data.dart';
import 'package:looklabs/Core/Widget/normal_text.dart';
import 'package:looklabs/Core/Widget/plan_container.dart';
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
            NormalText(
              crossAxisAlignment: CrossAxisAlignment.start,
              titleText: 'Wellness Overview',
              titleSize: context.text(18),
              titleWeight: FontWeight.w600,
              titleColor: AppColors.subHeadingColor,
            ),
            SizedBox(height: context.h(10)),
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
              height: context.h(130),
              // width: context.w(double.infinity),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                scrollDirection: Axis.horizontal,
                itemCount: homeViewModel.listViewData.length,
                itemBuilder: (context, index) {
                  final item = homeViewModel.listViewData[index];
                  return Container(
                    margin: EdgeInsets.only(
                      right: context.h(13),
                      top: context.h(16),
                      bottom: context.h(16),
                    ),
                    padding: context.padSym(h: 28, v: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(context.radius(16)),
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
                          color: AppColors.customContinerColorDown.withOpacity(
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
                        PlanContainer(
                          padding: context.padSym(h: 2, v: 2),
                          radius: BorderRadius.circular(10),
                          isSelected: false,
                          onTap: () {},
                          child: ClipRRect(
                            borderRadius: BorderRadiusGeometry.circular(6),
                            child: Image.asset(
                              item['image'],
                              height: context.h(24),
                              width: context.w(24),
                              fit: BoxFit.scaleDown,
                            ),
                          ),
                        ),
                        SizedBox(height: context.h(4)),
                        Text(
                          item['title'],
                          style: TextStyle(
                            fontSize: context.text(14),
                            fontWeight: FontWeight.w600,
                            color: AppColors.subHeadingColor,
                          ),
                        ),
                        SizedBox(height: context.h(3)),
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
            SizedBox(height: context.h(15)),
            SizedBox(
              height: context.h(1250),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  // mainAxisExtent: 2,
                  childAspectRatio: 3 / 4.3,
                ),
                itemCount: homeViewModel.gridData.length,
                itemBuilder: (context, index) {
                  final item = homeViewModel.gridData[index];
                  return PlanContainer(
                    padding: EdgeInsets.zero,
                    isSelected: false,
                    onTap: () {
                      homeViewModel.onItemTap(index, context);
                    },
                    child: Column(
                      children: [
                        CustomContainer(
                          border: null,
                          padding: EdgeInsets.zero,
                          // margin: context.padSym(h: 10, v: 10),
                          child: ClipRRect(
                            borderRadius: BorderRadiusGeometry.circular(10),
                            child: Image.asset(
                              item['image'],
                              fit: BoxFit.scaleDown,
                            ),
                          ),
                        ),
                        SizedBox(height: context.h(8)),
                        NormalText(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          titleText: item['title'],
                          titleSize: context.text(16),
                          titleWeight: FontWeight.w600,
                          titleColor: AppColors.subHeadingColor,
                          subText: item['subTitle'],
                          subSize: context.text(12),
                          subColor: AppColors.subHeadingColor,
                          subWeight: FontWeight.w400,
                        ),
                      ],
                    ),
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
