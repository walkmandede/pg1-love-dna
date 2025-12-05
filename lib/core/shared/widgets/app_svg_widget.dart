import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pg1/core/shared/constants/app_constants.dart';
import 'package:pg1/core/shared/theme/app_color.dart';

class AppSvgWidget extends StatelessWidget {
  final String svgString;
  final Size? size;
  final Color? color;
  final bool hasBgCircle;

  const AppSvgWidget({
    super.key,
    required this.svgString,
    this.color,
    this.size,
    this.hasBgCircle = false,
  });

  @override
  Widget build(BuildContext context) {
    return hasBgCircle ? _withBg() : _withoutBg();
  }

  Widget _withBg() {
    final minSize = min(size?.height ?? kBaseButtonHeight, size?.width ?? kBaseButtonHeight);
    return CircleAvatar(
      radius: min(size?.height ?? kBaseButtonHeight, size?.width ?? kBaseButtonHeight) * 0.5,
      backgroundColor: AppColor.primary,
      child: Padding(
        padding: EdgeInsetsGeometry.all(minSize * 0.3),
        child: _withoutBg(),
      ),
    );
  }

  Widget _withoutBg() {
    return SvgPicture.string(
      svgString,
      width: size?.width,
      height: size?.height,
      colorFilter: color == null ? null : ColorFilter.mode(color!, BlendMode.srcIn),
    );
  }
}
