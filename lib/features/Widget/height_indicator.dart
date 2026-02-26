// import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
// import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
// import 'package:looklabs/Core/Constants/Widget/normal_text.dart';
// import 'package:looklabs/Core/Constants/app_colors.dart';
// import 'package:looklabs/Core/Constants/size_extension.dart';

// class HeightIndicater extends StatelessWidget {
//   final String? title;
//   final String? per;
//   final onChanged;
//   //  ValueChanged<double>

//   const HeightIndicater({
//     super.key,
//     this.onChanged,
//     required this.title,
//     this.per,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         NormalText(
//           titleText: title ?? '',
//           titleSize: context.sp(14),
//           titleWeight: FontWeight.w600,
//           titleColor: AppColors.subHeadingColor,
//         ),
//         SizedBox(height: context.sh(16)),

//         Row(
//           children: [
//             // 🔹 Slider takes remaining width
//             Expanded(
//               child: Container(
//                 height: context.sh(20),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(context.radiusR(10)),
//                   border: Border.all(
//                     color: AppColors.backGroundColor,
//                     width: context.sw(1.5),
//                   ),
//                   color: AppColors.backGroundColor,
//                   boxShadow: [
//                     BoxShadow(
//                       color: AppColors.customContainerColorUp.withOpacity(0.4),
//                       offset: const Offset(5, 5),
//                       blurRadius: 5,
//                       inset: true,
//                     ),
//                     BoxShadow(
//                       color: AppColors.customContinerColorDown.withOpacity(0.4),
//                       offset: const Offset(-5, -5),
//                       blurRadius: 5,
//                       inset: true,
//                     ),
//                   ],
//                 ),
//                 child: Stack(
//                   clipBehavior: Clip.none,
//                   children: [
//                     // Active bar
//                     Container(
//                       height: context.sh(20),
//                       width: context.sw(200), // later dynamic
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(context.radiusR(10)),
//                         color: AppColors.pimaryColor,
//                       ),
//                     ),

//                     // Thumb
//                     Positioned(
//                       left: context.sw(180),
//                       top: -context.sh(4),
//                       child: Container(
//                         height: context.sh(28),
//                         width: context.sw(44),
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(
//                             context.radiusR(76),
//                           ),
//                           color: AppColors.backGroundColor,
//                           boxShadow: [
//                             BoxShadow(
//                               color: AppColors.customContainerColorUp
//                                   .withOpacity(0.4),
//                               offset: const Offset(2.5, 2.5),
//                               blurRadius: 0,
//                             ),
//                             BoxShadow(
//                               color: AppColors.customContinerColorDown
//                                   .withOpacity(0.4),
//                               offset: const Offset(-2.5, -2.5),
//                               blurRadius: 10,
//                             ),
//                           ],
//                         ),
//                         child: Center(
//                           child: Text(
//                             '|||',
//                             style: TextStyle(
//                               fontWeight: FontWeight.w800,
//                               color: AppColors.pimaryColor,
//                               fontSize: context.sp(15),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//             SizedBox(width: context.sw(8)),

//             // 🔹 Percentage text
//             NormalText(
//               titleText: per ?? '',
//               titleSize: context.sp(12),
//               titleWeight: FontWeight.w600,
//               titleColor: AppColors.subHeadingColor,
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:looklabs/Features/Widget/normal_text.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';

class HeightIndicater extends StatefulWidget {
  final String title;
  final double initialValue; // 0.0 - 1.0
  final ValueChanged<double>? onChanged;

  const HeightIndicater({
    super.key,
    required this.title,
    this.initialValue = 0.5,
    this.onChanged,
  });

  @override
  State<HeightIndicater> createState() => _HeightIndicaterState();
}

class _HeightIndicaterState extends State<HeightIndicater> {
  late double _value; // 0.0 - 1.0

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue.clamp(0.0, 1.0);
  }

  void _updateValue(Offset localPosition, double maxWidth) {
    double newValue = localPosition.dx / maxWidth;
    newValue = newValue.clamp(0.0, 1.0);

    setState(() => _value = newValue);

    widget.onChanged?.call(_value);
  }

  @override
  Widget build(BuildContext context) {
    final double barHeight = context.sh(20);
    final double thumbWidth = context.sw(44);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        NormalText(
          titleText: widget.title,
          titleSize: context.sp(14),
          titleWeight: FontWeight.w600,
          titleColor: AppColors.subHeadingColor,
        ),

        SizedBox(height: context.sh(16)),

        Row(
          children: [
            /// 🔹 SLIDER
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final double maxWidth = constraints.maxWidth;
                  final double progressWidth = maxWidth * _value;
                  final double thumbLeft = (progressWidth - thumbWidth / 2)
                      .clamp(0, maxWidth - thumbWidth);

                  return GestureDetector(
                    onHorizontalDragUpdate: (details) {
                      _updateValue(details.localPosition, maxWidth);
                    },
                    onTapDown: (details) {
                      _updateValue(details.localPosition, maxWidth);
                    },
                    child: Container(
                      height: barHeight,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(context.radiusR(10)),
                        color: AppColors.backGroundColor,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.customContainerColorUp.withOpacity(
                              0.4,
                            ),
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
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          /// ACTIVE BAR
                          Container(
                            height: barHeight,
                            width: progressWidth,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                context.radiusR(10),
                              ),
                              color: AppColors.pimaryColor,
                            ),
                          ),

                          /// THUMB
                          Positioned(
                            left: thumbLeft,
                            top: -context.sh(4),
                            child: Container(
                              height: context.sh(28),
                              width: thumbWidth,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  context.radiusR(76),
                                ),
                                color: AppColors.backGroundColor,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.customContainerColorUp
                                        .withOpacity(0.4),
                                    offset: const Offset(2.5, 2.5),
                                  ),
                                  BoxShadow(
                                    color: AppColors.customContinerColorDown
                                        .withOpacity(0.4),
                                    offset: const Offset(-2.5, -2.5),
                                    blurRadius: 10,
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  '|||',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.pimaryColor,
                                    fontSize: context.sp(15),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            SizedBox(width: context.sw(8)),

            /// 🔹 PERCENT TEXT
            NormalText(
              titleText: '${(_value * 100).round()}%',
              titleSize: context.sp(12),
              titleWeight: FontWeight.w600,
              titleColor: AppColors.subHeadingColor,
            ),
          ],
        ),
      ],
    );
  }
}
