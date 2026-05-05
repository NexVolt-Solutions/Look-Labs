import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:flutter_svg/svg.dart';
import 'package:looklabs/Core/Constants/app_assets.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/app_text.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Features/View/Setting/Widget/Sections/setting_personal_info_edit_form.dart';
import 'package:looklabs/Features/ViewModel/setting_view_model.dart';
import 'package:looklabs/Features/Widget/network_image_with_fallback.dart';
import 'package:looklabs/Features/Widget/normal_text.dart';
import 'package:looklabs/Features/Widget/setting_continer.dart';

class SettingsTitleSection extends StatelessWidget {
  const SettingsTitleSection({super.key});

  @override
  Widget build(BuildContext context) {
    return NormalText(
      crossAxisAlignment: CrossAxisAlignment.center,
      titleText: AppText.setting,
      titleSize: context.sp(20),
      titleWeight: FontWeight.w600,
      titleColor: AppColors.subHeadingColor,
    );
  }
}

class SettingsAvatarSection extends StatelessWidget {
  const SettingsAvatarSection({
    super.key,
    required this.profileImage,
    required this.avatarLabel,
  });

  final String? profileImage;
  final String avatarLabel;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(context.sw(4)),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.backGroundColor,
            width: context.sw(1.5),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.customContainerColorUp.withValues(alpha: 0.4),
              offset: const Offset(5, 5),
              blurRadius: 5,
            ),
            BoxShadow(
              color: AppColors.customContinerColorDown.withValues(alpha: 0.4),
              offset: const Offset(-5, -5),
              blurRadius: 5,
            ),
          ],
        ),
        child: SizedBox(
          width: 100,
          height: 100,
          child: ClipOval(
            child: profileImage != null && profileImage!.isNotEmpty
                ? NetworkImageWithFallback(
                    url: profileImage!,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    fallbackSize: 100,
                    errorWidget: _AvatarLetter(label: avatarLabel),
                  )
                : _AvatarLetter(label: avatarLabel),
          ),
        ),
      ),
    );
  }
}

class SettingsPersonalInfoSection extends StatelessWidget {
  const SettingsPersonalInfoSection({
    super.key,
    required this.settingVM,
    required this.onActionTap,
  });

  final SettingViewModel settingVM;
  final VoidCallback onActionTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: context.paddingSymmetricR(horizontal: 20, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              NormalText(
                crossAxisAlignment: CrossAxisAlignment.start,
                titleText: AppText.personalInformation,
                titleSize: context.sp(18),
                titleWeight: FontWeight.w600,
                titleColor: AppColors.subHeadingColor,
              ),
              GestureDetector(
                onTap: onActionTap,
                child: settingVM.isEditMode
                    ? Text(
                        AppText.save,
                        style: TextStyle(
                          fontSize: context.sp(16),
                          fontWeight: FontWeight.w600,
                          color: AppColors.buttonColor,
                        ),
                      )
                    : SvgPicture.asset(
                        AppAssets.editIcon,
                        height: context.sh(24),
                        width: context.sw(24),
                        fit: BoxFit.contain,
                      ),
              ),
            ],
          ),
        ),
        if (settingVM.isEditMode)
          PersonalInfoEditForm(settingVM: settingVM)
        else
          SettingContainer(items: settingVM.personalInfo, viewModel: settingVM),
      ],
    );
  }
}

class SettingsGroupSection extends StatelessWidget {
  const SettingsGroupSection({
    super.key,
    required this.title,
    required this.items,
    required this.settingVM,
  });

  final String title;
  final List<Map<String, dynamic>> items;
  final SettingViewModel settingVM;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: context.sw(20),
            right: context.sw(20),
            top: context.sh(12),
            bottom: context.sh(12),
          ),
          child: NormalText(
            crossAxisAlignment: CrossAxisAlignment.start,
            titleText: title,
            titleSize: context.sp(18),
            titleWeight: FontWeight.w600,
            titleColor: AppColors.subHeadingColor,
          ),
        ),
        SettingContainer(items: items, viewModel: settingVM),
      ],
    );
  }
}

class _AvatarLetter extends StatelessWidget {
  const _AvatarLetter({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      alignment: Alignment.center,
      child: Text(
        label,
        style: TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.w600,
          color: AppColors.iconColor,
        ),
      ),
    );
  }
}

