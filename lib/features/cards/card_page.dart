import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pg1/core/routes/app_routes.dart';
import 'package:pg1/core/states/session/bloc/session_bloc.dart';
import 'package:pg1/core/states/session/bloc/session_event.dart';
import 'package:pg1/core/states/session/bloc/session_state.dart';
import 'package:pg1/features/cards/widgets/option_tile.dart';
import 'package:pg1/features/cards/widgets/progress_handler.dart';

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
                ProgressHeader(state: state),

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
                            (b) => OptionTile(
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
                            (i) => OptionTile(
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
