import 'package:equatable/equatable.dart';

abstract class SessionEvent extends Equatable {
  const SessionEvent();

  @override
  List<Object?> get props => [];
}

class SessionStarted extends SessionEvent {
  const SessionStarted();
}

class BehaviourSelected extends SessionEvent {
  final String cardId;
  final String behaviourId;

  const BehaviourSelected({required this.cardId, required this.behaviourId});

  @override
  List<Object?> get props => [cardId, behaviourId];
}

class InterpretationSelected extends SessionEvent {
  final String cardId;
  final String interpretationId;

  const InterpretationSelected({required this.cardId, required this.interpretationId});

  @override
  List<Object?> get props => [cardId, interpretationId];
}

class NextCardRequested extends SessionEvent {
  const NextCardRequested();
}

class SessionCompleted extends SessionEvent {
  const SessionCompleted();
}

class SessionReset extends SessionEvent {
  const SessionReset();
}
