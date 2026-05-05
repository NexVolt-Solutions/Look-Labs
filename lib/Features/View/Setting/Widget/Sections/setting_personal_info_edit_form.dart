import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/app_text.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Features/ViewModel/setting_view_model.dart';
import 'package:looklabs/Features/Widget/normal_text.dart';

class PersonalInfoEditForm extends StatefulWidget {
  const PersonalInfoEditForm({super.key, required this.settingVM});
  final SettingViewModel settingVM;
  @override
  State<PersonalInfoEditForm> createState() => _PersonalInfoEditFormState();
}

class _PersonalInfoEditFormState extends State<PersonalInfoEditForm> {
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
        decoration: _cardDecoration(context),
        child: Column(
          children: [
            _PersonalInfoEditRow(
              label: AppText.fullName,
              child: _PersonalInfoTextField(
                controller: _nameController,
                hint: AppText.enterName,
                keyboard: TextInputType.text,
              ),
            ),
            const _EditDivider(),
            _PersonalInfoEditRow(
              label: AppText.email,
              child: Text(
                vm.personalInfo[1]['value'] as String? ?? '',
                style: TextStyle(
                  fontSize: context.sp(14),
                  color: AppColors.notSelectedColor,
                ),
              ),
            ),
            const _EditDivider(),
            _PersonalInfoEditRow(
              label: AppText.age,
              child: _PersonalInfoTextField(
                controller: _ageController,
                hint: AppText.enterAge,
                keyboard: TextInputType.number,
              ),
            ),
            const _EditDivider(),
            _PersonalInfoEditRow(
              label: AppText.gender,
              child: _PersonalInfoDropdown(
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

  BoxDecoration _cardDecoration(BuildContext context) {
    return BoxDecoration(
      color: AppColors.backGroundColor,
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
    );
  }
}

class _PersonalInfoEditRow extends StatelessWidget {
  const _PersonalInfoEditRow({required this.label, required this.child});
  final String label;
  final Widget child;
  @override
  Widget build(BuildContext context) {
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
}

class _PersonalInfoDropdown extends StatelessWidget {
  const _PersonalInfoDropdown({
    required this.value,
    required this.hint,
    required this.items,
    required this.onChanged,
  });
  final String? value;
  final String hint;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.sh(50),
      padding: EdgeInsets.symmetric(horizontal: context.sw(16)),
      decoration: BoxDecoration(
        color: AppColors.backGroundColor,
        borderRadius: BorderRadius.circular(context.radiusR(16)),
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
}

class _PersonalInfoTextField extends StatelessWidget {
  const _PersonalInfoTextField({
    required this.controller,
    required this.hint,
    required this.keyboard,
  });
  final TextEditingController controller;
  final String hint;
  final TextInputType keyboard;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.sh(50),
      decoration: BoxDecoration(
        color: AppColors.backGroundColor,
        borderRadius: BorderRadius.circular(context.radiusR(16)),
        boxShadow: [
          BoxShadow(
            color: AppColors.customContainerColorUp.withValues(alpha: 0.4),
            offset: const Offset(5, 5),
            blurRadius: 5,
            inset: true,
          ),
          BoxShadow(
            color: AppColors.customContinerColorDown.withValues(alpha: 0.4),
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

class _EditDivider extends StatelessWidget {
  const _EditDivider();

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: AppColors.subHeadingColor.withValues(alpha: 0.2),
      thickness: 1,
    );
  }
}
