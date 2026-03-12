import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide BoxShadow;
import 'package:flutter_svg/svg.dart';
import 'package:looklabs/Features/Widget/bottom_icon_container.dart';
import 'package:looklabs/Features/Widget/custom_container.dart';
import 'package:looklabs/Features/Widget/network_image_with_fallback.dart';
import 'package:looklabs/Features/Widget/normal_text.dart';
import 'package:looklabs/Core/Constants/app_assets.dart';
import 'package:looklabs/Core/Constants/app_text.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Features/ViewModel/auth_view_model.dart';
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
    final authViewModel = context.watch<AuthViewModel>();
    final userName = authViewModel.user?.name;
    final greeting = userName != null && userName.isNotEmpty
        ? '${AppText.hi} $userName'
        : AppText.hi;

    return Scaffold(
      backgroundColor: AppColors.backGroundColor,
      extendBody: true,
      bottomNavigationBar: SafeArea(top: false, child: BottomIconContainer()),
      body: SafeArea(
        child: Column(
          children: [
            /// 🔹 HEADER (Settings screen me hide)
            if (bottomSheetBarViewModel.selectedIndex != 2)
              Padding(
                padding: context.paddingSymmetricR(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          height: context.sh(40),
                          width: context.sw(40),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.white,
                              width: context.sw(1.5),
                            ),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child:
                              authViewModel.user?.profileImage != null &&
                                  authViewModel.user!.profileImage!.isNotEmpty
                              ? NetworkImageWithFallback(
                                  url: authViewModel.user!.profileImage!,
                                  width: context.sw(40),
                                  height: context.sh(40),
                                  fit: BoxFit.cover,
                                  fallbackSize: 40,
                                  errorWidget: Image.asset(
                                    AppAssets.circleIcon,
                                    fit: BoxFit.cover,
                                    width: context.sw(40),
                                    height: context.sh(40),
                                  ),
                                )
                              : Image.asset(
                                  AppAssets.circleIcon,
                                  fit: BoxFit.cover,
                                ),
                        ),
                        SizedBox(width: context.sw(12)),
                        NormalText(
                          titleText: greeting,
                          titleSize: context.sp(16),
                          titleWeight: FontWeight.w600,
                          titleColor: AppColors.subHeadingColor,
                          subText: AppText.goodMorning,
                          subSize: context.sp(14),
                          subColor: AppColors.notSelectedColor,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        // CustomContainer(
                        //   radius: context.radiusR(32),
                        //   padding: context.paddingSymmetricR(horizontal: 11, vertical: 3),
                        //   child: Row(
                        //     children: [
                        //       SvgPicture.asset(
                        //         AppAssets.fireIcon,
                        //         height: context.sh(20),
                        //         color: AppColors.fireColor,
                        //       ),
                        //       SizedBox(width: context.sw(4)),
                        //       Text(
                        //         '12',
                        //         style: TextStyle(
                        //           fontSize: context.sp(15),
                        //           fontWeight: FontWeight.w600,
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        // SizedBox(width: context.sw(10)),
                        CustomContainer(
                          radius: context.radiusR(30),
                          padding: context.paddingSymmetricR(
                            horizontal: 6,
                            vertical: 6,
                          ),
                          child: SvgPicture.asset(
                            AppAssets.notificationIcon,
                            fit: BoxFit.scaleDown,
                            // height: context.sh(24),
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
