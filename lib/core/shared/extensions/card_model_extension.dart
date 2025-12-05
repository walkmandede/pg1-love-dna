import 'package:pg1/core/models/card_model.dart';
import 'package:pg1/core/shared/assets/app_svgs.dart';

extension CardModelExtension on CardModel {
  String get svgIconString {
    switch (id) {
      case 'card_01':
        return AppSvgs.pattern1;
      case 'card_02':
        return AppSvgs.pattern2;
      case 'card_03':
        return AppSvgs.pattern3;
      case 'card_04':
        return AppSvgs.pattern4;
      case 'card_05':
        return AppSvgs.pattern5;
      case 'card_06':
        return AppSvgs.pattern6;
      case 'card_07':
        return AppSvgs.pattern7;
      case 'card_08':
        return AppSvgs.pattern8;
      case 'card_09':
        return AppSvgs.pattern9;
      case 'card_10':
        return AppSvgs.pattern10;
      case 'card_11':
        return AppSvgs.pattern11;
      case 'card_12':
        return AppSvgs.pattern12;
      default:
        return AppSvgs.heart;
    }
  }
}
