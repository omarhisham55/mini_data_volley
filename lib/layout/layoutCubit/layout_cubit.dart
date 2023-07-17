import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/teams_model.dart';
import '../../shared/constants.dart';
import 'layout_states.dart';

class LayoutManager extends Cubit<LayoutStates> {
  LayoutManager() : super(InitialLayoutState());

  static LayoutManager get(context) => BlocProvider.of(context);

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> createTeamKey = GlobalKey<FormState>();
  TextEditingController newTeam = TextEditingController();
  bool isBottomSheetOpened = false;
  Color color = Colors.red;

  void currentColor(Color color) {
    this.color = color;
    emit(ChangeTeamColorState());
  }

  String generateRandomId() {
    const characters =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    const idLength = 20;
    final id = String.fromCharCodes(Iterable.generate(idLength,
        (_) => characters.codeUnitAt(Random().nextInt(characters.length))));

    return id;
  }

  void createTeam(
      {required String level,
      required BuildContext context,
      String? image}) async {
    emit(LoadingCreateTeamState());
    String id = generateRandomId();
    TeamModel model = TeamModel(
      id: id,
      level: level,
      color: color.value.toRadixString(16),
      name: newTeam.text,
      image: image.toString(),
    );
    if (allTeams.any((element) {
      if (element.level == model.level) return element.name == model.name;
      return false;
    })) {
      volleyToast(message: 'Team already exists', state: ToastStates.warning);
      emit(ErrorCreateTeamState());
    } else {
      await FirebaseFirestore.instance
          .collection('teams')
          .doc(level)
          .collection('teams/')
          .doc(id)
          .set(model.toMap())
          .then((value) {
        getAllTeams();
        emit(SuccessCreateTeamState());
        Navigator.pop(context);
      }).catchError((e) {
        debugPrint(e.toString());
        emit(ErrorCreateTeamState());
      });
    }
  }

  void deleteTeam(String id, String level) async {
    await FirebaseFirestore.instance
        .collection('teams')
        .doc(level)
        .collection('teams/')
        .doc(id)
        .delete()
        .then((value) {
      emit(SuccessDeleteTeamState());
      getAllTeams();
    }).catchError((e) {
      debugPrint(e.toString());
      emit(ErrorDeleteTeamState());
    });
  }

  List<TeamModel> allTeams = [];
  List<TeamModel>? teams15;
  List<TeamModel>? teams17;
  List<TeamModel>? teams19;
  List<TeamModel>? teamsFirst;

  void getAllTeams() async {
    allTeams = [];
    teams15 = [];
    teams17 = [];
    teams19 = [];
    teamsFirst = [];
    emit(LoadingGetAllTeamsTeamState());
    getSingleLevel('15', teams15!);
    getSingleLevel('17', teams17!);
    getSingleLevel('19', teams19!);
    getSingleLevel('First', teamsFirst!);
  }

  void getSingleLevel(String level, List<TeamModel> teams) async {
    await FirebaseFirestore.instance
        .collection('teams')
        .doc(level)
        .collection('teams/')
        .get()
        .then((value) {
      for (var element in value.docs) {
        teams.add(TeamModel.fromJSON(element.data()));
      }
      print(teams);
      allTeams.addAll(teams);
      emit(SuccessGetAllTeamsTeamState());
    }).catchError((e) {
      debugPrint(e.toString());
      emit(ErrorGetAllTeamsTeamState());
    });
  }
}
