import 'package:flutter/material.dart';
import 'package:pg1/core/shared/widgets/app_button.dart';
import 'package:pg1/features/inputs/inputs_page_controller.dart';

class InputContinueButton extends StatelessWidget {
  final InputsPageController controller;

  const InputContinueButton({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller.isValidInput,
      builder: (context, isValidInput, child) {
        return AppButton(
          onPressed: () async {
            await controller.onContinuePressed(context);
          },
          label: 'Continue',
          width: double.infinity,
          isDisabled: !isValidInput,
        );
      },
    );
  }
}
