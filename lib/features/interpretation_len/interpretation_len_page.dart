import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pg1/core/models/card_model.dart';
import 'package:pg1/core/models/choice_model.dart';
import 'package:pg1/core/models/love_code_result.dart';
import 'package:pg1/core/models/pattern-insight.dart';
import 'package:pg1/core/shared/constants/app_constants.dart';
import 'package:pg1/core/shared/extensions/build_context_extension.dart';
import 'package:pg1/core/shared/extensions/card_model_extension.dart';
import 'package:pg1/core/shared/extensions/int_extension.dart';
import 'package:pg1/core/shared/theme/app_color.dart';
import 'package:pg1/core/shared/theme/app_text_styles.dart';
import 'package:pg1/core/shared/widgets/app_button.dart';
import 'package:pg1/core/shared/widgets/app_svg_widget.dart';
import 'package:pg1/core/shared/widgets/disclosure_message_widget.dart';

class InterpretationLenPage extends StatefulWidget {
  final CardModel cardModel;
  final CardAnswer cardAnswer;
  final PatternInsight patternInsight;

  const InterpretationLenPage({
    super.key,
    required this.cardModel,
    required this.cardAnswer,
    required this.patternInsight,
  });

  @override
  State<InterpretationLenPage> createState() => _InterpretationLenPageState();
}

class _InterpretationLenPageState extends State<InterpretationLenPage> {
  CardModel get _cardModel => widget.cardModel;
  CardAnswer get _cardAnswer => widget.cardAnswer;
  PatternInsight get _patternInsight => widget.patternInsight;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: kBasePaddingM,
            vertical: kBasePaddingM,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                16.heightGap,
                AppSvgWidget(
                  svgString: _cardModel.svgIconString,
                  color: AppColor.white,
                  hasBgCircle: true,
                ),
                16.heightGap,
                Text(
                  '${_cardModel.patternLabel} Identified',
                  style: AppTextStyles.cardTitle,
                  textAlign: TextAlign.center,
                ),
                16.heightGap,
                Text(
                  _patternInsight.subtitle,
                  style: AppTextStyles.patternCardLabel,
                  textAlign: TextAlign.center,
                ),
                16.heightGap,
                _insightCard(),
                16.heightGap,
                if (_patternInsight.traits.isNotEmpty) _traits(),
                if (_patternInsight.traits.isNotEmpty) 16.heightGap,
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
                _patternInsight.subtitle,
                style: AppTextStyles.insightBody,
              ),

              8.heightGap,
              ..._patternInsight.bullets.map(
                (b) => Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: kBasePaddingS,
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
                  size: Size(16, 16),
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
