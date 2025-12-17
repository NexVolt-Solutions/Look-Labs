import 'package:flutter/material.dart';

class AppColors {
  //Primary Colors
  static const Color headingColor = Color(0xFF1F2937);
  static const Color subHeadingColor = Color(0xFF1F2937);
  static const Color seconderyColor = Color(0xFF1E1A24);
  static const Color backGroundColor = Color(0xFFF0F0F3);

  //Used for BoxShawdow blur colors
  static const Color blurTopColor = Color(0xFFFAFBFF);
  static const Color blurBottomColor = Color(0xFFA6ABBD);

  //Button Color
  static const Color pimaryColor = Color(0xFF9D2CF5);
  static const Color buttonColor = Color(0xFF7729E4);

  static const Color black = Color(0x1A000000);
  static const Color black2 = Color(0xFF000000);
  static const Color white = Color(0x1AFFFFFF);
  static const Color customContinerColorDown = Color(0xFFFFFFFF);
  static const Color customContainerColorUp = Color(0xFFAEAEC080);
  static const Color grey = Colors.grey;

  static const LinearGradient blackWhiteGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [white, customContinerColorDown],
  );
  static const LinearGradient containerGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [black, white],
  );
}
