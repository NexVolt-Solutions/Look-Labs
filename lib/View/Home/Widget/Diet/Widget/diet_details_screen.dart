import 'package:flutter/material.dart';
import 'package:looklabs/Core/Constants/Widget/app_bar_container.dart';
import 'package:looklabs/Core/Constants/Widget/custom_button.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/ViewModel/diet_details_screen_view_model.dart';
import 'package:provider/provider.dart';

class DietDetailsScreen extends StatefulWidget {
  const DietDetailsScreen({super.key});

  @override
  State<DietDetailsScreen> createState() => _DietDetailsScreenState();
}

class _DietDetailsScreenState extends State<DietDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final dietDetailsScreenViewModel = Provider.of<DietDetailsScreenViewModel>(
      context,
    );
    return Scaffold(
      backgroundColor: AppColors.backGroundColor,
      bottomNavigationBar: CustomButton(
        text: 'Next',
        color: AppColors.pimaryColor,
        isEnabled: true,
        onTap: () {
          // dailyDietRoutineScreenViewModel.showTransparentDialog(context);
        },
      ),

      body: SafeArea(
        child: ListView(
          padding: context.padSym(h: 20),
          children: [
            AppBarContainer(
              title: 'Food Details',
              onTap: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(height: context.h(24)),
          ],
        ),
      ),
    );
  }
}
