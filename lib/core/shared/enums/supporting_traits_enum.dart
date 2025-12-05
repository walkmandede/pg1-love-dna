import 'package:pg1/core/shared/assets/app_svgs.dart';

enum SupportingTraitEnum {
  socialMirroring(
    id: "social_mirroring",
    label: "Social Mirroring",
    svgPath: AppSvgs.socialMirroring,
  ),

  timingSensitivity(
    id: "timing_sensitivity",
    label: "Timing Sensitivity",
    svgPath: AppSvgs.timingSensitivity,
  ),

  boundaryVigilance(
    id: "boundary_vigilance",
    label: "Boundary Vigilance",
    svgPath: AppSvgs.boundaryVigilance,
  ),

  emotionalGuarding(
    id: "emotional_guarding",
    label: "Emotional Guarding",
    svgPath: AppSvgs.emotionalGuarding,
  ),

  hopefulFraming(
    id: "hopeful_framing",
    label: "Hopeful Framing",
    svgPath: AppSvgs.hopefulFraming,
  ),

  meaningExpansion(
    id: "meaning_expansion",
    label: "Meaning Expansion",
    svgPath: AppSvgs.meaningExpansion,
  ),

  signalTracking(
    id: "signal_tracking",
    label: "Signal Tracking",
    svgPath: AppSvgs.signalTracking,
  ),

  meaningCompression(
    id: "meaning_compression",
    label: "Meaning Compression",
    svgPath: AppSvgs.meaningCompression,
  ),

  engagementFlow(
    id: "engagement_flow",
    label: "Engagement Flow",
    svgPath: AppSvgs.engagementFlow,
  ),

  affectionSurge(
    id: "affection_surge",
    label: "Affection Surge",
    svgPath: AppSvgs.affectionSurge,
  ),

  riskAssessment(
    id: "risk_assessment",
    label: "Risk Assessment",
    svgPath: AppSvgs.riskAssessment,
  ),

  emotionalDeliberation(
    id: "emotional_deliberation",
    label: "Emotional Deliberation",
    svgPath: AppSvgs.emotionalDeliberation,
  ),

  baselineReinforcement(
    id: "baseline_reinforcement",
    label: "Baseline Reinforcement",
    svgPath: AppSvgs.baselineReinforcement,
  ),

  patternConsistency(
    id: "pattern_consistency",
    label: "Pattern Consistency",
    svgPath: AppSvgs.patternConsistency,
  ),

  storyProjection(
    id: "story_projection",
    label: "Story Projection",
    svgPath: AppSvgs.storyProjection,
  ),

  senseMaking(
    id: "sense_making",
    label: "Sense-Making",
    svgPath: AppSvgs.senseMaking,
  ),

  emotionalAbsorption(
    id: "emotional_absorption",
    label: "Emotional Absorption",
    svgPath: AppSvgs.emotionalAbsorption,
  ),

  sensitivitySpike(
    id: "sensitivity_spike",
    label: "Sensitivity Spike",
    svgPath: AppSvgs.sensitivitySpike,
  ),

  internalFraming(
    id: "internal_framing",
    label: "Internal Framing",
    svgPath: AppSvgs.internalFraming,
  ),

  spaceMaking(
    id: "space_making",
    label: "Space-Making",
    svgPath: AppSvgs.spaceMaking,
  ),

  vulnerabilityMatching(
    id: "vulnerability_matching",
    label: "Vulnerability Matching",
    svgPath: AppSvgs.vulnerabilityMatching,
  ),

  relationalTracking(
    id: "relational_tracking",
    label: "Relational Tracking",
    svgPath: AppSvgs.relationalTracking,
  );

  //-----------------------------------------------------

  final String id;
  final String label;
  final String svgPath;

  const SupportingTraitEnum({
    required this.id,
    required this.label,
    required this.svgPath,
  });

  /// Helper: find enum by id
  static SupportingTraitEnum? fromId(String id) {
    return SupportingTraitEnum.values.firstWhere(
      (t) => t.id == id,
      orElse: () => throw Exception("Unknown SupportingTrait id: $id"),
    );
  }

  static SupportingTraitEnum? fromLabel(String label) {
    return SupportingTraitEnum.values.firstWhere(
      (t) => t.label == label,
      orElse: () => throw Exception("Unknown SupportingTrait id: $label"),
    );
  }
}
