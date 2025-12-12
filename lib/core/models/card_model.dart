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
  final String contentRoutePatternId;
  final String behaviourLensPatternId;
  final String selfViewLensPatternId;
  final String title;
  final String scenario;
  final List<Behaviour> behaviours;
  final List<Interpretation> interpretations;

  const CardModel({
    required this.id,
    required this.contentRoutePatternId,
    required this.behaviourLensPatternId,
    required this.selfViewLensPatternId,
    required this.title,
    required this.scenario,
    required this.behaviours,
    required this.interpretations,
  });

  factory CardModel.fromJson(Map<String, dynamic> json) {
    return CardModel(
      id: json['id'].toString(),
      contentRoutePatternId: json['contentRoutePatternId'].toString(),
      behaviourLensPatternId: json['behaviourLensPatternId'].toString(),
      selfViewLensPatternId: json['selfViewLensPatternId'].toString(),
      title: json['title'].toString(),
      scenario: json['scenario'].toString(),
      behaviours: (json['behaviours'] as List).map((b) => Behaviour.fromJson(b)).toList(),
      interpretations: (json['interpretations'] as List).map((i) => Interpretation.fromJson(i)).toList(),
    );
  }

  String get contentRoutePatternLabel => 'Pattern ${contentRoutePatternId.replaceAll('P', '')}';
  String get behaviourLensPatternLabel => 'Pattern ${behaviourLensPatternId.replaceAll('P', '')}';
  String get selfViewLensPatternLabel => 'Pattern ${selfViewLensPatternId.replaceAll('P', '')}';

  @override
  List<Object?> get props => [id, title, scenario, behaviours, interpretations];
}
