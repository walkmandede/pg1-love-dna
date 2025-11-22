import 'package:equatable/equatable.dart';
import 'package:pg1/core/models/card_model.dart';
import 'package:pg1/core/models/choice_model.dart';
import 'package:pg1/core/models/love_code_result.dart';

enum SessionStatus {
  initial, // Not started
  loading, // Loading JSON data
  ready, // Data loaded, ready to start
  inProgress, // Answering cards
  completing, // Calculating results
  completed, // Results ready
  error, // Something went wrong
}

enum CardPhase {
  behaviour, // User selecting behaviour
  interpretation, // User selecting interpretation
}

class SessionState extends Equatable {
  final SessionStatus status;
  final String sessionId;
  final List<CardModel> cards;
  final int currentCardIndex;
  final CardPhase currentPhase;
  final String? selectedBehaviourId;
  final List<CardAnswer> answers;
  final LoveCodeResult? result;
  final String? errorMessage;

  const SessionState({
    this.status = SessionStatus.initial,
    this.sessionId = '',
    this.cards = const [],
    this.currentCardIndex = 0,
    this.currentPhase = CardPhase.behaviour,
    this.selectedBehaviourId,
    this.answers = const [],
    this.result,
    this.errorMessage,
  });

  CardModel? get currentCard {
    if (cards.isEmpty || currentCardIndex >= cards.length) return null;
    return cards[currentCardIndex];
  }

  /// Progress from 0.0 to 1.0
  double get progress {
    if (cards.isEmpty) return 0;
    return (currentCardIndex + 1) / cards.length;
  }

  /// Check if on last card
  bool get isLastCard => currentCardIndex == cards.length - 1;

  /// Card number for display (1-12)
  int get cardNumber => currentCardIndex + 1;

  /// Total cards
  int get totalCards => cards.length;

  SessionState copyWith({
    SessionStatus? status,
    String? sessionId,
    List<CardModel>? cards,
    int? currentCardIndex,
    CardPhase? currentPhase,
    String? selectedBehaviourId,
    List<CardAnswer>? answers,
    LoveCodeResult? result,
    String? errorMessage,
    bool clearSelectedBehaviour = false,
    bool clearResult = false,
    bool clearError = false,
  }) {
    return SessionState(
      status: status ?? this.status,
      sessionId: sessionId ?? this.sessionId,
      cards: cards ?? this.cards,
      currentCardIndex: currentCardIndex ?? this.currentCardIndex,
      currentPhase: currentPhase ?? this.currentPhase,
      selectedBehaviourId: clearSelectedBehaviour ? null : (selectedBehaviourId ?? this.selectedBehaviourId),
      answers: answers ?? this.answers,
      result: clearResult ? null : (result ?? this.result),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [status, sessionId, cards, currentCardIndex, currentPhase, selectedBehaviourId, answers, result, errorMessage];
}
