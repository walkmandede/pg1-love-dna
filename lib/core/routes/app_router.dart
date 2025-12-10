import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pg1/core/models/card_model.dart';
import 'package:pg1/core/routes/app_routes.dart';
import 'package:pg1/core/shared/type_defs/type_defs.dart';
import 'package:pg1/core/states/session/cubit/session_cubit.dart';
import 'package:pg1/features/celebration/celebration_page.dart';
import 'package:pg1/features/engine_test/engine_test_page.dart';
import 'package:pg1/features/how_work/how_work_page.dart';
import 'package:pg1/features/inputs/inputs_page.dart';
import 'package:pg1/features/lens/interpretation_len/interpretation_len_page.dart';
import 'package:pg1/features/love_library/love_library_page.dart';
import 'package:pg1/features/onboarding/onboarding_page.dart';
import 'package:pg1/features/pattern_card/pattern_card_page.dart';
import 'package:pg1/features/lens/self_view_len/self_view_len_page.dart';
import 'package:pg1/features/why_these_moment/why_these_moment_page.dart';

class AppRouter {
  static final router = GoRouter(
    // initialLocation: AppRoutes.onboarding.path,
    initialLocation: AppRoutes.engineTest.path,
    redirect: (context, state) {
      if (state.matchedLocation == AppRoutes.results.path) {
        try {
          final bloc = context.read<SessionCubit>();
          if (bloc.state.result == null) {
            return AppRoutes.onboarding.path;
          }
        } catch (_) {
          return AppRoutes.onboarding.path;
        }
      }
      return null;
    },
    routes: [
      GoRoute(
        name: AppRoutes.onboarding.name,
        path: AppRoutes.onboarding.path,
        builder: (context, state) {
          return OnboardingPage();
        },
      ),
      GoRoute(
        name: AppRoutes.howWork.name,
        path: AppRoutes.howWork.path,
        builder: (context, state) {
          return HowWorkPage();
        },
      ),
      GoRoute(
        name: AppRoutes.inputs.name,
        path: AppRoutes.inputs.path,
        builder: (context, state) {
          return InputsPage();
        },
      ),
      GoRoute(
        name: AppRoutes.whyTheseMoment.name,
        path: AppRoutes.whyTheseMoment.path,
        builder: (context, state) {
          return WhyTheseMomentPage();
        },
      ),
      GoRoute(
        name: AppRoutes.loveLibrary.name,
        path: AppRoutes.loveLibrary.path,
        builder: (context, state) {
          return LoveLibraryPage();
        },
      ),
      GoRoute(
        name: AppRoutes.patternCard.name,
        path: AppRoutes.patternCard.path,
        builder: (context, state) {
          final card = state.extra as CardModel;
          return PatternCardPage(card: card);
        },
      ),
      GoRoute(
        name: AppRoutes.celebration.name,
        path: AppRoutes.celebration.path,
        builder: (context, state) {
          return CelebrationPage();
        },
      ),
      GoRoute(
        name: AppRoutes.engineTest.name,
        path: AppRoutes.engineTest.path,
        builder: (context, state) {
          return EngineTestPage();
        },
      ),
      GoRoute(
        name: AppRoutes.interpretationLen.name,
        path: AppRoutes.interpretationLen.path,
        builder: (context, state) {
          final meta = state.extra as LenPageMeta;
          return InterpretationLenPage(
            cardModel: meta.cardModel,
            cardAnswer: meta.cardAnswer,
            patternInsight: meta.patternInsight,
          );
        },
      ),
      GoRoute(
        name: AppRoutes.selfViewLen.name,
        path: AppRoutes.selfViewLen.path,
        builder: (context, state) {
          final meta = state.extra as LenPageMeta;
          return SelfViewLenPage(
            cardModel: meta.cardModel,
            cardAnswer: meta.cardAnswer,
            patternInsight: meta.patternInsight,
          );
        },
      ),
    ],
  );
}
