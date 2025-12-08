import 'package:flutter/material.dart';
import 'package:pg1/core/shared/constants/app_constants.dart';
import 'package:pg1/core/shared/widgets/app_responsive_builder.dart';
import 'package:pg1/features/inputs/inputs_page_controller.dart';
import 'package:pg1/features/inputs/widgets/address_input.dart';
import 'package:pg1/features/inputs/widgets/age_input.dart';
import 'package:pg1/features/inputs/widgets/gender_input.dart';
import 'package:pg1/features/inputs/widgets/name_input.dart';

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
        child: AppResponsiveBuilder(
          verticalBuilder: (isVertical) {
            return Center(
              child: SizedBox(
                width: kStandardMaxWidthForPortraitOrientation,
                child: _body(),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _body() {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(
              left: kBasePaddingS,
              top: kBasePaddingM,
            ),
            child: BackButton(
              onPressed: () async {
                await _controller.onClickBack(context);
              },
            ),
          ),
        ),
        Expanded(
          child: PageView.builder(
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
          ),
        ),
      ],
    );
  }
}
