import 'package:flutter/material.dart';

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
    // Get screen dimensions
    final Size screenSize = MediaQuery.of(context).size;
    final bool xHorizontal = screenSize.width >= screenSize.height;

    // Build the selected layout with the state passed to the builder
    return xHorizontal
        ? verticalBuilder(xHorizontal) // Pass true for horizontal layout
        : horizontalBuilder != null
        ? horizontalBuilder!(!xHorizontal) // Pass false for vertical layout
        : verticalBuilder(xHorizontal); // Fallback to horizontal if no vertical builder
  }
}
