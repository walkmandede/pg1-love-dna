// love_code_result.dart
import 'package:equatable/equatable.dart';

/// The main output object from TWLVE assessment
class LoveCodeResult extends Equatable {
  final DateTime timestamp;
  final String weightsVersion;
  final String centroidVersion;
  final List<double> eiVector;
  final List<double> ciVector;
  final DerivedMetrics derivedMetrics;
  final TypeAssignment typeAssignment;
  final List<String> meaningTags;
  final String narrativeText;

  const LoveCodeResult({
    required this.timestamp,
    required this.weightsVersion,
    required this.centroidVersion,
    required this.eiVector,
    required this.ciVector,
    required this.derivedMetrics,
    required this.typeAssignment,
    required this.meaningTags,
    required this.narrativeText,
  });

  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp.toIso8601String(),
      'weights_version': weightsVersion,
      'centroid_version': centroidVersion,
      'ei_vector': eiVector,
      'ci_vector': ciVector,
      'derived_metrics': derivedMetrics.toJson(),
      'type_assignment': typeAssignment.toJson(),
      'meaning_tags': meaningTags,
      'narrative_text': narrativeText,
    };
  }

  @override
  List<Object?> get props => [
    timestamp,
    weightsVersion,
    centroidVersion,
    eiVector,
    ciVector,
    derivedMetrics,
    typeAssignment,
    meaningTags,
    narrativeText,
  ];
}

/// Derived metrics computed from EI and CI vectors
class DerivedMetrics extends Equatable {
  final double eiIntensity;
  final double ciIntensity;
  final double balance;
  final double clarity;

  const DerivedMetrics({
    required this.eiIntensity,
    required this.ciIntensity,
    required this.balance,
    required this.clarity,
  });

  Map<String, dynamic> toJson() {
    return {
      'ei_intensity': eiIntensity,
      'ci_intensity': ciIntensity,
      'balance': balance,
      'clarity': clarity,
    };
  }

  @override
  List<Object?> get props => [eiIntensity, ciIntensity, balance, clarity];
}

/// Type assignment result
class TypeAssignment extends Equatable {
  final String typeCode;
  final double distance;
  final int rank;

  const TypeAssignment({
    required this.typeCode,
    required this.distance,
    required this.rank,
  });

  Map<String, dynamic> toJson() {
    return {
      'type_code': typeCode,
      'distance': distance,
      'rank': rank,
    };
  }

  @override
  List<Object?> get props => [typeCode, distance, rank];
}

/// Weight lookup entry from CSV
class WeightEntry extends Equatable {
  final int cardNumber;
  final String elementType; // 'behaviour' or 'interpretation'
  final String optionId;
  final List<double> deltas; // 9 trait deltas
  final List<String> meaningTags; // only for interpretation

  const WeightEntry({
    required this.cardNumber,
    required this.elementType,
    required this.optionId,
    required this.deltas,
    required this.meaningTags,
  });

  @override
  List<Object?> get props => [cardNumber, elementType, optionId, deltas, meaningTags];
}

/// Type centroid definition
class TypeCentroid extends Equatable {
  final String typeCode;
  final List<double> vector; // 9 trait values

  const TypeCentroid({
    required this.typeCode,
    required this.vector,
  });

  @override
  List<Object?> get props => [typeCode, vector];
}
