import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pg1/core/routes/app_routes.dart';
import 'package:pg1/core/shared/commons/app_controller.dart';
import 'package:pg1/core/states/session/cubit/session_cubit.dart';

class LoveLibraryController extends AppPageController {
  late SessionCubit sessionCubit;

  ValueNotifier<bool> isInitLoading = ValueNotifier(true);

  @override
  Future<void> dispose() async {}

  @override
  Future<void> initLoad(BuildContext context) async {
    sessionCubit = context.read<SessionCubit>();
    isInitLoading.value = false;
  }

  void onBeginCardPressed(BuildContext context) async {
    final int lastAnsweredIndex = sessionCubit.state.answers.length;
    final card = sessionCubit.state.cards[lastAnsweredIndex];

    context.pushNamed(AppRoutes.patternCard.name, extra: card);
  }
}
