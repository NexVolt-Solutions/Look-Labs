import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:looklabs/Core/Constants/Widget/normal_text.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';

class HealtDetailsViewModel extends ChangeNotifier {
  int currentStep = 0;

  List<String> buttonName = ['Balanced', 'Protein', 'Vegetarian', 'Custom'];

  String selectedIndex = '';

  void selectIndex(int index) {
    if (selectedIndex == buttonName[index]) {
      selectedIndex = '';
    } else {
      selectedIndex = buttonName[index];
    }
    notifyListeners();
  }

  void showCustomBottomSheet(BuildContext context) {
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
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              left: context.w(20),
              right: context.w(20),
              top: context.h(20),
              bottom: MediaQuery.of(context).viewInsets.bottom + context.h(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NormalText(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  titleText: 'Workout Frequency',
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
                  itemCount: buttonName.length,
                  itemBuilder: (context, index) {
                    final bool isSelected = selectedIndex == buttonName[index];

                    return GestureDetector(
                      onTap: () {
                        selectIndex(index);

                        if (buttonName[index] == 'Custom') {
                          showCustomBottomSheet(context);
                        }
                      },
                      child: Container(
                        padding: context.padSym(h: 24, v: 18),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.buttonColor.withOpacity(0.11)
                              : AppColors.backGroundColor,
                          borderRadius: BorderRadius.circular(
                            context.radius(16),
                          ),
                          border: isSelected
                              ? Border.all(
                                  color: AppColors.buttonColor,
                                  width: 1.5,
                                )
                              : null,
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: AppColors.buttonColor.withOpacity(
                                      0.15,
                                    ),
                                    offset: const Offset(5, 5),
                                    blurRadius: 20,
                                    inset: true,
                                  ),
                                  BoxShadow(
                                    color: AppColors.buttonColor.withOpacity(
                                      0.15,
                                    ),
                                    offset: const Offset(-5, -5),
                                    blurRadius: 20,
                                    inset: true,
                                  ),
                                ]
                              : [
                                  BoxShadow(
                                    color: AppColors.customContainerColorUp
                                        .withOpacity(0.5),
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
                            buttonName[index],
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
          ),
        );
      },
    );
  }
}
