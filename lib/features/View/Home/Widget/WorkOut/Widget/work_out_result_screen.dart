import 'package:flutter/material.dart';
import 'package:looklabs/Core/Network/api_error_handler.dart';
import 'package:looklabs/Features/Widget/app_bar_container.dart';
import 'package:looklabs/Features/Widget/custom_button.dart';
import 'package:looklabs/Features/View/Home/Widget/WorkOut/Widget/Sections/workout_result_sections.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Core/Routes/routes_name.dart';
import 'package:looklabs/Features/ViewModel/work_out_result_screen_view_model.dart';
import 'package:provider/provider.dart';

class WorkOutResultScreen extends StatefulWidget {
  const WorkOutResultScreen({super.key, this.workoutData});

  final Map<String, dynamic>? workoutData;

  @override
  State<WorkOutResultScreen> createState() => _WorkOutResultScreenState();
}

class _WorkOutResultScreenState extends State<WorkOutResultScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.workoutData != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        context.read<WorkOutResultScreenViewModel>().setWorkoutData(
          widget.workoutData!,
        );
      });
    }
  }

  @override
  void didUpdateWidget(covariant WorkOutResultScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(oldWidget.workoutData, widget.workoutData) &&
        widget.workoutData != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        context.read<WorkOutResultScreenViewModel>().setWorkoutData(
          widget.workoutData!,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final workOutResultViewModel = Provider.of<WorkOutResultScreenViewModel>(
      context,
    );
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: EdgeInsetsGeometry.only(
          top: context.sh(5),
          left: context.sw(20),
          right: context.sw(20),
          bottom: context.sh(30),
        ),
        child: CustomButton(
          isEnabled: !workOutResultViewModel.getStartedLoading,
          onTap: () async {
            final vm = workOutResultViewModel;
            if (!vm.hasGeneratedPlan && vm.selectedIndex < 0) {
              ApiErrorHandler.showSnackBar(
                context,
                fallback: 'Please select a focus',
              );
              return;
            }
            if (vm.hasGeneratedPlan) {
              if (!context.mounted) return;
              Navigator.pushNamed(
                context,
                RoutesName.WorkOutProgressScreen,
                arguments: vm.workoutData ?? widget.workoutData,
              );
              return;
            }
            final response = await vm.generateWorkoutPlan(
              selectedFocusIndex: vm.selectedIndex,
              loadingSource:
                  WorkOutResultScreenViewModel.loadingSourceGetStarted,
            );
            if (!context.mounted) return;
            if (!response.success) {
              ApiErrorHandler.showSnackBar(context, response: response);
              return;
            }
            Navigator.pushNamed(
              context,
              RoutesName.WorkOutProgressScreen,
              arguments: vm.workoutData ?? widget.workoutData,
            );
          },
          text: workOutResultViewModel.getStartedLoading
              ? 'Loading...'
              : workOutResultViewModel.hasGeneratedPlan
              ? 'Continue'
              : 'Get Started',
          color: AppColors.pimaryColor,
        ),
      ),

      backgroundColor: AppColors.backGroundColor,

      body: SafeArea(
        child: ListView(
          padding: context.paddingSymmetricR(horizontal: 20),
          children: [
            AppBarContainer(
              title: workOutResultViewModel.screenTitle ?? 'Workout',
              onTap: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(height: context.sh(24)),
            WorkoutAiMessageSection(viewModel: workOutResultViewModel),
            WorkoutAttributesSection(viewModel: workOutResultViewModel),
            WorkoutFocusSection(viewModel: workOutResultViewModel),
            WorkoutPostureInsightSection(viewModel: workOutResultViewModel),
          ],
        ),
      ),
    );
  }
}
