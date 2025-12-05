import 'package:flutter/material.dart';
import 'package:pg1/core/shared/theme/app_color.dart';
import 'package:pg1/features/inputs/inputs_page_controller.dart';

class ProgressBar extends StatelessWidget {
  final InputsPageController pageController;

  const ProgressBar({super.key, required this.pageController});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: pageController.currentPageIndex,
      builder: (context, currentPageIndex, child) {
        final currentPage = currentPageIndex + 1;
        return Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 16,
          children: [
            Text(
              'Step $currentPage of 4',
              style: TextStyle(
                color: AppColor.textSecondary,
                fontSize: 14,
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 10,
              child: Stack(
                children: [
                  _bar(1, AppColor.backgroundGrey),
                  _bar(currentPage / 4, AppColor.primary),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _bar(double amount, Color color) {
    return SizedBox.expand(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Align(
            alignment: Alignment.centerLeft,
            child: DecoratedBox(
              decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(1000)),
              child: SizedBox(
                height: double.infinity,
                width: constraints.maxWidth * amount,
              ),
            ),
          );
        },
      ),
    );
  }
}
