import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:looklabs/Features/Widget/app_bar_container.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Features/View/Home/Widget/WorkOut/Widget/Sections/workout_progress_header_metrics_section.dart';
import 'package:looklabs/Features/View/Home/Widget/WorkOut/Widget/Sections/workout_progress_recovery_section.dart';
import 'package:looklabs/Features/ViewModel/work_out_progress_screen_view_model.dart';
import 'package:provider/provider.dart';

class WorkOutProgressScreen extends StatefulWidget {
  const WorkOutProgressScreen({super.key, this.workoutData});

  final Map<String, dynamic>? workoutData;

  @override
  State<WorkOutProgressScreen> createState() => _WorkOutProgressScreenState();
}

class _WorkOutProgressScreenState extends State<WorkOutProgressScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final vm = context.read<WorkOutProgressScreenViewModel>();
      if (widget.workoutData != null) {
        vm.setWorkoutData(widget.workoutData!);
      }
      vm.loadProgressData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final yourProgressScreenViewModel =
        Provider.of<WorkOutProgressScreenViewModel>(context);
    return Scaffold(
      backgroundColor: AppColors.backGroundColor,

      body: SafeArea(
        child: yourProgressScreenViewModel.progressLoading
            ? Center(
                child: CircularProgressIndicator(color: AppColors.pimaryColor),
              )
            : ListView(
                padding: context.paddingSymmetricR(horizontal: 20),
                children: [
                  AppBarContainer(
                    title: 'Your Progress',
                    onTap: () => Navigator.pop(context),
                  ),
                  SizedBox(height: context.sh(24)),
                  WorkoutProgressHeaderSection(
                    viewModel: yourProgressScreenViewModel,
                  ),
                  WorkoutMetricsSection(viewModel: yourProgressScreenViewModel),
                  SizedBox(height: context.sh(10)),
                  WorkoutTodayCardSection(
                    viewModel: yourProgressScreenViewModel,
                    workoutData: widget.workoutData,
                  ),
                  WorkoutRecoverySection(viewModel: yourProgressScreenViewModel),
                  SizedBox(height: context.sh(20)),
                  WorkoutInsightCardSection(viewModel: yourProgressScreenViewModel),
                  SizedBox(height: context.sh(20)),
                ],
              ),
      ),
    );
  }
}
