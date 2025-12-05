import 'package:flutter/material.dart';
import 'package:pg1/core/models/card_model.dart';
import 'package:pg1/core/shared/constants/app_constants.dart';
import 'package:pg1/core/shared/extensions/build_context_extension.dart';
import 'package:pg1/core/shared/extensions/card_model_extension.dart';
import 'package:pg1/core/shared/extensions/int_extension.dart';
import 'package:pg1/core/shared/theme/app_color.dart';
import 'package:pg1/core/shared/theme/app_text_styles.dart';
import 'package:pg1/core/shared/widgets/app_button.dart';
import 'package:pg1/core/shared/widgets/app_loading_widget.dart';
import 'package:pg1/core/shared/widgets/app_svg_widget.dart';
import 'package:pg1/core/shared/widgets/app_text.dart';
import 'package:pg1/core/shared/widgets/disclosure_message_widget.dart';
import 'package:pg1/features/love_library/love_library_controller.dart';

class LoveLibraryPage extends StatefulWidget {
  const LoveLibraryPage({super.key});

  @override
  State<LoveLibraryPage> createState() => _LoveLibraryPageState();
}

class _LoveLibraryPageState extends State<LoveLibraryPage> {
  final LoveLibraryController _controller = LoveLibraryController();

  bool get _isCompleted => _controller.sessionCubit.state.answers.length == 12;
  List<CardModel> get cards => _controller.sessionCubit.state.cards;

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
      body: ValueListenableBuilder(
        valueListenable: _controller.isInitLoading,
        builder: (context, isInitLoading, child) {
          if (isInitLoading) {
            return AppLoadingWidget();
          } else {
            return _body();
          }
        },
      ),
    );
  }

  Widget _body() {
    return SizedBox.expand(
      child: Padding(
        padding: EdgeInsetsGeometry.all(kBasePaddingM),
        child: SingleChildScrollView(
          child: Column(
            children: [
              8.heightGap,
              Text(
                _isCompleted ? 'All 12 patterns' : 'Your Love Library',
                style: AppTextStyles.cardTitle,
              ),
              16.heightGap,
              Text(
                _isCompleted
                    ? 'You\'ve completed your example patterns.\nHere\'s the full picture.'
                    : 'You\'ll complete 12 short cards. Each card\nidentifies a pattern.',
                textAlign: TextAlign.center,
                style: AppTextStyles.subtitle,
              ),
              16.heightGap,
              _cards(),
              32.heightGap,
              AppButton(
                onPressed: () {
                  _controller.onBeginCardPressed(context);
                },
                width: double.infinity,
                label: _isCompleted ? 'See your Love Code' : 'Begin Card',
              ),
              16.heightGap,
              DisclosureMessageWidget(),
              8.heightGap,
            ],
          ),
        ),
      ),
    );
  }

  Widget _cards() {
    print(cards);
    return Column(
      spacing: 8,
      children: [
        Row(
          spacing: 8,
          children: [_card(0), _card(1), _card(2)],
        ),
        Row(
          spacing: 8,
          children: [_card(3), _card(4), _card(5)],
        ),
        Row(
          spacing: 8,
          children: [_card(6), _card(7), _card(8)],
        ),
        Row(
          spacing: 8,
          children: [_card(9), _card(10), _card(11)],
        ),
      ],
    );
  }

  Widget _card(int index) {
    final card = cards[index];
    int number = index + 1;
    // final bool isAnswered = (_controller.sessionCubit.state.answers.map((a) => a.cardId).contains(card.id));
    final bool isAnswered = index <= _controller.sessionCubit.currentCardIndex;
    return Expanded(
      child: AspectRatio(
        aspectRatio: 1,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Card(
              elevation: isAnswered ? 5 : 0,
              shadowColor: AppColor.backgroundGrey.withAlpha(25),
              color: AppColor.backgroundSecondary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(12),
                side: BorderSide(
                  color: isAnswered ? AppColor.primary : Colors.transparent,
                  width: 1.5,
                ),
              ),
              child: Padding(
                padding: EdgeInsetsGeometry.all(constraints.maxHeight * 0.05),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppSvgWidget(
                      svgString: card.svgIconString,
                      size: Size.fromRadius(constraints.maxHeight * 0.125),
                      color: isAnswered ? AppColor.primary : AppColor.diableGrey,
                    ),
                    (constraints.maxHeight * 0.1).toInt().heightGap,
                    Align(
                      alignment: Alignment.topCenter,
                      child: Text(
                        'Pattern\n$number',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodyTextSmall.copyWith(
                          fontWeight: FontWeight.w700,
                          height: 1.1,
                          color: isAnswered ? AppColor.textBase : AppColor.diableGrey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
    return Expanded(
      child: SizedBox(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Card(
              elevation: isAnswered ? 5 : 0,
              shadowColor: AppColor.backgroundGrey.withAlpha(25),
              color: AppColor.backgroundSecondary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(12),
                side: BorderSide(
                  color: isAnswered ? AppColor.primary : Colors.transparent,
                  width: 1.5,
                ),
              ),
              child: Padding(
                padding: EdgeInsetsGeometry.all(constraints.maxHeight * 0.05),
                child: Column(
                  children: [
                    AppSvgWidget(
                      svgString: card.svgIconString,
                      size: Size.fromRadius(constraints.maxHeight * 0.125),
                      color: isAnswered ? AppColor.primary : AppColor.diableGrey,
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Text(
                        'Pattern\n$number',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodyTextSmall.copyWith(
                          fontWeight: FontWeight.w700,
                          height: 1.1,
                          color: isAnswered ? AppColor.textBase : AppColor.diableGrey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
