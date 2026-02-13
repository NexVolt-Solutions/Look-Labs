import 'package:flutter/material.dart' hide BoxShadow;
import 'package:flutter_svg/svg.dart';
import 'package:looklabs/Features/Widget/bottom_icon_container.dart';
import 'package:looklabs/Features/Widget/custom_container.dart';
import 'package:looklabs/Features/Widget/normal_text.dart';
import 'package:looklabs/Core/Constants/app_assets.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Features/ViewModel/bottom_sheet_view_model.dart';
import 'package:provider/provider.dart';

class BottomSheetBarScreen extends StatefulWidget {
  const BottomSheetBarScreen({super.key});

  @override
  State<BottomSheetBarScreen> createState() => _BottomSheetBarScreenState();
}

class _BottomSheetBarScreenState extends State<BottomSheetBarScreen> {
  @override
  Widget build(BuildContext context) {
    final bottomSheetBarViewModel = context.watch<BottomSheetViewModel>();

    return Scaffold(
      backgroundColor: AppColors.backGroundColor,
      bottomSheet: BottomIconContainer(),
      body: SafeArea(
        child: Column(
          children: [
            /// 🔹 HEADER (Settings screen me hide)
            if (bottomSheetBarViewModel.selectedIndex != 2)
              Padding(
                padding: context.padSym(h: 20, v: 20),
                child: Row(
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
                          titleText: 'Hi Shehzad',
                          titleSize: context.text(16),
                          titleWeight: FontWeight.w600,
                          titleColor: AppColors.subHeadingColor,
                          subText: 'Good Morning',
                          subSize: context.text(14),
                          subColor: AppColors.notSelectedColor,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        // CustomContainer(
                        //   radius: context.radius(32),
                        //   padding: context.padSym(h: 11, v: 3),
                        //   child: Row(
                        //     children: [
                        //       SvgPicture.asset(
                        //         AppAssets.fireIcon,
                        //         height: context.h(20),
                        //         color: AppColors.fireColor,
                        //       ),
                        //       SizedBox(width: context.w(4)),
                        //       Text(
                        //         '12',
                        //         style: TextStyle(
                        //           fontSize: context.text(15),
                        //           fontWeight: FontWeight.w600,
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        // SizedBox(width: context.w(10)),
                        CustomContainer(
                          radius: context.radius(30),
                          padding: context.padSym(h: 6, v: 6),
                          child: SvgPicture.asset(
                            AppAssets.notificationIcon,
                            fit: BoxFit.scaleDown,
                            // height: context.h(24),
                            color: AppColors.notSelectedColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

            Expanded(
              child: bottomSheetBarViewModel
                  .screen[bottomSheetBarViewModel.selectedIndex],
            ),
          ],
        ),
      ),
    );
  }
}
