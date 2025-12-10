// twlve_scoring_engine.dart
import 'dart:math';
import 'package:collection/collection.dart';
import 'package:pg1/core/models/card_answer_model.dart';
import 'package:pg1/core/models/twlve_models.dart';
import 'package:pg1/core/shared/logger/app_logger.dart';

class EngineResult {
  LoveCodeResult loveCodeResult;
  List<TypeAssignment> types;

  EngineResult({
    required this.loveCodeResult,
    required this.types,
  });
}

class TwlveScoringEngine {
  final Map<String, WeightEntry> _weightLookup = {};
  final List<TypeCentroid> _centroids = [];
  final Map<String, String> _narratives = {};

  static const String weightsVersion = 'v2.0';
  static const String centroidVersion = 'v1.0';
  static const String narrativeVersion = 'v1.0';

  /// Initialize the engine with weights, centroids, and narratives
  void initialize({
    required List<WeightEntry> weights,
    required List<TypeCentroid> centroids,
    required Map<String, String> narratives,
  }) {
    _weightLookup.clear();
    _centroids.clear();
    _narratives.clear();

    // Build lookup map: "cardNumber_elementType_optionId" -> WeightEntry
    for (var entry in weights) {
      final key = _buildWeightKey(entry.cardNumber, entry.elementType, entry.optionId);
      _weightLookup[key] = entry;
    }

    _centroids.addAll(centroids);
    _narratives.addAll(narratives);
  }

  /// Main scoring method
  EngineResult computeResult(List<CardAnswerModel> answers) {
    if (answers.length != 12) {
      throw ArgumentError('Expected 12 card answers, got ${answers.length}');
    }

    // 1. Initialize vectors
    final eiVector = List<double>.filled(9, 0.0);
    final ciVector = List<double>.filled(9, 0.0);
    final meaningTags = <String>[];

    // 2. Accumulate deltas
    for (var i = 0; i < answers.length; i++) {
      final answer = answers[i];
      final cardNumber = i + 1;

      // Lookup behaviour deltas -> update EI
      final behaviourKey = _buildWeightKey(cardNumber, 'behaviour', answer.behaviourId);
      final behaviourEntry = _weightLookup[behaviourKey];
      if (behaviourEntry == null) {
        throw StateError('Missing behaviour weight: card=$cardNumber, option=${answer.behaviourId}');
      }
      _addVector(eiVector, behaviourEntry.deltas);

      // Lookup interpretation deltas -> update CI and collect tags
      final interpretationKey = _buildWeightKey(cardNumber, 'interpretation', answer.interpretationId);
      final interpretationEntry = _weightLookup[interpretationKey];
      if (interpretationEntry == null) {
        throw StateError('Missing interpretation weight: card=$cardNumber, option=${answer.interpretationId}');
      }
      _addVector(ciVector, interpretationEntry.deltas);
      meaningTags.addAll(interpretationEntry.meaningTags);
    }

    // 3. De-duplicate meaning tags
    final uniqueTags = meaningTags.toSet().toList();

    // 4. Compute derived metrics
    final metrics = _computeDerivedMetrics(eiVector, ciVector);

    // 5. Assign type via centroid matching
    final typeAssignments = _assignTypes(eiVector, ciVector);
    final typeAssignment = typeAssignments.first;

    // 6. Generate narrative
    final narrative = _generateNarrative(typeAssignment.typeCode, uniqueTags);

    // 7. Build result
    final loveCodeResult = LoveCodeResult(
      timestamp: DateTime.now(),
      weightsVersion: weightsVersion,
      centroidVersion: centroidVersion,
      eiVector: eiVector,
      ciVector: ciVector,
      derivedMetrics: metrics,
      typeAssignment: typeAssignment,
      meaningTags: uniqueTags,
      narrativeText: narrative,
    );

    return EngineResult(
      loveCodeResult: loveCodeResult,
      types: typeAssignments,
    );
  }

  String _buildWeightKey(int cardNumber, String elementType, String optionId) {
    return '${cardNumber}_${elementType}_$optionId';
  }

  void _addVector(List<double> target, List<double> delta) {
    for (var i = 0; i < target.length; i++) {
      target[i] += delta[i];
    }
  }

  DerivedMetrics _computeDerivedMetrics(List<double> ei, List<double> ci) {
    // Simple intensity: Euclidean magnitude
    final eiIntensity = _magnitude(ei);
    final ciIntensity = _magnitude(ci);

    // Balance: ratio of magnitudes (normalized)
    final balance = eiIntensity == 0 && ciIntensity == 0 ? 1.0 : 1.0 - ((eiIntensity - ciIntensity).abs() / max(eiIntensity, ciIntensity));

    // Clarity: average absolute value (how strongly traits are expressed)
    final avgEi = ei.map((v) => v.abs()).average;
    final avgCi = ci.map((v) => v.abs()).average;
    final clarity = (avgEi + avgCi) / 2.0;

    return DerivedMetrics(
      eiIntensity: eiIntensity,
      ciIntensity: ciIntensity,
      balance: balance,
      clarity: clarity,
    );
  }

  double _magnitude(List<double> vector) {
    return sqrt(vector.map((v) => v * v).sum);
  }

  List<TypeAssignment> _assignTypes(List<double> ei, List<double> ci) {
    // Concatenate EI and CI to form 18-dimensional matching vector
    final userVector = [...ei, ...ci];

    // Compute distance to each centroid
    final distances = <String, double>{};
    for (var centroid in _centroids) {
      // Expand centroid to 18d by duplicating (or use custom logic)
      // For now: use only the 9-trait centroid and compare against EI+CI average
      final combinedUser = _combineVectors(ei, ci);
      final distance = _euclideanDistance(combinedUser, centroid.vector);
      distances[centroid.typeCode] = distance;
    }

    // Find nearest
    final sorted = distances.entries.toList()..sort((a, b) => a.value.compareTo(b.value));
    // appPrintCyan(sorted);
    // final nearest = sorted.first;

    final types = <TypeAssignment>[];

    for (final each in sorted) {
      final rank = sorted.indexOf(each) + 1;
      types.add(
        TypeAssignment(
          typeCode: each.key,
          distance: each.value,
          rank: rank,
        ),
      );
    }

    return types;
  }

  /// Combine EI and CI into single 9-trait vector (simple average)
  List<double> _combineVectors(List<double> ei, List<double> ci) {
    return List.generate(9, (i) => (ei[i] + ci[i]) / 2.0);
  }

  double _euclideanDistance(List<double> a, List<double> b) {
    var sum = 0.0;
    for (var i = 0; i < a.length; i++) {
      final diff = a[i] - b[i];
      sum += diff * diff;
    }
    return sqrt(sum);
  }

  String _generateNarrative(String typeCode, List<String> meaningTags) {
    final baseNarrative = _narratives[typeCode] ?? 'Type narrative not found.';

    // For MVP: return base narrative with meaning tag summary
    final tagSummary = meaningTags.isEmpty ? '' : '\n\nKey themes in your responses: ${meaningTags.join(', ')}';

    return baseNarrative + tagSummary;
  }
}
