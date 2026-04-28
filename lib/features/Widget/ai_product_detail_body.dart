import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:looklabs/Core/Constants/app_assets.dart';
import 'package:looklabs/Features/Widget/normal_text.dart';
import 'package:looklabs/Features/Widget/plan_container.dart';
import 'package:looklabs/Features/Widget/network_image_with_fallback.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';

/// Fields read from a domain-flow `ai_products` item (same shape for hair / skin).
class AiProductApiFields {
  AiProductApiFields({
    required this.title,
    required this.overview,
    required this.howToUse,
    required this.whenToUse,
    required this.dontUseWith,
    required this.tags,
    required this.timeOfDay,
    this.imageUrl,
    this.confidencePercent,
  });

  factory AiProductApiFields.fromMap(Map<String, dynamic>? raw) {
    if (raw == null) {
      return AiProductApiFields(
        title: '',
        overview: '',
        howToUse: const [],
        whenToUse: '',
        dontUseWith: const [],
        tags: const [],
        timeOfDay: '',
      );
    }
    final m = Map<String, dynamic>.from(raw);
    return AiProductApiFields(
      title: _string(m, const ['name', 'title', 'product_name']),
      overview: _string(m, const ['overview', 'description', 'summary']),
      howToUse: _stringListFromKeys(m, const [
        'how_to_use',
        'howToUse',
        'usage',
        'steps',
      ]),
      whenToUse: _string(m, const ['when_to_use', 'when']),
      dontUseWith: _stringListFromKeys(m, const [
        'dont_use_with',
        'dontUseWith',
        'avoid_with',
        'avoidWith',
      ]),
      tags: _stringListFromKeys(m, const ['tags', 'tag_list']),
      timeOfDay: (m['time_of_day'] ?? '').toString().trim(),
      imageUrl: _imageUrl(m),
      confidencePercent: _confidence(m),
    );
  }

  final String title;
  final String overview;
  final List<String> howToUse;
  final String whenToUse;
  final List<String> dontUseWith;
  final List<String> tags;
  final String timeOfDay;
  final String? imageUrl;
  final int? confidencePercent;

  static String _string(Map<String, dynamic> m, List<String> keys) {
    for (final k in keys) {
      final v = m[k]?.toString().trim();
      if (v != null && v.isNotEmpty) return v;
    }
    return '';
  }

  static List<String> _stringListFromKeys(
    Map<String, dynamic> m,
    List<String> keys,
  ) {
    for (final k in keys) {
      if (!m.containsKey(k)) continue;
      final parsed = _stringList(m[k]);
      if (parsed.isNotEmpty) return parsed;
    }
    return const [];
  }

  static List<String> _stringList(dynamic raw) {
    if (raw == null) return const [];
    if (raw is List) {
      return raw
          .expand((e) {
            if (e is Map) {
              final mapped = Map<String, dynamic>.from(e);
              return [
                mapped['name'],
                mapped['title'],
                mapped['label'],
                mapped['value'],
                mapped['text'],
              ];
            }
            return [e];
          })
          .map((e) => e?.toString().trim() ?? '')
          .where((s) => s.isNotEmpty)
          .toList();
    }
    final text = raw.toString().trim();
    if (text.isEmpty) return const [];
    return text
        .split(RegExp(r'[\n\r]+|,|•'))
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
  }

  static String? _imageUrl(Map<String, dynamic> m) {
    const keys = [
      'image_url',
      'imageUrl',
      'thumbnail_url',
      'photo_url',
      'cover_url',
      'picture_url',
    ];
    for (final k in keys) {
      final v = m[k]?.toString().trim();
      if (v != null &&
          v.isNotEmpty &&
          (v.startsWith('http://') || v.startsWith('https://'))) {
        return v;
      }
    }
    return null;
  }

  static int? _confidence(Map<String, dynamic> m) {
    final c = m['confidence'];
    if (c is num) return c.round().clamp(0, 100);
    if (c is String) {
      final n = num.tryParse(c.trim());
      if (n != null) return n.round().clamp(0, 100);
    }
    return null;
  }
}

/// Shared scroll content for hair / skin product detail (all copy from [data]).
class AiProductDetailBody extends StatelessWidget {
  const AiProductDetailBody({super.key, required this.data});

  final AiProductApiFields data;

  ({bool hasAm, bool hasPm}) _timeFlags(String raw) {
    final t = raw.toUpperCase();
    final hasAm = t.contains('AM');
    final hasPm = t.contains('PM');
    return (hasAm: hasAm, hasPm: hasPm);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: context.paddingSymmetricR(horizontal: 20, vertical: 30),
      children: [
        if (data.overview.isNotEmpty) ...[
          NormalText(
            crossAxisAlignment: CrossAxisAlignment.start,
            titleText: 'Product overview',
            titleSize: context.sp(18),
            sizeBoxheight: context.sh(12),
            subText: data.overview,
            subSize: context.sp(12),
          ),
          SizedBox(height: context.sh(12)),
        ],
        NormalText(
          crossAxisAlignment: CrossAxisAlignment.start,
          titleText: 'How to use',
          titleSize: context.sp(18),
          sizeBoxheight: context.sh(12),
        ),
        if (data.howToUse.isEmpty)
          NormalText(
            subText: '—',
            subSize: context.sp(12),
            subColor: AppColors.subHeadingColor,
          )
        else
          ...data.howToUse.map(
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
        NormalText(
          crossAxisAlignment: CrossAxisAlignment.start,
          titleText: 'When to use',
          titleSize: context.sp(18),
          sizeBoxheight: context.sh(12),
        ),
        if (data.whenToUse.isEmpty)
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
                    subText: data.whenToUse,
                    subSize: context.sp(12),
                  ),
                ),
              ],
            ),
          ),
        SizedBox(height: context.sh(12)),
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

        if (data.dontUseWith.isEmpty)
          NormalText(
            subText: '—',
            subSize: context.sp(12),
            subColor: AppColors.subHeadingColor,
          )
        else
          Wrap(
            spacing: context.sw(8),
            children: data.dontUseWith
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
        // if (data.tags.isNotEmpty) ...[
        //   SizedBox(height: context.sh(16)),
        //   NormalText(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     titleText: 'Tags',
        //     titleSize: context.sp(18),
        //     titleWeight: FontWeight.w600,
        //     titleColor: AppColors.headingColor,
        //   ),
        //   SizedBox(height: context.sh(8)),
        //   Wrap(
        //     spacing: context.sw(6),
        //     runSpacing: context.sh(6),
        //     children: data.tags
        //         .map(
        //           (t) => PlanContainer(
        //             isSelected: false,
        //             onTap: () {},
        //             child: NormalText(
        //               titleText: t,
        //               titleColor: AppColors.subHeadingColor,
        //               titleSize: context.sp(10),
        //               titleWeight: FontWeight.w600,
        //             ),
        //           ),
        //         )
        //         .toList(),
        //   ),
        // ],
        // if (data.confidencePercent != null) ...[
        //   SizedBox(height: context.sh(16)),
        //   NormalText(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     titleText: 'Confidence',
        //     titleSize: context.sp(18),
        //     titleWeight: FontWeight.w600,
        //     titleColor: AppColors.headingColor,
        //     sizeBoxheight: context.sh(8),
        //     subText: '${data.confidencePercent}%',
        //     subSize: context.sp(12),
        //     subColor: AppColors.subHeadingColor,
        //     subWeight: FontWeight.w400,
        //   ),
        // ],
       ],
    );
  }
}
