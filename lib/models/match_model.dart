import 'teams_model.dart';

class MatchModel {
  late TeamModel homeTeam;
  late TeamModel awayTeam;
  late String homeTeamName;
  late String awayTeamName;
  late String dateTime;
  late String level;
  late String? numberScore;
  late List? homeSetter = [];
  late List? awaySetter = [];
  bool? isFriendly = false;
  bool? fileExist = false;
  bool? videoExist = false;
  Map<String, dynamic>? homePositions = {};
  Map<String, dynamic>? awayPositions = {};
  List? score = [];

  MatchModel({
    required this.homeTeam,
    required this.awayTeam,
    required this.homeTeamName,
    required this.awayTeamName,
    required this.dateTime,
    required this.level,
    this.numberScore,
    this.homeSetter,
    this.awaySetter,
    this.isFriendly,
    this.homePositions,
    this.awayPositions,
    this.score,
    this.fileExist,
    this.videoExist,
  });

  MatchModel.fromJSON(Map<String, dynamic> json) {
    homeTeam = TeamModel.fromJSON(json['homeTeam']);
    awayTeam = TeamModel.fromJSON(json['awayTeam']);
    homeTeamName = json['homeTeamName'];
    awayTeamName = json['awayTeamName'];
    dateTime = json['dateTime'];
    level = json['level'];
    numberScore = json['numberScore'];
    homeSetter = json['homeSetter'];
    awaySetter = json['awaySetter'];
    isFriendly = json['isFriendly'];
    homePositions = json['homePositions'];
    awayPositions = json['awayPositions'];
    score = json['score'];
    fileExist = json['fileExist'];
    videoExist = json['videoExist'];
  }

  Map<String, dynamic> toMap() {
    return {
      'homeTeam': homeTeam.toMap(),
      'awayTeam': awayTeam.toMap(),
      'homeTeamName': homeTeamName,
      'awayTeamName': awayTeamName,
      'dateTime': dateTime,
      'level': level,
      'numberScore': numberScore,
      'homeSetter': homeSetter,
      'awaySetter': awaySetter,
      'isFriendly': isFriendly,
      'homePositions': homePositions,
      'awayPositions': awayPositions,
      'score': score,
      'fileExist': fileExist,
      'videoExist': videoExist,
    };
  }
}
