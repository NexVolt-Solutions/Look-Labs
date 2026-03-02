import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:looklabs/Features/Widget/custom_button.dart';
import 'package:looklabs/Features/Widget/normal_text.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/app_text.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Core/Routes/routes_name.dart';
import 'package:looklabs/Features/ViewModel/gaol_screen_view_model.dart';
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a goal to start your journey.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final sessionId = OnboardingRepository.sessionId;
    if (sessionId == null || sessionId.isEmpty) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Session expired. Please start again.'),
          behavior: SnackBarBehavior.floating,
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            response.message ?? 'Failed to save goal. Please try again.',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    Navigator.pushNamed(context, RoutesName.OnBoardScreen);
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<GaolScreenViewModel>(context);
    return PopScope(
      canPop: false,
      child: Scaffold(
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
                  child: const Center(child: CircularProgressIndicator()),
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
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.buttonColor.withOpacity(0.11)
                              : AppColors.backGroundColor,
                          borderRadius:
                              BorderRadius.circular(context.radiusR(16)),
                          border: isSelected
                              ? Border.all(
                                  color: AppColors.pimaryColor,
                                  width: 1.5,
                                )
                              : null,
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: AppColors.buttonColor
                                        .withOpacity(0.15),
                                    offset: const Offset(5, 5),
                                    blurRadius: 20,
                                    inset: true,
                                  ),
                                  BoxShadow(
                                    color: AppColors.buttonColor
                                        .withOpacity(0.15),
                                    offset: const Offset(-5, -5),
                                    blurRadius: 20,
                                    inset: true,
                                  ),
                                ]
                              : [
                                  BoxShadow(
                                    color: AppColors.customContainerColorUp
                                        .withOpacity(0.5),
                                    offset: const Offset(5, 5),
                                    blurRadius: 20,
                                  ),
                                  BoxShadow(
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
