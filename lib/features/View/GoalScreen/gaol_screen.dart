import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:looklabs/Features/Widget/custom_button.dart';
import 'package:looklabs/Features/Widget/normal_text.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Core/Routes/routes_name.dart';
import 'package:looklabs/Features/ViewModel/gaol_screen_view_model.dart';
import 'package:provider/provider.dart';

class GaolScreen extends StatefulWidget {
  const GaolScreen({super.key});

  @override
  State<GaolScreen> createState() => _GaolScreenState();
}

class _GaolScreenState extends State<GaolScreen> {
  @override
  Widget build(BuildContext context) {
    final gaolScreenViewModel = Provider.of<GaolScreenViewModel>(context);
    return Scaffold(
      backgroundColor: AppColors.backGroundColor,

      bottomNavigationBar: Padding(
        padding: context.padSym(h: 20, v: 30),
        child: CustomButton(
          isEnabled: true,
          onTap: () => Navigator.pushNamed(context, RoutesName.OnBoardScreen),
          text: 'Get Started',
          color: AppColors.pimaryColor,
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: context.padSym(h: 20),
          clipBehavior: Clip.none,
          children: [
            SizedBox(height: context.h(20)),

            NormalText(
              crossAxisAlignment: CrossAxisAlignment.center,
              titleText: 'Choose Goal',
              titleSize: context.text(20),
              titleWeight: FontWeight.w600,
              titleColor: AppColors.headingColor,
            ),
            SizedBox(height: context.h(20)),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: context.w(16),
                crossAxisSpacing: context.w(16),
                childAspectRatio: 2.5,
              ),
              itemCount: gaolScreenViewModel.buttonName.length,
              itemBuilder: (context, index) {
                final bool isSelected =
                    gaolScreenViewModel.selectedIndex ==
                    gaolScreenViewModel.buttonName[index];

                return GestureDetector(
                  onTap: () {
                    gaolScreenViewModel.selectIndex(index);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.buttonColor.withOpacity(
                              0.11,
                            ) // selected bg
                          : AppColors.backGroundColor,
                      borderRadius: BorderRadius.circular(context.radius(16)),
                      border: isSelected
                          ? Border.all(color: AppColors.pimaryColor, width: 1.5)
                          : null,
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: AppColors.buttonColor.withOpacity(0.15),
                                offset: const Offset(5, 5),
                                blurRadius: 20,
                                inset: true,
                              ),
                              BoxShadow(
                                color: AppColors.buttonColor.withOpacity(0.15),
                                offset: const Offset(-5, -5),
                                blurRadius: 20,
                                inset: true,
                              ),
                            ]
                          : [
                              BoxShadow(
                                color: AppColors.customContainerColorUp
                                    .withOpacity(0.5),
                                offset: const Offset(5, 5),
                                blurRadius: 20,
                              ),
                              BoxShadow(
                                color: AppColors.customContinerColorDown,
                                offset: const Offset(-5, -5),
                                blurRadius: 20,
                              ),
                            ],
                    ),
                    child: Center(
                      child: Text(
                        gaolScreenViewModel.buttonName[index],
                        style: TextStyle(
                          fontSize: context.text(14),
                          fontWeight: FontWeight.w700,
                          color: isSelected
                              ? AppColors.headingColor
                              : AppColors.seconderyColor,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: context.h(223)),
          ],
        ),
      ),
    );
  }
}
