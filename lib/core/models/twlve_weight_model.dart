class TwlveWeight {
  final int cardNumber;
  final String elementType; // 'behaviour' or 'interpretation'
  final String optionId; // A..D or 1..4
  final Map<String, int> traitMap; // keys: emotional_regulation, stability_consistency, ...
  final List<String> meaningTags;

  TwlveWeight({
    required this.cardNumber,
    required this.elementType,
    required this.optionId,
    required this.traitMap,
    required this.meaningTags,
  });

  factory TwlveWeight.fromJson(Map<String, dynamic> j) {
    final traitKeys = [
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
    final Map<String, int> traitMap = {};
    for (final k in traitKeys) {
      final v = j[k];
      traitMap[k] = v == null ? 0 : (v is int ? v : int.parse(v.toString()));
    }
    final tags = <String>[];
    if (j.containsKey('meaning_tag_1') && j['meaning_tag_1'] != null) tags.add(j['meaning_tag_1'].toString());
    if (j.containsKey('meaning_tag_2') && j['meaning_tag_2'] != null) tags.add(j['meaning_tag_2'].toString());
    if (j.containsKey('meaning_tag_3') && j['meaning_tag_3'] != null) tags.add(j['meaning_tag_3'].toString());

    return TwlveWeight(
      cardNumber: j['card_number'] is int ? j['card_number'] : int.parse(j['card_number'].toString()),
      elementType: j['element_type'].toString(),
      optionId: j['option_id'].toString(),
      traitMap: traitMap,
      meaningTags: tags,
    );
  }

  /// returns trait values in canonical order (9 ints)
  List<int> traitList() {
    return [
      traitMap['emotional_regulation'] ?? 0,
      traitMap['stability_consistency'] ?? 0,
      traitMap['sensitivity_attunement'] ?? 0,
      traitMap['boundaries_autonomy'] ?? 0,
      traitMap['vulnerability_openness'] ?? 0,
      traitMap['avoidance_withdrawal'] ?? 0,
      traitMap['pursuit_anxiety'] ?? 0,
      traitMap['conflict_approach'] ?? 0,
      traitMap['spontaneity_flexibility'] ?? 0,
    ];
  }
}
