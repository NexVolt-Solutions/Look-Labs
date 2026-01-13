// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:looklabs/Core/Constants/Widget/normal_text.dart';
// import 'package:looklabs/Core/Constants/app_colors.dart';
// import 'package:looklabs/Core/Constants/size_extension.dart';
// import 'package:looklabs/ViewModel/top_product_view_model.dart';
// import 'plan_container.dart'; // assuming you have this widget

// class ProdectWidgetContiner extends StatelessWidget {
//   final TopProductViewModel topProductViewModel;
//   final int productIndex;

//   const ProdectWidgetContiner({
//     super.key,
//     required this.topProductViewModel,
//     required this.productIndex,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final product = topProductViewModel.scalpTags[productIndex];

//     return Container(
//       padding: EdgeInsets.symmetric(
//         horizontal: context.w(12),
//         vertical: context.h(12),
//       ),
//       margin: context.padSym(v: 12),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(context.radius(10)),
//         border: Border.all(
//           color: AppColors.backGroundColor,
//           width: context.w(1.5),
//         ),
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
//           // Icons row
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               // Left Icon
//               Container(
//                 padding: context.padSym(h: 4, v: 4),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(context.radius(10)),
//                   border: Border.all(
//                     color: AppColors.backGroundColor,
//                     width: context.w(1.5),
//                   ),
//                   color: AppColors.backGroundColor,
//                   boxShadow: [
//                     BoxShadow(
//                       color: AppColors.customContainerColorUp.withOpacity(0.4),
//                       offset: const Offset(5, 5),
//                       blurRadius: 5,
//                     ),
//                     BoxShadow(
//                       color: AppColors.customContinerColorDown.withOpacity(0.4),
//                       offset: const Offset(-5, -5),
//                       blurRadius: 5,
//                     ),
//                   ],
//                 ),
//                 child: Center(
//                   child: SvgPicture.asset(
//                     product['leftIcon'],
//                     height: context.h(24),
//                     width: context.w(24),
//                     fit: BoxFit.scaleDown,
//                   ),
//                 ),
//               ),
//               // Right Icons + Texts
//               Row(
//                 children: List.generate(product['rightIcons'].length, (index) {
//                   return Container(
//                     padding: context.padSym(h: 6, v: 6),
//                     margin: EdgeInsets.only(left: context.w(6)),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(context.radius(10)),
//                       border: Border.all(
//                         color: AppColors.backGroundColor,
//                         width: context.w(1.5),
//                       ),
//                       color: AppColors.backGroundColor,
//                       boxShadow: [
//                         BoxShadow(
//                           color: AppColors.customContainerColorUp.withOpacity(
//                             0.4,
//                           ),
//                           offset: const Offset(5, 5),
//                           blurRadius: 5,
//                         ),
//                         BoxShadow(
//                           color: AppColors.customContinerColorDown.withOpacity(
//                             0.4,
//                           ),
//                           offset: const Offset(-5, -5),
//                           blurRadius: 5,
//                         ),
//                       ],
//                     ),
//                     child: Row(
//                       children: [
//                         SvgPicture.asset(
//                           product['rightIcons'][index],
//                           height: context.h(24),
//                           width: context.w(24),
//                           color: AppColors.iconColor,
//                           fit: BoxFit.scaleDown,
//                         ),
//                         if (product['rightTexts'].length > index)
//                           NormalText(
//                             titleText: product['rightTexts'][index],
//                             titleColor: AppColors.iconColor,
//                             titleSize: context.text(10),
//                             titleWeight: FontWeight.w500,
//                           ),
//                       ],
//                     ),
//                   );
//                 }),
//               ),
//             ],
//           ),
//           SizedBox(height: context.h(12)),
//           // Title + Subtitle
//           NormalText(
//             titleText: product['title'],
//             titleColor: AppColors.subHeadingColor,
//             titleSize: context.text(16),
//             titleWeight: FontWeight.w600,
//             sizeBoxheight: context.h(12),
//             subText: product['description'],
//             subColor: AppColors.subHeadingColor,
//             subSize: context.text(12),
//             subWeight: FontWeight.w500,
//           ),
//           SizedBox(height: context.h(12)),
//           // Scalp tags buttons
//           Row(
//             children: List.generate(product['buttons'].length, (index) {
//               final isSelected =
//                   topProductViewModel.selectedButtonIndex[productIndex] ==
//                   index;
//               return PlanContainer(
//                 isSelected: isSelected,
//                 onTap: () {
//                   topProductViewModel.selectedButtonIndex[productIndex] = index;
//                   topProductViewModel.notifyListeners();
//                 },
//                 child: NormalText(
//                   titleText: product['buttons'][index],
//                   titleColor: AppColors.subHeadingColor,
//                   titleSize: context.text(10),
//                   titleWeight: FontWeight.w600,
//                 ),
//               );
//             }),
//           ),
//           SizedBox(height: context.h(12)),
//           // View Details Button
//           PlanContainer(
//             isSelected: false,
//             onTap: () {},
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 NormalText(
//                   titleText: 'View Details',
//                   titleColor: AppColors.subHeadingColor,
//                   titleSize: context.text(14),
//                   titleWeight: FontWeight.w500,
//                 ),
//                 SizedBox(width: context.w(4)),
//                 Icon(Icons.arrow_forward_ios, size: 20),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
