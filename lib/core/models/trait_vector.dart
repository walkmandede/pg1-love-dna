import 'dart:math';
import 'package:equatable/equatable.dart';

class TraitVector extends Equatable {
  final List<int> values;

  static const List<String> traitNames = [
    'emotional_regulation',
    'stability_consistency',
    'sensitivity_attunement',
    'boundaries_autonomy',
    'vulnerability_openness',
    'avoidance_withdrawal',
    'pursuit_anxiety',
    'conflict_approach',
    'spontaneity_flexibility',
  ];

  const TraitVector(this.values) : assert(values.length == 9);

  factory TraitVector.zero() => TraitVector([0, 0, 0, 0, 0, 0, 0, 0, 0]);

  factory TraitVector.fromJson(List<dynamic> json) {
    return TraitVector(json.map((e) => e as int).toList());
  }

  // Add two vectors
  TraitVector operator +(TraitVector other) {
    return TraitVector([for (int i = 0; i < 9; i++) values[i] + other.values[i]]);
  }

  // Subtract two vectors
  TraitVector operator -(TraitVector other) {
    return TraitVector([for (int i = 0; i < 9; i++) values[i] - other.values[i]]);
  }

  // Sum of all values
  int get sum => values.reduce((a, b) => a + b);

  // Euclidean distance to another vector
  double distanceTo(TraitVector other) {
    double sumSquares = 0;
    for (int i = 0; i < 9; i++) {
      sumSquares += pow(values[i] - other.values[i], 2);
    }
    return sqrt(sumSquares);
  }

  // Get value by trait name
  int getByName(String name) {
    final index = traitNames.indexOf(name);
    if (index == -1) throw ArgumentError('Unknown trait: $name');
    return values[index];
  }

  // Getters for individual traits
  int get emotionalRegulation => values[0];
  int get stabilityConsistency => values[1];
  int get sensitivityAttunement => values[2];
  int get boundariesAutonomy => values[3];
  int get vulnerabilityOpenness => values[4];
  int get avoidanceWithdrawal => values[5];
  int get pursuitAnxiety => values[6];
  int get conflictApproach => values[7];
  int get spontaneityFlexibility => values[8];

  Map<String, int> toMap() {
    return {for (int i = 0; i < 9; i++) traitNames[i]: values[i]};
  }

  @override
  List<Object?> get props => [values];
}
