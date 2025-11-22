import 'package:equatable/equatable.dart';
import 'trait_vector.dart';
import 'choice_model.dart';

class TypeAssignment extends Equatable {
  final String primary;
  final String stabiliser;
  final String growth;

  const TypeAssignment({required this.primary, required this.stabiliser, required this.growth});

  Map<String, dynamic> toJson() => {'primary': primary, 'stabiliser': stabiliser, 'growth': growth};

  @override
  List<Object?> get props => [primary, stabiliser, growth];
}

class DerivedMetrics extends Equatable {
  final int trustScore;
  final String contradictionIndex; // "low", "medium", "high"
  final String stabilityOutlook;

  const DerivedMetrics({required this.trustScore, required this.contradictionIndex, required this.stabilityOutlook});

  Map<String, dynamic> toJson() => {'trust_score': trustScore, 'contradiction_index': contradictionIndex, 'stability_outlook': stabilityOutlook};

  @override
  List<Object?> get props => [trustScore, contradictionIndex, stabilityOutlook];
}

class LoveCodeResult extends Equatable {
  final String sessionId;
  final DateTime createdAt;
  final String version;
  final List<CardAnswer> answers;
  final TraitVector eiVector;
  final TraitVector ciVector;
  final TypeAssignment types;
  final DerivedMetrics derivedMetrics;
  final List<String> meaningTags;

  const LoveCodeResult({
    required this.sessionId,
    required this.createdAt,
    required this.version,
    required this.answers,
    required this.eiVector,
    required this.ciVector,
    required this.types,
    required this.derivedMetrics,
    required this.meaningTags,
  });

  Map<String, dynamic> toJson() {
    return {
      'session_id': sessionId,
      'created_at': createdAt.toIso8601String(),
      'version': version,
      'user': {'uid': 'anon', 'platform': 'web', 'locale': 'en-GB'},
      'answers': answers.map((a) => a.toJson()).toList(),
      'emotional_dna': eiVector.toMap(),
      'interpretation_profile': ciVector.toMap(),
      'derived_metrics': derivedMetrics.toJson(),
      'types': types.toJson(),
      'meaning_system': {'tags': meaningTags},
    };
  }

  @override
  List<Object?> get props => [sessionId, createdAt, version, answers, eiVector, ciVector, types, derivedMetrics, meaningTags];
}
