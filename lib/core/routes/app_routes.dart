import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pg1/features/cards/card_page.dart';
import 'package:pg1/features/onboarding/onboarding_page.dart';
import 'package:pg1/features/results/result_page.dart';

enum AppRoutes {
  onboarding(name: 'onboarding', path: '/', page: OnboardingPage()),
  cards(name: 'cards', path: '/cards', page: CardPage()),
  results(name: 'results', path: '/results', page: ResultPage());

  final String name;
  final String path;
  final Widget page;
  const AppRoutes({required this.name, required this.path, required this.page});
}

class AppRouter {
  static final router = GoRouter(
    initialLocation: AppRoutes.onboarding.path,
    redirect: (context, state) {
      return null;
    },
    routes: AppRoutes.values.map((r) => GoRoute(path: r.path, name: r.name, builder: (context, state) => r.page)).toList(),
  );
}
