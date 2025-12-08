import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pg1/core/shared/constants/app_constants.dart';
import 'package:pg1/core/shared/theme/app_color.dart';

class AppResponsiveBuilder extends StatelessWidget {
  final Widget Function(bool isVertical) verticalBuilder;
  final Widget Function(bool isHorizontal)? horizontalBuilder;

  const AppResponsiveBuilder({
    super.key,
    required this.verticalBuilder,
    this.horizontalBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool isVertical = screenSize.width < screenSize.height;

    final child = isVertical
        ? verticalBuilder(isVertical)
        : horizontalBuilder != null
        ? horizontalBuilder!(!isVertical)
        : Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: kStandardMaxWidthForPortraitOrientation,
              ),
              child: verticalBuilder(isVertical),
            ),
          );

    return kDebugMode
        ? Badge(
            label: SizedBox(
              width: screenSize.width * 0.1,
              height: screenSize.height * 0.05,
              child: Center(
                child: FittedBox(
                  child: Text(
                    '${isVertical ? 'V-' : 'H-'} ${screenSize.width}:${screenSize.height}',
                    style: TextStyle(color: AppColor.textBase.withAlpha(100), fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            offset: Offset(-(screenSize.width * 0.1), (screenSize.height * 0.1 * 0.5)),
            backgroundColor: (isVertical ? Colors.teal : Colors.orange).withAlpha(100),
            child: child,
          )
        : child;
  }
}
