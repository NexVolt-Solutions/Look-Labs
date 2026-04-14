import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:looklabs/Features/Widget/app_bar_container.dart';
import 'package:looklabs/Features/Widget/camera_widget.dart';
import 'package:looklabs/Features/Widget/custom_button.dart';
import 'package:looklabs/Features/Widget/custom_stepper.dart';
import 'package:looklabs/Features/Widget/normal_text.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Core/Routes/routes_name.dart';
import 'package:looklabs/Features/ViewModel/review_scans_view_model.dart';
import 'package:provider/provider.dart';

class _PickSourceCard extends StatelessWidget {
  const _PickSourceCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(context.radiusR(16)),
        child: Ink(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(context.radiusR(16)),
            border: Border.all(
              color: AppColors.pimaryColor.withValues(alpha: 0.35),
              width: context.sw(1.2),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.customContainerColorUp.withValues(alpha: 0.2),
                offset: const Offset(2, 2),
                blurRadius: 6,
              ),
            ],
          ),
          child: Padding(
            padding: context.paddingSymmetricR(vertical: 20, horizontal: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: context.paddingSymmetricR(
                    horizontal: 14,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.pimaryColor.withValues(alpha: 0.12),
                  ),
                  child: Icon(
                    icon,
                    color: AppColors.pimaryColor,
                    size: context.sw(28),
                  ),
                ),
                SizedBox(height: context.sh(10)),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: context.sp(14),
                    fontWeight: FontWeight.w600,
                    color: AppColors.subHeadingColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> _pickSkinImageForSlot(
  BuildContext context,
  ReviewScansViewModel vm,
  int index,
) async {
  vm.selectStep(index);
  final source = await showModalBottomSheet<ImageSource>(
    context: context,
    showDragHandle: true,
    backgroundColor: AppColors.backGroundColor,
    builder: (ctx) => SafeArea(
      child: Padding(
        padding: context.paddingSymmetricR(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: _PickSourceCard(
                icon: Icons.photo_camera_outlined,
                label: 'Camera',
                onTap: () => Navigator.pop(ctx, ImageSource.camera),
              ),
            ),
            SizedBox(width: context.sw(12)),
            Expanded(
              child: _PickSourceCard(
                icon: Icons.photo_library_outlined,
                label: 'Gallery',
                onTap: () => Navigator.pop(ctx, ImageSource.gallery),
              ),
            ),
          ],
        ),
      ),
    ),
  );
  if (source == null || !context.mounted) return;
  await vm.pickImageForSlot(index, source);
}

class SkinReviewScans extends StatelessWidget {
  const SkinReviewScans({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ReviewScansViewModel>();
    return Scaffold(
      backgroundColor: AppColors.backGroundColor,
      bottomNavigationBar: Padding(
        padding: EdgeInsetsGeometry.only(
          top: context.sh(5),
          left: context.sw(20),
          right: context.sw(20),
          bottom: context.sh(30),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (viewModel.uploadError != null) ...[
              Padding(
                padding: EdgeInsets.only(bottom: context.sh(8)),
                child: Text(
                  viewModel.uploadError!,
                  style: TextStyle(
                    color: AppColors.redColor,
                    fontSize: context.sp(13),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
            CustomButton(
              text: viewModel.uploading ? 'Uploading...' : 'Continue',
              color: AppColors.pimaryColor,
              isEnabled:
                  !viewModel.uploading &&
                  (!viewModel.needsDomainUpload || viewModel.allSlotsFilled),
              onTap: () async {
                var navigatedEarly = false;
                final ok = await viewModel.uploadAllDomainImages(
                  onAnyStandardSlotProcessing: () {
                    if (!context.mounted || navigatedEarly) return;
                    navigatedEarly = true;
                    Navigator.pushNamed(
                      context,
                      RoutesName.SkinAnalyzingScreen,
                    );
                  },
                );
                if (!context.mounted || !ok) return;
                if (!navigatedEarly) {
                  Navigator.pushNamed(
                    context,
                    RoutesName.SkinAnalyzingScreen,
                  );
                }
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: context.paddingSymmetricR(horizontal: 20),
          children: [
            AppBarContainer(
              title: 'Review Scans',
              onTap: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(height: context.sh(24)),

            CustomStepper(
              currentStep: viewModel.stepperHighlightStep,
              steps: ReviewScansViewModel.stepperStepTitles,
            ),
            SizedBox(height: context.sh(20)),
            NormalText(
              crossAxisAlignment: CrossAxisAlignment.center,
              titleText: 'Capture Your Skin',

              subText:
                  'Take 4 photos from different angles for personalized recommendations',

              subAlign: TextAlign.center,
            ),
            SizedBox(height: context.sh(12)),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: context.sw(12),
                mainAxisSpacing: context.sh(12),
                childAspectRatio: 0.78,
              ),
              itemCount: 4,
              itemBuilder: (context, index) {
                return ReviewScanTile(
                  onTapCapture: () =>
                      _pickSkinImageForSlot(context, viewModel, index),
                  onRetake: () =>
                      _pickSkinImageForSlot(context, viewModel, index),
                  localImagePath: viewModel.imagePathForSlot(index),
                  isSelected:
                      (viewModel.imagePathForSlot(index)?.isNotEmpty ??
                          false) ||
                      viewModel.currentStep == index,
                  angleTitle: ReviewScansViewModel.slotLabels[index],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
