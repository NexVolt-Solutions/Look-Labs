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

class HairTopProduct extends StatelessWidget {
  const HairTopProduct({super.key});

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
                          routineVm.loading
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
                        final tod =
                            (row['time_of_day'] as String? ?? '').toUpperCase();
                        final isPmOnly =
                            tod.contains('PM') && !tod.contains('AM');
                        final isFirstIndex = index == 0;

                        return ProductWidget(
                          index: index,
                          title: row['title'] as String?,
                          disc: row['description'] as String?,
                          icon1: isPmOnly
                              ? AppAssets.nightIcon
                              : AppAssets.sunIcon,
                          secondIcon: isFirstIndex ? null : AppAssets.sunIcon,
                          text: isFirstIndex
                              ? (row['time_of_day'] as String?)
                              : null,
                          showGradient: !isFirstIndex,
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
