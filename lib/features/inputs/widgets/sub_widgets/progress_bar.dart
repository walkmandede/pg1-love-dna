import 'package:flutter/material.dart';
import 'package:pg1/core/shared/widgets/app_progress_bar.dart';
import 'package:pg1/features/inputs/inputs_page_controller.dart';

class InputPrgoressBar extends StatelessWidget {
  final InputsPageController pageController;

  const InputPrgoressBar({super.key, required this.pageController});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: pageController.currentPageIndex,
      builder: (context, currentPageIndex, child) {
        final currentPage = currentPageIndex + 1;
        return AppProgressBar(
          label: 'Step',
          current: currentPage,
          total: 4,
        );
      },
    );
  }
}
