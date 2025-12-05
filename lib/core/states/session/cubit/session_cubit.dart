import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pg1/core/models/card_model.dart';
import 'package:pg1/core/models/choice_model.dart';
import 'package:pg1/core/models/love_code_result.dart';
import 'package:pg1/core/models/pattern-insight.dart';
import 'package:pg1/core/services/engine_service.dart';
import 'package:pg1/core/services/json_loader.dart';
import 'package:pg1/core/shared/logger/app_logger.dart';
import 'package:pg1/core/shared/type_defs/type_defs.dart';
import 'package:uuid/uuid.dart';
import 'session_state.dart';

class SessionCubit extends Cubit<SessionState> {
  late EngineService _engineService;
  // final FirestoreService _firestoreService = FirestoreService();
  Map<String, Map<String, String>>? _narratives;
  Map<String, PatternInsight>? _patternInsights;

  SessionCubit() : super(SessionState());

  int get currentCardIndex => state.answers.length;

  Future<void> startSession() async {
    try {
      // Load all JSON data
      final cards = await JsonLoader.loadCards();
      final behaviourMappings = await JsonLoader.loadBehaviourMappings();
      final interpretationMappings = await JsonLoader.loadInterpretationMappings();
      final centroids = await JsonLoader.loadCentroids();

      _narratives = await JsonLoader.loadNarratives();
      _patternInsights = await JsonLoader.loadPatternInsights();

      // Initialize engine service
      _engineService = EngineService(behaviourMappings: behaviourMappings, interpretationMappings: interpretationMappings, centroids: centroids);
      appPrintGreen('Session started');

      // Generate session ID
      final sessionId = const Uuid().v4();

      emit(
        state.copyWith(
          status: SessionStatus.ready,
          sessionId: sessionId,
          cards: cards,
          currentCardIndex: 0,
          currentPhase: CardPhase.behaviour,
          answers: [],
          clearSelectedBehaviour: true,
          clearResult: true,
          clearError: true,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: SessionStatus.error, errorMessage: 'Failed to load data: $e'));
    }
  }

  PatternInsight? getPatternInsight(String patternId) {
    return _patternInsights?[patternId];
  }

  InterpretationLenMeta? addAnswer({required CardModel card, required Behaviour behaviour, required Interpretation interpretation}) {
    final answerCardIds = state.answers.map((a) => a.cardId);
    if (!answerCardIds.contains(card.id)) {
      final cardAnswer = CardAnswer(cardId: card.id, behaviourId: behaviour.id, interpretationId: interpretation.id);
      state.answers.add(cardAnswer);
      emit(state);

      final patternInsight = getPatternInsight(card.patternInsightId);
      if (patternInsight == null) {
        return null;
      }

      return (cardModel: card, cardAnswer: cardAnswer, patternInsight: getPatternInsight(card.patternInsightId)!);
    }
    return null;
  }
}
