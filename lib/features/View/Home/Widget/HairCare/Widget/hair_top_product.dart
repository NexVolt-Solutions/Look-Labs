import 'package:flutter/material.dart';
import 'package:looklabs/Features/Widget/app_bar_container.dart';
import 'package:looklabs/Features/Widget/normal_text.dart';
import 'package:looklabs/Features/Widget/product_widget.dart';
import 'package:looklabs/Core/Constants/app_assets.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Core/Routes/routes_name.dart';
import 'package:looklabs/Features/ViewModel/daily_hair_care_routine_view_model.dart';
import 'package:looklabs/Features/ViewModel/hair_top_product_view_model.dart';
import 'package:provider/provider.dart';

class HairTopProduct extends StatefulWidget {
  const HairTopProduct({super.key});

  @override
  State<HairTopProduct> createState() => _HairTopProductState();
}

class _HairTopProductState extends State<HairTopProduct> {
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
      final vm = context.read<DailyHairCareRoutineViewModel>();
      if (vm.hairProducts.isEmpty && !vm.showRoutineRefreshing) {
        vm.loadHaircareRoutine();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectionVm = context.watch<HairTopProductViewModel>();
    final routineVm = context.watch<DailyHairCareRoutineViewModel>();
    final rows = routineVm.hairProducts
        .map(DailyHairCareRoutineViewModel.productRowForListUi)
        .toList();

    return Scaffold(
      backgroundColor: AppColors.backGroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: context.paddingSymmetricR(horizontal: 20),
              child: AppBarContainer(
                title: 'Recommended Products',
                onTap: () => Navigator.pop(context),
                showHeart: true,
                onHeartTap: () {},
              ),
            ),
            SizedBox(height: context.sh(20)),
            Padding(
              padding: context.paddingSymmetricR(horizontal: 20),
              child: NormalText(
                crossAxisAlignment: CrossAxisAlignment.start,
                titleText: 'Curated for your hair & scalp concerns',
                titleSize: context.sp(18),
                titleWeight: FontWeight.w600,
                titleColor: AppColors.headingColor,
              ),
            ),
            SizedBox(height: context.sh(20)),
            Expanded(
              child: rows.isEmpty
                  ? Center(
                      child: Padding(
                        padding: context.paddingSymmetricR(horizontal: 24),
                        child: Text(
                          routineVm.showRoutineRefreshing
                              ? 'Loading…'
                              : 'No product recommendations yet. Complete your hair assessment from Home.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: context.sp(14),
                            color: AppColors.subHeadingColor,
                          ),
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: context.paddingSymmetricR(horizontal: 20),
                      itemCount: rows.length,
                      itemBuilder: (context, index) {
                        final row = rows[index];
                        final tags = (row['tags'] as List?)?.cast<String>() ?? [];
                        final rawTod =
                            (row['time_of_day'] as String? ?? '').trim();
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
                              RoutesName.HairProductDetailScreen,
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
