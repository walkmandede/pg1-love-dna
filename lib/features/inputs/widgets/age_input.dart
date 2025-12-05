import 'package:flutter/material.dart';
import 'package:pg1/core/shared/extensions/int_extension.dart';
import 'package:pg1/core/shared/theme/app_color.dart';
import 'package:pg1/core/shared/theme/app_text_styles.dart';
import 'package:pg1/core/shared/widgets/app_text.dart';
import 'package:pg1/core/shared/widgets/app_text_field.dart';
import 'package:pg1/features/inputs/inputs_page_controller.dart';

class AgeInput extends StatelessWidget {
  final InputsPageController pageController;

  const AgeInput({super.key, required this.pageController});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'How old are you?',
          style: AppTextStyles.inputLabel,
          textAlign: TextAlign.center,
        ),
        32.heightGap,
        AppTextField(
          hintText: 'Enter your age',
          controller: pageController.ageField,
        ),
        16.heightGap,
        Text(
          'This helps us understand who is discovering\nTWLVE. It does not affect your result.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.normal,
            color: AppColor.textSecondary,
          ),
        ),
      ],
    );
  }
}
