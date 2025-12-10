import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pg1/core/models/card_model.dart';
import 'package:pg1/core/models/card_answer_model.dart';
import 'package:pg1/core/models/pattern_insight.dart';
import 'package:pg1/core/shared/assets/app_svgs.dart';
import 'package:pg1/core/shared/constants/app_constants.dart';
import 'package:pg1/core/shared/extensions/build_context_extension.dart';
import 'package:pg1/core/shared/extensions/num_extension.dart';
import 'package:pg1/core/shared/theme/app_color.dart';
import 'package:pg1/core/shared/theme/app_text_styles.dart';
import 'package:pg1/core/shared/widgets/app_button.dart';
import 'package:pg1/core/shared/widgets/app_responsive_builder.dart';
import 'package:pg1/core/shared/widgets/app_svg_widget.dart';
import 'package:pg1/core/shared/widgets/disclosure_message_widget.dart';

class SelfViewLenPage extends StatefulWidget {
  final CardModel cardModel;
  final CardAnswerModel cardAnswer;
  final PatternInsight patternInsight;

  const SelfViewLenPage({
    super.key,
    required this.cardModel,
    required this.cardAnswer,
    required this.patternInsight,
  });

  @override
  State<SelfViewLenPage> createState() => _SelfViewLenPageState();
}

class _SelfViewLenPageState extends State<SelfViewLenPage> {
  CardModel get _cardModel => widget.cardModel;
  CardAnswerModel get _cardAnswer => widget.cardAnswer;
  PatternInsight get _patternInsight => widget.patternInsight;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppResponsiveBuilder(
        verticalBuilder: (isVertical) {
          return Center(
            child: SizedBox(
              width: min(context.screenWidth, kStandardMaxWidthForPortraitOrientation * 0.9),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: kBasePaddingM,
                  vertical: kBasePaddingM,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Align(
                        alignment: AlignmentGeometry.centerLeft,
                        child: BackButton(),
                      ),
                      (context.screenHeight * 0.05).heightGap,
                      AppSvgWidget(
                        svgString: AppSvgs.pattern,
                        color: AppColor.white,
                        hasBgCircle: true,
                      ),
                      16.heightGap,
                      Text(
                        '${_cardModel.contentRoutePatternId} Identified',
                        style: AppTextStyles.cardTitle,
                        textAlign: TextAlign.center,
                      ),
                      8.heightGap,
                      Text(
                        _patternInsight.title,
                        style: AppTextStyles.cardTitle,
                        textAlign: TextAlign.center,
                      ),
                      24.heightGap,
                      Text(
                        _patternInsight.coreMeaning,
                        style: AppTextStyles.subtitle,
                        textAlign: TextAlign.center,
                      ),
                      8.heightGap,
                      Text(
                        _patternInsight.subtitle,
                        style: AppTextStyles.subtitleMedium,
                        textAlign: TextAlign.center,
                      ),
                      24.heightGap,
                      _insightCard(),
                      16.heightGap,
                      if (_patternInsight.traits.isNotEmpty) _traits(),
                      (context.screenHeight * 0.05).heightGap,
                      AppButton(
                        onPressed: () {
                          context.pop();
                        },
                        label: 'Continue',
                      ),
                      16.heightGap,
                      DisclosureMessageWidget(),
                      16.heightGap,
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _insightCard() {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: kBasePaddingM,
            vertical: kBasePaddingM,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Insight',
                style: AppTextStyles.insightHeading,
              ),
              8.heightGap,
              Text(
                _patternInsight.insight,
                style: AppTextStyles.insightBody,
              ),

              8.heightGap,
              ..._patternInsight.bullets.map(
                (b) => Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 6,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 4,
                        backgroundColor: AppColor.primary,
                      ),
                      16.widthGap,
                      Expanded(
                        child: Text(
                          b,
                          style: AppTextStyles.bulletPoint.copyWith(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _traits() {
    return Column(
      children: _patternInsight.traits.map((t) {
        return Card(
          elevation: 0,
          color: AppColor.backgroundSecondary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2000)),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: kBasePaddingM,
              vertical: kBasePaddingS * 1.5,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                AppSvgWidget(
                  svgString: t.svgPath,
                  size: Size(12, 12),
                ),
                8.widthGap,
                Text(
                  t.label,
                  style: AppTextStyles.bulletPoint,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
