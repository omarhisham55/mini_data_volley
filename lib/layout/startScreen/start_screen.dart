import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_data_volley/modules/Scores/scoreLayout/total_teams.dart';
import '../../modules/Scores/scoreLayout/total_matches.dart';
import '../../shared/constants.dart';
import '../layoutCubit/layout_cubit.dart';
import '../layoutCubit/layout_states.dart';
import '../layoutWidgets/layout_widgets.dart';
import '../startMatch/start_match.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LayoutManager, LayoutStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              actions: [
                IconButton(
                  onPressed: () {
                    navigateTo(context, AllTeams());
                  },
                  icon: const Icon(Icons.people),
                  tooltip: 'Teams',
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  LayoutWidgets.startContainer(
                    context: context,
                    text: 'Start Match',
                    onTap: () {
                      navigateTo(context, const StartMatch());
                    },
                  ),
                  LayoutWidgets.startContainer(
                    context: context,
                    text: 'All Matches',
                    onTap: () {
                      navigateTo(context, const AllMatches());
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
}
