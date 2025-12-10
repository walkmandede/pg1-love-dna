import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pg1/core/models/card_model.dart';
import 'package:pg1/core/models/card_answer_model.dart';
import 'package:pg1/core/models/pattern_insight.dart';
import 'package:pg1/core/services/data_loader_service.dart';
import 'package:pg1/core/services/engine_service.dart';
import 'package:pg1/core/services/json_loader.dart';
import 'package:pg1/core/shared/logger/app_logger.dart';
import 'package:pg1/core/shared/type_defs/type_defs.dart';
import 'package:uuid/uuid.dart';
import 'session_state.dart';

class SessionCubit extends Cubit<SessionState> {
  final TwlveScoringEngine _engine = TwlveScoringEngine();
  // final FirestoreService _firestoreService = FirestoreService();
  Map<String, PatternInsight>? _patternInsights;

  SessionCubit() : super(SessionState());

  int get currentCardIndex => state.answers.length;

  int getIndexOfTheCard(CardModel card) {
    return state.cards.map((c) => c.id).toList().indexOf(card.id);
  }

  Future<void> _initEngine() async {
    final weights = await TwlveDataLoader.loadWeights('assets/json/twlve_weights.json');
    final centroids = TwlveDataLoader.loadCentroids();
    final narratives = TwlveDataLoader.loadNarratives();
    appPrintGreen(centroids);
    _engine.initialize(
      weights: weights,
      centroids: centroids,
      narratives: narratives,
    );
  }

  Future<void> startSession() async {
    try {
      // Load all JSON data
      final cards = await JsonLoader.loadCards();
      _patternInsights = await JsonLoader.loadPatternInsights();
      await _initEngine();

      // Initialize engine service
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

  PatternInsight? getPatternInsightForScoring(String patternId) {
    return _patternInsights?[patternId];
  }

  LenPageMeta? addAnswer({required CardModel card, required Behaviour behaviour, required Interpretation interpretation}) {
    final answerCardIds = state.answers.map((a) => a.cardId);
    if (!answerCardIds.contains(card.id)) {
      final cardAnswer = CardAnswerModel(cardId: card.id, behaviourId: behaviour.id, interpretationId: interpretation.id);
      state.answers.add(cardAnswer);
      emit(state);

      final patternInsight = getPatternInsightForScoring(card.behaviourLensPatternId);
      if (patternInsight == null) {
        return null;
      }

      return (cardModel: card, cardAnswer: cardAnswer, patternInsight: getPatternInsightForScoring(card.behaviourLensPatternId)!);
    }
    return null;
  }

  Future<EngineResult> computeResult(List<CardAnswerModel> answers) async {
    return _engine.computeResult(answers);
  }
}
