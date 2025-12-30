import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:looklabs/Core/Constants/Widget/normal_text.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';

class CustomDropdownField extends StatefulWidget {
  final String? hintText;
  final List<String> items;
  final Function(String) onSelected;
  final String? Function(String?)? validator;

  const CustomDropdownField({
    this.hintText,
    required this.items,
    required this.onSelected,
    this.validator,
    super.key,
  });

  @override
  CustomDropdownFieldState createState() => CustomDropdownFieldState();
}

class CustomDropdownFieldState extends State<CustomDropdownField> {
  bool _isExpanded = false;
  String? _selectedValue;

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      validator: widget.validator,
      builder: (FormFieldState<String> field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header container (always visible)
            GestureDetector(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              child: Container(
                height: context.h(54),
                padding: context.padSym(h: 17),
                decoration: BoxDecoration(
                  color: AppColors.backGroundColor,
                  borderRadius: BorderRadius.circular(context.radius(16)),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.4),
                    width: context.w(0.5),
                  ),
                  boxShadow: const [
                    BoxShadow(
                      offset: Offset(-2.5, -2.5),
                      blurRadius: 5,
                      color: AppColors.blurTopColor,
                      inset: true,
                    ),
                    BoxShadow(
                      offset: Offset(2.5, 2.5),
                      blurRadius: 5,
                      color: AppColors.blurBottomColor,
                      inset: true,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    NormalText(
                      titleText: _selectedValue ?? widget.hintText ?? "",
                      titleSize: context.text(16),
                      titleWeight: FontWeight.w400,
                      titleColor: _selectedValue == null
                          ? AppColors.notSelectedColor
                          : AppColors.headingColor,
                    ),
                    Icon(
                      _isExpanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: AppColors.headingColor,
                    ),
                  ],
                ),
              ),
            ),

            /// Dropdown list (appears inside same styled container)
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: _isExpanded
                  ? context.h(54) + MediaQuery.sizeOf(context).height * 0.2
                  : context.h(54),
              decoration: BoxDecoration(
                color: AppColors.backGroundColor,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
                border: Border.all(
                  color: Colors.white.withOpacity(0.4),
                  width: context.w(0.5),
                ),
                boxShadow: const [
                  BoxShadow(
                    offset: Offset(-2.5, -2.5),
                    blurRadius: 5,
                    color: AppColors.blurTopColor,
                    inset: true,
                  ),
                  BoxShadow(
                    offset: Offset(2.5, 2.5),
                    blurRadius: 5,
                    color: AppColors.blurBottomColor,
                    inset: true,
                  ),
                ],
              ),
              child: Column(
                children: [
                  /// Header row
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isExpanded = !_isExpanded;
                      });
                    },
                    child: Container(
                      height: context.h(54),
                      padding: context.padSym(h: 17),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          NormalText(
                            titleText: _selectedValue ?? widget.hintText ?? "",
                            titleSize: context.text(16),
                            titleWeight: FontWeight.w400,
                            titleColor: _selectedValue == null
                                ? AppColors.notSelectedColor
                                : AppColors.headingColor,
                          ),
                          Icon(
                            _isExpanded
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            color: AppColors.headingColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (_isExpanded)
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: widget.items.length,
                        itemBuilder: (context, index) {
                          final value = widget.items[index];
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedValue = value;
                                _isExpanded = false;
                              });
                              widget.onSelected(value);
                            },
                            child: Padding(
                              padding: context.padSym(h: 17, v: 12),
                              child: NormalText(
                                titleText: value,
                                titleSize: context.text(16),
                                titleWeight: FontWeight.w400,
                                titleColor: AppColors.headingColor,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),

            /// Error message
            if (field.hasError)
              Padding(
                padding: EdgeInsets.only(
                  top: context.h(10),
                  left: context.w(8),
                ),
                child: Text(
                  field.errorText ?? '',
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: Theme.of(context).colorScheme.error,
                    fontSize: context.text(12),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
