import 'package:flutter/material.dart';
import 'package:looklabs/Features/Widget/app_bar_container.dart';
import 'package:looklabs/Features/Widget/normal_text.dart';
import 'package:looklabs/Features/Widget/plan_container.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Features/ViewModel/daily_skin_care_routine_view_model.dart';
import 'package:provider/provider.dart';

class SkinHomeRemedies extends StatefulWidget {
  const SkinHomeRemedies({super.key});

  @override
  State<SkinHomeRemedies> createState() => _SkinHomeRemediesState();
}

class _SkinHomeRemediesState extends State<SkinHomeRemedies> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final vm = context.read<DailySkinCareRoutineViewModel>();
      if (vm.skincareRemedies.isEmpty &&
          vm.skincareSafetyTips.isEmpty &&
          !vm.showRoutineRefreshing) {
        vm.loadSkincareRoutine();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DailySkinCareRoutineViewModel>();
    final remedies = vm.skincareRemedies;
    final tips = vm.skincareSafetyTips;

    return Scaffold(
      backgroundColor: AppColors.backGroundColor,
      body: SafeArea(
        child: ListView(
          padding: context.paddingSymmetricR(horizontal: 20),
          children: [
            AppBarContainer(
              title: 'Skin Home Remedies',
              onTap: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(height: context.sh(20)),
            NormalText(
              crossAxisAlignment: CrossAxisAlignment.start,
              titleText: 'Recommended Home Remedies',
              titleSize: context.sp(18),
              titleWeight: FontWeight.w600,
              titleColor: AppColors.headingColor,
            ),
            SizedBox(height: context.sh(20)),
            if (remedies.isEmpty)
              NormalText(
                subAlign: TextAlign.center,
                titleText: vm.showRoutineRefreshing
                    ? 'Loading…'
                    : 'No remedies in your plan yet. Open Daily Skin Care Routine after completing skincare flow.',
                subText: 'No remedies in your plan yet. Open Daily Skin Care Routine after completing skincare flow.',
                titleSize: context.sp(14),
                titleColor: AppColors.subHeadingColor,
                subSize: context.sp(14),
                subColor: AppColors.subHeadingColor,
              )
            else
              ...remedies.map((r) {
                final name =
                    (r['name'] ?? r['title'] ?? 'Remedy').toString().trim();
                final stepsRaw = r['steps'];
                final steps = <String>[];
                if (stepsRaw is List) {
                  for (final s in stepsRaw) {
                    final t = s.toString().trim();
                    if (t.isNotEmpty) steps.add(t);
                  }
                }
                return PlanContainer(
                  isSelected: false,
                  onTap: () {},
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      NormalText(
                        titleText: name,
                        titleSize: context.sp(16),
                        titleWeight: FontWeight.w600,
                        titleColor: AppColors.subHeadingColor,
                      ),
                      if (steps.isNotEmpty) SizedBox(height: context.sh(8)),
                      ...steps.map(
                        (line) => Padding(
                          padding: EdgeInsets.only(bottom: context.sh(6)),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              NormalText(
                                titleText: '• ',
                                titleSize: context.sp(12),
                                titleWeight: FontWeight.w500,
                                titleColor: AppColors.grey,
                              ),
                              Expanded(
                                child: NormalText(
                                  titleText: line,
                                  titleSize: context.sp(12),
                                  titleWeight: FontWeight.w400,
                                  titleColor: AppColors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            if (tips.isNotEmpty) ...[
                            SizedBox(height: context.sh(8)),

              NormalText(
                crossAxisAlignment: CrossAxisAlignment.start,
                titleText: 'Safety tips',
                titleSize: context.sp(18),
                titleWeight: FontWeight.w600,
                titleColor: AppColors.headingColor,
              ),
              SizedBox(height: context.sh(12)),

               ...tips.map(
                (line) => Padding(
                  padding: EdgeInsets.only(bottom: context.sh(6)),
                  child: NormalText(
                    titleText: '• $line',
                    titleSize: context.sp(12),
                    titleWeight: FontWeight.w400,
                    titleColor: AppColors.headingColor,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
