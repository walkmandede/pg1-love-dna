import 'package:go_router/go_router.dart';
import 'package:pg1/features/cards/card_page.dart';
import 'package:pg1/features/onboarding/onboarding_page.dart';
import 'package:pg1/features/results/result_page.dart';

class AppRouter {
  static const String onboarding = '/';
  static const String cards = '/cards';
  static const String results = '/results';

  static final GoRouter router = GoRouter(
    initialLocation: onboarding,
    redirect: (context, state) {
      //to handle route guard
      return null;
    },
    routes: [
      GoRoute(path: onboarding, builder: (context, state) => const OnboardingPage()),
      GoRoute(path: cards, builder: (context, state) => const CardPage()),
      GoRoute(path: results, builder: (context, state) => const ResultPage()),
    ],
  );
}
