import 'package:flutter/material.dart';
import 'package:pg1/core/shared/constants/app_constants.dart';
import 'package:pg1/core/shared/extensions/int_extension.dart';
import 'package:pg1/core/shared/widgets/app_button.dart';
import 'package:pg1/core/shared/widgets/disclosure_message_widget.dart';
import 'package:pg1/features/inputs/inputs_page_controller.dart';
import 'package:pg1/features/inputs/widgets/address_input.dart';
import 'package:pg1/features/inputs/widgets/age_input.dart';
import 'package:pg1/features/inputs/widgets/gender_input.dart';
import 'package:pg1/features/inputs/widgets/name_input.dart';
import 'package:pg1/features/inputs/widgets/progress_bar.dart';

class InputsPage extends StatefulWidget {
  const InputsPage({super.key});

  @override
  State<InputsPage> createState() => _InputsPageState();
}

class _InputsPageState extends State<InputsPage> {
  final InputsPageController _controller = InputsPageController();

  @override
  void initState() {
    super.initState();
    _controller.initLoad(context);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SizedBox.expand(
        child: Padding(
          padding: EdgeInsets.all(kBasePaddingM),
          child: Column(
            children: [
              32.heightGap,
              ProgressBar(pageController: _controller),
              16.heightGap,
              Expanded(child: _body()),
              16.heightGap,
              _continueButton(),
              16.heightGap,
              DisclosureMessageWidget(),
              32.heightGap,
            ],
          ),
        ),
      ),
    );
  }

  Widget _body() {
    return PageView.builder(
      physics: const NeverScrollableScrollPhysics(),
      controller: _controller.pageController,
      itemCount: 4,
      itemBuilder: (context, index) {
        switch (index) {
          case 0:
            return NameInput(pageController: _controller);
          case 1:
            return AgeInput(pageController: _controller);
          case 2:
            return AddressInput(pageController: _controller);
          case 3:
            return GenderInput(pageController: _controller);
          default:
            return const SizedBox.shrink();
        }
      },
    );
  }

  Widget _continueButton() {
    return ValueListenableBuilder(
      valueListenable: _controller.isValidInput,
      builder: (context, isValidInput, child) {
        return AppButton(
          onPressed: () async {
            await _controller.onContinuePressed(context);
          },
          label: 'Continue',
          width: double.infinity,
          isDisabled: !isValidInput,
        );
      },
    );
  }
}
