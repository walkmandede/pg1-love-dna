import 'package:flutter/material.dart';
import 'package:pg1/core/shared/constants/app_constants.dart';
import 'package:pg1/core/shared/extensions/num_extension.dart';
import 'package:pg1/core/shared/theme/app_color.dart';
import 'package:pg1/core/shared/theme/app_text_styles.dart';
import 'package:pg1/core/shared/widgets/app_text_field.dart';
import 'package:pg1/core/shared/widgets/disclosure_message_widget.dart';
import 'package:pg1/features/inputs/inputs_page_controller.dart';
import 'package:pg1/features/inputs/widgets/sub_widgets/continue_button.dart';
import 'package:pg1/features/inputs/widgets/sub_widgets/errot_text.dart';

class AgeInput extends StatelessWidget {
  final InputsPageController pageController;

  const AgeInput({super.key, required this.pageController});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(kBasePaddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Text(
            'How old are you?',
            style: AppTextStyles.inputLabel,
            textAlign: TextAlign.center,
          ),
          32.heightGap,
          ValueListenableBuilder(
            valueListenable: pageController.errorText,
            builder: (context, errorText, child) {
              return AppTextField(
                hintText: 'Enter your age',
                controller: pageController.ageField,
                errorText: errorText,
              );
            },
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
          const Spacer(),
          InputErrorText(pageController: pageController),
          InputContinueButton(controller: pageController),
          16.heightGap,
          DisclosureMessageWidget(),
          8.heightGap,
        ],
      ),
    );
  }
}
