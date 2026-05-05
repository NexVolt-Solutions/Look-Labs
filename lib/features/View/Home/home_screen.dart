import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Features/View/Home/Widget/Sections/explore_plans_section.dart';
import 'package:looklabs/Features/View/Home/Widget/Sections/wellness_overview_section.dart';
import 'package:looklabs/Features/View/Home/Widget/Sections/weekly_progress_section.dart';
import 'package:looklabs/Features/ViewModel/home_view_model.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final vm = context.read<HomeViewModel>();
      // First paint: explore grid only to reduce first-frame jank.
      vm.loadDomainsForExplore();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 120), () {
        if (!mounted) return;
        context.read<HomeViewModel>().loadWellness();
      });
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 280), () {
        if (!mounted) return;
        context.read<HomeViewModel>().loadWeeklyProgress();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final homeViewModel = Provider.of<HomeViewModel>(context);

    return ListView(
      padding: context.paddingSymmetricR(horizontal: 20),
      clipBehavior: Clip.hardEdge,
      children: [
        WellnessOverviewSection(homeViewModel: homeViewModel),
        WeeklyProgressSection(homeViewModel: homeViewModel),
        ExplorePlansSection(homeViewModel: homeViewModel),
      ],
    );
  }
}
