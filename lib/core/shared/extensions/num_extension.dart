import 'package:flutter/widgets.dart';

extension IntExtension on int {
  SizedBox get heightGap => SizedBox(height: toDouble());
  SizedBox get widthGap => SizedBox(width: toDouble());
}

extension DoubleExtension on double {
  SizedBox get heightGap => SizedBox(height: toDouble());
  SizedBox get widthGap => SizedBox(width: toDouble());
}
