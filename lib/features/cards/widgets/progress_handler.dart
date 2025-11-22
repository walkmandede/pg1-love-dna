import 'package:flutter/material.dart';
import 'package:pg1/core/states/session/bloc/session_state.dart';

class ProgressHeader extends StatelessWidget {
  final SessionState state;

  const ProgressHeader({super.key, required this.state});

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
