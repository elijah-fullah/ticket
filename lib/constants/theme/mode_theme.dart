import 'package:flutter/material.dart';
import '../colors/colors.dart';

class ModeTheme {
  static final lightMode = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
      brightness: Brightness.light,
      onPrimary: background,
      onSecondary: grey,
    ),
  );

  static final darkTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
      brightness: Brightness.dark,
      onPrimary: blackBackground,
      onSecondary: blackGrey,
    ),
  );

  static const background = Color(0xFFFDFCFF);
  static const grey = Color(0xFFEEEEEE);
  static const blackBackground = Color(0xFF111111);
  static const blackGrey = Color(0xFF111111);
}