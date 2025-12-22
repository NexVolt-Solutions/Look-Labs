import 'package:flutter/material.dart';
import 'package:looklabs/Core/Constants/Widget/app_bar_container.dart';
import 'package:looklabs/Core/Constants/app_assets.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';

class MyAlbumScreen extends StatefulWidget {
  const MyAlbumScreen({super.key});

  @override
  State<MyAlbumScreen> createState() => _MyAlbumScreenState();
}

class _MyAlbumScreenState extends State<MyAlbumScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backGroundColor,
      body: SafeArea(
        child: ListView(
          clipBehavior: Clip.hardEdge,
          padding: context.padSym(h: 20),
          children: [
            AppBarContainer(title: 'My Album'),
            SizedBox(height: context.h(25)),
            SizedBox(
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  // mainAxisSpacing: 12,
                  // crossAxisSpacing: 12,
                  childAspectRatio: 4 / 4,
                ),
                itemCount: 21,
                itemBuilder: (context, index) {
                  // final item = homeViewModel.homeOverViewData[index];
                  return Padding(
                    padding: context.padSym(h: 5, v: 5),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(AppAssets.image, fit: BoxFit.cover),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
