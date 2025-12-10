// twlve_data_loader.dart
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:pg1/core/models/twlve_models.dart';

/// Loads weights, centroids, and narratives from assets
class TwlveDataLoader {
  /// Load weights from JSON
  /// Expected JSON structure: { "version": "v2.0", "weights": [...] }
  static Future<List<WeightEntry>> loadWeights(String jsonPath) async {
    final jsonString = await rootBundle.loadString(jsonPath);
    final jsonData = json.decode(jsonString) as Map<String, dynamic>;

    final weightsJson = jsonData['weights'] as List;
    final entries = <WeightEntry>[];

    for (var weightData in weightsJson) {
      final deltas = (weightData['deltas'] as List).map((v) => (v as num).toDouble()).toList();

      final tags = (weightData['meaning_tags'] as List).map((v) => v.toString()).toList();

      entries.add(
        WeightEntry(
          cardNumber: weightData['card_number'] as int,
          elementType: weightData['element_type'] as String,
          optionId: weightData['option_id'] as String,
          deltas: deltas,
          meaningTags: tags,
        ),
      );
    }

    return entries;
  }

  /// Load type centroids
  static List<TypeCentroid> loadCentroids() {
    return [
      TypeCentroid(typeCode: 'Steady Anchor', vector: [3, 3, 1, 1, 1, -1, -1, 1, -1]),
      TypeCentroid(typeCode: 'Quiet Protector', vector: [2, 2, 2, 2, -1, 1, -2, 0, -1]),
      TypeCentroid(typeCode: 'Warm Connector', vector: [1, 1, 3, -1, 3, -2, 2, 0, 1]),
      TypeCentroid(typeCode: 'Thoughtful Analyst', vector: [2, 1, 2, 1, 0, 1, -1, 1, -2]),
      TypeCentroid(typeCode: 'Independent Spirit', vector: [1, 0, 1, 3, -1, 2, -2, 0, 2]),
      TypeCentroid(typeCode: 'Growth-Seeker', vector: [1, 0, 2, 0, 2, -1, 1, 1, 2]),
      TypeCentroid(typeCode: 'Spark-Driven Adventurer', vector: [-1, -1, 1, -1, 1, -1, 2, 0, 3]),
      TypeCentroid(typeCode: 'Reassurance Harmoniser', vector: [0, 1, 3, -1, 2, -2, 3, -2, 0]),
      TypeCentroid(typeCode: 'Compassionate Healer', vector: [1, 0, 3, -2, 3, -2, 1, -1, 0]),
      TypeCentroid(typeCode: 'Purpose-Led Planner', vector: [2, 3, 1, 2, 0, 0, -1, 2, -2]),
      TypeCentroid(typeCode: 'Boundary-Minded Realist', vector: [2, 1, 0, 3, -1, 1, -2, 1, -1]),
      TypeCentroid(typeCode: 'Intuitive Romantic', vector: [-1, 0, 3, -1, 3, -1, 2, 0, 1]),
    ].map((c) => TypeCentroid(typeCode: c.typeCode, vector: c.vector.map((v) => v.toDouble()).toList())).toList();
  }

  /// Load narratives
  static Map<String, String> loadNarratives() {
    return {
      'Steady Anchor':
          '''You bring reliability, emotional steadiness, and a grounded presence into relationships. People experience you as consistent and calming - your reactions don't fluctuate wildly, and you tend to interpret situations with measured clarity. You value stability and honesty, and you approach connection at a steady pace that creates trust over time.

You don't rush into emotional closeness, but once you feel secure, you offer a sense of safety that others naturally lean into. Your interpretations are typically pragmatic - you avoid assumptions, over-analysis, or emotional dramatics. You prefer facts, patterns, and observable behaviour over speculation.

Under stress, you may become quieter or even temporarily withdrawn, not out of avoidance but to prevent escalation. This internal regulation is a strength, but it can also make your discomfort hard to read. Sometimes your mind tells you everything is manageable even when your emotions are signalling something different.

Your growth lies in allowing small moments of vulnerability to surface earlier. Letting others see your internal shifts - before they accumulate - strengthens the connection you already support so well.''',

      'Quiet Protector':
          '''You are observant, measured, and emotionally perceptive. You don't reveal everything upfront; instead, you let trust build through consistency and shared understanding. You sense emotional shifts quickly, often before they're spoken, and you use that awareness to navigate connection with care.

Your instinct is to protect your inner world until you feel secure. You are loyal, steady, and deeply supportive once someone earns that access. Your interpretations tend to lean cautious - you evaluate tone, patterns, and intentions carefully before responding.

Under stress, you retreat inward to regain clarity. This is not withdrawal from the relationship but a method of grounding yourself. However, others may misunderstand this introspective pause unless you communicate what's happening internally.

Your growth involves signalling your emotional process earlier. When you share even a little of what you're thinking or feeling, others understand you more easily - and your relationships deepen without compromising your natural reserve.''',

      'Warm Connector':
          '''You move through relationships with emotional openness, responsiveness, and a natural instinct for closeness. You attune quickly to tone and emotional nuance, and you often notice how someone feels before they've fully articulated it. You value mutual engagement, steady communication, and the sense of being emotionally "met."

You trust through warmth and reciprocity. When someone shows up consistently, you open generously; when the signal feels mixed, you may work harder to steady the connection. Your interpretations are intuitive and relational - you look for meaning, intention, and emotional balance.

Under stress, your emotional system becomes more active. You may lean into reassurance or over-functioning as a way to secure connection. At times, this can create internal contradiction: wanting closeness while simultaneously sensing instability.

Your growth lies in letting others carry more of the emotional load. When your warmth is paired with boundaries, it becomes one of the most powerful stabilising forces in your relationships.''',

      'Thoughtful Analyst':
          '''You approach relationships with reflection, curiosity, and a desire to understand emotional dynamics with clarity. Your instinct is to make sense of patterns - why something feels the way it does, what someone's behaviour signals, how meaning emerges between two people.

You trust through coherence. When emotional signals align with your interpretation, you feel grounded; when they don't, you revisit conversations mentally, looking for clarity or missing context. You are perceptive but can become internally busy when something feels ambiguous.

Under stress, your mind may stay active even when your emotions are steady. You tend to prioritise understanding before expression, which can sometimes delay communication that others would find reassuring.

Your growth lies in allowing emotional experience to coexist with incomplete explanations. When you give yourself permission to feel before analysing, your relationships become more fluid and less mentally demanding.''',

      'Independent Spirit':
          '''You value autonomy, clarity, and emotional self-sufficiency. You're open to connection, but you need space to process at your own pace and on your own terms. You prefer direct communication, clear boundaries, and relationships that support independence rather than consume it.

You trust through consistency and straightforward behaviour. When someone shows up reliably, you relax and let them in; when they don't, you instinctively create distance to regain equilibrium. Your interpretations tend to be practical - you evaluate actions, not assumptions.

Under stress, you become more self-contained. You lean on internal logic and reduce emotional output to maintain stability. This can create situations where you feel more than you share, and others may mistake your quietness for indifference.

Your growth comes from inviting people into your emotional world sooner. Independence is your strength, and connection becomes even richer when you allow others to understand how you feel behind your steadiness.''',

      'Growth-Seeker':
          '''You move toward relationships that encourage self-development, emotional expansion, and deeper mutual understanding. You're curious about how connection evolves over time and attentive to how each interaction contributes to a broader pattern of growth - for you and for the other person.

You trust through sincerity and meaningful engagement. When someone shows emotional depth or places value on learning and adaptation, you open more fully. Your interpretations often focus on possibility, intention, and the trajectory of a relationship rather than isolated moments.

Under stress, you become more introspective, scanning for what the moment is trying to teach you. This can lead to heightened sensitivity or internal pressure to "get it right," creating temporary tension between your emotional and cognitive responses.

Your growth lies in recognising that not every signal is a lesson and not every moment requires improvement. When you allow relationships to breathe without needing constant evolution, connection becomes more grounded and sustainable.''',

      'Spark-Driven Adventurer':
          '''You bring energy, spontaneity, and a sense of possibility into relationships. You respond strongly to emotional momentum - when things feel alive, open, and dynamic, you're engaged and expressive. You value experiences that create connection rather than routines that confine it.

You trust through energetic compatibility. Consistency matters, but so does spark - the feeling that the relationship has movement and vitality. Your interpretations tend to be fast, intuitive, and responsive to shifts in tone or excitement.

Under stress, your emotional energy may fluctuate more sharply. You can feel connected and uncertain in the same moment, creating internal contradictions that others misunderstand as inconsistency.

Your growth lies in grounding the spark with structure. When your spontaneity is paired with steady pacing, your relationships gain the stability they need to thrive without dimming your natural light.''',

      'Reassurance Harmoniser':
          '''You value emotional clarity, steady communication, and relational stability. You sense shifts quickly and often work to restore balance before things become misaligned. Your instinct is to maintain harmony - not by suppressing your needs, but by keeping connection open and responsive.

You trust through dependability and emotional presence. When someone communicates clearly and shows care, you soften and open. When signals feel inconsistent, you may seek reassurance or step in to stabilise the dynamic.

Under stress, you may overextend emotionally to maintain harmony. This creates internal contradiction: wanting to feel supported while also taking responsibility for the emotional tone of the relationship.

Your growth lies in asserting your needs earlier and trusting that harmony doesn't require self-sacrifice. When you hold your boundaries as confidently as your care, relationships become more balanced and mutually steady.''',

      'Compassionate Healer':
          '''You bring empathy, depth, and emotional generosity into relationships. You are sensitive to what others feel and naturally create space for emotional honesty. People often experience you as warm, insightful, and grounding.

You trust through emotional sincerity. When someone shows vulnerability or truthfulness, you engage fully; when they feel guarded or inconsistent, you may become quieter as you assess what's happening. Your interpretations are compassionate but sometimes layered with concern.

Under stress, you may carry more emotional weight than intended. Your instinct to understand and support can pull you into roles that require more giving than receiving, creating inner contradictions between caring for others and caring for yourself.

Your growth is in allowing reciprocity - letting others support you with the same depth you offer them. This balance strengthens your emotional wellbeing and your relationships.''',

      'Purpose-Led Planner':
          '''You move through connection with intention, clarity, and foresight. You're emotionally present but also oriented toward long-term alignment. You value relationships that feel stable, structured, and rooted in shared direction.

You trust through consistency and honesty. You prefer clear communication, thoughtful pacing, and evidence of commitment. Your interpretations tend to weigh immediate emotional signals against the broader trajectory of the relationship.

Under stress, you may become more vigilant - tracking patterns, anticipating emotional outcomes, or mentally organising the relationship to regain certainty. This can create tension between your desire for spontaneity and your need for predictability.

Your growth lies in allowing uncertainty without perceiving it as risk. When you make space for imperfect moments, connection becomes less pressured and more authentically shared.''',

      'Boundary-Minded Realist':
          '''You approach relationships with clarity, accountability, and strong internal boundaries. You value emotional honesty but prefer interactions that feel grounded rather than overly expressive. You open up when trust is earned, not assumed.

You trust through evidence, not implication. When someone's behaviour matches their words, you engage steadily; when it doesn't, you recalibrate quickly. Your interpretations are direct and rooted in observable dynamics.

Under stress, you may become firmer or more reserved, using boundaries to maintain internal stability. This can create internal contradiction: caring deeply but showing less outward emotion than you feel.

Your growth lies in letting others see your warmth without feeling that it compromises your strength. When clarity and openness coexist, you build relationships that feel stable and deeply authentic.''',

      'Intuitive Romantic':
          '''You lead with emotional depth, intuition, and a search for meaningful connection. You feel things vividly and read emotional undercurrents with ease. Relationships for you are not just practical - they are experiences of resonance, purpose, and felt understanding.

You trust through emotional alignment. When someone's energy or values match yours, connection feels natural and immediate. Your interpretations are layered, symbolic, and attentive to tone.

Under stress, your sensitivity increases. You may withdraw into introspection, trying to understand the emotional truth behind a moment. This can create internal contradictions - wanting closeness while protecting yourself from potential misalignment.

Your growth lies in grounding your depth with clarity. When you express your needs directly rather than intuitively, relationships become easier to navigate and more emotionally secure.''',
    };
  }
}
