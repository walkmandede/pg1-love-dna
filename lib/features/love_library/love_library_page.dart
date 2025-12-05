import 'package:flutter/material.dart';
import 'package:pg1/core/shared/constants/app_constants.dart';
import 'package:pg1/core/shared/extensions/build_context_extension.dart';
import 'package:pg1/core/shared/extensions/card_model_extension.dart';
import 'package:pg1/core/shared/extensions/int_extension.dart';
import 'package:pg1/core/shared/theme/app_color.dart';
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
              TitleText(text: _isCompleted ? 'All 12 patterns' : 'Your Love Library'),
              16.heightGap,
              Text(
                _isCompleted
                    ? 'You\'ve completed your example patterns.\nHere\'s the full picture.'
                    : 'You\'ll complete 12 short cards. Each card\nidentifies a pattern.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColor.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
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
    final cards = _controller.sessionCubit.state.cards;
    return GridView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1,
        mainAxisSpacing: 6,
        crossAxisSpacing: 6,
      ),
      itemCount: cards.length,
      itemBuilder: (context, index) {
        final card = cards[index];
        int number = index + 1;
        // final bool isAnswered = (_controller.sessionCubit.state.answers.map((a) => a.cardId).contains(card.id));
        final bool isAnswered = index <= _controller.sessionCubit.currentCardIndex;

        return LayoutBuilder(
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
                    Expanded(
                      flex: 3,
                      child: AppSvgWidget(
                        svgString: card.svgIconString,
                        size: Size.fromRadius(constraints.maxHeight * 0.125),
                        color: isAnswered ? AppColor.primary : AppColor.diableGrey,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Text(
                          'Pattern\n$number',
                          textAlign: TextAlign.center,
                          style: context.bodyMedium.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            height: 1.1,
                            color: isAnswered ? AppColor.textBase : AppColor.diableGrey,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
