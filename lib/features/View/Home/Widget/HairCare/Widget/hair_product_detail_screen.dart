import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:looklabs/Features/Widget/app_bar_container.dart';
import 'package:looklabs/Features/Widget/custom_button.dart';
import 'package:looklabs/Features/Widget/normal_text.dart';
import 'package:looklabs/Features/Widget/plan_container.dart';
import 'package:looklabs/Core/Constants/app_assets.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';

class HairProductDetailScreen extends StatelessWidget {
  const HairProductDetailScreen({super.key});

  static String _stringVal(Map<String, dynamic>? m, List<String> keys) {
    if (m == null) return '';
    for (final k in keys) {
      final v = m[k]?.toString().trim();
      if (v != null && v.isNotEmpty) return v;
    }
    return '';
  }

  static List<String> _stringList(dynamic raw) {
    if (raw is! List) return [];
    return raw
        .map((e) => e.toString().trim())
        .where((s) => s.isNotEmpty)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    Map<String, dynamic>? api;
    var title = '';
    if (args is Map<String, dynamic>) {
      api = args;
      title = _stringVal(api, const ['name', 'title', 'product_name']);
    } else if (args is String) {
      title = args.trim();
    }

    final overview = _stringVal(api, const ['overview', 'description']);
    final howToUse = _stringList(api?['how_to_use']);
    final whenToUse = _stringVal(api, const ['when_to_use']);
    final dontUseWith = _stringList(api?['dont_use_with']);
    final tags = _stringList(api?['tags']);

    return Scaffold(
      backgroundColor: AppColors.backGroundColor,
      bottomNavigationBar: Padding(
        padding: EdgeInsetsGeometry.only(
          top: context.sh(5),
          left: context.sw(20),
          right: context.sw(20),
          bottom: context.sh(30),
        ),
        child: CustomButton(
          text: 'Add to Routine',
          color: AppColors.pimaryColor,
          isEnabled: true,
          onTap: () {},
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: context.paddingSymmetricR(horizontal: 20),
          children: [
            AppBarContainer(
              title: 'Recommended Product',
              onTap: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(height: context.sh(20)),
            NormalText(
              crossAxisAlignment: CrossAxisAlignment.start,
              titleText: title.isNotEmpty ? title : 'Product',
              titleSize: context.sp(18),
              titleWeight: FontWeight.w600,
              titleColor: AppColors.headingColor,
            ),
            SizedBox(
              height: context.sh(220),
              width: context.sw(220),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  AppAssets.shampoo,
                  height: context.sh(220),
                  width: context.sw(220),
                  fit: BoxFit.scaleDown,
                ),
              ),
            ),
            SizedBox(height: context.sh(20)),
            NormalText(
              crossAxisAlignment: CrossAxisAlignment.start,
              titleText: 'Product overview',
              titleSize: context.sp(18),
              titleWeight: FontWeight.w600,
              titleColor: AppColors.headingColor,
              sizeBoxheight: context.sh(12),
              subText: overview.isNotEmpty
                  ? overview
                  : 'Details will appear here when opened from your personalized hair plan.',
              subSize: context.sp(12),
              subColor: AppColors.subHeadingColor,
              subWeight: FontWeight.w400,
            ),
            SizedBox(height: context.sh(12)),
            NormalText(
              crossAxisAlignment: CrossAxisAlignment.start,
              titleText: 'How to use',
              titleSize: context.sp(18),
              titleWeight: FontWeight.w600,
              titleColor: AppColors.headingColor,
              sizeBoxheight: context.sh(12),
            ),
            if (howToUse.isEmpty)
              Text(
                'No steps provided.',
                style: TextStyle(
                  fontSize: context.sp(12),
                  color: AppColors.subHeadingColor,
                ),
              )
            else
              ...howToUse.map(
                (line) => Padding(
                  padding: EdgeInsets.only(bottom: context.sh(6)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '• ',
                        style: TextStyle(
                          fontSize: context.sp(12),
                          fontWeight: FontWeight.w500,
                          color: AppColors.subHeadingColor,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          line,
                          style: TextStyle(
                            fontSize: context.sp(12),
                            fontWeight: FontWeight.w400,
                            color: AppColors.subHeadingColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            SizedBox(height: context.sh(12)),
            NormalText(
              crossAxisAlignment: CrossAxisAlignment.start,
              titleText: 'When to use',
              titleSize: context.sp(18),
              titleWeight: FontWeight.w600,
              titleColor: AppColors.headingColor,
              sizeBoxheight: context.sh(12),
            ),
            if (whenToUse.isEmpty)
              Text(
                '—',
                style: TextStyle(
                  fontSize: context.sp(12),
                  color: AppColors.subHeadingColor,
                ),
              )
            else
              Padding(
                padding: EdgeInsets.only(bottom: context.sh(6)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '• ',
                      style: TextStyle(
                        fontSize: context.sp(12),
                        fontWeight: FontWeight.w500,
                        color: AppColors.subHeadingColor,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        whenToUse,
                        style: TextStyle(
                          fontSize: context.sp(12),
                          fontWeight: FontWeight.w400,
                          color: AppColors.subHeadingColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            SizedBox(height: context.sh(12)),
            Row(
              children: [
                SvgPicture.asset(
                  AppAssets.starIcon,
                  height: context.sh(24),
                  width: context.sw(24),
                  colorFilter: const ColorFilter.mode(
                    AppColors.pimaryColor,
                    BlendMode.srcIn,
                  ),
                  fit: BoxFit.scaleDown,
                ),
                SizedBox(width: context.sw(8)),
                NormalText(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  titleText: 'Don’t use with',
                  titleSize: context.sp(18),
                  titleWeight: FontWeight.w600,
                  titleColor: AppColors.headingColor,
                ),
              ],
            ),
            if (dontUseWith.isEmpty)
              Padding(
                padding: EdgeInsets.only(top: context.sh(8)),
                child: Text(
                  '—',
                  style: TextStyle(
                    fontSize: context.sp(12),
                    color: AppColors.subHeadingColor,
                  ),
                ),
              )
            else
              Padding(
                padding: EdgeInsets.only(top: context.sh(8)),
                child: Wrap(
                  spacing: context.sw(6),
                  runSpacing: context.sh(6),
                  children: dontUseWith
                      .map(
                        (t) => PlanContainer(
                          isSelected: false,
                          onTap: () {},
                          child: NormalText(
                            titleText: t,
                            titleColor: AppColors.subHeadingColor,
                            titleSize: context.sp(10),
                            titleWeight: FontWeight.w600,
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            if (tags.isNotEmpty) ...[
              SizedBox(height: context.sh(16)),
              NormalText(
                crossAxisAlignment: CrossAxisAlignment.start,
                titleText: 'Tags',
                titleSize: context.sp(18),
                titleWeight: FontWeight.w600,
                titleColor: AppColors.headingColor,
              ),
              SizedBox(height: context.sh(8)),
              Wrap(
                spacing: context.sw(6),
                runSpacing: context.sh(6),
                children: tags
                    .map(
                      (t) => PlanContainer(
                        isSelected: false,
                        onTap: () {},
                        child: NormalText(
                          titleText: t,
                          titleColor: AppColors.subHeadingColor,
                          titleSize: context.sp(10),
                          titleWeight: FontWeight.w600,
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
            SizedBox(height: context.sh(12)),
          ],
        ),
      ),
    );
  }
}
