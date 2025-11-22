import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pg1/core/routes/app_routes.dart';
import 'package:pg1/core/states/session/bloc/session_bloc.dart';
import 'package:pg1/core/states/session/bloc/session_state.dart';
import 'package:pg1/features/onboarding/widgets/info_chip.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<SessionBloc, SessionState>(
        listenWhen: (prev, curr) => prev.status != curr.status,
        listener: (context, state) {
          if (state.status == SessionStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.errorMessage ?? 'An error occurred')));
          }
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const Spacer(flex: 2),

                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryContainer, shape: BoxShape.circle),
                  child: Icon(Icons.favorite_rounded, size: 60, color: Theme.of(context).colorScheme.primary),
                ),

                const SizedBox(height: 40),

                Text(
                  'Discover Your\nLove DNA',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
                ),

                const SizedBox(height: 16),

                Text(
                  'Answer 12 simple scenarios to understand\nhow you connect in relationships.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                ),

                const SizedBox(height: 24),

                Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: [
                    InfoChip(icon: Icons.timer_outlined, label: '5 minutes'),
                    InfoChip(icon: Icons.psychology_outlined, label: '12 cards'),
                    InfoChip(icon: Icons.lock_outline, label: 'Private'),
                  ],
                ),

                const Spacer(flex: 3),

                BlocBuilder<SessionBloc, SessionState>(
                  builder: (context, state) {
                    final isLoading = state.status == SessionStatus.loading;
                    final isReady = state.status == SessionStatus.ready;

                    return SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: FilledButton(
                        onPressed: isReady ? () => context.go(AppRoutes.cards.path) : null,
                        child: isLoading
                            ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                            : const Text('Begin', style: TextStyle(fontSize: 18)),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 16),

                Text(
                  'Your responses are stored anonymously.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.outline),
                ),

                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
