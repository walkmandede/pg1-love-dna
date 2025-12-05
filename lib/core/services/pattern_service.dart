// class PatternService {
//   final Map<String, PatternTrigger> behaviourPatterns;
//   final Map<String, PatternTrigger> interpretationPatterns;

//   PatternService({
//     required this.behaviourPatterns,
//     required this.interpretationPatterns,
//   });

//   /// Returns a single dominant pattern ID for a card.
//   String getPatternForCard(String cardId, String behaviourId, String interpretationId) {
//     final behaviourPattern = behaviourPatterns[cardId]?[behaviourId];
//     final interpretationPattern = interpretationPatterns[cardId]?[interpretationId];

//     if (behaviourPattern == null && interpretationPattern == null) {
//       throw Exception("No pattern mapping found for card $cardId");
//     }

//     // RULE 1 — If both map to same pattern → return it
//     if (behaviourPattern?.patternId == interpretationPattern?.patternId) {
//       return behaviourPattern!.patternId;
//     }

//     // RULE 2 — If different → Behaviour pattern wins
//     if (behaviourPattern != null) {
//       return behaviourPattern.patternId;
//     }

//     // RULE 3 — If behaviour is missing (rare), fallback to interpretation
//     return interpretationPattern!.patternId;
//   }
// }

// class PatternTrigger {
//   final String patternId; // e.g. P1
//   final String insightPageId; // e.g. INSIGHT_01

//   PatternTrigger(this.patternId, this.insightPageId);
// }
