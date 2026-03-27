import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' as material;
import 'package:looklabs/Features/Widget/custom_button.dart';
import 'package:looklabs/Features/Widget/normal_text.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/app_text.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Core/Network/api_error_handler.dart';
import 'package:looklabs/Core/Network/api_services.dart';
import 'package:looklabs/Core/Routes/routes_name.dart';
import 'package:looklabs/Features/ViewModel/gaol_screen_view_model.dart';
import 'package:looklabs/Repository/auth_repository.dart';
import 'package:looklabs/Repository/onboarding_repository.dart';
import 'package:provider/provider.dart';

class GaolScreen extends StatefulWidget {
  const GaolScreen({super.key});

  @override
  State<GaolScreen> createState() => _GaolScreenState();
}

class _GaolScreenState extends State<GaolScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GaolScreenViewModel>().loadDomains();
    });
  }

  Future<void> _onGetStarted(
    BuildContext context,
    GaolScreenViewModel vm,
  ) async {
    final domain = vm.selectedDomain;
    if (domain == null || domain.isEmpty) {
      material.ScaffoldMessenger.of(context).showSnackBar(
        material.SnackBar(
          content: Text('Please select a goal to start your journey.'),
          behavior: material.SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final sessionId = OnboardingRepository.sessionId;
    if (sessionId == null || sessionId.isEmpty) {
      if (!context.mounted) return;
      material.ScaffoldMessenger.of(context).showSnackBar(
        material.SnackBar(
          content: material.Text('Session expired. Please start again.'),
          behavior: material.SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final response = await OnboardingRepository.instance.selectDomain(
      sessionId: sessionId,
      domain: domain,
    );

    if (!context.mounted) return;
    if (!response.success) {
      ApiErrorHandler.showSnackBar(
        context,
        response: response,
        fallback: 'Failed to save goal. Please try again.',
      );
      return;
    }

    // Ensure anonymous onboarding session is linked to the authenticated user
    // so users/me wellness/progress can resolve submitted onboarding answers.
    final token = ApiServices.authToken;
    if (token != null && token.trim().isNotEmpty) {
      final linkRes = await OnboardingRepository.instance.linkSessionToUser(
        sessionId,
      );
      if (!linkRes.success && kDebugMode) {
        debugPrint(
          '[Onboarding] linkSessionToUser failed: statusCode=${linkRes.statusCode}, message=${linkRes.message}',
        );
      }
    }

    // Store selected domain from response (status: domain_selected, domain: "fashion") for later domain APIs.
    if (response.data != null && response.data is Map) {
      final domainFromResponse = (response.data as Map)['domain']
          ?.toString()
          .trim();
      if (domainFromResponse != null && domainFromResponse.isNotEmpty) {
        await AuthRepository.setSelectedDomain(domainFromResponse);
      }
    }

    if (!context.mounted) return;
    Navigator.pushNamed(context, RoutesName.OnBoardScreen);
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<GaolScreenViewModel>(context);
    return PopScope(
      canPop: false,
      child: material.Scaffold(
        backgroundColor: AppColors.backGroundColor,
        bottomNavigationBar: Padding(
          padding: context.paddingSymmetricR(horizontal: 20, vertical: 30),
          child: CustomButton(
            isEnabled: true,
            onTap: () => _onGetStarted(context, vm),
            text: AppText.getStarted,
            color: AppColors.pimaryColor,
          ),
        ),
        body: SafeArea(
          child: ListView(
            padding: context.paddingSymmetricR(horizontal: 20),
            clipBehavior: Clip.none,
            children: [
              SizedBox(height: context.sh(20)),
              NormalText(
                crossAxisAlignment: CrossAxisAlignment.center,
                titleText: AppText.chooseGoal,
                titleSize: context.sp(20),
                titleWeight: FontWeight.w600,
                titleColor: AppColors.headingColor,
              ),
              SizedBox(height: context.sh(20)),
              if (vm.isLoading)
                Padding(
                  padding: EdgeInsets.only(top: context.sh(40)),
                  child: Center(
                    child: CupertinoActivityIndicator(
                      color: AppColors.pimaryColor,
                    ),
                  ),
                )
              else if (vm.error != null)
                Padding(
                  padding: EdgeInsets.only(top: context.sh(40)),
                  child: Center(
                    child: Text(
                      vm.error!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: context.sp(14),
                        color: AppColors.seconderyColor,
                      ),
                    ),
                  ),
                )
              else
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: context.sw(16),
                    crossAxisSpacing: context.sw(16),
                    childAspectRatio: 2.5,
                  ),
                  itemCount: vm.buttonName.length,
                  itemBuilder: (context, index) {
                    final isSelected = vm.isSelected(index);
                    return GestureDetector(
                      onTap: () => vm.selectIndex(index),
                      child: Container(
                        decoration: material.BoxDecoration(
                          color: isSelected
                              ? AppColors.buttonColor.withOpacity(0.11)
                              : AppColors.backGroundColor,
                          borderRadius: material.BorderRadius.circular(
                            context.radiusR(16),
                          ),
                          border: isSelected
                              ? material.Border.all(
                                  color: AppColors.pimaryColor,
                                  width: 1.5,
                                )
                              : null,
                          boxShadow: isSelected
                              ? [
                                  material.BoxShadow(
                                    color: AppColors.buttonColor.withOpacity(
                                      0.15,
                                    ),
                                    offset: const Offset(5, 5),
                                    blurRadius: 20,
                                  ),
                                  material.BoxShadow(
                                    color: AppColors.buttonColor.withOpacity(
                                      0.15,
                                    ),
                                    offset: const Offset(-5, -5),
                                    blurRadius: 20,
                                  ),
                                ]
                              : [
                                  material.BoxShadow(
                                    color: AppColors.customContainerColorUp
                                        .withOpacity(0.5),
                                    offset: const Offset(5, 5),
                                    blurRadius: 20,
                                  ),
                                  material.BoxShadow(
                                    color: AppColors.customContinerColorDown,
                                    offset: const Offset(-5, -5),
                                    blurRadius: 20,
                                  ),
                                ],
                        ),
                        child: Center(
                          child: Text(
                            vm.buttonName[index],
                            style: TextStyle(
                              fontSize: context.sp(14),
                              fontWeight: FontWeight.w700,
                              color: isSelected
                                  ? AppColors.headingColor
                                  : AppColors.seconderyColor,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              SizedBox(height: context.sh(223)),
            ],
          ),
        ),
      ),
    );
  }
}
