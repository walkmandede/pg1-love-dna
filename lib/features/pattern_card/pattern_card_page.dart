import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pg1/core/models/card_model.dart';
import 'package:pg1/core/routes/app_routes.dart';
import 'package:pg1/core/shared/constants/app_constants.dart';
import 'package:pg1/core/shared/extensions/int_extension.dart';
import 'package:pg1/core/shared/theme/app_color.dart';
import 'package:pg1/core/shared/widgets/app_button.dart';
import 'package:pg1/core/shared/widgets/app_progress_bar.dart';
import 'package:pg1/core/shared/widgets/disclosure_message_widget.dart';
import 'package:pg1/core/states/session/cubit/session_cubit.dart';

class PatternCardPage extends StatefulWidget {
  final CardModel card;

  const PatternCardPage({
    super.key,
    required this.card,
  });

  @override
  State<PatternCardPage> createState() => _PatternCardPageState();
}

class _PatternCardPageState extends State<PatternCardPage> {
  CardModel get _card => widget.card;

  Behaviour? _selectedBehaviour;
  Interpretation? _selectedInterpretation;

  SessionCubit get _sessiobCubit => context.read<SessionCubit>();

  int get currentIndex => _sessiobCubit.state.cards.map((c) => c.id).toList().indexOf(_card.id);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

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
                Align(
                  alignment: Alignment.centerLeft,
                  child: InkWell(
                    onTap: () {
                      context.pop();
                    },
                    child: Icon(
                      Icons.arrow_back_ios,
                    ),
                  ),
                ),
                16.heightGap,
                AppProgressBar(label: 'Card', current: currentIndex + 1, total: 12),
                16.heightGap,
                _patternTitle(),
                16.heightGap,
                _scenarioCard(),
                16.heightGap,
                _responds(),
                16.heightGap,
                _reflects(),
                16.heightGap,
                _continueButton(),
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

  Widget _patternTitle() {
    return Center(
      child: Text(
        _card.title,
        style: TextStyle(
          color: AppColor.textBase,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _scenarioCard() {
    return Card(
      margin: EdgeInsets.zero,
      color: AppColor.backgroundSecondary,
      elevation: 0,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: kBasePaddingM,
          vertical: kBasePaddingM,
        ),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              8.heightGap,
              Text(
                'Scenario',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              8.heightGap,
              Text(
                _card.scenario,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              8.heightGap,
            ],
          ),
        ),
      ),
    );
  }

  Widget _responds() {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'How do you usually respond first?',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColor.textSecondary,
            ),
          ),
          16.heightGap,
          ..._card.behaviours.map((b) {
            bool isSelected = _selectedBehaviour == b;
            return Padding(
              padding: EdgeInsets.only(bottom: kBasePaddingS),
              child: SizedBox(
                height: kBaseButtonHeight,
                child: FilledButton(
                  onPressed: () {
                    _selectedBehaviour = b;
                    setState(() {});
                  },
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(12),
                      side: BorderSide(
                        color: isSelected ? AppColor.primary : Colors.transparent,
                      ),
                    ),
                    backgroundColor: AppColor.backgroundSecondary,
                    padding: EdgeInsets.symmetric(
                      horizontal: kBasePaddingM,
                      vertical: kBasePaddingM,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        isSelected ? Icons.circle : Icons.circle_outlined,
                        size: 20,
                        color: isSelected ? AppColor.primary : AppColor.diableGrey,
                      ),
                      16.widthGap,
                      Expanded(
                        child: Text(
                          b.label,
                          style: TextStyle(
                            color: AppColor.textBase,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _reflects() {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'What does this reflect about you?',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColor.textSecondary,
            ),
          ),
          16.heightGap,
          ..._card.interpretations.map((i) {
            bool isSelected = _selectedInterpretation == i;
            return Padding(
              padding: EdgeInsets.only(bottom: kBasePaddingS),
              child: SizedBox(
                height: kBaseButtonHeight,
                child: FilledButton(
                  onPressed: () {
                    _selectedInterpretation = i;
                    setState(() {});
                  },
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(12),
                      side: BorderSide(
                        color: isSelected ? AppColor.primary : Colors.transparent,
                      ),
                    ),
                    backgroundColor: AppColor.backgroundSecondary,
                    padding: EdgeInsets.symmetric(
                      horizontal: kBasePaddingM,
                      vertical: kBasePaddingM,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        isSelected ? Icons.circle : Icons.circle_outlined,
                        size: 20,
                        color: isSelected ? AppColor.primary : AppColor.diableGrey,
                      ),
                      16.widthGap,
                      Expanded(
                        child: Text(
                          i.label,
                          style: TextStyle(
                            color: AppColor.textBase,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _continueButton() {
    bool isValid = _selectedBehaviour != null && _selectedInterpretation != null;
    return AppButton(
      onPressed: () async {
        if (!isValid) {
          return;
        }
        final meta = _sessiobCubit.addAnswer(card: _card, behaviour: _selectedBehaviour!, interpretation: _selectedInterpretation!);
        context.pop();
        context.pushNamed(AppRoutes.interpretationLen.name, extra: meta);
      },
      isDisabled: !isValid,
      width: double.infinity,
      height: kBaseButtonHeight,
      label: 'Continue',
    );
  }
}
