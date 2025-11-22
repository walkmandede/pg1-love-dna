import '../models/trait_vector.dart';
import '../models/choice_model.dart';
import '../models/love_code_result.dart';

class EngineService {
  final Map<String, Map<String, BehaviourMapping>> behaviourMappings;
  final Map<String, Map<String, InterpretationMapping>> interpretationMappings;
  final Map<String, TraitVector> centroids;

  EngineService({required this.behaviourMappings, required this.interpretationMappings, required this.centroids});

  TraitVector calculateEI(List<CardAnswer> answers) {
    TraitVector result = TraitVector.zero();
    for (final answer in answers) {
      final mapping = behaviourMappings[answer.cardId]?[answer.behaviourId];
      if (mapping != null) {
        result = result + TraitVector(mapping.ei);
      }
    }
    return result;
  }

  TraitVector calculateCI(List<CardAnswer> answers) {
    TraitVector result = TraitVector.zero();
    for (final answer in answers) {
      final mapping = interpretationMappings[answer.cardId]?[answer.interpretationId];
      if (mapping != null) {
        result = result + TraitVector(mapping.ci);
      }
    }
    return result;
  }

  List<String> collectMeaningTags(List<CardAnswer> answers) {
    final Set<String> tags = {};
    for (final answer in answers) {
      final mapping = interpretationMappings[answer.cardId]?[answer.interpretationId];
      if (mapping != null) {
        tags.addAll(mapping.tags);
      }
    }
    return tags.toList();
  }

  int calculateTrustScore(TraitVector ei) {
    return ei.vulnerabilityOpenness + ei.stabilityConsistency - ei.avoidanceWithdrawal - ei.pursuitAnxiety;
  }

  String calculateContradictionIndex(TraitVector ei, TraitVector ci) {
    final int raw = (ei.sum - ci.sum).abs();
    if (raw <= 2) return 'low';
    if (raw <= 5) return 'medium';
    return 'high';
  }

  String calculateStabilityOutlook(TraitVector ei) {
    final int score = ei.emotionalRegulation + ei.stabilityConsistency - ei.avoidanceWithdrawal - ei.pursuitAnxiety;
    if (score >= 6) return 'steady';
    if (score >= 0) return 'variable';
    return 'reactive';
  }

  List<String> rankTypesByDistance(TraitVector ei, TraitVector ci) {
    final Map<String, double> distances = {};

    centroids.forEach((typeName, centroid) {
      // Average distance of EI and CI to centroid
      final eiDist = ei.distanceTo(centroid);
      final ciDist = ci.distanceTo(centroid);
      distances[typeName] = (eiDist + ciDist) / 2;
    });

    final sorted = distances.entries.toList()..sort((a, b) => a.value.compareTo(b.value));

    return sorted.map((e) => e.key).toList();
  }

  TypeAssignment assignTypes(TraitVector ei, TraitVector ci) {
    final ranked = rankTypesByDistance(ei, ci);
    return TypeAssignment(
      primary: ranked[0],
      stabiliser: ranked[1],
      growth: ranked.last, // Last type equals to growth opportunity
    );
  }

  DerivedMetrics calculateDerivedMetrics(TraitVector ei, TraitVector ci) {
    return DerivedMetrics(
      trustScore: calculateTrustScore(ei),
      contradictionIndex: calculateContradictionIndex(ei, ci),
      stabilityOutlook: calculateStabilityOutlook(ei),
    );
  }
}
