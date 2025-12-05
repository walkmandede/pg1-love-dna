import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pg1/core/shared/constants/app_constants.dart';
import 'package:pg1/core/shared/enums/gender_enum.dart';
import 'package:pg1/core/shared/extensions/int_extension.dart';
import 'package:pg1/core/shared/theme/app_color.dart';
import 'package:pg1/core/shared/theme/app_text_styles.dart';
import 'package:pg1/core/shared/widgets/app_button.dart';
import 'package:pg1/core/shared/widgets/app_text.dart';
import 'package:pg1/core/shared/widgets/disclosure_message_widget.dart';
import 'package:pg1/features/inputs/inputs_page_controller.dart';

class GenderInput extends StatelessWidget {
  final InputsPageController pageController;

  const GenderInput({super.key, required this.pageController});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: pageController.selectedGender,
      builder: (context, selectedGender, child) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              32.heightGap,
              Text(
                'How do you describle\nyourself?',
                style: AppTextStyles.inputLabel,
                textAlign: TextAlign.center,
              ),
              16.heightGap,
              ...GenderEnum.values.map((gender) {
                bool isSelected = gender == selectedGender;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: AppButton(
                    onPressed: () {
                      pageController.onGenderSelected(gender);
                    },
                    label: gender.label,
                    borderRadius: 12,
                    bgColor: isSelected ? AppColor.primary : AppColor.backgroundSecondary,
                    textColor: isSelected ? AppColor.white : AppColor.textBase,
                    borderColorHover: isSelected ? null : AppColor.primary,
                    borderColor: isSelected ? null : AppColor.borderGrey,
                    width: double.infinity,
                  ),
                );
              }),
              32.heightGap,
              _continueButton(),
              16.heightGap,
              DisclosureMessageWidget(),
              32.heightGap,
            ],
          ),
        );
      },
    );
  }

  Widget _continueButton() {
    return ValueListenableBuilder(
      valueListenable: pageController.isValidInput,
      builder: (context, isValidInput, child) {
        return AppButton(
          onPressed: () async {
            await pageController.onContinuePressed(context);
          },
          label: 'Continue',
          width: double.infinity,
          isDisabled: !isValidInput,
        );
      },
    );
  }
}
