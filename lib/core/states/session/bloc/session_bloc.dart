import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pg1/core/models/choice_model.dart';
import 'package:pg1/core/models/love_code_result.dart';
import 'package:pg1/core/services/engine_service.dart';

import 'package:pg1/core/services/json_loader.dart';
import 'package:uuid/uuid.dart';
import 'session_event.dart';
import 'session_state.dart';

class SessionBloc extends Bloc<SessionEvent, SessionState> {
  EngineService? _engineService;
  // final FirestoreService _firestoreService = FirestoreService();
  Map<String, Map<String, String>>? _narratives;

  SessionBloc() : super(const SessionState()) {
    on<SessionStarted>(_onSessionStarted);
    on<BehaviourSelected>(_onBehaviourSelected);
    on<InterpretationSelected>(_onInterpretationSelected);
    on<NextCardRequested>(_onNextCardRequested);
    on<SessionCompleted>(_onSessionCompleted);
    on<SessionReset>(_onSessionReset);
  }

  Future<void> _onSessionStarted(SessionStarted event, Emitter<SessionState> emit) async {
    emit(state.copyWith(status: SessionStatus.loading));

    try {
      // Load all JSON data
      final cards = await JsonLoader.loadCards();
      final behaviourMappings = await JsonLoader.loadBehaviourMappings();
      final interpretationMappings = await JsonLoader.loadInterpretationMappings();
      final centroids = await JsonLoader.loadCentroids();
      _narratives = await JsonLoader.loadNarratives();

      // Initialize engine service
      _engineService = EngineService(behaviourMappings: behaviourMappings, interpretationMappings: interpretationMappings, centroids: centroids);

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

  void _onBehaviourSelected(BehaviourSelected event, Emitter<SessionState> emit) {
    emit(state.copyWith(status: SessionStatus.inProgress, selectedBehaviourId: event.behaviourId, currentPhase: CardPhase.interpretation));
  }

  void _onInterpretationSelected(InterpretationSelected event, Emitter<SessionState> emit) {
    final answer = CardAnswer(cardId: event.cardId, behaviourId: state.selectedBehaviourId!, interpretationId: event.interpretationId);

    final updatedAnswers = [...state.answers, answer];

    emit(state.copyWith(answers: updatedAnswers));

    if (state.isLastCard) {
      add(const SessionCompleted());
    } else {
      add(const NextCardRequested());
    }
  }

  void _onNextCardRequested(NextCardRequested event, Emitter<SessionState> emit) {
    emit(state.copyWith(currentCardIndex: state.currentCardIndex + 1, currentPhase: CardPhase.behaviour, clearSelectedBehaviour: true));
  }

  Future<void> _onSessionCompleted(SessionCompleted event, Emitter<SessionState> emit) async {
    emit(state.copyWith(status: SessionStatus.completing));

    try {
      final engine = _engineService!;

      final eiVector = engine.calculateEI(state.answers);
      final ciVector = engine.calculateCI(state.answers);

      final meaningTags = engine.collectMeaningTags(state.answers);

      final derivedMetrics = engine.calculateDerivedMetrics(eiVector, ciVector);

      final types = engine.assignTypes(eiVector, ciVector);

      final result = LoveCodeResult(
        sessionId: state.sessionId,
        createdAt: DateTime.now(),
        version: 'mvp_v1.3',
        answers: state.answers,
        eiVector: eiVector,
        ciVector: ciVector,
        types: types,
        derivedMetrics: derivedMetrics,
        meaningTags: meaningTags,
      );

      // await _firestoreService.saveResultWithId(result);

      emit(state.copyWith(status: SessionStatus.completed, result: result));
    } catch (e) {
      emit(state.copyWith(status: SessionStatus.error, errorMessage: 'Failed to complete session: $e'));
    }
  }

  void _onSessionReset(SessionReset event, Emitter<SessionState> emit) {
    add(const SessionStarted());
  }

  /// Get narrative for a type name
  Map<String, String>? getNarrative(String typeName) {
    return _narratives?[typeName];
  }
}
