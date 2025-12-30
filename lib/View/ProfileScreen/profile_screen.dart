import 'package:looklabs/Core/Constants/Widget/app_bar_container.dart';
import 'package:looklabs/Core/Constants/Widget/custom_check_box.dart';
import 'package:looklabs/Core/Constants/Widget/custom_button.dart';
import 'package:looklabs/Core/Constants/Widget/custom_drop_down_field.dart';
import 'package:looklabs/Core/Constants/Widget/neu_text_fied.dart';
import 'package:looklabs/Core/Constants/Widget/normal_text.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Core/utils/Routes/routes_name.dart';
import 'package:looklabs/ViewModel/profile_view_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final profileViewModel = Provider.of<ProfileViewModel>(context);
    return Scaffold(
      backgroundColor: AppColors.backGroundColor,
      body: SafeArea(
        child: ListView(
          padding: context.padSym(h: 20),
          clipBehavior: Clip.hardEdge,
          children: [
            AppBarContainer(title: 'Profile Setup'),
            SizedBox(height: context.h(20)),
            NeuTextField(
              label: 'What is your name?',
              obscure: false,
              validatorType: 'name',
              hintText: 'Enter Name',
              keyboard: TextInputType.name,
            ),
            SizedBox(height: context.h(16)),

            SizedBox(height: context.h(20)),
            NormalText(
              crossAxisAlignment: CrossAxisAlignment.start,
              titleText: 'Select gender',
              titleSize: context.text(20),
              titleWeight: FontWeight.w600,
              titleColor: AppColors.headingColor,
            ),
            SizedBox(height: context.h(20)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                profileViewModel.checkBoxName.length,
                (index) => CustomCheckBox(
                  genderName: profileViewModel.checkBoxName[index],
                ),
              ),
            ),
            SizedBox(height: context.h(142)),
            CustomButton(
              isEnabled: true,
              onTap: () =>
                  Navigator.pushNamed(context, RoutesName.HealtDetailsScreen),
              text: 'Next',
              color: AppColors.buttonColor,
              padding: context.padSym(h: 145, v: 17),
            ),
          ],
        ),
      ),
    );
  }
}
