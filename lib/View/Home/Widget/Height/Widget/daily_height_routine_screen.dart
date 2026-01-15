import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:flutter_svg/svg.dart';
import 'package:looklabs/Core/Constants/Widget/app_bar_container.dart';
import 'package:looklabs/Core/Constants/Widget/gird_data.dart';
import 'package:looklabs/Core/Constants/Widget/goal_activity_graph.dart';
import 'package:looklabs/Core/Constants/Widget/height_slider.dart';
import 'package:looklabs/Core/Constants/Widget/normal_text.dart';
import 'package:looklabs/Core/Constants/Widget/plan_container.dart';
import 'package:looklabs/Core/Constants/app_assets.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';

class DailyHeightRoutineScreen extends StatefulWidget {
  const DailyHeightRoutineScreen({super.key});

  @override
  State<DailyHeightRoutineScreen> createState() =>
      _DailyHeightRoutineScreenState();
}

class _DailyHeightRoutineScreenState extends State<DailyHeightRoutineScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backGroundColor,
      body: SafeArea(
        child: ListView(
          padding: context.padSym(h: 20),
          children: [
            AppBarContainer(
              title: 'Height',
              onTap: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(height: context.h(24)),
            NormalText(
              crossAxisAlignment: CrossAxisAlignment.start,
              titleText: 'Improve posture & track your height progress',
              titleSize: context.text(16),
              titleWeight: FontWeight.w600,
              titleColor: AppColors.subHeadingColor,
            ),
            SizedBox(height: context.h(18)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(2, (index) {
                return Container(
                  padding: context.padSym(h: 23.5, v: 13.5),
                  margin: EdgeInsets.only(right: context.w(24)),
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
                    children: [
                      Container(
                        height: context.h(44),
                        width: context.w(44),
                        decoration: BoxDecoration(
                          color: AppColors.backGroundColor,
                          borderRadius: BorderRadius.circular(
                            context.radius(16),
                          ),
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
                              AppAssets.heightIcon,
                              fit: BoxFit.scaleDown,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: context.h(9)),
                      NormalText(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        titleText: '19 cm',
                        titleSize: context.text(14),
                        titleWeight: FontWeight.w600,
                        titleColor: AppColors.subHeadingColor,
                        sizeBoxheight: context.h(9),
                        subText: 'Current Height',
                        subSize: context.text(12),
                        subWeight: FontWeight.w400,
                        subColor: AppColors.notSelectedColor,
                      ),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
