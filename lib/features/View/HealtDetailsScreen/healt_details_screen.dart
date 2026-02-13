import 'package:flutter/material.dart';
import 'package:looklabs/features/Widget/custom_button.dart';
import 'package:looklabs/features/Widget/custom_continer.dart';
import 'package:looklabs/features/Widget/normal_text.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Core/utils/Routes/routes_name.dart';
import 'package:looklabs/features/ViewModel/healt_details_view_model.dart';
import 'package:provider/provider.dart';

class HealtDetailsScreen extends StatefulWidget {
  const HealtDetailsScreen({super.key});

  @override
  State<HealtDetailsScreen> createState() => _HealtDetailsScreenState();
}

class _HealtDetailsScreenState extends State<HealtDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final healtDetailsViewModel = Provider.of<HealtDetailsViewModel>(context);
    return Scaffold(
      backgroundColor: AppColors.backGroundColor,
      body: SafeArea(
        child: ListView(
          padding: context.padSym(h: 20),
          clipBehavior: Clip.hardEdge,
          children: [
            SizedBox(height: context.h(32)),
            NormalText(
              crossAxisAlignment: CrossAxisAlignment.center,
              titleText: 'Healt Details',
              titleSize: context.text(20),
              titleWeight: FontWeight.w600,
              titleColor: AppColors.headingColor,
            ),
            SizedBox(height: context.h(24)),
            CustomContiner(
              isEnabled: true,
              onTap: () {
                healtDetailsViewModel.showSelectionBottomSheet(
                  context: context,
                  title: 'Diet Type',
                  list: healtDetailsViewModel.dietTypButtonName,
                  isDiet: true,
                );
              },
              title1: 'Diet Type',
              title2: healtDetailsViewModel.selectedDiet,
              title2Color: AppColors.pimaryColor,
            ),

            SizedBox(height: context.h(24)),
            CustomContiner(
              isEnabled: true,
              onTap: () {
                healtDetailsViewModel.showSelectionBottomSheet(
                  context: context,
                  title: 'Workout Frequency',
                  list: healtDetailsViewModel.workOutFreButtonName,
                  isDiet: false,
                );
              },
              title1: 'Workout Frequency',
              title2: healtDetailsViewModel.selectedWorkout,
              title2Color: AppColors.pimaryColor,
            ),
            SizedBox(height: context.h(305)),
            CustomButton(
              isEnabled: true,
              onTap: () => Navigator.pushNamed(context, RoutesName.GaolScreen),
              text: 'Next',
              color: AppColors.buttonColor,
            ),
          ],
        ),
      ),
    );
  }
}
