import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:flutter_svg/svg.dart';
import 'package:looklabs/Features/Widget/app_bar_container.dart';
import 'package:looklabs/Features/Widget/custom_button.dart';
import 'package:looklabs/Features/Widget/height_widget_cont.dart';
import 'package:looklabs/Features/Widget/light_card_widget.dart';
import 'package:looklabs/Features/Widget/linear_slider_widget.dart';
import 'package:looklabs/Features/Widget/normal_text.dart';
import 'package:looklabs/Features/Widget/plan_container.dart';
import 'package:looklabs/Core/Constants/app_assets.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Features/ViewModel/height_result_view_model.dart';
import 'package:looklabs/Features/ViewModel/height_screen_view_model.dart';
import 'package:provider/provider.dart';

class HeightResultScreen extends StatefulWidget {
  const HeightResultScreen({super.key, this.resultData});

  final Map<String, dynamic>? resultData;

  @override
  State<HeightResultScreen> createState() => _HeightResultScreenState();
}

class _HeightResultScreenState extends State<HeightResultScreen> {
  late final HeightResultViewModel _resultLogic;

  @override
  void initState() {
    super.initState();
    _resultLogic = HeightResultViewModel(widget.resultData);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<HeightScreenViewModel>().applyApiResult(widget.resultData);
    });
  }

  @override
  Widget build(BuildContext context) {
    final routines = context.watch<HeightScreenViewModel>();
    final ui = _resultLogic.ui(routines);
    final hasRoutine = _resultLogic.hasRoutineFor(routines);

    return Scaffold(
      backgroundColor: AppColors.backGroundColor,
      bottomNavigationBar: Padding(
        padding: EdgeInsetsGeometry.only(
          top: context.sh(5),
          left: context.sw(20),
          right: context.sw(20),
          bottom: context.sh(30),
        ),
        child: CustomButton(
          isEnabled: true,
          onTap: () => _resultLogic.openDailyHeightRoutine(context, routines),
          text: 'Check your daily routine',
          color: AppColors.pimaryColor,
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: context.paddingSymmetricR(horizontal: 20),
          children: [
            AppBarContainer(
              title: 'Height',
              onTap: () => Navigator.pop(context),
            ),
            SizedBox(height: context.sh(24)),
            NormalText(
              crossAxisAlignment: CrossAxisAlignment.start,
              titleText: 'Improve posture & track your height progress',
              titleSize: context.sp(16),
              titleWeight: FontWeight.w600,
              titleColor: AppColors.subHeadingColor,
            ),
            SizedBox(height: context.sh(18)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                HeightWidgetCont(
                  title: ui.currentHeightRaw,
                  subTitle: 'Current Height',
                  imgPath: AppAssets.heightIcon,
                ),
                HeightWidgetCont(
                  title: ui.goalHeightRaw,
                  subTitle: 'Goal Height',
                  imgPath: AppAssets.heightIcon,
                ),
              ],
            ),
            SizedBox(height: context.sh(10)),
            PlanContainer(
              padding: context.paddingSymmetricR(horizontal: 12, vertical: 12),
              isSelected: false,
              onTap: () {},
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          NormalText(
                            titleText: 'Current Height',
                            titleSize: context.sp(15),
                            titleWeight: FontWeight.w600,
                            titleColor: AppColors.iconColor,
                          ),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: ui.richNumberPart,
                                  style: TextStyle(
                                    fontSize: context.sp(26),
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.subHeadingColor,
                                  ),
                                ),
                                TextSpan(
                                  text: ui.richUnitPart.isEmpty
                                      ? ''
                                      : ' ${ui.richUnitPart}',
                                  style: TextStyle(
                                    fontSize: context.sp(16),
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.subHeadingColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: context.sh(44.16),
                        width: context.sw(46),
                        decoration: BoxDecoration(
                          color: AppColors.backGroundColor,
                          borderRadius: BorderRadius.circular(
                            context.radiusR(10),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.customContainerColorUp
                                  .withValues(alpha: 0.4),
                              offset: const Offset(3, 3),
                              blurRadius: 4,
                            ),
                            BoxShadow(
                              color: AppColors.customContinerColorDown
                                  .withValues(alpha: 0.4),
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
                              AppAssets.heightIncreaseIcon,
                              fit: BoxFit.scaleDown,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: context.sh(12)),
                  Divider(
                    color: AppColors.iconColor.withValues(alpha: 0.2),
                    thickness: 0.5,
                    height: context.sh(0.5),
                  ),
                  SizedBox(height: context.sh(12)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset(
                            AppAssets.liftingUpIcon,
                            height: context.sh(24),
                            width: context.sw(24),
                            colorFilter: const ColorFilter.mode(
                              AppColors.iconColor,
                              BlendMode.srcIn,
                            ),
                            fit: BoxFit.scaleDown,
                          ),
                          NormalText(
                            titleText: 'BMI Status',
                            titleSize: context.sp(12),
                            titleWeight: FontWeight.w400,
                            titleColor: AppColors.iconColor,
                          ),
                        ],
                      ),
                      PlanContainer(
                        isSelected: false,
                        padding: context.paddingSymmetricR(
                          horizontal: 14.5,
                          vertical: 8,
                        ),
                        radius: BorderRadius.circular(context.radiusR(16)),
                        onTap: () {},
                        child: NormalText(
                          titleText: ui.bmiStatus,
                          titleSize: context.sp(10),
                          titleWeight: FontWeight.w600,
                          titleColor: AppColors.subHeadingColor,
                        ),
                      ),
                    ],
                  ),
                  NormalText(
                    titleText: 'Progress',
                    titleSize: context.sp(14),
                    titleWeight: FontWeight.w600,
                    titleColor: AppColors.subHeadingColor,
                  ),
                  SizedBox(height: context.sh(16)),
                  LinearSliderWidget(progress: ui.progressPercent),
                  SizedBox(height: context.sh(12)),
                ],
              ),
            ),
            SizedBox(height: context.sh(12)),
            PlanContainer(
              margin: context.paddingSymmetricR(horizontal: 0),
              padding: context.paddingSymmetricR(horizontal: 12, vertical: 12),
              isSelected: false,
              onTap: () =>
                  _resultLogic.openDailyHeightRoutine(context, routines),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        NormalText(
                          titleText: 'Today\'s exercises',
                          titleSize: context.sp(16),
                          titleWeight: FontWeight.w600,
                          titleColor: AppColors.subHeadingColor,
                        ),
                        SizedBox(height: context.sh(4)),
                        NormalText(
                          titleText:
                              '${ui.routineExerciseCount} exercises • ${ui.routineEstimatedMinutes} min',
                          titleSize: context.sp(12),
                          titleWeight: FontWeight.w400,
                          titleColor: AppColors.subHeadingColor.withValues(alpha: 0.7),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    hasRoutine ? Icons.chevron_right : Icons.lock_outline,
                    size: context.sh(24),
                    color: hasRoutine
                        ? AppColors.subHeadingColor
                        : AppColors.subHeadingColor.withValues(alpha: 0.5),
                  ),
                ],
              ),
            ),
            SizedBox(height: context.sh(12)),
            LightCardWidget(text: ui.insightText),
            SizedBox(height: context.sh(30)),
          ],
        ),
      ),
    );
  }
}
