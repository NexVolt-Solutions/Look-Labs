import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';

class BottomSheetBarScreen extends StatefulWidget {
  const BottomSheetBarScreen({super.key});

  @override
  State<BottomSheetBarScreen> createState() => _BottomSheetBarScreenState();
}

class _BottomSheetBarScreenState extends State<BottomSheetBarScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backGroundColor,
      bottomSheet: Container(
        height: context.h(76),
        width: context.w(double.infinity),
        padding: context.padSym(h: 12),
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
      ),
      body: SafeArea(child: ListView(children: [])),
    );
  }
}
