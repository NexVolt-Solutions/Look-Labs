import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:flutter_svg/svg.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Features/ViewModel/bottom_sheet_view_model.dart';
import 'package:provider/provider.dart';

class BottomIconContainer extends StatelessWidget {
  const BottomIconContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomAppBarVModel = context.watch<BottomSheetViewModel>();

    return Container(
      height: context.sh(76),
      width: context.sw(double.infinity),
      margin: context.paddingSymmetricR(vertical: 14),

      decoration: BoxDecoration(
        border: Border.all(color: AppColors.white),
        color: AppColors.backGroundColor,
        boxShadow: [
          BoxShadow(
            color: AppColors.white,
            offset: const Offset(16, 4),
            blurRadius: 80,
            inset: false,
          ),
          BoxShadow(
            color: Color(0xFF123D65).withOpacity(0.2),
            offset: const Offset(-8, -6),
            blurRadius: 80,
            inset: false,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(bottomAppBarVModel.bottomAppBarData.length, (
          index,
        ) {
          final item = bottomAppBarVModel.bottomAppBarData[index];
          final isSelected = bottomAppBarVModel.selectedIndex == index;

          return GestureDetector(
            onTap: () => bottomAppBarVModel.changeIndex(index),

            child: Padding(
              padding: context.paddingSymmetricR(horizontal: 40, vertical: 4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  Container(
                    height: context.sh(36),
                    width: context.sw(36),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.backGroundColor,
                        width: context.sw(1.5),
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
                          color: AppColors.customContinerColorDown.withOpacity(
                            0.4,
                          ),
                          offset: const Offset(-5, -5),
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        item['image'],
                        height: context.sh(20),
                        color: isSelected
                            ? AppColors.pimaryColor
                            : AppColors.iconColor,
                      ),
                    ),
                  ),
                  SizedBox(height: context.sh(4)),
                  Text(
                    item['name'],
                    style: TextStyle(
                      fontFamily: 'Raleway',
                      fontSize: context.sp(10),
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? AppColors.pimaryColor
                          : AppColors.iconColor,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
