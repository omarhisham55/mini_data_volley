import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../models/match_model.dart';
import '../../../models/teams_model.dart';
import '../../../shared/constants.dart';
import '../../Scores/scoreCubit/score_cubit.dart';
import '../matchLayout/match_page.dart';
import 'match_states.dart';

class MatchManager extends Cubit<MatchStates> {
  MatchManager() : super(InitialMatchState());

  static MatchManager get(context) => BlocProvider.of(context);

  List<List<TextEditingController>> homePosition = List.generate(
      5, (index) => List.generate(6, (index) => TextEditingController()));

  List<TextEditingController> homeSetter =
      List.generate(5, (index) => TextEditingController());
  List<TextEditingController> awaySetter =
      List.generate(5, (index) => TextEditingController());

  List<List<TextEditingController>> awayPosition = List.generate(
      5, (index) => List.generate(6, (index) => TextEditingController()));

  List<TextEditingController> finalScore1 =
      List.generate(5, (index) => TextEditingController());
  List<TextEditingController> finalScore2 =
      List.generate(5, (index) => TextEditingController());

  int homeWins = 0;
  int awayWins = 0;

  final PageController pageController = PageController();

  MatchModel? matchModel;

  void startMatch({
    required BuildContext context,
    required String level,
    required TeamModel homeTeam,
    required TeamModel awayTeam,
    required String dateTime,
  }) async {
    emit(LoadingStartMatchState());
    matchModel = MatchModel(
      level: level,
      homeTeamName: homeTeam.name,
      awayTeamName: awayTeam.name,
      dateTime: dateTime,
    );
    await FirebaseFirestore.instance
        .collection('matches')
        .doc(level)
        .collection('matches/')
        .doc('${homeTeam.name} Vs ${awayTeam.name}')
        .set(matchModel!.toMap())
        .then((value) {
      volleyToast(message: 'Match started', state: ToastStates.success);
      replacePage(context, MatchPage(homeTeam: homeTeam, awayTeam: awayTeam));
      emit(SuccessStartMatchState());
    }).catchError((e) {
      debugPrint(e.toString());
      emit(ErrorStartMatchState());
    });
  }

  void updateMatch({
    required BuildContext context,
    required String level,
    required String numberScore,
    required List<String> homeSetter,
    required List<String> awaySetter,
    required TeamModel homeTeam,
    required TeamModel awayTeam,
    required List<List<String>> homePositions,
    required List<List<String>> awayPositions,
    required List<String> score,
    bool? isFriendly = false,
  }) async {
    matchModel = MatchModel(
      level: level,
      homeTeamName: homeTeam.name,
      awayTeamName: awayTeam.name,
      dateTime: matchModel!.dateTime,
      isFriendly: isFriendly,
      numberScore: numberScore,
      homeSetter: homeSetter,
      awaySetter: awaySetter,
      homePositions: {
        'set1': homePositions[0],
        'set2': homePositions[1],
        'set3': homePositions[2],
        'set4': homePositions[3],
        'set5': homePositions[4],
      },
      awayPositions: {
        'set1': awayPositions[0],
        'set2': awayPositions[1],
        'set3': awayPositions[2],
        'set4': awayPositions[3],
        'set5': awayPositions[4],
      },
      score: score,
    );
    emit(LoadingUpdateMatchState());
    await FirebaseFirestore.instance
        .collection('matches')
        .doc(level)
        .collection('matches/')
        .doc('${homeTeam.name} Vs ${awayTeam.name}')
        .update(matchModel!.toMap())
        .then((value) {
      ScoreManager.get(context).getAllMatches();
      emit(SuccessUpdateMatchState(matchModel!));
    }).catchError((e) {
      debugPrint(e.toString());
      emit(ErrorUpdateMatchState());
    });
  }
}
