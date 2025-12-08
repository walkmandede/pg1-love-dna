import 'package:flutter/material.dart';
import 'package:pg1/core/shared/constants/app_constants.dart';
import 'package:pg1/core/shared/enums/gender_enum.dart';
import 'package:pg1/core/shared/extensions/build_context_extension.dart';
import 'package:pg1/core/shared/extensions/num_extension.dart';
import 'package:pg1/core/shared/theme/app_color.dart';
import 'package:pg1/core/shared/theme/app_text_styles.dart';
import 'package:pg1/core/shared/widgets/app_button.dart';
import 'package:pg1/core/shared/widgets/disclosure_message_widget.dart';
import 'package:pg1/features/inputs/inputs_page_controller.dart';
import 'package:pg1/features/inputs/widgets/continue_button.dart';
import 'package:pg1/features/inputs/widgets/progress_bar.dart';

class GenderInput extends StatelessWidget {
  final InputsPageController pageController;

  const GenderInput({super.key, required this.pageController});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: pageController.selectedGender,
      builder: (context, selectedGender, child) {
        return SingleChildScrollView(
          padding: EdgeInsets.all(kBasePaddingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InputPrgoressBar(pageController: pageController),
              (context.screenHeight * 0.1).heightGap,
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
              (context.screenHeight * 0.1).heightGap,
              InputContinueButton(controller: pageController),
              16.heightGap,
              DisclosureMessageWidget(),
              32.heightGap,
            ],
          ),
        );
      },
    );
  }
}
