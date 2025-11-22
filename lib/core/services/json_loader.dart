import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/card_model.dart';
import '../models/choice_model.dart';
import '../models/trait_vector.dart';

class JsonLoader {
  static Future<List<CardModel>> loadCards() async {
    final String jsonString = await rootBundle.loadString('assets/json/cards-json.json');
    final Map<String, dynamic> data = json.decode(jsonString);
    final List<dynamic> cardsJson = data['cards'];
    return cardsJson.map((c) => CardModel.fromJson(c)).toList();
  }

  static Future<Map<String, Map<String, BehaviourMapping>>> loadBehaviourMappings() async {
    final String jsonString = await rootBundle.loadString('assets/json/mappings-json.json');
    final Map<String, dynamic> data = json.decode(jsonString);
    final Map<String, dynamic> behaviours = data['behaviours'];

    final Map<String, Map<String, BehaviourMapping>> result = {};
    behaviours.forEach((cardId, options) {
      result[cardId] = {};
      (options as Map<String, dynamic>).forEach((optionId, mapping) {
        result[cardId]![optionId] = BehaviourMapping.fromJson(mapping);
      });
    });
    return result;
  }

  static Future<Map<String, Map<String, InterpretationMapping>>> loadInterpretationMappings() async {
    final String jsonString = await rootBundle.loadString('assets/json/mappings-json.json');
    final Map<String, dynamic> data = json.decode(jsonString);
    final Map<String, dynamic> interpretations = data['interpretations'];

    final Map<String, Map<String, InterpretationMapping>> result = {};
    interpretations.forEach((cardId, options) {
      result[cardId] = {};
      (options as Map<String, dynamic>).forEach((optionId, mapping) {
        result[cardId]![optionId] = InterpretationMapping.fromJson(mapping);
      });
    });
    return result;
  }

  static Future<Map<String, TraitVector>> loadCentroids() async {
    final String jsonString = await rootBundle.loadString('assets/json/centroids-json.json');
    final Map<String, dynamic> data = json.decode(jsonString);
    final Map<String, dynamic> types = data['types'];

    final Map<String, TraitVector> result = {};
    types.forEach((typeName, typeData) {
      final List<dynamic> centroid = typeData['centroid'];
      result[typeName] = TraitVector(centroid.map((e) => e as int).toList());
    });
    return result;
  }

  static Future<Map<String, Map<String, String>>> loadNarratives() async {
    final String jsonString = await rootBundle.loadString('assets/json/narratives-json.json');
    final Map<String, dynamic> data = json.decode(jsonString);
    final Map<String, dynamic> types = data['types'];

    final Map<String, Map<String, String>> result = {};
    types.forEach((typeName, narrative) {
      result[typeName] = {'title': narrative['title'] as String, 'short': narrative['short'] as String, 'long': narrative['long'] as String};
    });
    return result;
  }
}
