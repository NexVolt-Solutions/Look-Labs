import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/app_text.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Repository/domain_questions_repository.dart';
import 'package:looklabs/Features/Widget/app_bar_container.dart';
import 'package:looklabs/Features/Widget/custom_button.dart';
import 'package:looklabs/Features/Widget/linear_slider_widget.dart';
import 'package:looklabs/Features/Widget/normal_text.dart';
import 'package:looklabs/Core/Routes/routes_name.dart';

class FashionAnalyzingScreen extends StatefulWidget {
  const FashionAnalyzingScreen({super.key});

  @override
  State<FashionAnalyzingScreen> createState() => _FashionAnalyzingScreenState();
}

class _FashionAnalyzingScreenState extends State<FashionAnalyzingScreen> {
  bool _loading = true;
  Map<String, dynamic>? _flowData;
  List<String> _insights = const [];
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();
    _loadFashionFlow();
  }

  Future<void> _loadFashionFlow() async {
    final flowRes = await DomainQuestionsRepository.instance.getDomainFlow(
      'fashion',
    );
    Map<String, dynamic>? payload;
    if (flowRes.success && flowRes.data is Map) {
      payload = Map<String, dynamic>.from(flowRes.data as Map);
      final status = (payload['status']?.toString() ?? '').toLowerCase();
      if (status == 'processing' ||
          status == 'pending' ||
          status == 'in_progress') {
        final completed = await DomainQuestionsRepository.instance
            .pollDomainFlowUntilCompleted('fashion', lastKnownResponse: payload);
        if (completed != null) payload = Map<String, dynamic>.from(completed);
      }
    }
    if (!mounted) return;
    _flowData = payload;
    _insights = _extractInsights(payload);
    _loading = false;
    setState(() {});
    if (_shouldAutoNavigateOnCompleted(payload)) {
      _goToProfile();
    }
  }

  bool _isFlowCompleted(Map<String, dynamic>? payload) {
    if (payload == null) return false;
    final status = (payload['status']?.toString() ?? '').toLowerCase().trim();
    if (status == 'completed' || status == 'ok') return true;
    final redirect = (payload['redirect']?.toString() ?? '')
        .toLowerCase()
        .trim();
    return redirect == 'completed_flow';
  }

  bool _shouldAutoNavigateOnCompleted(Map<String, dynamic>? payload) {
    if (!_isFlowCompleted(payload)) return false;
    // If insights are available, let the user read them and continue manually.
    return _insights.isEmpty;
  }

  void _goToProfile() {
    if (!mounted || _hasNavigated) return;
    _hasNavigated = true;
    Navigator.pushReplacementNamed(
      context,
      RoutesName.FashionProfileScreen,
      arguments: _flowData,
    );
  }

  List<String> _extractInsights(Map<String, dynamic>? payload) {
    if (payload == null) return const [];
    final summaryRaw = payload['ai_summary'];
    if (summaryRaw is! Map) return const [];
    final summary = Map<String, dynamic>.from(summaryRaw);
    final raw = summary['analyzing_insights'];
    if (raw is! List) return const [];
    return raw
        .map((e) => (e?.toString() ?? '').trim())
        .where((e) => e.isNotEmpty)
        .toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
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
          text: _loading ? 'Analyzing...' : 'Continue',
          color: AppColors.pimaryColor,
          isEnabled: !_loading,
          onTap: _goToProfile,
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: context.paddingSymmetricR(horizontal: 20),
          children: [
            AppBarContainer(
              title: AppText.analyzing,
              onTap: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(height: context.sh(32)),
            SizedBox(
              // width: context.sw(60),
              // height: context.sh(60),
              child: CupertinoActivityIndicator(
                radius: 50,
                color: AppColors.pimaryColor,
              ),
            ),
            SizedBox(height: context.sh(24)),
            NormalText(
              crossAxisAlignment: CrossAxisAlignment.center,
              titleText: AppText.analyzingYourStyle,
              titleSize: context.sp(18),
              titleWeight: FontWeight.w600,
              titleColor: AppColors.headingColor,
              subText: AppText.aiStudyingStyle,
              subSize: context.sp(14),
              subWeight: FontWeight.w400,
              subColor: AppColors.subHeadingColor,
              sizeBoxheight: context.sh(4),
              subAlign: TextAlign.center,
            ),
            SizedBox(height: context.sh(24)),
            Padding(
              padding: context.paddingSymmetricR(horizontal: 56),
              child: LinearSliderWidget(
                showTopIcon: true,
                progress: _loading ? 20 : 100,
                inset: false,
                height: context.sh(10),
                animatedConHeight: context.sh(10),
                showPercentage: false,
              ),
            ),
            SizedBox(height: context.sh(24)),
            ...List.generate(_insights.isEmpty ? 4 : _insights.length, (index) {
              return Padding(
                padding: EdgeInsets.only(bottom: context.sh(18)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '• ', // Dot bullet
                      style: TextStyle(
                        fontSize: context.sp(16),
                        fontWeight: FontWeight.w400,
                        color: AppColors.subHeadingColor,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        _insights.isEmpty
                            ? AppText.darkCirclesUnderEyes
                            : _insights[index],
                        style: TextStyle(
                          fontSize: context.sp(12),
                          fontWeight: FontWeight.w400,
                          color: AppColors.subHeadingColor,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
