import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:looklabs/Features/Widget/normal_text.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class SpeedMeterWidget extends StatelessWidget {
  final String? box1Title;
  final String? box1subTitle;
  final String? box2Title;
  final String? box2subTitle;
  final String? box1per;
  final String? box2per;

  final String? smHTitle;
  final String? smTitle;
  final String? smsSubTitle;

  /// Needle value for the semi-circle gauge (0–100).
  final double? gaugeNeedleValue;

  const SpeedMeterWidget({
    super.key,
    this.box1Title,
    this.box1subTitle,
    this.box2Title,
    this.box2subTitle,
    this.box1per,
    this.box2per,
    this.smHTitle,
    this.smTitle,
    this.smsSubTitle,
    this.gaugeNeedleValue,
  });

  /// Needle 0–100 from concerns `PageView` rows (`title`, `subTitle`, optional `progress` / `pers`).
  /// Uses severity language in [subTitle] (e.g. Low / Moderate / High); blends with API confidence when set.
  static double needleFromConcernRows(List<Map<String, dynamic>> rows) {
    if (rows.isEmpty) return 45;

    Map<String, dynamic>? hairLossRow;
    for (final r in rows) {
      final t = (r['title'] ?? '').toString().toLowerCase();
      if (t.contains('hairloss') ||
          t.contains('hair loss') ||
          t.contains('hairfall') ||
          t.contains('hair fall')) {
        hairLossRow = r;
        break;
      }
    }
    final primary = hairLossRow ?? rows.first;
    final label = (primary['subTitle'] ?? '').toString().toLowerCase().trim();
    final semantic = _semanticSeverityNeedle(label);
    final conf = _rowConfidencePercent(primary);
    var needle = conf != null
        ? (0.58 * semantic + 0.42 * conf).clamp(0, 100)
        : semantic;

    if (rows.length >= 2) {
      final secondary = rows[1];
      final l2 = (secondary['subTitle'] ?? '').toString().toLowerCase().trim();
      final s2 = _semanticSeverityNeedle(l2);
      final c2 = _rowConfidencePercent(secondary);
      final n2 = c2 != null ? (0.58 * s2 + 0.42 * c2).clamp(0, 100) : s2;
      needle = (0.72 * needle + 0.28 * n2).clamp(0, 100);
    }

    return needle.clamp(0, 100).toDouble();
  }

  static double? _rowConfidencePercent(Map<String, dynamic> row) {
    final p = row['progress'];
    if (p is num) return p.toDouble().clamp(0, 100);
    final s = row['pers']?.toString().replaceAll('%', '').trim();
    return double.tryParse(s ?? '');
  }

  /// Higher needle = more severe for loss / damage style labels.
  static double _semanticSeverityNeedle(String lower) {
    if (lower.isEmpty) return 45;
    if (lower.contains('critical')) return 97;
    if (lower.contains('severe')) return 93;
    if (lower.contains('very high')) return 90;
    if (lower.contains('moderately high')) return 74;
    if (lower.contains('high')) return 86;
    if (lower.contains('moderate')) return 62;
    if (lower.contains('elevated')) return 58;
    if (lower.contains('mild')) return 36;
    if (lower.contains('normal') || lower.contains('balanced')) return 42;
    if (lower.contains('healthy') && !lower.contains('unhealthy')) return 28;
    if (lower.contains('minimal')) return 16;
    if (lower.contains('none') ||
        lower == 'clear' ||
        lower.startsWith('no ') ||
        lower.endsWith(' none')) {
      return 10;
    }
    if (lower.contains('low')) return 24;
    if (lower.contains('sparse') || lower.contains('thinning')) return 55;
    if (lower.contains('recession') || lower.contains('receding')) return 60;
    return 48;
  }

  static double _percentFromString(String? raw) {
    if (raw == null || raw.trim().isEmpty) return 0;
    final n = double.tryParse(raw.replaceAll('%', '').trim());
    if (n == null) return 0;
    return (n / 100).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final p1 = _percentFromString(box1per);
    final p2 = _percentFromString(box2per);

    return Column(
      children: [
        Row(
          children: List.generate(2, (index) {
            final title = index == 0 ? box1Title : box2Title;
            final sub = index == 0 ? box1subTitle : box2subTitle;
            final per = index == 0 ? box1per : box2per;
            final pct = index == 0 ? p1 : p2;

            return Expanded(
              child: Container(
                padding: context.paddingSymmetricR(
                  horizontal: 20,
                  vertical: 30,
                ),
                margin: context.paddingSymmetricR(horizontal: 8, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(context.radiusR(16)),
                  color: AppColors.backGroundColor,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.customContainerColorUp.withValues(
                        alpha: 0.4,
                      ),
                      offset: const Offset(5, 5),
                      blurRadius: 5,
                      inset: false,
                    ),
                    BoxShadow(
                      color: AppColors.customContinerColorDown.withValues(
                        alpha: 0.4,
                      ),
                      offset: const Offset(-5, -5),
                      blurRadius: 5,
                      inset: false,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title ?? '',
                      style: TextStyle(
                        fontSize: context.sp(12),
                        fontWeight: FontWeight.w600,
                        color: AppColors.notSelectedColor,
                      ),
                    ),
                    Text(
                      sub ?? '',
                      style: TextStyle(
                        fontSize: context.sp(16),
                        fontWeight: FontWeight.w600,
                        color: AppColors.subHeadingColor,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                            height: context.sh(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                context.radiusR(20),
                              ),
                              color: AppColors.backGroundColor,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.customContainerColorUp
                                      .withValues(alpha: 0.4),
                                  offset: const Offset(5, 5),
                                  blurRadius: 5,
                                  inset: true,
                                ),
                                BoxShadow(
                                  color: AppColors.customContinerColorDown
                                      .withValues(alpha: 0.4),
                                  offset: const Offset(-5, -5),
                                  blurRadius: 5,
                                  inset: true,
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                context.radiusR(20),
                              ),
                              child: LinearPercentIndicator(
                                padding: EdgeInsets.zero,
                                lineHeight: context.sh(8),
                                percent: pct,
                                backgroundColor: AppColors.backGroundColor,
                                progressColor: AppColors.pimaryColor,
                                barRadius: Radius.circular(context.radiusR(20)),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: context.sw(8)),
                        Text(
                          per ?? '',
                          style: TextStyle(
                            fontSize: context.sp(12),
                            fontWeight: FontWeight.w600,
                            color: AppColors.subHeadingColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
        ),

        Container(
          padding: context.paddingSymmetricR(horizontal: 20, vertical: 12),
          margin: context.paddingSymmetricR(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(context.radiusR(16)),
            color: AppColors.backGroundColor,
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
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    NormalText(
                      titleText: smHTitle ?? '',
                      titleSize: context.sp(12),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      titleWeight: FontWeight.w600,
                      titleColor: AppColors.subHeadingColor,
                    ),
                    Divider(
                      thickness: context.sw(2),
                      indent: 0,
                      endIndent: context.sw(5),
                    ),
                    NormalText(
                      titleText: smTitle ?? '',
                      titleSize: context.sp(12),
                      maxLines: 6,
                      overflow: TextOverflow.ellipsis,
                      titleWeight: FontWeight.w600,
                      titleColor: AppColors.notSelectedColor,
                      subText: smsSubTitle ?? '',
                      subSize: context.sp(16),
                      subWeight: FontWeight.w600,
                      subColor: AppColors.subHeadingColor,
                      subMaxLines: 10,
                      subOverflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              SizedBox(width: context.sw(8)),
              Expanded(
                flex: 1,
                child: _RadialGauge(needle: gaugeNeedleValue ?? 70),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RadialGauge extends StatelessWidget {
  final double needle;

  const _RadialGauge({required this.needle});

  @override
  Widget build(BuildContext context) {
    final v = needle.clamp(0, 100).toDouble();

    return SizedBox(
      height: 100,
      width: 200,
      child: SfRadialGauge(
        axes: <RadialAxis>[
          RadialAxis(
            minimum: 0,
            maximum: 100,
            startAngle: 180,
            endAngle: 0,
            showTicks: false,
            showLabels: false,
            axisLineStyle: const AxisLineStyle(
              thickness: 8,
              cornerStyle: CornerStyle.bothCurve,
            ),
            ranges: <GaugeRange>[
              GaugeRange(
                startValue: 0,
                endValue: 33,
                color: Colors.red,
                startWidth: 8,
                endWidth: 8,
              ),
              GaugeRange(
                startValue: 33,
                endValue: 66,
                color: Colors.yellow,
                startWidth: 8,
                endWidth: 8,
              ),
              GaugeRange(
                startValue: 66,
                endValue: 100,
                color: Colors.green,
                startWidth: 8,
                endWidth: 8,
              ),
            ],
            pointers: <GaugePointer>[
              NeedlePointer(
                value: v,
                needleLength: 0.6,
                needleStartWidth: 1,
                needleEndWidth: 3,
                knobStyle: KnobStyle(
                  color: Colors.black,
                  sizeUnit: GaugeSizeUnit.factor,
                  knobRadius: 0.04,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
