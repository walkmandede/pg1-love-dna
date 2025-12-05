import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pg1/core/routes/app_routes.dart';
import 'package:pg1/core/shared/commons/app_controller.dart';
import 'package:pg1/core/states/session/cubit/session_cubit.dart';

class SplashPageController extends AppPageController {
  ValueNotifier<bool> isLoaded = ValueNotifier(false);

  @override
  Future<void> initLoad(BuildContext context) async {
    final sessionCubit = context.read<SessionCubit>();
    await sessionCubit.startSession();
    await Future.delayed(const Duration(seconds: 2));
    isLoaded.value = true;
    if (context.mounted) {
      context.pushNamed(AppRoutes.onboarding.name);
    }
  }

  @override
  Future<void> dispose() async {}
}
