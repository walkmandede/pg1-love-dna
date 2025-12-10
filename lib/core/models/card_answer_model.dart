// card_answer_model.dart (Updated version)
import 'package:equatable/equatable.dart';

/// User's answer for a single card
// ignore: must_be_immutable
class CardAnswerModel extends Equatable {
  final String cardId;
  String behaviourId; // A, B, C, or D
  String interpretationId; // 1, 2, 3, or 4

  CardAnswerModel({
    required this.cardId,
    required this.behaviourId,
    required this.interpretationId,
  });

  factory CardAnswerModel.fromJson(Map<String, dynamic> json) {
    return CardAnswerModel(
      cardId: json['card_id'] as String,
      behaviourId: json['behaviour_id'] as String,
      interpretationId: json['interpretation_id'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'card_id': cardId,
      'behaviour_id': behaviourId,
      'interpretation_id': interpretationId,
    };
  }

  @override
  List<Object?> get props => [cardId, behaviourId, interpretationId];
}

// Optional: Keep these if you need them for UI mapping
// but they're not used by the scoring engine
class BehaviourMapping extends Equatable {
  final List<int> ei;

  const BehaviourMapping({required this.ei});

  factory BehaviourMapping.fromJson(Map<String, dynamic> json) {
    return BehaviourMapping(
      ei: (json['ei'] as List).map((e) => e as int).toList(),
    );
  }

  @override
  List<Object?> get props => [ei];
}

class InterpretationMapping extends Equatable {
  final List<int> ci;
  final List<String> tags;

  const InterpretationMapping({required this.ci, required this.tags});

  factory InterpretationMapping.fromJson(Map<String, dynamic> json) {
    return InterpretationMapping(
      ci: (json['ci'] as List).map((e) => e as int).toList(),
      tags: (json['tags'] as List).map((e) => e as String).toList(),
    );
  }

  @override
  List<Object?> get props => [ci, tags];
}
