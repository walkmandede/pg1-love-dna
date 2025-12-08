import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pg1/core/shared/commons/app_controller.dart';
import 'package:pg1/core/states/session/cubit/session_cubit.dart';

class OnboardingPageController extends AppPageController {
  ValueNotifier<bool> isLoaded = ValueNotifier(false);

  @override
  Future<void> initLoad(BuildContext context) async {
    final sessionCubit = context.read<SessionCubit>();
    await sessionCubit.startSession();
    await Future.delayed(const Duration(milliseconds: 100));
    isLoaded.value = true;
  }

  @override
  Future<void> dispose() async {}
}
