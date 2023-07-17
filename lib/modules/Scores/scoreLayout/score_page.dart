import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../layout/startScreen/start_screen.dart';
import '../../../models/match_model.dart';
import '../../../shared/constants.dart';
import '../../matchModule/matchCubit/match_cubit.dart';
import '../scoreCubit/score_cubit.dart';
import '../scoreCubit/score_states.dart';
import '../scoreWidgets/score_widgets.dart';

class ScorePage extends StatelessWidget {
  final MatchModel matchModel;
  const ScorePage({super.key, required this.matchModel});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ScoreManager, ScoreStates>(
      listener: (context, state) {},
      builder: (context, state) {
        // ScoreManager manager = ScoreManager.get(context);
        print(matchModel.homePositions!.keys.toList());
        return Scaffold(
          appBar: AppBar(
            title: const Text('Total Scores'),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 10.0),
                Text(
                  '${matchModel.homeTeamName}    ${MatchManager.get(context).homeWins} - ${MatchManager.get(context).awayWins}    ${matchModel.awayTeamName}',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                const SizedBox(height: 10.0),
                SizedBox(
                  height: 20.0,
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) => Text(
                        '${MatchManager.get(context).finalScore1[index].text}/${MatchManager.get(context).finalScore2[index].text}'),
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 10.0),
                    itemCount: 3,
                  ),
                ),
                ScoreWidgets.matchInfo(matchModel),
                ScoreWidgets.teamPosition(
                  context: context,
                  teamName: matchModel.homeTeamName,
                  model: matchModel.homePositions!,
                  setters: matchModel.homeSetter!,
                ),
                ScoreWidgets.teamPosition(
                  context: context,
                  teamName: matchModel.awayTeamName,
                  model: matchModel.awayPositions!,
                  setters: matchModel.awaySetter!,
                ),
                bigButton(
                  context: context,
                  text: 'Go to home',
                  onPressed: () => navigateTo(context, const StartScreen()),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
