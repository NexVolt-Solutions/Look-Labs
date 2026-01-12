import 'package:flutter/material.dart';

class TopProductViewModel extends ChangeNotifier {
  final List<String> scalpTags = [
    'Oily Scalp',
    'Excess Sebum',
    'Product Buildup',
  ];
}

// final List<Map<String, dynamic>> scalpTags = [
//     {
//       'leftIcon': AppAssets.dropIcon,
//       'rightIcon': AppAssets.nightIcon,
//       'rightText': 'PM',
//       'title': 'Oil-Control Shampoo',
//       'description': 'Controls excess oil while keeping scalp healthy',
//       'buttonText': ['Product Buildup', 'Oily Scalp', 'Excess Sebum'],
//     },
//     {
//       'leftIcon': AppAssets.dropIcon,
//       'rightIcon': AppAssets.nightIcon,
//       'rightText': 'PM',
//       'title': 'Lightweight Scalp Serum',
//       'description': 'Non-greasy nourishment for daily scalp care',
//       'buttonText': ['Weak Roots', 'Scalp Dryness', 'Hair Thinning Support'],
//     },
//     {
//       'leftIcon': AppAssets.dropIcon,
//       'rightIcon': AppAssets.nightIcon,
//       'rightText': 'PM',
//       'title': 'Minoxidil Foam',
//       'description': 'Clinically backed support for hair regrowth',
//       'buttonText': ['Hair Thinning', 'Hair Fall', 'Low Density Areas'],
//     },
//   ];
