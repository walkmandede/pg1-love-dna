import 'package:equatable/equatable.dart';

class CardAnswer extends Equatable {
  final String cardId;
  final String behaviourId;
  final String interpretationId;

  const CardAnswer({required this.cardId, required this.behaviourId, required this.interpretationId});

  Map<String, dynamic> toJson() {
    return {'card_id': cardId, 'behaviour_id': behaviourId, 'interpretation_id': interpretationId};
  }

  @override
  List<Object?> get props => [cardId, behaviourId, interpretationId];
}

class BehaviourMapping extends Equatable {
  final List<int> ei;

  const BehaviourMapping({required this.ei});

  factory BehaviourMapping.fromJson(Map<String, dynamic> json) {
    return BehaviourMapping(ei: (json['ei'] as List).map((e) => e as int).toList());
  }

  @override
  List<Object?> get props => [ei];
}

/// Stores CI deltas and meaning tags for an interpretation option
class InterpretationMapping extends Equatable {
  final List<int> ci;
  final List<String> tags;

  const InterpretationMapping({required this.ci, required this.tags});

  factory InterpretationMapping.fromJson(Map<String, dynamic> json) {
    return InterpretationMapping(ci: (json['ci'] as List).map((e) => e as int).toList(), tags: (json['tags'] as List).map((e) => e as String).toList());
  }

  @override
  List<Object?> get props => [ci, tags];
}
