import 'package:looklabs/Core/Constants/Widget/custom_check_box.dart';
import 'package:looklabs/Core/Constants/Widget/custom_button.dart';
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
        child: Padding(
          padding: context.padSym(h: 20),
          child: ListView(
            clipBehavior: Clip.hardEdge,
            children: [
              SizedBox(height: context.h(20)),
              NormalText(
                crossAxisAlignment: CrossAxisAlignment.center,
                titleText: 'Build Your Profile',
                titleSize: context.text(20),
                titleWeight: FontWeight.w600,
                titleColor: AppColors.headingColor,
              ),
              SizedBox(height: context.h(20)),
              NeuTextField(
                label: 'Enter Name',
                obscure: true,
                validatorType: 'name',
                hintText: 'Enter Name',
                keyboard: TextInputType.name,
              ),
              SizedBox(height: context.h(16)),
              NeuTextField(
                label: 'Enter Age',
                obscure: true,
                validatorType: 'phone',
                hintText: 'Enter Age',
                keyboard: TextInputType.name,
              ),
              SizedBox(height: context.h(16)),
              NeuTextField(
                label: 'Enter Hight (cm)',
                obscure: true,
                validatorType: 'phone',
                hintText: 'Enter Hight (cm)',
                keyboard: TextInputType.name,
              ),
              SizedBox(height: context.h(16)),
              NeuTextField(
                label: 'Enter Weight (kg)',
                obscure: true,
                validatorType: 'phone',
                hintText: 'Enter Weight (kg)',
                keyboard: TextInputType.name,
              ),
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
      ),
    );
  }
}

// class SteperContainer extends StatelessWidget {
//   const SteperContainer({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Container(
//           padding: context.padSym(h: 16, v: 16),
//           decoration: BoxDecoration(
//             color: AppColors.backGroundColor,
//             shape: BoxShape.circle,
//             border: Border.all(
//               color: AppColors.pimaryColor,
//               width: context.w(1.1),
//             ),
//             boxShadow: [
//               BoxShadow(
//                 offset: const Offset(1.1, 1.1),
//                 color: AppColors.blurbottomColor,
//                 blurRadius: 2.1,
//               ),
//               BoxShadow(
//                 offset: const Offset(-1.1, -1.1),
//                 color: AppColors.textColor,
//                 blurRadius: 2.1,
//               ),
//             ],
//           ),
//           child: Container(
//             padding: context.padSym(h: 4, v: 4),
//             decoration: BoxDecoration(
//               color: AppColors.pimaryColor,
//               shape: BoxShape.circle,
//             ),
//           ),
//         ),
//         SizedBox(height: context.h(2)),
//       ],
//     );
//   }
// }
