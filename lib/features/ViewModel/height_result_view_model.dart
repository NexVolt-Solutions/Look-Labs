import 'package:flutter/material.dart';
import 'package:looklabs/Core/Network/api_error_handler.dart';
import 'package:looklabs/Core/Network/models/height_flow_ui_data.dart';
import 'package:looklabs/Core/Network/models/height_routine_lists.dart';
import 'package:looklabs/Core/Routes/routes_name.dart';
import 'package:looklabs/Features/ViewModel/height_screen_view_model.dart';

/// Presentation logic for [HeightResultScreen]: maps API payload + routine lists to UI data and navigation.
class HeightResultViewModel {
  HeightResultViewModel(this.resultData);

  final Map<String, dynamic>? resultData;

  HeightRoutineLists _lists(HeightScreenViewModel routines) {
    return HeightRoutineLists(
      morning: routines.morningRoutineList,
      evening: routines.eveningRoutineList,
    );
  }

  HeightFlowUiData ui(HeightScreenViewModel routines) {
    return HeightFlowUiData.fromResult(resultData, _lists(routines));
  }

  bool hasRoutineFor(HeightScreenViewModel routines) {
    final l = _lists(routines);
    return l.morning.isNotEmpty || l.evening.isNotEmpty;
  }

  void openDailyHeightRoutine(BuildContext context, HeightScreenViewModel vm) {
    final lists = _lists(vm);
    if (lists.morning.isEmpty && lists.evening.isEmpty) {
      ApiErrorHandler.showSnackBar(
        context,
        fallback: 'No exercises in your plan yet.',
      );
      return;
    }
    final args = HeightFlowUiData.dailyRoutineArguments(resultData, lists);
    Navigator.pushNamed(
      context,
      RoutesName.DailyHeightRoutineScreen,
      arguments: args,
    );
  }
}
