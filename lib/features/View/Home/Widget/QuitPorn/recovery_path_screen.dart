import 'package:flutter/material.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Features/ViewModel/recovery_path_screen_view_model.dart';
import 'package:looklabs/Features/Widget/app_bar_container.dart';
import 'package:looklabs/Features/Widget/light_card_widget.dart';
import 'package:looklabs/Features/Widget/normal_text.dart';
import 'package:looklabs/Features/View/Home/Widget/QuitPorn/recovery_path_sections.dart';
import 'package:provider/provider.dart';

class RecoveryPathScreen extends StatefulWidget {
  const RecoveryPathScreen({super.key, this.resultData});

  final Map<String, dynamic>? resultData;

  @override
  State<RecoveryPathScreen> createState() => _RecoveryPathScreenState();
}

class _RecoveryPathScreenState extends State<RecoveryPathScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<RecoveryPathScreenViewModel>().initialize(widget.resultData);
    });
  }

  Future<void> _onActionTap(RecoveryPathScreenViewModel vm, int actionIndex) async {
    final message = await vm.onActionTap(actionIndex);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<RecoveryPathScreenViewModel>();

    return Scaffold(
      backgroundColor: AppColors.backGroundColor,
      body: SafeArea(
        child: ListView(
          padding: context.paddingSymmetricR(horizontal: 20),
          children: [
            AppBarContainer(
              title: 'Recovery Path',
              onTap: () => Navigator.pop(context),
            ),
            SizedBox(height: context.sh(20)),
            RecoveryStreakSection(streak: vm.uiData.streak),
            SizedBox(height: context.sh(18)),
            RecoveryProgressSection(
              periodButtons: vm.periodButtons,
              selectedPeriod: vm.selectedPeriod,
              onPeriodTap: vm.onPeriodTap,
              chartLoading: vm.chartLoading,
              chartData: vm.chartFor(vm.selectedPeriod) ?? const [],
              repButtons: vm.repButtons,
              selectedAction: vm.selectedAction,
              onActionTap: (i) => _onActionTap(vm, i),
            ),
            SizedBox(height: context.sh(12)),
            LightCardWidget(text: vm.uiData.insightText),
            SizedBox(height: context.sh(12)),
            RecoverySectionTabs(
              selectedSection: vm.selectedSection,
              onSectionChanged: vm.setSelectedSection,
            ),
            SizedBox(height: context.sh(12)),
            NormalText(
              titleText: vm.taskSectionTitle,
              titleSize: context.sp(18),
              titleWeight: FontWeight.w600,
              titleColor: AppColors.subHeadingColor,
            ),
            SizedBox(height: context.sh(8)),
            RecoveryTaskList(
              selectedSection: vm.selectedSection,
              taskItems: vm.selectedTaskItems,
              taskDone: vm.selectedTaskDone,
              onToggleDaily: vm.toggleDailyDoneAt,
              onToggleExercise: vm.toggleExerciseDoneAt,
            ),
            SizedBox(height: context.sh(24)),
          ],
        ),
      ),
    );
  }
}
