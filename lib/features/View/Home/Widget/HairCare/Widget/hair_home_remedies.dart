import 'package:flutter/material.dart';
import 'package:looklabs/Features/Widget/app_bar_container.dart';
import 'package:looklabs/Features/Widget/normal_text.dart';
import 'package:looklabs/Features/Widget/plan_container.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Features/ViewModel/daily_hair_care_routine_view_model.dart';
import 'package:provider/provider.dart';

class HairHomeRemedies extends StatefulWidget {
  const HairHomeRemedies({super.key});

  @override
  State<HairHomeRemedies> createState() => _HairHomeRemediesState();
}

class _HairHomeRemediesState extends State<HairHomeRemedies> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final vm = context.read<DailyHairCareRoutineViewModel>();
      if (vm.hairRemedies.isEmpty &&
          vm.hairSafetyTips.isEmpty &&
          !vm.showRoutineRefreshing) {
        vm.loadHaircareRoutine();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DailyHairCareRoutineViewModel>();
    final remedies = vm.hairRemedies;
    final tips = vm.hairSafetyTips;

    return Scaffold(
      backgroundColor: AppColors.backGroundColor,
      body: SafeArea(
        child: ListView(
          padding: context.paddingSymmetricR(horizontal: 20),
          children: [
            AppBarContainer(
              title: 'Hair Home Remedies',
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
              Text(
                vm.showRoutineRefreshing
                    ? 'Loading…'
                    : 'No remedies in your plan yet. Open Daily Hair Routine from Home after completing hair questions.',
                style: TextStyle(
                  fontSize: context.sp(14),
                  color: AppColors.subHeadingColor,
                ),
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
                return Padding(
                  padding: EdgeInsets.only(bottom: context.sh(16)),
                  child: PlanContainer(
                    isSelected: false,
                    onTap: () {},
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                            fontSize: context.sp(18),
                            fontWeight: FontWeight.w600,
                            color: AppColors.subHeadingColor,
                          ),
                        ),
                        if (steps.isNotEmpty) SizedBox(height: context.sh(8)),
                        ...steps.map(
                          (line) => Padding(
                            padding: EdgeInsets.only(bottom: context.sh(6)),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '• ',
                                  style: TextStyle(
                                    fontSize: context.sp(12),
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.iconColor,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    line,
                                    style: TextStyle(
                                      fontSize: context.sp(12),
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.iconColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            if (tips.isNotEmpty) ...[
              SizedBox(height: context.sh(16)),
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
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '• ',
                        style: TextStyle(
                          fontSize: context.sp(12),
                          fontWeight: FontWeight.w500,
                          color: AppColors.subHeadingColor,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          line,
                          style: TextStyle(
                            fontSize: context.sp(16),
                            fontWeight: FontWeight.w400,
                            color: AppColors.subHeadingColor,
                          ),
                        ),
                      ),
                    ],
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
