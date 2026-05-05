import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:flutter_svg/svg.dart';
import 'package:looklabs/Core/Constants/app_assets.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Features/Widget/app_bar_container.dart';
import 'package:looklabs/Features/View/Home/Widget/Fashion/Widget/Sections/profile_overview_section.dart';
import 'package:looklabs/Features/View/Home/Widget/Fashion/Widget/Sections/style_chip_card_section.dart';
import 'package:looklabs/Features/View/Home/Widget/Fashion/Widget/Sections/warm_palette_card_section.dart';
import 'package:looklabs/Features/View/Home/Widget/Fashion/Widget/Sections/weekly_plan_nav_card.dart';
import 'package:looklabs/Features/Widget/plan_container.dart';
import 'package:looklabs/Features/ViewModel/fashion_profile_screen_view_model.dart';
import 'package:provider/provider.dart';

class FashionProfileScreen extends StatefulWidget {
  const FashionProfileScreen({super.key, this.resultData});

  final Map<String, dynamic>? resultData;

  @override
  State<FashionProfileScreen> createState() => _FashionProfileScreenState();
}

class _FashionProfileScreenState extends State<FashionProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<FashionProfileScreenViewModel>().initializeFromResult(
        widget.resultData,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final fashionProfileScreenViewModel =
        context.watch<FashionProfileScreenViewModel>();
    return Scaffold(
      backgroundColor: AppColors.backGroundColor,
      // bottomNavigationBar: CustomButton(
      //   text: 'Next',
      //   color: AppColors.pimaryColor,
      //   isEnabled: true,
      //   onTap: () {
      //     Navigator.pushNamed(context, RoutesName.DailySkinCareRoutineScreen);
      //   },
      // ),
      body: SafeArea(
        child: ListView(
          padding: context.paddingSymmetricR(horizontal: 20),
          children: [
            AppBarContainer(
              title: fashionProfileScreenViewModel.profileTitle,
              onTap: () {
                Navigator.pop(context);
              },
            ),

            SizedBox(height: context.sh(20)),
            ProfileOverviewSection(viewModel: fashionProfileScreenViewModel),
            SizedBox(height: context.sh(18)),
            StyleChipCardSection(
              title: 'Styles to Avoid',
              chips: fashionProfileScreenViewModel.stylesToAvoid,
              leading: PlanContainer(
                margin: context.paddingSymmetricR(vertical: 0),
                padding: context.paddingSymmetricR(vertical: 4, horizontal: 4),
                isSelected: false,
                onTap: () {},
                child: GestureDetector(
                  onTap: fashionProfileScreenViewModel.toggleBestClothingSelection,
                  child: Container(
                    height: context.sh(20),
                    width: context.sw(20),
                    decoration: BoxDecoration(
                      color: fashionProfileScreenViewModel.isBestClothingSelected
                          ? AppColors.pimaryColor
                          : AppColors.backGroundColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.customContainerColorUp.withValues(alpha: 0.4),
                          offset: const Offset(3, 3),
                          blurRadius: 4,
                          inset: true,
                        ),
                        BoxShadow(
                          color: AppColors.customContinerColorDown.withValues(alpha: 0.4),
                          offset: const Offset(-3, -3),
                          blurRadius: 4,
                          inset: true,
                        ),
                      ],
                    ),
                    child: Center(
                      child: fashionProfileScreenViewModel.isBestClothingSelected
                          ? Icon(
                              Icons.check,
                              size: context.sh(16),
                              color: AppColors.white,
                            )
                          : const SizedBox(),
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: context.sh(18)),

            StyleChipCardSection(
              title: 'Best Clothing Fits',
              chips: fashionProfileScreenViewModel.bestClothingFits,
              leading: PlanContainer(
                margin: context.paddingSymmetricR(vertical: 0),
                padding: context.paddingSymmetricR(vertical: 4, horizontal: 4),
                isSelected: false,
                onTap: () {},
                child: GestureDetector(
                  onTap: fashionProfileScreenViewModel.toggleBestClothingSelection,
                  child: SvgPicture.asset(
                    AppAssets.waringIcon,
                    fit: BoxFit.scaleDown,
                  ),
                ),
              ),
            ),
            SizedBox(height: context.sh(18)),
            WarmPaletteCardSection(
              palette: fashionProfileScreenViewModel.warmPalette,
              onIconTap: fashionProfileScreenViewModel.toggleBestClothingSelection,
            ),
            SizedBox(height: context.sh(18)),
            WeeklyPlanNavCard(viewModel: fashionProfileScreenViewModel),
          ],
        ),
      ),
    );
  }
}
