import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:looklabs/Features/Widget/normal_text.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class SpeedMeterWidget extends StatelessWidget {
  final box1Title;
  final box1subTitle;
  final box2Title;
  final box2subTitle;
  final box1per;
  final box2per;

  final smHTitle;
  final smTitle;
  final smsSubTitle;
  const SpeedMeterWidget({
    super.key,
    this.box1Title,
    this.box1subTitle,
    this.box2Title,
    this.box2subTitle,
    this.box1per,
    this.box2per,
    this.smHTitle,
    this.smTitle,
    this.smsSubTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: List.generate(2, (index) {
            return Expanded(
              child: Container(
                padding: context.paddingSymmetricR(horizontal: 20, vertical: 30),
                margin: context.paddingSymmetricR(horizontal: 8, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(context.radiusR(16)),
                  color: AppColors.backGroundColor,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.customContainerColorUp.withOpacity(0.4),
                      offset: const Offset(5, 5),
                      blurRadius: 5,
                      inset: false,
                    ),
                    BoxShadow(
                      color: AppColors.customContinerColorDown.withOpacity(0.4),
                      offset: const Offset(-5, -5),
                      blurRadius: 5,
                      inset: false,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      box1Title,
                      style: TextStyle(
                        fontSize: context.sp(16.32),
                        fontWeight: FontWeight.w600,
                        color: AppColors.notSelectedColor,
                      ),
                    ),
                    Text(
                      box1subTitle,
                      style: TextStyle(
                        fontSize: context.sp(16.32),
                        fontWeight: FontWeight.w600,
                        color: AppColors.subHeadingColor,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                            height: context.sh(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                context.radiusR(20),
                              ),
                              color: AppColors.backGroundColor,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.customContainerColorUp
                                      .withOpacity(0.4),
                                  offset: const Offset(5, 5),
                                  blurRadius: 5,
                                  inset: true,
                                ),
                                BoxShadow(
                                  color: AppColors.customContinerColorDown
                                      .withOpacity(0.4),
                                  offset: const Offset(-5, -5),
                                  blurRadius: 5,
                                  inset: true,
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                context.radiusR(20),
                              ),
                              child: LinearPercentIndicator(
                                padding: EdgeInsets.zero,
                                lineHeight: context.sh(8),
                                percent: 0.5,
                                backgroundColor: AppColors.backGroundColor,
                                progressColor: AppColors.pimaryColor,
                                barRadius: Radius.circular(context.radiusR(20)),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: context.sw(8)),
                        Text(
                          box1per,
                          style: TextStyle(
                            fontSize: context.sp(12),
                            fontWeight: FontWeight.w600,
                            color: AppColors.subHeadingColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
        ),

        Container(
          padding: context.paddingSymmetricR(horizontal: 20, vertical: 13),
          margin: context.paddingSymmetricR(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(context.radiusR(16)),
            color: AppColors.backGroundColor,
            boxShadow: [
              BoxShadow(
                color: AppColors.customContainerColorUp.withOpacity(0.4),
                offset: const Offset(5, 5),
                blurRadius: 5,
              ),
              BoxShadow(
                color: AppColors.customContinerColorDown.withOpacity(0.4),
                offset: const Offset(-5, -5),
                blurRadius: 5,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  NormalText(
                    titleText: smHTitle,
                    titleSize: context.sp(16),
                    titleWeight: FontWeight.w500,
                    titleColor: AppColors.subHeadingColor,
                  ),
                  Divider(thickness: 1, indent: 0, endIndent: 10),
                  NormalText(
                    titleText: smTitle,
                    titleSize: context.sp(12),
                    titleWeight: FontWeight.w500,
                    titleColor: AppColors.subHeadingColor,
                    subText: smsSubTitle,
                    subSize: context.sp(14),
                    subWeight: FontWeight.w600,
                    subColor: AppColors.subHeadingColor,
                  ),
                ],
              ),
              Center(child: _getRadialGauge()),
            ],
          ),
        ),
      ],
    );
  }
}

Widget _getRadialGauge() {
  return SizedBox(
    height: 100,
    width: 200,

    child: SfRadialGauge(
      axes: <RadialAxis>[
        RadialAxis(
          minimum: 0,
          maximum: 100,

          // 🔹 SEMI CIRCLE
          startAngle: 180,
          endAngle: 0,

          showTicks: false,
          showLabels: false,

          axisLineStyle: const AxisLineStyle(
            thickness: 8, // chhoti size ke liye kam
            cornerStyle: CornerStyle.bothCurve,
          ),

          // 🔹 3 COLOR PARTS
          ranges: <GaugeRange>[
            GaugeRange(
              startValue: 0,
              endValue: 33,
              color: Colors.red,
              startWidth: 8,
              endWidth: 8,
            ),
            GaugeRange(
              startValue: 33,
              endValue: 66,
              color: Colors.yellow,
              startWidth: 8,
              endWidth: 8,
            ),
            GaugeRange(
              startValue: 66,
              endValue: 100,
              color: Colors.green,
              startWidth: 8,
              endWidth: 8,
            ),
          ],

          // 🔹 NEEDLE
          pointers: const <GaugePointer>[
            NeedlePointer(
              value: 70,
              needleLength: 0.6,
              needleStartWidth: 1,
              needleEndWidth: 3,
              knobStyle: KnobStyle(
                color: Colors.black,
                sizeUnit: GaugeSizeUnit.factor,
                knobRadius: 0.04,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
