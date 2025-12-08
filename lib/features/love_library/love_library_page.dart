// ignore_for_file: deprecated_member_use

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pg1/core/models/card_model.dart';
import 'package:pg1/core/shared/assets/app_svgs.dart';
import 'package:pg1/core/shared/constants/app_constants.dart';
import 'package:pg1/core/shared/enums/pattern_card_state_enum.dart';
import 'package:pg1/core/shared/extensions/build_context_extension.dart';
import 'package:pg1/core/shared/extensions/card_model_extension.dart';
import 'package:pg1/core/shared/extensions/num_extension.dart';
import 'package:pg1/core/shared/theme/app_color.dart';
import 'package:pg1/core/shared/theme/app_text_styles.dart';
import 'package:pg1/core/shared/widgets/app_button.dart';
import 'package:pg1/core/shared/widgets/app_loading_widget.dart';
import 'package:pg1/core/shared/widgets/app_responsive_builder.dart';
import 'package:pg1/core/shared/widgets/app_svg_widget.dart';
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
            return AppResponsiveBuilder(
              verticalBuilder: (isVertical) {
                return Center(
                  child: SizedBox(
                    width: min(context.screenWidth, kStandardMaxWidthForPortraitOrientation - kBasePaddingM),
                    child: _body(),
                  ),
                );
              },
            );
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
    final int number = index + 1;
    final int current = _controller.sessionCubit.currentCardIndex;

    // Determine state
    final isLocked = index > current;
    final isCurrent = index == current;
    final isCompleted = index < current;

    return Expanded(
      child: AspectRatio(
        aspectRatio: 1,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final size = constraints.maxHeight;

            return GestureDetector(
              onTap: isLocked ? null : () => _controller.onEachCardPressed(context, card, index),
              child: AnimatedScale(
                scale: isCurrent ? 1.05 : 1.0,
                duration: const Duration(milliseconds: 200),
                child: Card(
                  elevation: isLocked ? 0 : 4,
                  shadowColor: AppColor.backgroundGrey.withAlpha(25),
                  color: AppColor.backgroundSecondary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: isLocked ? AppColor.diableGrey : AppColor.primary,
                      width: isCurrent ? 2.5 : 1.8,
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Main content
                      Center(
                        child: Padding(
                          padding: EdgeInsets.all(constraints.maxHeight * 0.06),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Opacity(
                                opacity: isLocked ? 0.4 : 1.0,
                                child: AppSvgWidget(
                                  svgString: card.svgIconString,
                                  size: Size.fromRadius(size * 0.125),
                                  color: isLocked ? AppColor.diableGrey : AppColor.primary,
                                ),
                              ),

                              (size * 0.1).toInt().heightGap,

                              Text(
                                'Pattern\n$number',
                                textAlign: TextAlign.center,
                                style: AppTextStyles.bodyTextSmall.copyWith(
                                  fontWeight: FontWeight.w700,
                                  height: 1.1,
                                  color: isLocked ? AppColor.diableGrey : AppColor.textBase,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Lock icon (Locked state)
                      if (isLocked)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: AppSvgWidget(
                            svgString: AppSvgs.locked,
                            size: Size(size * 0.13, size * 0.13),
                            color: AppColor.diableGrey.withOpacity(0.7),
                          ),
                        ),

                      // Checkmark (Completed state)
                      if (isCompleted)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: AppSvgWidget(
                            svgString: AppSvgs.answred,
                            size: Size(size * 0.13, size * 0.13),
                            color: AppColor.primary.withOpacity(0.7),
                          ),
                        ),

                      // Pulse animation overlay (Current)
                      if (isCurrent)
                        Positioned.fill(
                          child: IgnorePointer(
                            child: AnimatedOpacity(
                              duration: const Duration(milliseconds: 600),
                              opacity: 0.15,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 12,
                                      spreadRadius: 4,
                                      color: AppColor.primary,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
