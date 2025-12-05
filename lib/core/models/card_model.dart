import 'package:equatable/equatable.dart';

class Behaviour extends Equatable {
  final String id;
  final String label;

  const Behaviour({required this.id, required this.label});

  factory Behaviour.fromJson(Map<String, dynamic> json) {
    return Behaviour(id: json['id'] as String, label: json['label'] as String);
  }

  @override
  List<Object?> get props => [id, label];
}

class Interpretation extends Equatable {
  final String id;
  final String label;

  const Interpretation({required this.id, required this.label});

  factory Interpretation.fromJson(Map<String, dynamic> json) {
    return Interpretation(id: json['id'] as String, label: json['label'] as String);
  }

  @override
  List<Object?> get props => [id, label];
}

class CardModel extends Equatable {
  final String id;
  final String patternInsightId;
  final String title;
  final String scenario;
  final List<Behaviour> behaviours;
  final List<Interpretation> interpretations;

  const CardModel({
    required this.id,
    required this.patternInsightId,
    required this.title,
    required this.scenario,
    required this.behaviours,
    required this.interpretations,
  });

  factory CardModel.fromJson(Map<String, dynamic> json) {
    return CardModel(
      id: json['id'] as String,
      patternInsightId: json['patternInsightId'] as String,
      title: json['title'] as String,
      scenario: json['scenario'] as String,
      behaviours: (json['behaviours'] as List).map((b) => Behaviour.fromJson(b)).toList(),
      interpretations: (json['interpretations'] as List).map((i) => Interpretation.fromJson(i)).toList(),
    );
  }

  String get patternLabel => 'Pattern ${patternInsightId.replaceAll('P', '')}';

  @override
  List<Object?> get props => [id, title, scenario, behaviours, interpretations];
}
