import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:looklabs/Features/Widget/custom_container.dart';
import 'package:looklabs/Features/Widget/normal_text.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Features/ViewModel/setting_view_model.dart';

class SettingContainer extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  final SettingViewModel viewModel;

  const SettingContainer({
    super.key,
    required this.items,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: context.paddingSymmetricR(horizontal: 20),
      child: Container(
        padding: context.paddingSymmetricR(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(context.radiusR(8))),
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
          children: List.generate(items.length, (index) {
            final item = items[index];
            final isTappable = item['isArrow'] == true;

            return Column(
              children: [
                InkWell(
                  onTap: isTappable
                      ? () => viewModel.onItemTap(item, context)
                      : null,
                  child: Padding(
                    padding: context.paddingSymmetricR(vertical: 4),
                    child: Row(
                      children: [
                        CustomContainer(
                          color: AppColors.backGroundColor,
                          padding: context.paddingSymmetricR(
                            horizontal: 8,
                            vertical: 8,
                          ),
                          child: SvgPicture.asset(
                            item['icon'],
                            color: AppColors.iconColor,
                          ),
                        ),
                        SizedBox(width: context.sw(12)),
                        Expanded(
                          flex: 2,
                          child: NormalText(
                            titleText: item['title'],
                            titleSize: context.sp(14),
                            titleWeight: FontWeight.w500,
                            titleColor: AppColors.subHeadingColor,
                            maxLines: 2,
                            overflow: TextOverflow.visible,
                          ),
                        ),
                        // SizedBox(width: context.sw(8)),
                        _buildTrailing(context, item, index),
                      ],
                    ),
                  ),
                ),

                /// DIVIDER
                if (index != items.length - 1)
                  Divider(
                    color: AppColors.subHeadingColor.withOpacity(0.2),
                    thickness: 1,
                  ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildTrailing(
    BuildContext context,
    Map<String, dynamic> item,
    int index,
  ) {
    /// 🔹 SWITCH
    if (item['isSwitch'] == true) {
      return Switch(
        value: item['value'],
        onChanged: (val) {
          viewModel.toggleNotification(index, val);
        },
      );
    }

    /// 🔹 ARROW
    if (item['isArrow'] == true) {
      return const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: AppColors.subHeadingColor,
      );
    }

    /// 🔹 SUBTITLE TEXT
    return Expanded(
      flex: 2,
      child: NormalText(
        titleText: item['value'] ?? '',
        titleSize: context.sp(14),
        titleWeight: FontWeight.w400,
        titleColor: AppColors.subHeadingColor,
      ),
    );
  }
}
