import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:looklabs/features/Widget/normal_text.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';

class CustomDropdownField extends StatefulWidget {
  final String? label;
  final String? hintText;
  final List<String> items;
  final Function(String) onSelected;
  final String? Function(String?)? validator;

  const CustomDropdownField({
    this.label,
    this.hintText,
    required this.items,
    required this.onSelected,
    this.validator,
    super.key,
  });

  @override
  CustomDropdownFieldState createState() => CustomDropdownFieldState();
}

class CustomDropdownFieldState extends State<CustomDropdownField>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  String? _selectedValue;

  @override
  Widget build(BuildContext context) {
    final double headerHeight = context.h(54);
    final double maxListHeight = context.h(200);

    return FormField<String>(
      validator: widget.validator,
      builder: (FormFieldState<String> field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.label != null)
              Padding(
                padding: EdgeInsets.only(bottom: context.h(8)),
                child: Text(
                  widget.label!,
                  style: TextStyle(
                    color: AppColors.headingColor,
                    fontSize: context.text(14),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            Container(
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () => setState(() => _isExpanded = !_isExpanded),
                    child: Container(
                      height: headerHeight,
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
                                : Icons.unfold_more,
                            color: AppColors.headingColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                  AnimatedSize(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    child: _isExpanded
                        ? SizedBox(
                            height: maxListHeight,
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: widget.items.length,
                              itemBuilder: (context, index) {
                                final value = widget.items[index];
                                return InkWell(
                                  onTap: () {
                                    setState(() {
                                      _selectedValue = value;
                                      _isExpanded = false;
                                    });
                                    field.didChange(value);
                                    field.validate();
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
                          )
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
            if (field.hasError)
              Padding(
                padding: EdgeInsets.only(top: context.h(8)),
                child: Text(
                  field.errorText ?? '',
                  style: TextStyle(
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
