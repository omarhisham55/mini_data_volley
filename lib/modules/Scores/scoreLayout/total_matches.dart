import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_data_volley/shared/constants.dart';
import '../scoreCubit/score_cubit.dart';
import '../scoreCubit/score_states.dart';
import '../scoreWidgets/score_widgets.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';

class AllMatches extends StatefulWidget {
  const AllMatches({super.key});

  @override
  State<AllMatches> createState() => _AllMatchesState();
}

class _AllMatchesState extends State<AllMatches>
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
        ScoreManager manager = ScoreManager.get(context);

        return Scaffold(
          appBar: AppBar(
            title: const Text('All Matches'),
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
            ConditionalBuilder(
              condition: manager.matches15 != null,
              builder: (context) => ScoreWidgets.buildViewMatchItem(
                page: 0,
                matchTitles: manager.matchTeamNames15,
                matchModels: manager.matches15!,
              ),
              fallback: (context) => fallBackIndicator(),
            ),
            ConditionalBuilder(
              condition: manager.matches17 != null,
              builder: (context) => ScoreWidgets.buildViewMatchItem(
                page: 1,
                matchTitles: manager.matchTeamNames17,
                matchModels: manager.matches17!,
              ),
              fallback: (context) => fallBackIndicator(),
            ),
            ConditionalBuilder(
              condition: manager.matches19 != null,
              builder: (context) => ScoreWidgets.buildViewMatchItem(
                page: 2,
                matchTitles: manager.matchTeamNames19,
                matchModels: manager.matches19!,
              ),
              fallback: (context) => fallBackIndicator(),
            ),
            ConditionalBuilder(
              condition: manager.matchesFirst != null,
              builder: (context) => ScoreWidgets.buildViewMatchItem(
                page: 3,
                matchTitles: manager.matchTeamNamesFirst,
                matchModels: manager.matchesFirst!,
              ),
              fallback: (context) => fallBackIndicator(),
            ),
          ]),
        );
      },
    );
  }
}
