import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import '../../../models/teams_model.dart';
import '../../../shared/constants.dart';
import '../../Scores/scoreLayout/score_page.dart';
import '../matchCubit/match_cubit.dart';
import '../matchCubit/match_states.dart';
import '../modulesWidgets/modules_widgets.dart';

class MatchPage extends StatelessWidget {
  final TeamModel homeTeam;
  final TeamModel awayTeam;
  const MatchPage({super.key, required this.homeTeam, required this.awayTeam});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MatchManager, MatchStates>(
      listener: (context, state) {
        if (state is SuccessUpdateMatchState) {
          navigateTo(context, ScorePage(matchModel: state.matchModel));
        }
      },
      builder: (context, state) {
        MatchManager manager = MatchManager.get(context);
        List<String> totalScore = List.generate(
            5,
            (index) =>
                '${manager.finalScore1[index].text}:${manager.finalScore2[index].text}');
        List<List<String>> homePositionText = List.generate(
            manager.homePosition.length,
            (index) => List.generate(manager.homePosition[index].length,
                (index2) => manager.homePosition[index][index2].text));
        List<List<String>> awayPositionText = List.generate(
            manager.homePosition.length,
            (index) => List.generate(manager.awayPosition[index].length,
                (index2) => manager.awayPosition[index][index2].text));
        return PageView.builder(
          controller: manager.pageController,
          itemBuilder: (context, index) => ConditionalBuilder(
            condition: manager.matchModel != null,
            builder: (context) => Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                automaticallyImplyLeading: false,
                title: Text('Set ${index + 1}'),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.table_chart_outlined),
                    onPressed: () {
                      navigateTo(
                          context, ScorePage(matchModel: manager.matchModel!));
                    },
                  ),
                ],
              ),
              body: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10.0, vertical: 30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (state is LoadingUpdateMatchState)
                      const LinearProgressIndicator(),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          MatchWidgets.buildTeamNumberCards(
                            context: context,
                            teamName: homeTeam.name.toString(),
                            setterController: manager.homeSetter[index],
                            positionControllers: manager.homePosition[index],
                          ),
                          const Text('Final Score'),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              MatchWidgets.squareTextField(
                                context: context,
                                textFieldController: manager.finalScore1[index],
                              ),
                              const Text(':'),
                              MatchWidgets.squareTextField(
                                context: context,
                                textFieldController: manager.finalScore2[index],
                              ),
                            ],
                          ),
                          MatchWidgets.buildTeamNumberCards(
                            context: context,
                            teamName: awayTeam.name.toString(),
                            setterController: manager.awaySetter[index],
                            positionControllers: manager.awayPosition[index],
                            sixBlocksAlignment: MainAxisAlignment.end,
                            setterAlignment: AlignmentDirectional.topStart,
                            setterPadding: 15.0,
                          ),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // SizedBox(
                        //   width: width(context, .5),
                        //   child: smallButton(
                        //     text: 'start'.toUpperCase(),
                        //     onPressed: () {},
                        //   ),
                        // ),
                        // const SizedBox(height: 10.0),
                        bigButton(
                          context: context,
                          text: 'finish set ${index + 1}',
                          onPressed: () {
                            if (manager.pageController.page != 4) {
                              manager.pageController.nextPage(
                                  duration: const Duration(milliseconds: 600),
                                  curve: Curves.linear);
                            } else {
                              String level = '';
                              if (homeTeam.level == awayTeam.level) {
                                level = homeTeam.level;
                              } else {
                                level = 'friendly';
                              }
                              List<String> homeSetter = [];
                              List<String> awaySetter = [];
                              for (int i = 0; i < 5; i++) {
                                homeSetter.add(manager.homeSetter[i].text);
                                awaySetter.add(manager.awaySetter[i].text);
                              }
                              MatchManager.get(context).homeWins = 0;
                              MatchManager.get(context).awayWins = 0;
                              for (int i = 0;
                                  i <
                                      MatchManager.get(context)
                                          .finalScore1
                                          .length;
                                  i++) {
                                if (MatchManager.get(context)
                                        .finalScore1[i]
                                        .text ==
                                    '25') {
                                  MatchManager.get(context).homeWins++;
                                }
                                if (MatchManager.get(context)
                                        .finalScore2[i]
                                        .text ==
                                    '25') {
                                  MatchManager.get(context).awayWins++;
                                }
                              }
                              print(MatchManager.get(context)
                                      .homeWins
                                      .toString() +
                                  MatchManager.get(context)
                                      .awayWins
                                      .toString());
                              debugPrint(totalScore.toString());
                              debugPrint(homePositionText.toString());
                              debugPrint(awayPositionText.toString());
                              bool isFriendly = false;
                              MatchWidgets.friendlyDialog(
                                context: context,
                                yesFunction: () {
                                  isFriendly = true;
                                  manager.updateMatch(
                                    context: context,
                                    level: level,
                                    homeTeam: homeTeam,
                                    awayTeam: awayTeam,
                                    homeSetter: homeSetter,
                                    awaySetter: awaySetter,
                                    homePositions: homePositionText,
                                    awayPositions: awayPositionText,
                                    isFriendly: isFriendly,
                                    score: totalScore,
                                    numberScore:
                                        '${MatchManager.get(context).homeWins} - ${MatchManager.get(context).awayWins}',
                                  );
                                },
                                noFunction: () {
                                  isFriendly = false;
                                  manager.updateMatch(
                                    context: context,
                                    level: level,
                                    homeTeam: homeTeam,
                                    awayTeam: awayTeam,
                                    homeSetter: homeSetter,
                                    awaySetter: awaySetter,
                                    homePositions: homePositionText,
                                    awayPositions: awayPositionText,
                                    isFriendly: isFriendly,
                                    score: totalScore,
                                    numberScore:
                                        '${MatchManager.get(context).homeWins} - ${MatchManager.get(context).awayWins}',
                                  );
                                },
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            fallback: (context) => fallBackIndicator(),
          ),
          itemCount: 5,
        );
      },
    );
  }
}
