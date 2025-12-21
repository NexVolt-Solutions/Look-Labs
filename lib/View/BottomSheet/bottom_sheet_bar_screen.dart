import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:looklabs/Core/Constants/Widget/bottom_icon_container.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/ViewModel/bottom_sheet_view_model.dart';
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
        child: bottomSheetBarViewModel
            .screen[bottomSheetBarViewModel.selectedIndex],
      ),
    );
  }
}
