import 'package:flutter/material.dart';
import 'package:looklabs/Features/Widget/app_bar_container.dart';
import 'package:looklabs/Features/Widget/normal_text.dart';
import 'package:looklabs/Features/Widget/product_widget.dart';
import 'package:looklabs/Core/Constants/app_assets.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Core/Routes/routes_name.dart';
import 'package:looklabs/Features/ViewModel/daily_skin_care_routine_view_model.dart';
import 'package:looklabs/Features/ViewModel/hair_top_product_view_model.dart';
import 'package:provider/provider.dart';

class SkinTopProduct extends StatefulWidget {
  const SkinTopProduct({super.key});

  @override
  State<SkinTopProduct> createState() => _SkinTopProductState();
}

class _SkinTopProductState extends State<SkinTopProduct> {
  ({bool hasAm, bool hasPm}) _timeFlags(String raw) {
    final t = raw.toUpperCase();
    final hasAm = t.contains('AM');
    final hasPm = t.contains('PM');
    return (hasAm: hasAm, hasPm: hasPm);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final vm = context.read<DailySkinCareRoutineViewModel>();
      if (vm.skincareProducts.isEmpty && !vm.showRoutineRefreshing) {
        vm.loadSkincareRoutine();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectionVm = context.watch<HairTopProductViewModel>();
    final routineVm = context.watch<DailySkinCareRoutineViewModel>();
    final rows = routineVm.skincareProducts
        .map(DailySkinCareRoutineViewModel.productRowForListUi)
        .toList();

    return Scaffold(
      backgroundColor: AppColors.backGroundColor,
      body: SafeArea(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: context.paddingSymmetricR(horizontal: 20),
              child: AppBarContainer(title: 'Top Products', onTap: () => Navigator.pop(context)),
            ),
            SizedBox(height: context.sh(24)),
            Padding(
              padding: context.paddingSymmetricR(horizontal: 20),
              child: NormalText(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 subAlign: TextAlign.start,
                 subText: 'Curated for your skin concerns',
                 subSize: context.sp(16),
                 subWeight: FontWeight.w600,
                 subColor: AppColors.headingColor,
              ),
            ),
            SizedBox(height: context.sh(10)),
            Expanded(
              child: rows.isEmpty
                  ? Center(
                      child: Padding(
                        padding: context.paddingSymmetricR(horizontal: 24),
                        child: NormalText(
                          subAlign: TextAlign.center,
                          subText: routineVm.showRoutineRefreshing
                              ? 'Loading…'
                              : 'No product recommendations yet. Complete your skincare assessment.',
                          subSize: context.sp(14),
                          subColor: AppColors.subHeadingColor,
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: context.paddingSymmetricR(horizontal: 20),
                      itemCount: rows.length,
                      itemBuilder: (context, index) {
                        final row = rows[index];
                        final tags =
                            (row['tags'] as List?)?.cast<String>() ?? [];
                        final rawTod = (row['time_of_day'] as String? ?? '')
                            .trim();
                        final flags = _timeFlags(rawTod);
                        final icon1 = flags.hasPm
                            ? AppAssets.nightIcon
                            : (flags.hasAm ? AppAssets.sunIcon : null);
                        final secondIcon = flags.hasAm && flags.hasPm
                            ? AppAssets.sunIcon
                            : null;

                        return ProductWidget(
                          index: index,
                          title: row['title'] as String?,
                          disc: row['description'] as String?,
                          icon1: icon1,
                          secondIcon: secondIcon,
                          text: null,
                          showGradient: flags.hasAm && flags.hasPm,
                          viewmodel: selectionVm,
                          tagLabels: tags,
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              RoutesName.SkinProductDetailScreen,
                              arguments: row['raw'] ?? row,
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
