import 'package:flutter/material.dart';

extension BuildContextExtension on BuildContext {
  Size get screenSize => MediaQuery.of(this).size;
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;

  //TextStyle
  TextStyle get displaySmall => Theme.of(this).textTheme.displaySmall!;
  TextStyle get titleMedium => Theme.of(this).textTheme.titleMedium!;
  TextStyle get bodyMedium => Theme.of(this).textTheme.bodyMedium!;
  TextStyle get labelMedium => Theme.of(this).textTheme.labelMedium!;
}
