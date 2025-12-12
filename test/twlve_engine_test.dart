// import 'package:flutter_test/flutter_test.dart';
// import 'dart:convert';
// import 'package:flutter/services.dart';

// import 'package:pg1/core/json/json_loader.dart';
// import 'package:pg1/core/models/card_answer_model.dart';
// import 'package:pg1/core/engine/love_engine.dart';
// import 'package:pg1/core/services/engine_service.dart';

// void main() {
//   TestWidgetsFlutterBinding.ensureInitialized();

//   setUpAll(() async {
//     // Register test asset loader
//     final assets = {
//       'assets/json/cards-json.json',
//       'assets/json/mappings-json.json',
//       'assets/json/narratives-json.json',
//       'assets/json/pattern-insights-json.json',
//     };

//     for (final path in assets) {
//       final data = await rootBundle.loadString(path);

//       TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
//           .setMockMessageHandler("flutter/assets", (message) async {
//         final key = utf8.decode(message.buffer.asUint8List());
//         if (key == path) {
//           return ByteData.view(utf8.encode(data).buffer);
//         }
//         return null;
//       });
//     }
//   });

//   test("Run deterministic TWLVE test case", () async {
//     // Load JSON data via your JsonLoader
//     final cards = await JsonLoader.loadCards();
//     final behaviourMappings = await JsonLoader.loadBehaviourMappings();
//     final interpretationMappings =
//         await JsonLoader.loadInterpretationMappings();

//     // 12-card deterministic test case (update as needed)
//     final answers = [
//       CardAnswerModel(cardId: 'card_01', behaviourId: 'A', interpretationId: '3'),
//       CardAnswerModel(cardId: 'card_02', behaviourId: 'B', interpretationId: '1'),
//       CardAnswerModel(cardId: 'card_03', behaviourId: 'C', interpretationId: '2'),
//       CardAnswerModel(cardId: 'card_04', behaviourId: 'A', interpretationId: '4'),
//       CardAnswerModel(cardId: 'card_05', behaviourId: 'D', interpretationId: '1'),
//       CardAnswerModel(cardId: 'card_06', behaviourId: 'A', interpretationId: '2'),
//       CardAnswerModel(cardId: 'card_07', behaviourId: 'B', interpretationId: '3'),
//       CardAnswerModel(cardId: 'card_08', behaviourId: 'C', interpretationId: '4'),
//       CardAnswerModel(cardId: 'card_09', behaviourId: 'D', interpretationId: '1'),
//       CardAnswerModel(cardId: 'card_10', behaviourId: 'A', interpretationId: '3'),
//       CardAnswerModel(cardId: 'card_11', behaviourId: 'B', interpretationId: '2'),
//       CardAnswerModel(cardId: 'card_12', behaviourId: 'C', interpretationId: '4'),
//     ];

//     // Init engine
//     final engine = TwlveScoringEngine(
//       cards: cards,
//       behaviourMappings: behaviourMappings,
//       interpretationMappings: interpretationMappings,
//     );

//     // 1. Compute 9-trait vector
//     final vector = engine.computeUserVector(answers);
//     print("User Vector (9 traits): $vector");

//     // 2. Rank types
//     final ranked = engine.rankTypes(vector);
//     print("Top 5 ranked: ${ranked.take(5).toList()}");

//     expect(vector.length, 9);
//     expect(ranked.isNotEmpty, true);
//   });
// }
