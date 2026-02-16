// import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
// import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:looklabs/Core/Constants/Widget/normal_text.dart';
// import 'package:looklabs/Core/Constants/Widget/plan_container.dart';
// import 'package:looklabs/Core/Constants/app_assets.dart';
// import 'package:looklabs/Core/Constants/app_colors.dart';
// import 'package:looklabs/Core/Constants/size_extension.dart';

// class ProductWidget extends StatelessWidget {
//   final String? title;
//   final String? disc;
//   final VoidCallback? onTap;
//   final String? icon1;
//   final String? text;
//   final int index;

//   final dynamic viewmodel;

//   const ProductWidget({
//     super.key,
//     required this.index,
//     this.title,
//     this.disc,
//     this.onTap,
//     this.icon1,
//     this.text,
//     this.viewmodel,
//   });

//   @override
//   Widget build(BuildContext context) {
//     /// ✅ Active ViewModel (Hair ya Skin)

//     return Container(
//       padding: EdgeInsets.symmetric(
//         horizontal: context.w(12),
//         vertical: context.h(12),
//       ),
//       margin: context.padSym(v: 12),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(context.radius(10)),
//         color: AppColors.backGroundColor,
//         boxShadow: [
//           BoxShadow(
//             color: AppColors.customContainerColorUp.withOpacity(0.4),
//             offset: const Offset(5, 5),
//             blurRadius: 5,
//           ),
//           BoxShadow(
//             color: AppColors.customContinerColorDown.withOpacity(0.4),
//             offset: const Offset(-5, -5),
//             blurRadius: 5,
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           /// 🔹 HEADER
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Container(
//                 padding: context.padSym(h: 4, v: 4),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(context.radius(10)),
//                   color: AppColors.backGroundColor,
//                   boxShadow: [
//                     BoxShadow(
//                       color: AppColors.customContainerColorUp.withOpacity(0.4),
//                       offset: const Offset(5, 5),
//                       blurRadius: 5,
//                       inset: false,
//                     ),
//                     BoxShadow(
//                       color: AppColors.customContinerColorDown.withOpacity(0.4),
//                       offset: const Offset(-5, -5),
//                       blurRadius: 5,
//                       inset: false,
//                     ),
//                   ],
//                 ),
//                 child: SvgPicture.asset(
//                   AppAssets.dropIcon,
//                   height: context.h(24),
//                   width: context.w(24),
//                 ),
//               ),
//               Container(
//                 padding: context.padSym(h: 6, v: 6),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(context.radius(10)),
//                   color: AppColors.backGroundColor,
//                   boxShadow: [
//                     BoxShadow(
//                       color: AppColors.customContainerColorUp.withOpacity(0.4),
//                       offset: const Offset(5, 5),
//                       blurRadius: 5,
//                       inset: false,
//                     ),
//                     BoxShadow(
//                       color: AppColors.customContinerColorDown.withOpacity(0.4),
//                       offset: const Offset(-5, -5),
//                       blurRadius: 5,
//                       inset: false,
//                     ),
//                   ],
//                 ),
//                 child: Row(
//                   children: [
//                     SvgPicture.asset(
//                       icon1 ?? '',
//                       height: context.h(20),
//                       width: context.w(20),
//                     ),
//                     SizedBox(width: context.w(4)),
//                     NormalText(
//                       titleText: text,
//                       titleSize: context.text(10),
//                       titleColor: AppColors.iconColor,
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),

//           SizedBox(height: context.h(12)),

//           /// 🔹 TITLE + DESC
//           NormalText(
//             titleText: title,
//             subText: disc,
//             titleSize: context.text(16),
//             subSize: context.text(12),
//             titleWeight: FontWeight.w600,
//             subWeight: FontWeight.w500,
//           ),

//           SizedBox(height: context.h(12)),

//           /// 🔹 BUTTON TAGS
//           Wrap(
//             spacing: context.w(8),
//             runSpacing: context.h(8),
//             children: List.generate(viewmodel.productData.length.toInt(), (
//               btnIndex,
//             ) {
//               return PlanContainer(
//                 padding: context.padSym(h: 12, v: 8),
//                 radius: BorderRadius.circular(context.radius(16)),
//                 isSelected: false,
//                 onTap: () {},
//                 child: NormalText(
//                   titleText:
//                       viewmodel!.productData[index]['buttonText'][btnIndex],
//                   titleSize: context.text(10),
//                   titleWeight: FontWeight.w600,
//                   titleColor: AppColors.subHeadingColor,
//                 ),
//               );
//             }),
//           ),
//           // SizedBox(height: context.h(2)),

//           /// 🔹 VIEW DETAILS
//           PlanContainer(
//             isSelected: viewmodel?.selectedIndex == index,
//             onTap: () {
//               viewmodel?.selectProduct(index);
//               onTap?.call();
//             },
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: const [
//                 Text('View Details'),
//                 SizedBox(width: 4),
//                 Icon(Icons.arrow_forward_ios, size: 18),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:looklabs/Features/Widget/normal_text.dart';
import 'package:looklabs/Features/Widget/plan_container.dart';
import 'package:looklabs/Core/Constants/app_assets.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';

class ProductWidget extends StatelessWidget {
  final String? title;
  final String? disc;
  final VoidCallback? onTap;

  /// 🔹 Right badge
  final String? icon1; // first svg
  final String? secondIcon; // second svg (optional)
  final String? text; // text (optional)

  final bool showGradient; // gradient optional
  final int index;
  final dynamic viewmodel;

  const ProductWidget({
    super.key,
    required this.index,
    this.title,
    this.disc,
    this.onTap,
    this.icon1,
    this.secondIcon,
    this.text,
    this.showGradient = false,
    this.viewmodel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.w(12),
        vertical: context.h(12),
      ),
      margin: context.padSym(v: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(context.radius(10)),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔹 HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// Left Icon
              Container(
                padding: context.padSym(h: 4, v: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(context.radius(10)),
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
                child: SvgPicture.asset(
                  AppAssets.dropIcon,
                  height: context.h(24),
                  width: context.w(24),
                  placeholderBuilder: (_) =>
                      const Icon(Icons.image_not_supported),
                ),
              ),

              /// Right Badge (Gradient Optional)
              Container(
                padding: context.padSym(h: 6, v: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(context.radius(10)),
                  gradient: showGradient
                      ? const LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Color(0xFFD0F040),
                            Color(0xFFFFFFFF),
                            Color(0xFFFFE5E2),
                          ],
                        )
                      : null,
                  color: showGradient ? null : AppColors.backGroundColor,
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

                /// 🔹 Badge Content
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    /// First Icon
                    if (icon1 != null)
                      SvgPicture.asset(
                        icon1!,
                        height: context.h(20),
                        width: context.w(20),
                        placeholderBuilder: (_) => const Icon(Icons.image),
                      ),

                    /// Second Icon (Optional)
                    if (secondIcon != null) ...[
                      SizedBox(width: context.w(4)),
                      SvgPicture.asset(
                        secondIcon!,
                        height: context.h(16),
                        width: context.w(16),
                        placeholderBuilder: (_) => const Icon(Icons.image),
                      ),
                    ],

                    /// Text (Optional)
                    if (text != null) ...[
                      SizedBox(width: context.w(4)),
                      NormalText(
                        titleText: text,
                        titleSize: context.text(10),
                        titleColor: AppColors.iconColor,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: context.h(12)),

          /// 🔹 TITLE + DESCRIPTION
          NormalText(
            titleText: title,
            subText: disc,
            titleSize: context.text(16),
            subSize: context.text(12),
            titleWeight: FontWeight.w600,
            subWeight: FontWeight.w500,
          ),

          SizedBox(height: context.h(12)),

          /// 🔹 BUTTON TAGS
          Wrap(
            spacing: context.w(8),
            runSpacing: context.h(8),
            children: List.generate(
              viewmodel.productData[index]['buttonText'].length,
              (btnIndex) {
                return PlanContainer(
                  padding: context.padSym(h: 12, v: 8),
                  radius: BorderRadius.circular(context.radius(16)),
                  isSelected: false,
                  onTap: () {},
                  child: NormalText(
                    titleText:
                        viewmodel.productData[index]['buttonText'][btnIndex],
                    titleSize: context.text(10),
                    titleWeight: FontWeight.w600,
                    titleColor: AppColors.subHeadingColor,
                  ),
                );
              },
            ),
          ),

          SizedBox(height: context.h(12)),

          /// 🔹 VIEW DETAILS BUTTON
          PlanContainer(
            isSelected: viewmodel?.selectedIndex == index,
            onTap: () {
              viewmodel?.selectProduct(index);
              onTap?.call();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('View Details'),
                SizedBox(width: 4),
                Icon(Icons.arrow_forward_ios, size: 18),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
