// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:looklabs/Core/Constants/Widget/normal_text.dart';
// import 'package:looklabs/Core/Constants/app_assets.dart';
// import 'package:looklabs/Core/Constants/app_colors.dart';
// import 'package:looklabs/Core/Constants/size_extension.dart';

// class AppBarContainer extends StatelessWidget {
//   final String title;
//   final VoidCallback? onTap;
//   final bool showHeart;
//   final VoidCallback? onHeartTap;

//   const AppBarContainer({
//     super.key,
//     required this.title,
//     this.onTap,
//     this.showHeart = false,
//     this.onHeartTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.only(
//         // left: context.w(3),
//         // right: context.w(3),
//         top: context.h(8),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           /// Back Button
//           GestureDetector(
//             onTap: onTap,
//             child: Container(
//               height: context.h(40),
//               width: context.w(40),
//               decoration: BoxDecoration(
//                 color: AppColors.backGroundColor,
//                 borderRadius: BorderRadius.circular(context.radius(1)),
//                 border: Border.all(
//                   color: AppColors.white.withOpacity(0.2),
//                   width: 1.5,
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: AppColors.arrowBlurColor,
//                     offset: const Offset(5, 5),
//                     blurRadius: 5,
//                   ),
//                   BoxShadow(
//                     color: AppColors.customContinerColorDown,
//                     offset: const Offset(-5, -5),
//                     blurRadius: 30,
//                   ),
//                 ],
//               ),
//               child: Center(child: SvgPicture.asset(AppAssets.backIcon)),
//             ),
//           ),

//           /// Space
//           // SizedBox(width: context.w(10)),

//           /// Title (Auto center & flexible)
//           NormalText(
//             titleText: title,
//             titleSize: context.text(20),
//             titleWeight: FontWeight.w600,
//             titleColor: AppColors.headingColor,
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//           ),

//           /// Space
//           // SizedBox(width: context.w(10)),

//           /// Heart Icon OR Placeholder (UI stays same)
//           SizedBox(
//             height: context.h(40),
//             width: context.w(40),
//             child: showHeart
//                 ? GestureDetector(
//                     onTap: onHeartTap,
//                     child: Icon(Icons.heart_broken),
//                   )
//                 : const SizedBox(),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:looklabs/Core/Widget/normal_text.dart';
import 'package:looklabs/Core/Constants/app_assets.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';

class AppBarContainer extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  final bool showHeart;
  final VoidCallback? onHeartTap;

  const AppBarContainer({
    super.key,
    required this.title,
    this.onTap,
    this.showHeart = false,
    this.onHeartTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: context.h(8)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: onTap,
            child: Container(
              height: context.h(40),
              width: context.w(40),
              decoration: BoxDecoration(
                color: AppColors.backGroundColor,
                borderRadius: BorderRadius.circular(context.radius(12)),
                border: Border.all(
                  color: AppColors.white.withOpacity(0.2),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.arrowBlurColor,
                    offset: const Offset(5, 5),
                    blurRadius: 5,
                  ),
                  BoxShadow(
                    color: AppColors.customContinerColorDown,
                    offset: const Offset(-5, -5),
                    blurRadius: 30,
                  ),
                ],
              ),

              /// ✅ SVG SAFE LOADER
              child: Center(
                child: SvgPicture.asset(
                  AppAssets.backIcon,
                  fit: BoxFit.scaleDown,
                  placeholderBuilder: (context) =>
                      const Icon(Icons.arrow_back, color: Colors.white),
                ),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: NormalText(
                titleText: title,
                titleSize: context.text(20),
                titleWeight: FontWeight.w600,
                titleColor: AppColors.headingColor,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),

          /// ❤️ Heart OR Empty Space
          SizedBox(
            height: context.h(40),
            width: context.w(40),
            child: showHeart
                ? GestureDetector(
                    onTap: onHeartTap,
                    child: SvgPicture.asset(
                      AppAssets.appaleIcon,
                      fit: BoxFit.scaleDown,
                      placeholderBuilder: (context) => const Icon(
                        Icons.favorite_border,
                        color: Colors.white,
                      ),
                    ),
                  )
                : const SizedBox(),
          ),
        ],
      ),
    );
  }
}
