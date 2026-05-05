import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Core/Routes/routes_name.dart';
import 'package:looklabs/Features/ViewModel/fashion_profile_screen_view_model.dart';
import 'package:looklabs/Features/Widget/normal_text.dart';
import 'package:looklabs/Features/Widget/plan_container.dart';

class WeeklyPlanNavCard extends StatelessWidget {
  const WeeklyPlanNavCard({super.key, required this.viewModel});

  final FashionProfileScreenViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        NormalText(
          crossAxisAlignment: CrossAxisAlignment.start,
          titleText: viewModel.weeklyTitle,
          titleSize: context.sp(18),
          titleWeight: FontWeight.w600,
          titleColor: AppColors.subHeadingColor,
        ),
        SizedBox(height: context.sh(12)),
        PlanContainer(
          padding: context.paddingSymmetricR(horizontal: 19, vertical: 22),
          isSelected: viewModel.isExerciseSelected,
          onTap: () {
            viewModel.selectExercise();
            Future.delayed(const Duration(milliseconds: 150), () {
              if (!context.mounted) return;
              Navigator.pushNamed(
                context,
                RoutesName.WeeklyPlanScreen,
                arguments: {'daily_plan': viewModel.dailyPlan},
              );
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  viewModel.weeklySubtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: context.sp(18),
                    fontWeight: FontWeight.w600,
                    color: AppColors.headingColor,
                  ),
                ),
              ),
              SizedBox(width: context.sw(8)),
              const Icon(Icons.arrow_forward_ios, size: 20),
            ],
          ),
        ),
      ],
    );
  }
}
