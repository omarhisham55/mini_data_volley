import '../../../models/match_model.dart';

abstract class MatchStates {}

class InitialMatchState extends MatchStates {}

class LoadingStartMatchState extends MatchStates {}

class SuccessStartMatchState extends MatchStates {}

class ErrorStartMatchState extends MatchStates {}

class LoadingUpdateMatchState extends MatchStates {}

class SuccessUpdateMatchState extends MatchStates {
  final MatchModel matchModel;

  SuccessUpdateMatchState(this.matchModel);
}

class ErrorUpdateMatchState extends MatchStates {}
