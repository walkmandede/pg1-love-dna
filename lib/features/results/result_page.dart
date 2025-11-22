import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pg1/core/routes/app_routes.dart';
import 'package:pg1/core/states/session/bloc/session_bloc.dart';
import 'package:pg1/core/states/session/bloc/session_event.dart';
import 'package:pg1/core/states/session/bloc/session_state.dart';

class ResultPage extends StatelessWidget {
  const ResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<SessionBloc, SessionState>(
        builder: (context, state) {
          final result = state.result;

          if (result == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final bloc = context.read<SessionBloc>();
          final narrative = bloc.getNarrative(result.types.primary);

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Center(
                    child: Column(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryContainer, shape: BoxShape.circle),
                          child: Icon(Icons.auto_awesome, size: 40, color: Theme.of(context).colorScheme.primary),
                        ),
                        const SizedBox(height: 16),
                        Text('Your Love DNA', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Primary type
                  _TypeCard(
                    label: 'Primary Type',
                    typeName: narrative?['title'] ?? result.types.primary,
                    description: narrative?['short'] ?? '',
                    color: Theme.of(context).colorScheme.primary,
                  ),

                  const SizedBox(height: 16),

                  // Stabiliser and Growth
                  Row(
                    children: [
                      Expanded(
                        child: _SmallTypeCard(label: 'Stabiliser', typeName: result.types.stabiliser, icon: Icons.balance),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _SmallTypeCard(label: 'Growth', typeName: result.types.growth, icon: Icons.trending_up),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Metrics section
                  Text('Your Metrics', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),

                  _MetricRow(label: 'Trust Score', value: result.derivedMetrics.trustScore.toString(), icon: Icons.handshake_outlined),
                  _MetricRow(label: 'Contradiction Index', value: result.derivedMetrics.contradictionIndex, icon: Icons.compare_arrows),
                  _MetricRow(label: 'Stability Outlook', value: result.derivedMetrics.stabilityOutlook, icon: Icons.insights),

                  const SizedBox(height: 24),

                  // Meaning tags
                  Text('Your Values', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: result.meaningTags
                        .map((tag) => Chip(label: Text(tag), backgroundColor: Theme.of(context).colorScheme.secondaryContainer))
                        .toList(),
                  ),

                  const SizedBox(height: 32),

                  // Full narrative
                  if (narrative?['long'] != null) ...[
                    Text('About You', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Text(narrative!['long']!, style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.6)),
                  ],

                  const SizedBox(height: 32),

                  // Restart button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: OutlinedButton(
                      onPressed: () {
                        context.read<SessionBloc>().add(const SessionReset());
                        context.go(AppRoutes.onboarding.path);
                      },
                      child: const Text('Start Again'),
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _TypeCard extends StatelessWidget {
  final String label;
  final String typeName;
  final String description;
  final Color color;

  const _TypeCard({required this.label, required this.typeName, required this.description, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: color, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            typeName,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
          ),
          if (description.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(description, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
          ],
        ],
      ),
    );
  }
}

class _SmallTypeCard extends StatelessWidget {
  final String label;
  final String typeName;
  final IconData icon;

  const _SmallTypeCard({required this.label, required this.typeName, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainerHighest, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 8),
          Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
          const SizedBox(height: 4),
          Text(typeName, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _MetricRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _MetricRow({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: Theme.of(context).textTheme.bodyMedium)),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
          ),
        ],
      ),
    );
  }
}
