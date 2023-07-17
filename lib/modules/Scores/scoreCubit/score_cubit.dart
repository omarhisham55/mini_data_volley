import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/models/match_model.dart';
import 'score_states.dart';

class ScoreManager extends Cubit<ScoreStates> {
  ScoreManager() : super(InitialScoreState());

  static ScoreManager get(context) => BlocProvider.of(context);

  List<MatchModel>? matches15;
  List<MatchModel>? matches17;
  List<MatchModel>? matches19;
  List<MatchModel>? matchesFirst;
  late List<List<MatchModel>> matchesLast = [
    matches15!,
    matches17!,
    matches19!,
    matchesFirst!,
  ];
  List<String> matchTeamNames15 = [];
  List<String> matchTeamNames17 = [];
  List<String> matchTeamNames19 = [];
  List<String> matchTeamNamesFirst = [];
  late List<List<String>> matchTeamNamesLast = [
    matchTeamNames15,
    matchTeamNames17,
    matchTeamNames19,
    matchTeamNamesFirst,
  ];

  void getAllMatches() async {
    matches15 = [];
    matches17 = [];
    matches19 = [];
    matchesFirst = [];
    matchTeamNames15 = [];
    matchTeamNames17 = [];
    matchTeamNames19 = [];
    matchTeamNamesFirst = [];
    getSingleLevel('15', matches15!, matchTeamNames15);
    getSingleLevel('17', matches17!, matchTeamNames17);
    getSingleLevel('19', matches19!, matchTeamNames19);
    getSingleLevel('First', matchesFirst!, matchTeamNamesFirst);
    emit(GetAllMatchesLoadingState());
  }

  void getSingleLevel(
      String level, List<MatchModel> data, List<String> dataTitles) async {
    await FirebaseFirestore.instance
        .collection('matches')
        .doc(level)
        .collection('matches/')
        .orderBy('dateTime')
        .get()
        .then((value) {
      for (var element in value.docs) {
        // debugPrint(element.id);
        dataTitles.add(element.id);
        data.add(MatchModel.fromJSON(element.data()));
      }
      emit(GetAllMatchesSuccessState());
    }).catchError((e) {
      debugPrint('level: $level error: $e');
      emit(GetAllMatchesErrorState());
    });
  }

  late List<List<bool>> isClicked = List.generate(
      4, (index) => List.generate(matchesLast[index].length, (index) => false));

  void openMatchDetail(int page, int index) {
    (isClicked[page][index])
        ? isClicked[page][index] = false
        : isClicked[page][index] = true;
    print(isClicked[page][index]);
    emit(OpenMatchDetailsState());
  }
}
