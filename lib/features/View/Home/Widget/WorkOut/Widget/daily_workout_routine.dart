import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:looklabs/Core/Constants/app_assets.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Features/View/Home/Widget/WorkOut/Widget/Sections/daily_workout_routine_sections.dart';
import 'package:looklabs/Features/Widget/app_bar_container.dart';
import 'package:looklabs/Features/ViewModel/daily_workout_routine_view_model.dart';
import 'package:provider/provider.dart';

class DailyWorkoutRoutine extends StatefulWidget {
  const DailyWorkoutRoutine({super.key, this.workoutData});

   final Map<String, dynamic>? workoutData;

  @override
  State<DailyWorkoutRoutine> createState() => _DailyWorkoutRoutineState();
}

class _DailyWorkoutRoutineState extends State<DailyWorkoutRoutine> {
  @override
  void initState() {
    super.initState();
    if (widget.workoutData != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (!mounted) return;
        await context.read<DailyWorkoutRoutineViewModel>().setWorkoutData(
          widget.workoutData!,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final dailyWorkoutRoutineViewModel =
        Provider.of<DailyWorkoutRoutineViewModel>(context);
    return Scaffold(
      backgroundColor: AppColors.backGroundColor,
      
      body: SafeArea(
        child: ListView(
          padding: context.paddingSymmetricR(horizontal: 20),
          children: [
            AppBarContainer(
              title: 'Daily Workout Routine',
              onTap: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(height: context.sh(24)),
            const WorkoutRoutineHeaderSection(),
            WorkoutPlanCard(
              title: 'Morning Plan',
              iconAsset: AppAssets.sunIcon,
              iconColorFilter: const ColorFilter.mode(
                AppColors.fireColor,
                BlendMode.srcIn,
              ),
              items: dailyWorkoutRoutineViewModel.morningRoutineList,
              baseGlobalIndex: 0,
              viewModel: dailyWorkoutRoutineViewModel,
            ),
            if (dailyWorkoutRoutineViewModel.morningRoutineList.isNotEmpty &&
                dailyWorkoutRoutineViewModel.eveningRoutineList.isNotEmpty)
              SizedBox(height: context.sh(8)),
            WorkoutPlanCard(
              title: 'Evening Plan',
              iconAsset: AppAssets.nightIcon,
              iconColorFilter: null,
              items: dailyWorkoutRoutineViewModel.eveningRoutineList,
              baseGlobalIndex:
                  dailyWorkoutRoutineViewModel.morningRoutineList.length,
              viewModel: dailyWorkoutRoutineViewModel,
            ),
            WorkoutRoutineInsightCard(
              message: dailyWorkoutRoutineViewModel.aiMessage,
            ),
          ],
        ),
      ),
    );
  }
}
