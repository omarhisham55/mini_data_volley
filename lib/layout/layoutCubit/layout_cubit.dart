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
      color: color.toString(),
      name: newTeam.text,
      image: image.toString(),
    );
    if (allTeams.any((element) => element.name == newTeam.text)) {
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

  List<TeamModel> allTeams = [];
  List<TeamModel> teams15 = [];
  List<TeamModel> teams17 = [];
  List<TeamModel> teams19 = [];

  void getAllTeams() async {
    allTeams = [];
    teams15 = [];
    teams17 = [];
    teams19 = [];
    emit(LoadingGetAllTeamsTeamState());
    await FirebaseFirestore.instance
        .collection('teams')
        .doc('15')
        .collection('teams/')
        .get()
        .then((value15) async {
      for (var element15 in value15.docs) {
        teams15.add(TeamModel.fromJSON(element15.data()));
      }
      await FirebaseFirestore.instance
          .collection('teams')
          .doc('17')
          .collection('teams/')
          .get()
          .then((value17) async {
        for (var element17 in value17.docs) {
          teams17.add(TeamModel.fromJSON(element17.data()));
        }
        await FirebaseFirestore.instance
            .collection('teams')
            .doc('19')
            .collection('teams/')
            .get()
            .then((value19) {
          for (var element19 in value19.docs) {
            teams19.add(TeamModel.fromJSON(element19.data()));
          }
          allTeams = teams15 + teams17 + teams19;
          emit(SuccessGetAllTeamsTeamState());
        }).catchError((e) {
          debugPrint('from 19 $e');
          emit(ErrorGetAllTeamsTeamState());
        });
      }).catchError((e) {
        debugPrint('from 17 $e');
        emit(ErrorGetAllTeamsTeamState());
      });
    }).catchError((e) {
      debugPrint('from 15 $e');
      emit(ErrorGetAllTeamsTeamState());
    });
  }
}
