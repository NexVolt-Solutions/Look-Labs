import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:looklabs/Features/Widget/app_bar_container.dart';
import 'package:looklabs/Features/Widget/linear_slider_widget.dart';
import 'package:looklabs/Features/Widget/normal_text.dart';
import 'package:looklabs/Features/ViewModel/skin_analyzing_view_model.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/app_text.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Core/Routes/routes_name.dart';
import 'package:provider/provider.dart';

class SkinAnalyzingScreen extends StatefulWidget {
  const SkinAnalyzingScreen({super.key});

  @override
  State<SkinAnalyzingScreen> createState() => _SkinAnalyzingScreenState();
}

class _SkinAnalyzingScreenState extends State<SkinAnalyzingScreen> {
  bool _navigated = false;
  SkinAnalyzingViewModel? _vm;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _vm = context.read<SkinAnalyzingViewModel>();
      _vm!.addListener(_onAnalyzingVm);
      _onAnalyzingVm();
    });
  }

  @override
  void dispose() {
    _vm?.removeListener(_onAnalyzingVm);
    super.dispose();
  }

  void _onAnalyzingVm() {
    if (!mounted || _navigated) return;
    final vm = _vm ?? context.read<SkinAnalyzingViewModel>();
    if (!vm.shouldAutoNavigateToRoutine) return;
    _navigated = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      Navigator.pushReplacementNamed(
        context,
        RoutesName.DailySkinCareRoutineScreen,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SkinAnalyzingViewModel>();

    return Scaffold(
      backgroundColor: AppColors.backGroundColor,
      body: SafeArea(
        child: ListView(
          padding: context.paddingSymmetricR(horizontal: 20),
          children: [
            AppBarContainer(
              title: AppText.analyzing,
              onTap: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(height: context.sh(32)),
            if (vm.showBusyIndicator) ...[
              CupertinoActivityIndicator(
                radius: 50,
                color: AppColors.pimaryColor,
              ),
              SizedBox(height: context.sh(24)),
            ],
            NormalText(
              crossAxisAlignment: CrossAxisAlignment.center,
              titleText: AppText.analyzingYourSkin,
              subText: AppText.aiStudyingSkin,
              subAlign: TextAlign.center,
            ),
            SizedBox(height: context.sh(24)),
            Padding(
              padding: context.paddingSymmetricR(horizontal: 56),
              child: LinearSliderWidget(
                showTopIcon: true,
                progress: vm.progressPercent.toDouble(),
                inset: false,
                height: context.sh(10),
                animatedConHeight: context.sh(10),
                showPercentage: false,
              ),
            ),
            if (vm.fetchError != null) ...[
              SizedBox(height: context.sh(16)),
              Text(
                vm.fetchError!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.redColor,
                  fontSize: context.sp(13),
                ),
              ),
            ],
            if (vm.analysisError != null) ...[
              SizedBox(height: context.sh(16)),
              Text(
                vm.analysisError!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.redColor,
                  fontSize: context.sp(13),
                ),
              ),
            ],
            SizedBox(height: context.sh(24)),
            ...vm.stagedBullets.asMap().entries.map((entry) {
              final index = entry.key;
              final line = entry.value;
              return AnimatedOpacity(
                duration: Duration(milliseconds: 220 + (index * 80)),
                opacity: 1,
                child: Padding(
                  padding: EdgeInsets.only(bottom: context.sh(18)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '• ',
                        style: TextStyle(
                          fontSize: context.sp(16),
                          fontWeight: FontWeight.w400,
                          color: AppColors.subHeadingColor,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          line,
                          style: TextStyle(
                            fontSize: context.sp(12),
                            fontWeight: FontWeight.w400,
                            color: AppColors.subHeadingColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
