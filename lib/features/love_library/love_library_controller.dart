import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pg1/core/models/card_model.dart';
import 'package:pg1/core/routes/app_routes.dart';
import 'package:pg1/core/shared/commons/app_controller.dart';
import 'package:pg1/core/shared/type_defs/type_defs.dart';
import 'package:pg1/core/states/session/cubit/session_cubit.dart';

class LoveLibraryController extends AppPageController {
  late SessionCubit sessionCubit;

  ValueNotifier<bool> isInitLoading = ValueNotifier(true);

  @override
  Future<void> dispose() async {}

  @override
  Future<void> initLoad(BuildContext context) async {
    isInitLoading.value = true;
    sessionCubit = context.read<SessionCubit>();
    isInitLoading.value = false;
  }

  void onBeginCardPressed(BuildContext context) async {
    final int currentCardIndex = sessionCubit.state.answers.length;
    if (currentCardIndex < 12) {
      final card = sessionCubit.state.cards[currentCardIndex];
      context.pushNamed(AppRoutes.patternCard.name, extra: card);
    } else {}
  }

  void onEachCardPressed(BuildContext context, CardModel card, int index) async {
    final cardAnswer = sessionCubit.state.answers.where((a) => a.cardId == card.id).firstOrNull;
    final selfViewPattern = sessionCubit.getPatternInsightForScoring(card.contentRoutePatternId);
    if (cardAnswer != null && selfViewPattern != null) {
      final LenPageMeta lenPageMeta = (cardModel: card, cardAnswer: cardAnswer, patternInsight: selfViewPattern);
      context.pushNamed(AppRoutes.selfViewLen.name, extra: lenPageMeta);
    }
  }
}
