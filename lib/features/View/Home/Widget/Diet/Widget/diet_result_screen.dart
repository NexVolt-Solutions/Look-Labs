import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:looklabs/features/Widget/app_bar_container.dart';
import 'package:looklabs/features/Widget/custom_button.dart';
import 'package:looklabs/features/Widget/height_widget_cont.dart';
import 'package:looklabs/features/Widget/normal_text.dart';
import 'package:looklabs/features/Widget/plan_container.dart';
import 'package:looklabs/Core/Constants/app_assets.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Core/Routes/routes_name.dart';
import 'package:looklabs/features/ViewModel/diet_result_screen_view_model.dart';
import 'package:provider/provider.dart';

class DietResultScreen extends StatefulWidget {
  const DietResultScreen({super.key});

  @override
  State<DietResultScreen> createState() => _DietResultScreenState();
}

class _DietResultScreenState extends State<DietResultScreen> {
  @override
  Widget build(BuildContext context) {
    final dietResultScreenViewModel = Provider.of<DietResultScreenViewModel>(
      context,
    );
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: EdgeInsetsGeometry.only(
          top: context.h(5),
          left: context.w(20),
          right: context.w(20),
          bottom: context.h(30),
        ),
        child: CustomButton(
          text: 'Next',
          color: AppColors.pimaryColor,
          isEnabled: true,
          onTap: () {
            Navigator.pushNamed(context, RoutesName.DailyDietRoutineScreen);
          },
        ),
      ),
      backgroundColor: AppColors.backGroundColor,
      body: SafeArea(
        child: ListView(
          padding: context.padSym(h: 20),
          children: [
            AppBarContainer(
              title: 'Diet',
              onTap: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(height: context.h(24)),
            NormalText(
              crossAxisAlignment: CrossAxisAlignment.start,
              titleText: 'Improve strength & track your workout progress',
              titleSize: context.text(16),
              titleWeight: FontWeight.w600,
              titleColor: AppColors.subHeadingColor,
            ),
            SizedBox(height: context.h(18)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                dietResultScreenViewModel.gridData.length,
                (index) {
                  return HeightWidgetCont(
                    // padding: context.padSym(h: 11.5, v: 14.5),
                    title: dietResultScreenViewModel.gridData[index]['title'],
                    subTitle:
                        dietResultScreenViewModel.gridData[index]['subtitle'],
                    imgPath: dietResultScreenViewModel.gridData[index]['image'],
                  );
                },
              ),
            ),
            SizedBox(height: context.h(18)),
            NormalText(
              titleText: 'Today\'s Focus',
              titleSize: context.text(18),
              titleWeight: FontWeight.w600,
              titleColor: AppColors.subHeadingColor,
            ),
            SizedBox(height: context.h(12)),

            Wrap(
              spacing: context.w(5),
              runSpacing: context.h(11),
              children: List.generate(dietResultScreenViewModel.exData.length, (
                btnIndex,
              ) {
                final bool isSelected = dietResultScreenViewModel.isSelected(
                  btnIndex,
                );

                return PlanContainer(
                  isSelected: isSelected,
                  radius: BorderRadius.circular(context.radius(16)),
                  margin: context.padSym(h: 0),
                  padding: context.padSym(h: 14, v: 10),
                  onTap: () {
                    dietResultScreenViewModel.selectExercise(btnIndex);
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                        child: SizedBox(
                          height: context.h(20),
                          width: context.w(20),
                          child: SvgPicture.asset(
                            dietResultScreenViewModel.exData[btnIndex]['image'],
                            fit: BoxFit.scaleDown,
                            color: isSelected
                                ? AppColors.pimaryColor
                                : AppColors.subHeadingColor,
                          ),
                        ),
                      ),
                      SizedBox(width: context.w(8)),
                      NormalText(
                        titleText:
                            dietResultScreenViewModel.exData[btnIndex]['title'],
                        titleSize: context.text(14),
                        titleWeight: FontWeight.w500,
                        titleColor: isSelected
                            ? AppColors.pimaryColor
                            : AppColors.subHeadingColor,
                      ),
                    ],
                  ),
                );
              }),
            ),
            SizedBox(height: context.h(18)),
            PlanContainer(
              padding: context.padSym(h: 12, v: 12),
              margin: context.padSym(h: 0),
              isSelected: false,
              onTap: () {},
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Container(
                    height: context.h(28),
                    width: context.w(28),
                    decoration: BoxDecoration(
                      color: AppColors.backGroundColor,
                      borderRadius: BorderRadius.circular(context.radius(10)),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.customContainerColorUp.withOpacity(
                            0.4,
                          ),
                          offset: const Offset(3, 3),
                          blurRadius: 4,
                        ),
                        BoxShadow(
                          color: AppColors.customContinerColorDown.withOpacity(
                            0.4,
                          ),
                          offset: const Offset(-3, -3),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Center(
                      child: SizedBox(
                        height: context.h(32),
                        width: context.w(32),
                        child: SvgPicture.asset(
                          AppAssets.lightBulbIcon,
                          fit: BoxFit.scaleDown,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: context.h(8)),

                  NormalText(
                    titleText: 'Posture Insight',
                    titleSize: context.text(16),
                    titleWeight: FontWeight.w500,
                    titleColor: AppColors.subHeadingColor,
                    subText:
                        'Consistency improves stamina, strength & metabolism over time. Keep pushing!',
                    subSize: context.text(12),
                    subWeight: FontWeight.w600,
                  ),
                ],
              ),
            ),
            SizedBox(height: context.h(18)),
            PlanContainer(
              margin: context.padSym(h: 0),
              padding: context.padSym(h: 12, v: 12),
              isSelected: false,
              onTap: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  NormalText(
                    titleText: 'Today\'s Meals',
                    titleSize: context.text(16),
                    titleWeight: FontWeight.w500,
                    titleColor: AppColors.subHeadingColor,
                    subText: '3 meals + 2 snacks • 22 min prep',
                    subSize: context.text(12),
                    subWeight: FontWeight.w600,
                  ),
                  Container(
                    padding: context.padSym(h: 6, v: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(context.radius(10)),
                      gradient: const LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Color(0xFFD0F040),
                          Color(0xFFFFFFFF),
                          Color(0xFFFFE5E2),
                        ],
                      ),

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

                    /// 🔹 Badge Content
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        /// First Icon
                        SvgPicture.asset(
                          AppAssets.sunIcon,
                          height: context.h(20),
                          width: context.w(20),
                          placeholderBuilder: (_) => const Icon(Icons.image),
                        ),

                        SizedBox(width: context.w(4)),
                        SvgPicture.asset(
                          AppAssets.nightIcon,
                          height: context.h(16),
                          width: context.w(16),
                          placeholderBuilder: (_) => const Icon(Icons.image),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
