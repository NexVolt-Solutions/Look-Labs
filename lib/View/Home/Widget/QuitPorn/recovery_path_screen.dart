import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:flutter_svg/svg.dart';
import 'package:looklabs/Core/Widget/app_bar_container.dart';
import 'package:looklabs/Core/Widget/custom_container.dart';
import 'package:looklabs/Core/Widget/light_card_widget.dart';
import 'package:looklabs/Core/Widget/line_chart_widget.dart';
import 'package:looklabs/Core/Widget/normal_text.dart';
import 'package:looklabs/Core/Widget/plan_container.dart';
import 'package:looklabs/Core/Constants/app_assets.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Core/Widget/streak_widget.dart';
import 'package:looklabs/ViewModel/recovery_path_screen_view_model.dart';

class RecoveryPathScreen extends StatefulWidget {
  const RecoveryPathScreen({super.key});

  @override
  State<RecoveryPathScreen> createState() => _RecoveryPathScreenState();
}

class _RecoveryPathScreenState extends State<RecoveryPathScreen> {
  @override
  Widget build(BuildContext context) {
    final recoveryPathScreenViewModel = RecoveryPathScreenViewModel();
    return Scaffold(
      backgroundColor: AppColors.backGroundColor,
      body: SafeArea(
        child: ListView(
          padding: context.padSym(h: 20),
          children: [
            AppBarContainer(
              title: 'Recovery Path',
              onTap: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(height: context.h(24)),
            PlanContainer(
              margin: context.padSym(v: 0),
              padding: context.padSym(h: 12, v: 20),
              isSelected: false,
              onTap: () {},
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StreakWidget(
                    image: AppAssets.fatLossIcon,
                    title: 'Current Streak',
                    titleSize: context.text(16),
                    titleColor: AppColors.iconColor,
                    titleWeight: FontWeight.w500,
                    richTitle: '10',
                    richSubTitle: ' days',
                    richTitleSize: context.text(24),
                    richTitleWeight: FontWeight.w600,
                    richTitleColor: AppColors.subHeadingColor,
                    richSubTitleSize: context.text(14),
                    richSubTitleWeight: FontWeight.w600,
                    richSubTitleColor: AppColors.subHeadingColor,
                  ),
                  SizedBox(height: context.h(5)),
                  Divider(
                    color: AppColors.iconColor,
                    thickness: 0.5,
                    height: context.h(0.5),
                  ),
                  SizedBox(height: context.h(5)),
                  NormalText(
                    titleText: 'Today is day one. Let\'s make it count! 🌱',
                    titleSize: context.text(12),
                    titleWeight: FontWeight.w400,
                    titleColor: AppColors.iconColor,
                  ),
                  // SizedBox(height: context.h(18)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      recoveryPathScreenViewModel.richTextName.length,
                      (index) {
                        return Expanded(
                          child: PlanContainer(
                            margin: context.padSym(v: 8, h: 6),
                            radius: BorderRadius.circular(context.radius(10)),
                            padding: context.padSym(h: 12, v: 12),
                            isSelected: false,
                            onTap: () {},
                            child: StreakWidget(
                              image: recoveryPathScreenViewModel
                                  .richTextName[index]['image'],
                              title: recoveryPathScreenViewModel
                                  .richTextName[index]['text'],
                              titleColor: AppColors.iconColor,
                              titleSize: context.text(12),
                              titleWeight: FontWeight.w500,
                              richTitle: recoveryPathScreenViewModel
                                  .richTextName[index]['richtitle'],
                              richSubTitle: recoveryPathScreenViewModel
                                  .richTextName[index]['richsubtitle'],
                              richTitleSize: context.text(14),
                              richTitleWeight: FontWeight.w500,
                              richTitleColor: AppColors.subHeadingColor,
                              richSubTitleSize: context.text(14),
                              richSubTitleWeight: FontWeight.w600,
                              richSubTitleColor: AppColors.subHeadingColor,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: context.h(20)),
            NormalText(
              titleText: 'Your Progress',
              titleSize: context.text(18),
              titleWeight: FontWeight.w600,
              titleColor: AppColors.subHeadingColor,
            ),
            SizedBox(height: context.h(8)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(
                recoveryPathScreenViewModel.buttonName.length,
                (index) {
                  final bool isSelected =
                      recoveryPathScreenViewModel.selectedIndex ==
                      recoveryPathScreenViewModel.buttonName[index];
                  return CustomContainer(
                    radius: context.radius(10),
                    onTap: () {
                      recoveryPathScreenViewModel.selectIndex(index);
                    },
                    color: isSelected
                        ? AppColors.buttonColor.withOpacity(0.11)
                        : AppColors.backGroundColor,
                    border: isSelected
                        ? Border.all(color: AppColors.pimaryColor, width: 1.5)
                        : null,
                    padding: context.padSym(h: 38, v: 12),
                    margin: context.padSym(h: 0, v: 0),
                    child: Center(
                      child: Text(
                        recoveryPathScreenViewModel.buttonName[index],
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
            SizedBox(height: context.h(8)),
            PlanContainer(
              padding: context.padSym(h: 10, v: 10),
              radius: BorderRadius.circular(context.radius(10)),
              isSelected: false,
              onTap: () {},
              child: LineChartWidget(),
            ),

            SizedBox(height: context.h(8)),
            SizedBox(
              height: 80,
              child: ListView.separated(
                separatorBuilder: (context, index) =>
                    SizedBox(width: context.w(12)),
                scrollDirection: Axis.horizontal,
                itemCount: 2,
                itemBuilder: (_, index) {
                  final item = recoveryPathScreenViewModel.repButtonName[index];

                  return PlanContainer(
                    margin: context.padSym(v: 0),
                    padding: context.padSym(h: 45),
                    radius: BorderRadius.circular(context.radius(10)),
                    isSelected:
                        recoveryPathScreenViewModel.selectedRepIndex == index,
                    onTap: () {
                      recoveryPathScreenViewModel.selectRepButton(index);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: context.h(24),
                          width: context.w(24),
                          child: SvgPicture.asset(
                            item['image'],
                            color: AppColors.pimaryColor,
                            fit: BoxFit.scaleDown,
                          ),
                        ),
                        SizedBox(height: context.h(6)),
                        NormalText(
                          titleText: item['text'],
                          titleSize: context.text(12),
                          titleWeight: FontWeight.w500,
                          titleColor: AppColors.subHeadingColor,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: context.h(18)),
            LightCardWidget(
              text:
                  'Consistency improves stamina, strength & posture over time.',
            ),
            SizedBox(height: context.h(18)),
            SizedBox(
              height: 70,
              child: ListView.separated(
                separatorBuilder: (context, index) =>
                    SizedBox(width: context.w(12)),
                scrollDirection: Axis.horizontal,
                itemCount: 2,
                itemBuilder: (_, index) {
                  final item =
                      recoveryPathScreenViewModel.recordButtonName[index];
                  return PlanContainer(
                    margin: context.padSym(v: 0),
                    padding: context.padSym(h: 38, v: 6),
                    radius: BorderRadius.circular(context.radius(10)),
                    isSelected:
                        recoveryPathScreenViewModel.selectedRecIndex == index,
                    onTap: () {
                      recoveryPathScreenViewModel.selectRecordButton(index);

                      // Add this line to track which section should be shown
                      if (item['text'] == 'Daily Tasks') {
                        recoveryPathScreenViewModel.selectSection(
                          'Daily Tasks',
                        );
                      } else if (item['text'] == 'Exercise') {
                        recoveryPathScreenViewModel.selectSection('Exercise');
                      }
                    },
                    child: Row(
                      children: [
                        SvgPicture.asset(item['image']),
                        SizedBox(width: context.w(6)),
                        NormalText(titleText: item['text']),
                      ],
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: context.h(8)),

            if (recoveryPathScreenViewModel.selectedSection == 'Daily Tasks')
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  NormalText(
                    titleText: 'Your Daily Tasks',
                    titleSize: context.text(18),
                    titleWeight: FontWeight.w600,
                    titleColor: AppColors.subHeadingColor,
                  ),
                  SizedBox(height: context.h(15)),
                  PlanContainer(
                    margin: context.padSym(v: 0),
                    padding: context.padSym(v: 5, h: 14),
                    isSelected: false,
                    onTap: () {},
                    child: Column(
                      children: List.generate(
                        recoveryPathScreenViewModel.checkBoxName.length,
                        (index) {
                          final isChecked = recoveryPathScreenViewModel
                              .selectedChecklist[index];

                          return Padding(
                            padding: context.padSym(v: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    recoveryPathScreenViewModel.toggleChecklist(
                                      index,
                                    );
                                  },
                                  child: Container(
                                    height: context.h(28),
                                    width: context.w(28),
                                    decoration: BoxDecoration(
                                      color: isChecked
                                          ? AppColors.pimaryColor
                                          : AppColors.backGroundColor,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors
                                              .customContainerColorUp
                                              .withOpacity(0.4),
                                          offset: const Offset(3, 3),
                                          blurRadius: 4,
                                          inset: true,
                                        ),
                                        BoxShadow(
                                          color: AppColors
                                              .customContinerColorDown
                                              .withOpacity(0.4),
                                          offset: const Offset(-3, -3),
                                          blurRadius: 4,
                                          inset: true,
                                        ),
                                      ],
                                    ),
                                    child: isChecked
                                        ? Icon(
                                            Icons.check,
                                            size: context.h(16),
                                            color: AppColors.white,
                                          )
                                        : null,
                                  ),
                                ),
                                SizedBox(width: context.w(12)),
                                Expanded(
                                  child: NormalText(
                                    titleText: recoveryPathScreenViewModel
                                        .checkBoxName[index]['text'],
                                    titleSize: context.text(14),
                                    titleWeight: FontWeight.w500,
                                    titleColor: AppColors.subHeadingColor,
                                    subText: recoveryPathScreenViewModel
                                        .checkBoxName[index]['subTitle'],
                                    subSize: context.text(10),
                                    subColor: AppColors.subHeadingColor,
                                    subWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              )
            else if (recoveryPathScreenViewModel.selectedSection == 'Exercise')
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  NormalText(
                    titleText: 'Mental & Physical Exercises',
                    titleSize: context.text(18),
                    titleWeight: FontWeight.w600,
                    titleColor: AppColors.subHeadingColor,
                  ),
                  // Your exercise content from Document 1
                  Column(
                    children: List.generate(
                      recoveryPathScreenViewModel.checkBoxName.length,
                      (index) {
                        final isChecked = recoveryPathScreenViewModel
                            .selectedChecklist[index];

                        return PlanContainer(
                          isSelected: isChecked,
                          onTap: () {
                            recoveryPathScreenViewModel.toggleChecklist(index);
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              PlanContainer(
                                margin: context.padSym(v: 1),
                                padding: context.padSym(h: 4, v: 4),
                                isSelected: false,
                                onTap: () {},
                                child: Center(
                                  child: SizedBox(
                                    height: context.h(32),
                                    width: context.w(32),
                                    child: SvgPicture.asset(
                                      AppAssets.lightBulbIcon,
                                      fit: BoxFit.scaleDown,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: context.w(12)),
                              Expanded(
                                child: NormalText(
                                  titleText: recoveryPathScreenViewModel
                                      .checkBoxName[index]['text'],
                                  titleSize: context.text(14),
                                  titleWeight: FontWeight.w500,
                                  titleColor: AppColors.subHeadingColor,
                                  subText: recoveryPathScreenViewModel
                                      .checkBoxName[index]['subTitle'],
                                  subSize: context.text(10),
                                  subColor: AppColors.subHeadingColor,
                                  subWeight: FontWeight.w400,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  recoveryPathScreenViewModel.toggleChecklist(
                                    index,
                                  );
                                },
                                child: Container(
                                  height: context.h(28),
                                  width: context.w(28),
                                  decoration: BoxDecoration(
                                    color: isChecked
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
                                  child: isChecked
                                      ? Icon(
                                          Icons.check,
                                          size: context.h(16),
                                          color: AppColors.white,
                                        )
                                      : null,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            SizedBox(height: context.h(30)),
          ],
        ),
      ),
    );
  }
}
