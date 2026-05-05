import 'package:flutter/material.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Features/Widget/normal_text.dart';
import 'package:looklabs/Features/Widget/plan_container.dart';

class ProductOverviewSection extends StatelessWidget {
  const ProductOverviewSection({super.key, required this.overview});

  final String overview;

  @override
  Widget build(BuildContext context) {
    if (overview.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        NormalText(
          crossAxisAlignment: CrossAxisAlignment.start,
          titleText: 'Product overview',
          titleSize: context.sp(18),
          sizeBoxheight: context.sh(12),
          subText: overview,
          subSize: context.sp(12),
        ),
        SizedBox(height: context.sh(12)),
      ],
    );
  }
}

class HowToUseSection extends StatelessWidget {
  const HowToUseSection({super.key, required this.items});

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        NormalText(
          crossAxisAlignment: CrossAxisAlignment.start,
          titleText: 'How to use',
          titleSize: context.sp(18),
          sizeBoxheight: context.sh(12),
        ),
        if (items.isEmpty)
          NormalText(
            subText: '—',
            subSize: context.sp(12),
            subColor: AppColors.subHeadingColor,
          )
        else
          ...items.map(
            (line) => Padding(
              padding: EdgeInsets.only(bottom: context.sh(6)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  NormalText(
                    subText: '• ',
                    subSize: context.sp(12),
                    subColor: AppColors.subHeadingColor,
                  ),
                  Expanded(
                    child: NormalText(
                      subText: line,
                      subSize: context.sp(12),
                      subColor: AppColors.subHeadingColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        SizedBox(height: context.sh(12)),
      ],
    );
  }
}

class WhenToUseSection extends StatelessWidget {
  const WhenToUseSection({super.key, required this.value});

  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        NormalText(
          crossAxisAlignment: CrossAxisAlignment.start,
          titleText: 'When to use',
          titleSize: context.sp(18),
          sizeBoxheight: context.sh(12),
        ),
        if (value.isEmpty)
          NormalText(subText: '—', subSize: context.sp(12))
        else
          Padding(
            padding: EdgeInsets.only(bottom: context.sh(6)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NormalText(subText: '• ', subSize: context.sp(12)),
                Expanded(
                  child: NormalText(
                    subText: value,
                    subSize: context.sp(12),
                  ),
                ),
              ],
            ),
          ),
        SizedBox(height: context.sh(12)),
      ],
    );
  }
}

class DontUseWithSection extends StatelessWidget {
  const DontUseWithSection({super.key, required this.items});

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.star_rounded,
              size: context.sp(26),
              color: AppColors.pimaryColor,
            ),
            SizedBox(width: context.sw(8)),
            NormalText(
              crossAxisAlignment: CrossAxisAlignment.center,
              titleText: 'Don’t use with',
              titleSize: context.sp(18),
            ),
          ],
        ),
        SizedBox(height: context.sh(8)),
        if (items.isEmpty)
          NormalText(
            subText: '—',
            subSize: context.sp(12),
            subColor: AppColors.subHeadingColor,
          )
        else
          Wrap(
            spacing: context.sw(8),
            children: items
                .map(
                  (t) => PlanContainer(
                    margin: context.paddingSymmetricR(vertical: 8),
                    padding: context.paddingSymmetricR(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    radius: BorderRadius.circular(context.radiusR(10)),
                    isSelected: false,
                    onTap: () {},
                    child: NormalText(
                      subText: t,
                      subSize: context.sp(12),
                      subColor: AppColors.subHeadingColor,
                      subWeight: FontWeight.w600,
                    ),
                  ),
                )
                .toList(),
          ),
      ],
    );
  }
}
