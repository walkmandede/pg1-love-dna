import 'package:flutter/material.dart';
import 'package:pg1/core/shared/extensions/int_extension.dart';
import 'package:pg1/core/shared/theme/app_color.dart';
import 'package:pg1/core/shared/theme/app_text_styles.dart';
import 'package:pg1/core/shared/widgets/app_text.dart';
import 'package:pg1/core/shared/widgets/app_text_field.dart';
import 'package:pg1/features/inputs/inputs_page_controller.dart';

class AddressInput extends StatelessWidget {
  final InputsPageController pageController;

  const AddressInput({super.key, required this.pageController});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Where do you live?',
          style: AppTextStyles.inputLabel,
        ),
        32.heightGap,
        AppTextField(
          hintText: 'Select your location',
          controller: pageController.addressField,
        ),
        16.heightGap,
        Text(
          'This doesn\'t affect your result — It helps us\nunderstand where people are discovering TWLVE',
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
