import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:looklabs/Core/Widget/activity_consistency_widget.dart';
import 'package:looklabs/Core/Widget/app_bar_container.dart';
import 'package:looklabs/Core/Widget/custom_container.dart';
import 'package:looklabs/Core/Widget/height_widget_cont.dart';
import 'package:looklabs/Core/Widget/line_chart_widget.dart';
import 'package:looklabs/Core/Widget/normal_text.dart';
import 'package:looklabs/Core/Constants/app_assets.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/ViewModel/facial_progress_screen_view_model.dart';
import 'package:provider/provider.dart';

class FacialProgressScreen extends StatefulWidget {
  const FacialProgressScreen({super.key});

  @override
  State<FacialProgressScreen> createState() => _FacialProgressScreenState();
}

class _FacialProgressScreenState extends State<FacialProgressScreen> {
  @override
  Widget build(BuildContext context) {
    final facialProgressScreenViewModel =
        Provider.of<FacialProgressScreenViewModel>(context);
    return Scaffold(
      backgroundColor: AppColors.backGroundColor,

      body: SafeArea(
        child: ListView(
          padding: context.padSym(h: 20),
          children: [
            AppBarContainer(
              title: 'Your Progress',
              onTap: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(height: context.h(24)),
            NormalText(
              crossAxisAlignment: CrossAxisAlignment.start,
              titleText: 'Track your facial feature improvement journey',
              titleSize: context.text(16),
              titleWeight: FontWeight.w600,
              titleColor: AppColors.subHeadingColor,
            ),
            SizedBox(height: context.h(8)),
            SizedBox(
              height: context.h(135),
              child: ListView.builder(
                itemCount: 4,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return HeightWidgetCont(
                    title: '2300',
                    subTitle: 'Weekly Cal',
                    imgPath: AppAssets.fatLossIcon,
                  );
                },
              ),
            ),
            SizedBox(height: context.h(17)),
            NormalText(
              titleText: 'Your Progress',
              titleSize: context.text(18),
              titleWeight: FontWeight.w600,
              titleColor: AppColors.subHeadingColor,
            ),
            SizedBox(height: context.h(17)),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(
                facialProgressScreenViewModel.buttonName.length,
                (index) {
                  final bool isSelected =
                      facialProgressScreenViewModel.selectedIndex ==
                      facialProgressScreenViewModel.buttonName[index];
                  return CustomContainer(
                    radius: context.radius(10),
                    onTap: () {
                      facialProgressScreenViewModel.selectIndex(index);
                    },
                    color: isSelected
                        ? AppColors.buttonColor.withOpacity(0.11)
                        : AppColors.backGroundColor,
                    border: isSelected
                        ? Border.all(color: AppColors.pimaryColor, width: 1.5)
                        : null,
                    padding: context.padSym(h: 37, v: 13),
                    margin: EdgeInsets.only(right: 8),
                    child: Center(
                      child: Text(
                        facialProgressScreenViewModel.buttonName[index],
                        style: TextStyle(
                          fontSize: context.text(14),
                          fontWeight: FontWeight.w700,
                          color: AppColors.seconderyColor,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: context.h(16)),
            CustomContainer(
              radius: context.radius(10),
              color: AppColors.backGroundColor,
              padding: context.padSym(h: 10, v: 10),
              margin: EdgeInsets.only(bottom: context.h(20)),
              child: Center(child: LineChartWidget()),
            ),
            ActivityConsistencyWidget(
              title: 'Workout Consistency',
              subtitle: 'Your workout activity this week',
              pressentage: 20,
            ),
            SizedBox(height: context.h(16)),
            NormalText(
              titleText: 'Daily Recovery Checklist',
              titleSize: context.text(18),
              titleWeight: FontWeight.w600,
              titleColor: AppColors.subHeadingColor,
            ),
            SizedBox(height: context.h(16)),
            Column(
              children: List.generate(
                facialProgressScreenViewModel.checkBoxName.length,
                (index) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: context.h(12)),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            facialProgressScreenViewModel.toggleChecklist(
                              index,
                            );
                          },
                          child: Container(
                            height: context.h(28),
                            width: context.w(28),
                            decoration: BoxDecoration(
                              color:
                                  facialProgressScreenViewModel
                                      .selectedChecklist[index]
                                  ? AppColors.pimaryColor
                                  : AppColors.backGroundColor,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.customContainerColorUp
                                      .withOpacity(0.4),
                                  offset: const Offset(3, 3),
                                  blurRadius: 4,
                                  inset: true,
                                ),
                                BoxShadow(
                                  color: AppColors.customContinerColorDown
                                      .withOpacity(0.4),
                                  offset: const Offset(-3, -3),
                                  blurRadius: 4,
                                  inset: true,
                                ),
                              ],
                            ),
                            child: Center(
                              child:
                                  facialProgressScreenViewModel
                                      .selectedChecklist[index]
                                  ? Icon(
                                      Icons.check,
                                      size: context.h(16),
                                      color: AppColors.white,
                                    )
                                  : SizedBox(),
                            ),
                          ),
                        ),

                        SizedBox(width: context.w(12)),

                        Expanded(
                          child: NormalText(
                            titleText: facialProgressScreenViewModel
                                .checkBoxName[index],
                            titleSize: context.text(16),
                            titleWeight: FontWeight.w600,
                            titleColor: AppColors.subHeadingColor,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: context.h(150)),
          ],
        ),
      ),
    );
  }
}
