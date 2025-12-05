import 'package:flutter/material.dart';
import 'package:pg1/core/shared/extensions/int_extension.dart';
import 'package:pg1/core/shared/theme/app_color.dart';
import 'package:pg1/core/shared/theme/app_text_styles.dart';
import 'package:pg1/core/shared/widgets/app_text.dart';
import 'package:pg1/core/shared/widgets/app_text_field.dart';
import 'package:pg1/features/inputs/inputs_page_controller.dart';

class NameInput extends StatelessWidget {
  final InputsPageController pageController;

  const NameInput({super.key, required this.pageController});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'What\'s your name?',
          style: AppTextStyles.inputLabel,
        ),
        32.heightGap,
        AppTextField(
          hintText: 'Enter your name',
          controller: pageController.nameField,
        ),
        16.heightGap,
        Text(
          'Your name isn\'t stored with your answers',
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
