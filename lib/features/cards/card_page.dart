import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pg1/core/routes/app_routes.dart';
import 'package:pg1/core/states/session/bloc/session_bloc.dart';
import 'package:pg1/core/states/session/bloc/session_event.dart';
import 'package:pg1/core/states/session/bloc/session_state.dart';

class CardPage extends StatelessWidget {
  const CardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<SessionBloc, SessionState>(
        listenWhen: (prev, curr) => prev.status != curr.status,
        listener: (context, state) {
          if (state.status == SessionStatus.completed) {
            context.go(AppRoutes.results.path);
          } else if (state.status == SessionStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.errorMessage ?? 'An error occurred')));
          }
        },
        builder: (context, state) {
          final card = state.currentCard;
          if (card == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return SafeArea(
            child: Column(
              children: [
                _ProgressHeader(state: state),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          card.title,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
                        ),

                        const SizedBox(height: 16),

                        Text(card.scenario, style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5)),

                        const SizedBox(height: 32),

                        Text(
                          state.currentPhase == CardPhase.behaviour ? 'How do you respond?' : 'What do you think?',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                        ),

                        const SizedBox(height: 16),

                        if (state.currentPhase == CardPhase.behaviour)
                          ...card.behaviours.map(
                            (b) => _OptionTile(
                              id: b.id,
                              label: b.label,
                              isSelected: state.selectedBehaviourId == b.id,
                              onTap: () {
                                context.read<SessionBloc>().add(BehaviourSelected(cardId: card.id, behaviourId: b.id));
                              },
                            ),
                          )
                        else
                          ...card.interpretations.map(
                            (i) => _OptionTile(
                              id: i.id,
                              label: i.label,
                              isSelected: false,
                              onTap: () {
                                context.read<SessionBloc>().add(InterpretationSelected(cardId: card.id, interpretationId: i.id));
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ProgressHeader extends StatelessWidget {
  final SessionState state;

  const _ProgressHeader({required this.state});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Card ${state.cardNumber} of ${state.totalCards}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
              Text(
                state.currentPhase == CardPhase.behaviour ? 'Step 1/2' : 'Step 2/2',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.outline),
              ),
            ],
          ),

          const SizedBox(height: 8),

          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(value: state.progress, minHeight: 6, backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest),
          ),
        ],
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  final String id;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _OptionTile({required this.id, required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: isSelected ? Theme.of(context).colorScheme.primaryContainer : Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: isSelected ? Theme.of(context).colorScheme.primary : Colors.transparent, width: 2),
            ),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.surfaceContainerHighest,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      id,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Text(label, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
