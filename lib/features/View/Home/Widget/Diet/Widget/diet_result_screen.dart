import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:looklabs/Features/Widget/app_bar_container.dart';
import 'package:looklabs/Features/Widget/custom_button.dart';
import 'package:looklabs/Features/Widget/height_widget_cont.dart';
import 'package:looklabs/Features/Widget/normal_text.dart';
import 'package:looklabs/Features/Widget/plan_container.dart';
import 'package:looklabs/Core/Constants/app_assets.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Core/Routes/routes_name.dart';
import 'package:looklabs/Features/ViewModel/diet_result_screen_view_model.dart';
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
          top: context.sh(5),
          left: context.sw(20),
          right: context.sw(20),
          bottom: context.sh(30),
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
          padding: context.paddingSymmetricR(horizontal: 20),
          children: [
            AppBarContainer(
              title: 'Diet',
              onTap: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(height: context.sh(24)),
            NormalText(
              crossAxisAlignment: CrossAxisAlignment.start,
              titleText: 'Improve strength & track your workout progress',
              titleSize: context.sp(16),
              titleWeight: FontWeight.w600,
              titleColor: AppColors.subHeadingColor,
            ),
            SizedBox(height: context.sh(18)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                dietResultScreenViewModel.gridData.length,
                (index) {
                  return HeightWidgetCont(
                    // padding: context.paddingSymmetricR(horizontal: 11.5, vertical: 14.5),
                    title: dietResultScreenViewModel.gridData[index]['title'],
                    subTitle:
                        dietResultScreenViewModel.gridData[index]['subtitle'],
                    imgPath: dietResultScreenViewModel.gridData[index]['image'],
                  );
                },
              ),
            ),
            SizedBox(height: context.sh(18)),
            NormalText(
              titleText: 'Today\'s Focus',
              titleSize: context.sp(18),
              titleWeight: FontWeight.w600,
              titleColor: AppColors.subHeadingColor,
            ),
            SizedBox(height: context.sh(12)),

            Wrap(
              spacing: context.sw(5),
              runSpacing: context.sh(11),
              children: List.generate(dietResultScreenViewModel.exData.length, (
                btnIndex,
              ) {
                final bool isSelected = dietResultScreenViewModel.isSelected(
                  btnIndex,
                );

                return PlanContainer(
                  isSelected: isSelected,
                  radius: BorderRadius.circular(context.radiusR(16)),
                  margin: context.paddingSymmetricR(horizontal: 0),
                  padding: context.paddingSymmetricR(horizontal: 14, vertical: 10),
                  onTap: () {
                    dietResultScreenViewModel.selectExercise(btnIndex);
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                        child: SizedBox(
                          height: context.sh(20),
                          width: context.sw(20),
                          child: SvgPicture.asset(
                            dietResultScreenViewModel.exData[btnIndex]['image'],
                            fit: BoxFit.scaleDown,
                            color: isSelected
                                ? AppColors.pimaryColor
                                : AppColors.subHeadingColor,
                          ),
                        ),
                      ),
                      SizedBox(width: context.sw(8)),
                      NormalText(
                        titleText:
                            dietResultScreenViewModel.exData[btnIndex]['title'],
                        titleSize: context.sp(14),
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
            SizedBox(height: context.sh(18)),
            PlanContainer(
              padding: context.paddingSymmetricR(horizontal: 12, vertical: 12),
              margin: context.paddingSymmetricR(horizontal: 0),
              isSelected: false,
              onTap: () {},
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Container(
                    height: context.sh(28),
                    width: context.sw(28),
                    decoration: BoxDecoration(
                      color: AppColors.backGroundColor,
                      borderRadius: BorderRadius.circular(context.radiusR(10)),
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
                        height: context.sh(32),
                        width: context.sw(32),
                        child: SvgPicture.asset(
                          AppAssets.lightBulbIcon,
                          fit: BoxFit.scaleDown,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: context.sh(8)),

                  NormalText(
                    titleText: 'Posture Insight',
                    titleSize: context.sp(16),
                    titleWeight: FontWeight.w500,
                    titleColor: AppColors.subHeadingColor,
                    subText:
                        'Consistency improves stamina, strength & metabolism over time. Keep pushing!',
                    subSize: context.sp(12),
                    subWeight: FontWeight.w600,
                  ),
                ],
              ),
            ),
            SizedBox(height: context.sh(18)),
            PlanContainer(
              margin: context.paddingSymmetricR(horizontal: 0),
              padding: context.paddingSymmetricR(horizontal: 12, vertical: 12),
              isSelected: false,
              onTap: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  NormalText(
                    titleText: 'Today\'s Meals',
                    titleSize: context.sp(16),
                    titleWeight: FontWeight.w500,
                    titleColor: AppColors.subHeadingColor,
                    subText: '3 meals + 2 snacks • 22 min prep',
                    subSize: context.sp(12),
                    subWeight: FontWeight.w600,
                  ),
                  Container(
                    padding: context.paddingSymmetricR(horizontal: 6, vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(context.radiusR(10)),
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
                          height: context.sh(20),
                          width: context.sw(20),
                          placeholderBuilder: (_) => const Icon(Icons.image),
                        ),

                        SizedBox(width: context.sw(4)),
                        SvgPicture.asset(
                          AppAssets.nightIcon,
                          height: context.sh(16),
                          width: context.sw(16),
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
