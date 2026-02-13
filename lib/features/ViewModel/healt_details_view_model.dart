import 'package:flutter/material.dart';
import 'package:looklabs/Features/Widget/normal_text.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';

class HealtDetailsViewModel extends ChangeNotifier {
  int currentStep = 0;

  List<String> dietTypButtonName = [
    'Balanced',
    'Protein',
    'Vegetarian',
    'Custom',
  ];

  List<String> workOutFreButtonName = [
    'Daily',
    '3-4x per week',
    'Rarely',
    'Never',
  ];

  String selectedDiet = 'Balance Diet';
  String selectedWorkout = 'Never';

  void selectValue(String value, bool isDiet) {
    if (isDiet) {
      selectedDiet = value;
    } else {
      selectedWorkout = value;
    }
    notifyListeners();
  }

  /// 🔥 REUSABLE BOTTOM SHEET
  void showSelectionBottomSheet({
    required BuildContext context,
    required String title,
    required List<String> list,
    required bool isDiet,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.backGroundColor,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(context.radius(24)),
        ),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            left: context.w(20),
            right: context.w(20),
            top: context.h(20),
            bottom: context.h(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NormalText(
                titleText: title,
                titleSize: context.text(20),
                titleWeight: FontWeight.w600,
                titleColor: AppColors.headingColor,
              ),
              SizedBox(height: context.h(24)),

              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: context.w(16),
                  crossAxisSpacing: context.w(16),
                  childAspectRatio: 2.5,
                ),
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final bool isSelected = isDiet
                      ? selectedDiet == list[index]
                      : selectedWorkout == list[index];

                  return GestureDetector(
                    onTap: () {
                      selectValue(list[index], isDiet);
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: context.padSym(h: 24, v: 18),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.buttonColor.withOpacity(0.11)
                            : AppColors.backGroundColor,
                        borderRadius: BorderRadius.circular(context.radius(16)),
                        border: isSelected
                            ? Border.all(
                                color: AppColors.buttonColor,
                                width: 1.5,
                              )
                            : null,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.customContainerColorUp.withOpacity(
                              0.4,
                            ),
                            offset: const Offset(5, 5),
                            blurRadius: 20,
                          ),
                          BoxShadow(
                            color: AppColors.customContinerColorDown,
                            offset: const Offset(-5, -5),
                            blurRadius: 20,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          list[index],
                          style: TextStyle(
                            fontSize: context.text(14),
                            fontWeight: FontWeight.w700,
                            color: isSelected
                                ? AppColors.headingColor
                                : AppColors.seconderyColor,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
