import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';

import '../../models/teams_model.dart';
import '../../modules/matchModule/matchCubit/match_cubit.dart';
import '../../shared/constants.dart';
import '../layoutCubit/layout_cubit.dart';
import '../layoutCubit/layout_states.dart';
import '../layoutWidgets/layout_widgets.dart';

class StartMatch extends StatelessWidget {
  const StartMatch({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LayoutManager, LayoutStates>(
      listener: (context, state) {},
      builder: (context, state) {
        LayoutManager manager = LayoutManager.get(context);
        return Scaffold(
          key: manager.scaffoldKey,
          body: ConditionalBuilder(
            condition: (state is! LoadingGetAllTeamsTeamState &&
                    state is! LoadingCreateTeamState) ||
                manager.allTeams.isNotEmpty,
            builder: (context) {
              late TeamModel homeTeam = manager.allTeams[0];
              late TeamModel awayTeam = manager.allTeams[0];
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          LayoutWidgets.dropDownMenu(
                            context: context,
                            labelText: 'Main Team',
                            onChanged: (value) {
                              for (var element in manager.allTeams) {
                                if (element.name == value!.substring(4)) {
                                  homeTeam = element;
                                }
                              }
                            },
                            items: List.generate(
                                manager.allTeams.isEmpty
                                    ? 1
                                    : manager.allTeams.length,
                                (index) => manager.allTeams.isEmpty
                                    ? 'no teams yet'
                                    : '${manager.allTeams[index].level}  ${manager.allTeams[index].name}'),
                          ),
                          LayoutWidgets.dropDownMenu(
                            context: context,
                            labelText: 'Opponent Team',
                            onChanged: (value) {
                              for (var element in manager.allTeams) {
                                if (element.name == value!.substring(4)) {
                                  awayTeam = element;
                                }
                              }
                            },
                            items: List.generate(
                                manager.allTeams.isEmpty
                                    ? 1
                                    : manager.allTeams.length,
                                (index) => manager.allTeams.isEmpty
                                    ? 'no teams yet'
                                    : '${manager.allTeams[index].level}  ${manager.allTeams[index].name}'),
                          ),
                          const SizedBox(height: 20.0),
                          smallButton(
                            text: 'Create new team',
                            onPressed: () {
                              LayoutWidgets.openBottomSheet(
                                context: context,
                                key: manager.scaffoldKey,
                                manager: manager,
                                state: state,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    bigButton(
                      context: context,
                      text: 'start',
                      onPressed: () {
                        debugPrint('${homeTeam.name} ${awayTeam.name}');
                        if (homeTeam.name == awayTeam.name &&
                            homeTeam.level == awayTeam.level) {
                          volleyToast(
                            message: 'Same team cannot play',
                            state: ToastStates.error,
                          );
                        } else {
                          DateTime now = DateTime.now();
                          if (homeTeam.level == awayTeam.level) {
                            MatchManager.get(context).startMatch(
                              context: context,
                              level: homeTeam.level,
                              homeTeam: homeTeam,
                              awayTeam: awayTeam,
                              dateTime: '${now.day}/${now.month}/${now.year}',
                            );
                          } else {
                            MatchManager.get(context).startMatch(
                              context: context,
                              level: 'friendly',
                              homeTeam: homeTeam,
                              awayTeam: awayTeam,
                              dateTime: '${now.day}/${now.month}/${now.year}',
                            );
                          }
                        }
                      },
                    ),
                  ],
                ),
              );
            },
            fallback: (context) => fallBackIndicator(),
          ),
        );
      },
    );
  }
}
