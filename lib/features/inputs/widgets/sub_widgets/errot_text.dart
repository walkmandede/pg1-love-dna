import 'package:flutter/material.dart';
import 'package:pg1/core/shared/constants/app_constants.dart';
import 'package:pg1/core/shared/theme/app_color.dart';
import 'package:pg1/core/shared/theme/app_text_styles.dart';
import 'package:pg1/features/inputs/inputs_page_controller.dart';

class InputErrorText extends StatelessWidget {
  final InputsPageController pageController;

  const InputErrorText({super.key, required this.pageController});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: kBasePaddingS),
      child: ValueListenableBuilder(
        valueListenable: pageController.errorText,
        builder: (context, errorText, child) {
          return Center(
            child: Text(
              errorText ?? '',
              style: AppTextStyles.bodyTextSmall.copyWith(
                color: AppColor.error600,
              ),
            ),
          );
        },
      ),
    );
  }
}
