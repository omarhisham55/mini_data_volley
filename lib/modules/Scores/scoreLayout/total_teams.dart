import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_data_volley/layout/layoutCubit/layout_cubit.dart';
import 'package:mini_data_volley/layout/layoutCubit/layout_states.dart';
import '../scoreCubit/score_cubit.dart';
import '../scoreCubit/score_states.dart';
import '../scoreWidgets/score_widgets.dart';

class AllTeams extends StatefulWidget {
  const AllTeams({super.key});

  @override
  State<AllTeams> createState() => _AllTeamsState();
}

class _AllTeamsState extends State<AllTeams>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ScoreManager, ScoreStates>(
      listener: (context, state) {},
      builder: (context, state) {
        LayoutManager manager = LayoutManager.get(context);
        return Scaffold(
          key: ScoreManager.get(context).totalTeamsKey,
          appBar: AppBar(
            title: const Text('All Teams'),
            bottom: TabBar(
              controller: tabController,
              tabs: const <Widget>[
                Tab(text: '15'),
                Tab(text: '17'),
                Tab(text: '19'),
                Tab(text: 'First'),
              ],
            ),
          ),
          body: TabBarView(controller: tabController, children: [
            if (state is LoadingGetAllTeamsTeamState)
              const LinearProgressIndicator(),
            ScoreWidgets.buildViewTeamItem(
              page: 0,
              teamModels: manager.teams15!,
            ),
            ScoreWidgets.buildViewTeamItem(
              page: 1,
              teamModels: manager.teams17!,
            ),
            ScoreWidgets.buildViewTeamItem(
              page: 2,
              teamModels: manager.teams19!,
            ),
            ScoreWidgets.buildViewTeamItem(
              page: 3,
              teamModels: manager.teamsFirst!,
            ),
          ]),
        );
      },
    );
  }
}
