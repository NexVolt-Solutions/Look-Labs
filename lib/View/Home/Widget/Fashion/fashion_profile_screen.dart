// import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
// import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
// import 'package:looklabs/Core/Constants/app_assets.dart';
// import 'package:looklabs/Core/Constants/app_colors.dart';
// import 'package:looklabs/Core/Constants/size_extension.dart';
// import 'package:looklabs/Core/Widget/app_bar_container.dart';
// import 'package:looklabs/Core/Widget/custom_button.dart';
// import 'package:looklabs/Core/Widget/height_widget_cont.dart';
// import 'package:looklabs/Core/Widget/normal_text.dart';
// import 'package:looklabs/Core/Widget/plan_container.dart';
// import 'package:looklabs/Core/utils/Routes/routes_name.dart';

// class FashionProfileScreen extends StatefulWidget {
//   const FashionProfileScreen({super.key});

//   @override
//   State<FashionProfileScreen> createState() => _FashionProfileScreenState();
// }

// class _FashionProfileScreenState extends State<FashionProfileScreen> {

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.backGroundColor,
//       bottomNavigationBar: CustomButton(
//         text: 'Next',
//         color: AppColors.pimaryColor,
//         isEnabled: true,
//         onTap: () {
//           Navigator.pushNamed(context, RoutesName.DailySkinCareRoutineScreen);
//         },
//       ),
//       body: SafeArea(
//         child: ListView(
//           padding: context.padSym(h: 20),
//           children: [
//             AppBarContainer(
//               title: 'Analyzing',
//               onTap: () {
//                 Navigator.pop(context);
//               },
//             ),
//             SizedBox(height: context.h(24)),
//             NormalText(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               titleText: 'AI analysis complete',
//               titleSize: context.text(18),
//               titleWeight: FontWeight.w600,
//               titleColor: AppColors.subHeadingColor,
//             ),
//             SizedBox(
//               height: context.h(140),
//               child: ListView.builder(
//                 itemCount: 4,
//                 scrollDirection: Axis.horizontal,
//                 itemBuilder: (context, index) {
//                   return HeightWidgetCont(
//                     title: '2300',
//                     subTitle: 'Weekly Cal',
//                     imgPath: AppAssets.fatLossIcon,
//                   );
//                 },
//               ),
//             ),
//             SizedBox(height: context.h(18)),
//             NormalText(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               titleText: 'AI analysis complete',
//               titleSize: context.text(18),
//               titleWeight: FontWeight.w600,
//               titleColor: AppColors.subHeadingColor,
//             ),
//             SizedBox(height: context.h(8)),
//             SizedBox(
//               height: context.h(190),
//               child: ListView.builder(
//                 itemCount: 3,
//                 scrollDirection: Axis.horizontal,
//                 itemBuilder: (context, index) {
//                   return Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Container(
//                         width: context.w(158), // ✅ FIXED WIDTH
//                         padding: context.padSym(h: 1, v: 1),
//                         margin: EdgeInsets.only(right: context.w(12)),
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(16),
//                           border: Border.all(color: AppColors.pimaryColor),
//                         ),
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(12),
//                           child: Image.asset(
//                             'assets/Picsart_25-12-27_23-56-38-946.jpg',
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: context.h(8)),
//                       NormalText(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         titleText: 'LeftSide',
//                         titleSize: context.text(14),
//                         titleColor: AppColors.subHeadingColor,
//                         titleWeight: FontWeight.w600,
//                       ),
//                     ],
//                   );
//                 },
//               ),
//             ),
//             SizedBox(height: context.h(8)),
//             PlanContainer(
//               margin: context.padSym(v: 10),
//               padding: context.padSym(h: 12, v: 12),
//               isSelected: false,
//               onTap: () {},
//               child: Column(
//                 children: [
//                   Row(
//                     children: [
//                       GestureDetector(
//                           onTap: () {
//                           },
//                           child: Container(
//                             height: context.h(28),
//                             width: context.w(28),
//                             decoration: BoxDecoration(
//                               color: AppColors.backGroundColor,
//                               shape: BoxShape.circle,
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: AppColors.customContainerColorUp
//                                       .withOpacity(0.4),
//                                   offset: const Offset(3, 3),
//                                   blurRadius: 4,
//                                   inset: true,
//                                 ),
//                                 BoxShadow(
//                                   color: AppColors.customContinerColorDown
//                                       .withOpacity(0.4),
//                                   offset: const Offset(-3, -3),
//                                   blurRadius: 4,
//                                   inset: true,
//                                 ),
//                               ],
//                             ),
//                             child: Center(
//                               child:

//                                   ? Icon(
//                                       Icons.check,
//                                       size: context.h(16),
//                                       color: AppColors.pimaryColor,
//                                     )
//                                   :SizedBox(),
//                             ),
//                           ),
//                         ),
//                       SizedBox(width: context.w(11)),
//                       NormalText(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         titleText: 'Best Clothing Fits',
//                         titleSize: context.text(14),
//                         titleWeight: FontWeight.w600,
//                         titleColor: AppColors.subHeadingColor,
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: context.h(2)),
//                   Row(
//                     children: [
//                       Wrap(
//                         spacing: 8,
//                         runSpacing: 8,
//                         children: List.generate(
//                           3,
//                           (index) => PlanContainer(
//                             margin: context.padSym(v: 10),
//                             radius: BorderRadius.circular(context.radius(10)),
//                             padding: context.padSym(v: 8, h: 12),
//                             isSelected: false,
//                             onTap: () {},
//                             child: NormalText(
//                               titleText: 'Fitted shirts',
//                               titleSize: context.text(10),
//                               titleWeight: FontWeight.w600,
//                               titleColor: AppColors.subHeadingColor,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: context.h(2)),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:looklabs/Core/Constants/app_assets.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Core/Widget/app_bar_container.dart';
import 'package:looklabs/Core/Widget/custom_button.dart';
import 'package:looklabs/Core/Widget/height_widget_cont.dart';
import 'package:looklabs/Core/Widget/normal_text.dart';
import 'package:looklabs/Core/Widget/plan_container.dart';
import 'package:looklabs/Core/utils/Routes/routes_name.dart';

class FashionProfileScreen extends StatefulWidget {
  const FashionProfileScreen({super.key});

  @override
  State<FashionProfileScreen> createState() => _FashionProfileScreenState();
}

class _FashionProfileScreenState extends State<FashionProfileScreen> {
  bool isBestClothingSelected = false;

  final List<String> clothingFits = [
    'Fitted shirts',
    'Slim jeans',
    'Tailored jackets',
    'Casual wear',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backGroundColor,
      bottomNavigationBar: CustomButton(
        text: 'Next',
        color: AppColors.pimaryColor,
        isEnabled: true,
        onTap: () {
          Navigator.pushNamed(context, RoutesName.DailySkinCareRoutineScreen);
        },
      ),
      body: SafeArea(
        child: ListView(
          padding: context.padSym(h: 20),
          children: [
            AppBarContainer(
              title: 'Analyzing',
              onTap: () {
                Navigator.pop(context);
              },
            ),

            SizedBox(height: context.h(24)),

            NormalText(
              crossAxisAlignment: CrossAxisAlignment.start,
              titleText: 'AI analysis complete',
              titleSize: context.text(18),
              titleWeight: FontWeight.w600,
              titleColor: AppColors.subHeadingColor,
            ),

            SizedBox(
              height: context.h(140),
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

            SizedBox(height: context.h(18)),

            NormalText(
              crossAxisAlignment: CrossAxisAlignment.start,
              titleText: 'AI analysis complete',
              titleSize: context.text(18),
              titleWeight: FontWeight.w600,
              titleColor: AppColors.subHeadingColor,
            ),

            SizedBox(height: context.h(8)),

            SizedBox(
              height: context.h(190),
              child: ListView.builder(
                itemCount: 3,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Container(
                        width: context.w(158),
                        padding: context.padSym(h: 1, v: 1),
                        margin: EdgeInsets.only(right: context.w(12)),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.pimaryColor),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            'assets/Picsart_25-12-27_23-56-38-946.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(height: context.h(8)),
                      NormalText(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        titleText: 'LeftSide',
                        titleSize: context.text(14),
                        titleWeight: FontWeight.w600,
                        titleColor: AppColors.subHeadingColor,
                      ),
                    ],
                  );
                },
              ),
            ),

            SizedBox(height: context.h(8)),

            /// 🔹 Best Clothing Fits Section
            PlanContainer(
              margin: context.padSym(v: 10),
              padding: context.padSym(h: 12, v: 12),
              isSelected: false,
              onTap: () {},
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isBestClothingSelected = !isBestClothingSelected;
                          });
                        },
                        child: Container(
                          height: context.h(28),
                          width: context.w(28),
                          decoration: BoxDecoration(
                            color: isBestClothingSelected
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
                            child: isBestClothingSelected
                                ? Icon(
                                    Icons.check,
                                    size: context.h(16),
                                    color: AppColors.white,
                                  )
                                : const SizedBox(),
                          ),
                        ),
                      ),

                      SizedBox(width: context.w(11)),

                      NormalText(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        titleText: 'Best Clothing Fits',
                        titleSize: context.text(14),
                        titleWeight: FontWeight.w600,
                        titleColor: AppColors.subHeadingColor,
                      ),
                    ],
                  ),
                  SizedBox(height: context.h(10)),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: clothingFits.map((item) {
                      return PlanContainer(
                        radius: BorderRadius.circular(context.radius(10)),
                        padding: context.padSym(v: 8, h: 12),
                        isSelected: false,
                        onTap: () {},
                        child: NormalText(
                          titleText: item,
                          titleSize: context.text(10),
                          titleWeight: FontWeight.w600,
                          titleColor: AppColors.subHeadingColor,
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            PlanContainer(
              margin: context.padSym(v: 10),
              padding: context.padSym(h: 12, v: 12),
              isSelected: false,
              onTap: () {},
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isBestClothingSelected = !isBestClothingSelected;
                          });
                        },
                        child: Container(
                          height: context.h(28),
                          width: context.w(28),
                          decoration: BoxDecoration(
                            color: isBestClothingSelected
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
                            child: isBestClothingSelected
                                ? Icon(
                                    Icons.check,
                                    size: context.h(16),
                                    color: AppColors.white,
                                  )
                                : const SizedBox(),
                          ),
                        ),
                      ),

                      SizedBox(width: context.w(11)),

                      NormalText(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        titleText: 'Best Clothing Fits',
                        titleSize: context.text(14),
                        titleWeight: FontWeight.w600,
                        titleColor: AppColors.subHeadingColor,
                      ),
                    ],
                  ),
                  SizedBox(height: context.h(10)),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: clothingFits.map((item) {
                      return PlanContainer(
                        radius: BorderRadius.circular(context.radius(10)),
                        padding: context.padSym(v: 8, h: 12),
                        isSelected: false,
                        onTap: () {},
                        child: NormalText(
                          titleText: item,
                          titleSize: context.text(10),
                          titleWeight: FontWeight.w600,
                          titleColor: AppColors.subHeadingColor,
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
