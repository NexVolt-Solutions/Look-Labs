import 'package:flutter/material.dart';
import 'package:looklabs/Features/Widget/normal_text.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';

/// Shared expanded-body lines for height exercise tiles (result + daily routine).
List<Widget> buildHeightExerciseDetailWidgets(
  BuildContext context,
  Map<String, dynamic> item,
) {
  final stepsRaw = item['steps'];
  if (stepsRaw is List && stepsRaw.isNotEmpty) {
    final rows = <Widget>[];
    for (final s in stepsRaw) {
      final line = s?.toString().trim() ?? '';
      if (line.isEmpty) continue;
      rows.add(
        NormalText(
          titleText: '• $line',
          titleSize: context.sp(12),
          titleWeight: FontWeight.w600,
          titleColor: AppColors.iconColor,
        ),
      );
      rows.add(SizedBox(height: context.sh(6)));
    }
    if (rows.isNotEmpty) rows.removeLast();
    return rows;
  }
  final details = item['details']?.toString().trim() ?? '';
  if (details.isNotEmpty) {
    return [
      NormalText(
        titleText: details,
        titleSize: context.sp(12),
        titleWeight: FontWeight.w600,
        titleColor: AppColors.iconColor,
      ),
    ];
  }
  return [
    NormalText(
      titleText: '• Do exercises slowly',
      titleSize: context.sp(12),
      titleWeight: FontWeight.w600,
      titleColor: AppColors.iconColor,
    ),
    SizedBox(height: context.sh(6)),
    NormalText(
      titleText: '• Maintain proper breathing',
      titleSize: context.sp(12),
      titleWeight: FontWeight.w600,
      titleColor: AppColors.iconColor,
    ),
  ];
}
