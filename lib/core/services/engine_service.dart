import 'dart:math';
import 'package:collection/collection.dart';
import 'package:pg1/core/models/card_answer_model.dart';
import 'package:pg1/core/models/twlve_models.dart';
import 'package:pg1/core/shared/logger/app_logger.dart';

class EngineResult {
  final TwlveScoringEngine twlveScoringEngine;
  final LoveCodeResult loveCodeResult;
  final List<TypeAssignment> rankedTypes;
  final List<double> eIVectors;
  final List<double> cIVectors;
  final List<double> userVectors;
  final List<String> meaningTags;

  EngineResult({
    required this.twlveScoringEngine,
    required this.loveCodeResult,
    required this.rankedTypes,
    required this.eIVectors,
    required this.cIVectors,
    required this.userVectors,
    required this.meaningTags,
  });
}

class TwlveScoringEngine {
  // cardId → elementType → optionId → WeightEntry
  final Map<String, WeightEntry> _weightLookup = {};
  final List<TypeCentroid> _centroids = [];
  final Map<String, String> _narratives = {};

  static const String weightsVersion = 'v2.0';
  static const String centroidVersion = 'v1.0';

  Map<String, dynamic> toMap() {
    return {
      'weights': _weightLookup,
      'centroids': _centroids,
    };
  }

  void initialize({
    required List<WeightEntry> weights,
    required List<TypeCentroid> centroids,
    required Map<String, String> narratives,
  }) {
    _weightLookup.clear();
    for (final w in weights) {
      final key = '${w.cardNumber}_${w.elementType}_${w.optionId}';
      _weightLookup[key] = w;
    }
    _centroids.clear();
    _centroids.addAll(centroids);
    _narratives.addAll(narratives);
    for (final c in _centroids) {
      appPrintCyan(c);
    }
  }

  EngineResult computeResult(List<CardAnswerModel> answers) {
    if (answers.length != 12) {
      throw ArgumentError('Exactly 12 answers required');
    }

    final eiVector = List<double>.filled(9, 0.0);
    final ciVector = List<double>.filled(9, 0.0);
    final Set<String> meaningTags = {};

    for (final answer in answers) {
      final cardId = answer.cardNumber;

      // Behaviour → EI
      final bKey = '${cardId}_behaviour_${answer.behaviourId}';
      final bEntry = _weightLookup[bKey];
      if (bEntry == null) {
        throw StateError('Missing weight: $bKey');
      }
      _add(eiVector, bEntry.deltas);

      // Interpretation → CI + tags
      // e.g. g.      card_01_interpretation_1
      final iKey = '${cardId}_interpretation_${answer.interpretationId}';
      final iEntry = _weightLookup[iKey];
      if (iEntry == null) {
        throw StateError('Missing weight: $iKey');
      }
      _add(ciVector, iEntry.deltas);
      meaningTags.addAll(iEntry.meaningTags);
    }

    final userVector = List<double>.generate(9, (i) {
      final avg = (eiVector[i] + ciVector[i]) / 12.0;
      return avg.clamp(-3.0, 3.0);
    });

    final rankedTypes = _assignTypes(userVector);
    final metrics = _computeDerivedMetrics(eiVector, ciVector);
    final primaryType = rankedTypes.first.typeCode;
    final narrative = _generateNarrative(primaryType, meaningTags.toList()..sort());

    final result = LoveCodeResult(
      timestamp: DateTime.now(),
      weightsVersion: weightsVersion,
      centroidVersion: centroidVersion,
      eiVector: eiVector,
      ciVector: ciVector,
      derivedMetrics: metrics,
      typeAssignment: rankedTypes.first,
      meaningTags: meaningTags.toList()..sort(),
      narrativeText: narrative,
    );

    return EngineResult(
      twlveScoringEngine: this,
      loveCodeResult: result,
      rankedTypes: rankedTypes,
      cIVectors: ciVector,
      eIVectors: eiVector,
      meaningTags: meaningTags.toList(),
      userVectors: userVector,
    );
  }

  // ────────────────────── Helpers ──────────────────────

  void _add(List<double> target, List<double> delta) {
    for (var i = 0; i < 9; i++) {
      target[i] += delta[i];
    }
  }

  List<TypeAssignment> _assignTypes(List<double> userVector) {
    final distances = <String, double>{};
    for (final c in _centroids) {
      distances[c.typeCode] = _euclidean(userVector, c.vector);
    }

    final sorted = distances.entries.toList()..sort((a, b) => a.value.compareTo(b.value));

    // Debug near-ties
    for (var i = 1; i < sorted.length; i++) {
      if ((sorted[i].value - sorted[i - 1].value).abs() < 1e-9) {
        // appPrintRed('Near tie: ${sorted[i - 1].key} vs ${sorted[i].key}');
      }
    }

    return List.generate(sorted.length, (i) {
      final e = sorted[i];
      return TypeAssignment(
        typeCode: e.key,
        distance: e.value,
        rank: i + 1,
      );
    });
  }

  double _euclidean(List<double> userVector, List<double> centroids) {
    double sum = 0.0;
    for (int i = 0; i < userVector.length; i++) {
      final d = userVector[i] - centroids[i];
      sum += d * d;
    }
    return sqrt(sum);
  }

  DerivedMetrics _computeDerivedMetrics(List<double> ei, List<double> ci) {
    final eiMag = sqrt(ei.map((e) => e * e).sum);
    final ciMag = sqrt(ci.map((e) => e * e).sum);

    final balance = eiMag == 0 && ciMag == 0 ? 1.0 : 1.0 - (eiMag - ciMag).abs() / max(eiMag, ciMag);

    final clarity = (ei.map((v) => v.abs()).average + ci.map((v) => v.abs()).average) / 2.0;

    return DerivedMetrics(
      eiIntensity: eiMag,
      ciIntensity: ciMag,
      balance: balance,
      clarity: clarity,
    );
  }

  String _generateNarrative(String typeCode, List<String> tags) {
    final base = _narratives[typeCode] ?? 'Narrative missing';
    if (tags.isEmpty) return base;
    return '$base\n\nKey themes in your responses: ${tags.join(", ")}';
  }
}
