import 'package:flutter/cupertino.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:flutter_svg/svg.dart';
import 'package:looklabs/Features/Widget/normal_text.dart';
import 'package:looklabs/Features/Widget/setting_continer.dart';
import 'package:looklabs/Core/Constants/app_assets.dart';
import 'package:looklabs/Core/Constants/app_text.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Core/Network/api_error_handler.dart';
import 'package:looklabs/Features/ViewModel/auth_view_model.dart';
import 'package:looklabs/Features/ViewModel/setting_view_model.dart';
import 'package:provider/provider.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final SettingViewModel settingVM = SettingViewModel();

  @override
  void initState() {
    super.initState();
    settingVM.addListener(_onSettingVMUpdate);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final authVm = context.read<AuthViewModel>();
      if (authVm.isLoggedIn && authVm.profile == null) {
        authVm.fetchProfile();
      }
    });
  }

  @override
  void dispose() {
    settingVM.removeListener(_onSettingVMUpdate);
    super.dispose();
  }

  void _onSettingVMUpdate() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final authVm = context.watch<AuthViewModel>();
    final user = authVm.user;
    final profile = authVm.profile;
    settingVM.updateFromUser(
      name: user?.name ?? profile?.name,
      email: user?.email ?? profile?.email,
      age: profile?.age?.toString(),
      gender: profile?.gender,
    );

    final name = user?.name ?? profile?.name;
    final email = user?.email ?? profile?.email;
    final profileImage = user?.profileImage ?? profile?.profileImage;
    final avatarLabel = (name != null && name.isNotEmpty)
        ? name.substring(0, 1).toUpperCase()
        : (email != null && email.isNotEmpty)
        ? email.substring(0, 1).toUpperCase()
        : '';

    return SafeArea(
      child: ListView(
        children: [
          SizedBox(height: context.sh(24)),
          NormalText(
            crossAxisAlignment: CrossAxisAlignment.center,
            titleText: AppText.setting,
            titleSize: context.sp(20),
            titleWeight: FontWeight.w600,
            titleColor: AppColors.subHeadingColor,
          ),
          SizedBox(height: context.sh(16)),
          Center(
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
              child: SizedBox(
                width: 100,
                height: 100,
                child: ClipOval(
                  child: profileImage != null && profileImage.isNotEmpty
                      ? Image.network(
                          profileImage,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                          loadingBuilder: (_, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return SizedBox(
                              width: 100,
                              height: 100,
                              child: Center(
                                child: CupertinoActivityIndicator(
                                  color: AppColors.pimaryColor,
                                ),
                              ),
                            );
                          },
                          errorBuilder: (_, __, ___) =>
                              _avatarLetter(avatarLabel),
                        )
                      : _avatarLetter(avatarLabel),
                ),
              ),
            ),
          ),

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
                  onTap: () => _onPersonalInfoAction(context),
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
            _PersonalInfoEditForm(settingVM: settingVM)
          else
            SettingContainer(
              items: settingVM.personalInfo,
              viewModel: settingVM,
            ),
          _sectionHeader(context, AppText.account),
          SettingContainer(items: settingVM.paymentInfo, viewModel: settingVM),
          _sectionHeader(context, AppText.preferencesAndSupport),
          SettingContainer(items: settingVM.appSettings, viewModel: settingVM),
          SizedBox(height: context.sh(250)),
        ],
      ),
    );
  }

  Widget _avatarLetter(String label) {
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

  Widget _sectionHeader(BuildContext context, String title) {
    return Padding(
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
    );
  }

  void _onPersonalInfoAction(BuildContext context) {
    if (!settingVM.isEditMode) {
      settingVM.startEditMode();
      return;
    }
    _showSavingDialog(context);
    settingVM.saveProfile(context).then((success) {
      if (!context.mounted) return;
      Navigator.of(context, rootNavigator: true).pop();
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        ApiErrorHandler.showSnackBar(
          context,
          fallback: 'Failed to update profile. Please try again.',
        );
      }
    });
  }

  void _showSavingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Center(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [const CupertinoActivityIndicator()],
            ),
          ),
        ),
      ),
    );
  }
}

/// Inline edit form for personal info (name, email read-only, age, gender).
class _PersonalInfoEditForm extends StatefulWidget {
  const _PersonalInfoEditForm({required this.settingVM});

  final SettingViewModel settingVM;

  @override
  State<_PersonalInfoEditForm> createState() => _PersonalInfoEditFormState();
}

class _PersonalInfoEditFormState extends State<_PersonalInfoEditForm> {
  late final TextEditingController _nameController;
  late final TextEditingController _ageController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.settingVM.editName);
    _ageController = TextEditingController(text: widget.settingVM.editAge);
    _nameController.addListener(
      () => widget.settingVM.setEditName(_nameController.text),
    );
    _ageController.addListener(
      () => widget.settingVM.setEditAge(_ageController.text),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = widget.settingVM;
    return Padding(
      padding: context.paddingSymmetricR(horizontal: 20),
      child: Container(
        padding: context.paddingSymmetricR(horizontal: 17.5, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.backGroundColor,
          border: Border.all(
            color: AppColors.backGroundColor,
            width: context.sw(1.5),
          ),
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
          children: [
            _editRow(
              context,
              label: AppText.fullName,
              child: _borderlessNeuField(
                context,
                controller: _nameController,
                hint: AppText.enterName,
                keyboard: TextInputType.text,
              ),
            ),
            Divider(
              color: AppColors.subHeadingColor.withOpacity(0.2),
              thickness: 1,
            ),
            _editRow(
              context,
              label: AppText.email,
              child: Text(
                vm.personalInfo[1]['value'] as String? ?? '',
                style: TextStyle(
                  fontSize: context.sp(14),
                  color: AppColors.notSelectedColor,
                ),
              ),
            ),
            Divider(
              color: AppColors.subHeadingColor.withOpacity(0.2),
              thickness: 1,
            ),
            _editRow(
              context,
              label: AppText.age,
              child: _borderlessNeuField(
                context,
                controller: _ageController,
                hint: AppText.enterAge,
                keyboard: TextInputType.number,
              ),
            ),
            Divider(
              color: AppColors.subHeadingColor.withOpacity(0.2),
              thickness: 1,
            ),
            _editRow(
              context,
              label: AppText.gender,
              child: _neumorphicDropdown(
                context,
                value:
                    vm.editGender.isEmpty ||
                        !SettingViewModel.genderOptions.contains(vm.editGender)
                    ? null
                    : vm.editGender,
                hint: AppText.selectGender,
                items: SettingViewModel.genderOptions,
                onChanged: (v) {
                  if (v != null) vm.setEditGender(v);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _editRow(
    BuildContext context, {
    required String label,
    required Widget child,
  }) {
    return Padding(
      padding: context.paddingSymmetricR(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: context.sw(100),
            child: NormalText(
              titleText: label,
              titleSize: context.sp(14),
              titleWeight: FontWeight.w500,
              titleColor: AppColors.subHeadingColor,
            ),
          ),
          SizedBox(width: context.sw(12)),
          Expanded(child: child),
        ],
      ),
    );
  }

  /// Neumorphic-styled dropdown (same container as text fields).
  Widget _neumorphicDropdown(
    BuildContext context, {
    required String? value,
    required String hint,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      height: context.sh(50),
      padding: EdgeInsets.symmetric(horizontal: context.sw(16)),
      decoration: BoxDecoration(
        color: AppColors.backGroundColor,
        borderRadius: BorderRadius.circular(context.radiusR(16)),
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
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          borderRadius: BorderRadius.circular(context.radiusR(12)),
          dropdownColor: AppColors.backGroundColor,
          hint: Text(
            hint,
            style: TextStyle(
              fontSize: context.sp(14),
              fontWeight: FontWeight.w400,
              color: AppColors.iconColor,
            ),
          ),
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.subHeadingColor,
            size: 24,
          ),
          items: items
              .map(
                (s) => DropdownMenuItem<String>(
                  value: s,
                  child: Text(
                    s,
                    style: TextStyle(
                      fontSize: context.sp(14),
                      fontWeight: FontWeight.w400,
                      color: AppColors.subHeadingColor,
                    ),
                  ),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  /// Borderless neumorphic-style field matching onboarding (NeuTextField look, no inner border).
  Widget _borderlessNeuField(
    BuildContext context, {
    required TextEditingController controller,
    required String hint,
    required TextInputType keyboard,
  }) {
    return Container(
      height: context.sh(50),

      decoration: BoxDecoration(
        color: AppColors.backGroundColor,
        borderRadius: BorderRadius.circular(context.radiusR(16)),
        boxShadow: [
          BoxShadow(
            color: AppColors.customContainerColorUp.withOpacity(0.4),
            offset: const Offset(5, 5),
            blurRadius: 5,
            inset: true,
          ),
          BoxShadow(
            color: AppColors.customContinerColorDown.withOpacity(0.4),
            offset: const Offset(-5, -5),
            blurRadius: 5,
            inset: true,
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboard,
        decoration: InputDecoration(
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: context.sw(16),
            vertical: context.sh(16),
          ),
          hintText: hint,
          hintStyle: TextStyle(
            fontSize: context.sp(14),
            fontWeight: FontWeight.w400,
            color: AppColors.iconColor,
          ),
          fillColor: Colors.transparent,
          filled: true,
        ),
        style: TextStyle(
          fontSize: context.sp(14),
          color: AppColors.subHeadingColor,
        ),
      ),
    );
  }
}
