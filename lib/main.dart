import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'layout/layoutCubit/layout_cubit.dart';
import 'layout/layoutCubit/layout_states.dart';
import 'layout/startScreen/start_screen.dart';
import 'modules/Scores/scoreCubit/score_cubit.dart';
import 'modules/Scores/scoreCubit/score_states.dart';
import 'modules/matchModule/matchCubit/match_cubit.dart';
import 'modules/matchModule/matchCubit/match_states.dart';
import 'shared/bloc_observer/bloc_observer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';

import 'shared/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  // await SharedPrefs.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => LayoutManager()..getAllTeams()),
          BlocProvider(create: (context) => MatchManager()),
          BlocProvider(create: (context) => ScoreManager()..getAllMatches()),
        ],
        child: MultiBlocListener(
          listeners: [
            BlocListener<LayoutManager, LayoutStates>(
                listener: (context, state) {
              if (state is SuccessCreateTeamState) {
                volleyToast(
                    message: 'Team created',
                    state: ToastStates.success);
              }
            }),
            BlocListener<MatchManager, MatchStates>(listener: (context, state) {
              if (state is SuccessStartMatchState) {
                volleyToast(
                    message: 'Match started',
                    state: ToastStates.success);
              }
            }),
            BlocListener<ScoreManager, ScoreStates>(
                listener: (context, state) {}),
          ],
          child: MaterialApp(
            title: 'Position Taker',
            debugShowCheckedModeBanner: false,
            theme: ThemeData.dark(),
            home: const StartScreen(),
          ),
        ),
      ),
    );
  }
}
