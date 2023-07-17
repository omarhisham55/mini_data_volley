import 'package:flutter/material.dart';
import '../../../models/match_model.dart';
import '../../../shared/constants.dart';
import '../scoreCubit/score_cubit.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';

class ScoreWidgets {
  static Widget matchInfo(MatchModel model) => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('level')),
            DataColumn(label: Text('HomeTeam')),
            DataColumn(label: Text('AwayTeam')),
            DataColumn(label: Text('Date')),
          ],
          rows: [
            DataRow(cells: [
              DataCell(Text(model.level.toString())),
              DataCell(Text(model.homeTeamName.toString())),
              DataCell(Text(model.awayTeamName.toString())),
              DataCell(Text(model.dateTime.toString())),
            ]),
          ],
        ),
      );
  static Widget teamPosition(
      {required BuildContext context,
      required String teamName,
      required Map<String, dynamic> model,
      required List setters}) {
    List<dynamic> position = model.values.toList();
    return SizedBox(
      width: width(context, 1),
      child: DataTable(
        columns: [
          DataColumn(label: Text(teamName.toString())),
          DataColumn(label: Text('Setter')),
        ],
        rows: [
          DataRow(cells: [
            DataCell(
              (model.values.toList()[0].isNotEmpty)
                  ? Text('Set 1: ${position[0]}')
                  : const Text('Set 1 not played'),
            ),
            DataCell(Text(setters[0])),
          ]),
          DataRow(cells: [
            DataCell(
              (model.values.toList()[1].isNotEmpty)
                  ? Text('Set 2: ${position[1]}')
                  : const Text('Set 2 not played'),
            ),
            DataCell(Text(setters[1])),
          ]),
          DataRow(cells: [
            DataCell(
              (model.values.toList()[2].isNotEmpty)
                  ? Text('Set 3: ${position[2]}')
                  : const Text('Set 3 not played'),
            ),
            DataCell(Text(setters[2])),
          ]),
          DataRow(cells: [
            DataCell(
              (model.values.toList()[3].isNotEmpty)
                  ? Text('Set 4: ${position[3]}')
                  : const Text('Set 1 not played'),
            ),
            DataCell(Text(setters[3])),
          ]),
          DataRow(cells: [
            DataCell(
              (model.values.toList()[4].isNotEmpty)
                  ? Text('Set 5: ${position[4]}')
                  : const Text('Set 1 not played'),
            ),
            DataCell(Text(setters[4])),
          ]),
        ],
      ),
    );
  }

  static Widget buildViewMatchItem({
    required int page,
    required List<String> matchTitles,
    required List<MatchModel>? matchModels,
  }) {
    return ConditionalBuilder(
      condition: matchModels != null,
      builder: (context) {
        return ConditionalBuilder(
          condition: matchModels!.isNotEmpty,
          builder: (context) => SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                ExpansionPanelList(
                  animationDuration: const Duration(milliseconds: 300),
                  children: List.generate(
                    matchModels.length,
                    (index) => expandedRowItem(
                      context: context,
                      page: page,
                      index: index,
                      matchTitle: matchTitles[index],
                      matchModel: matchModels[index],
                    ),
                  ),
                ),
              ],
            ),
          ),
          fallback: (context) => const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(child: Text('No Matches')),
            ],
          ),
        );
      },
      fallback: (context) => fallBackIndicator(),
    );
  }

  static ExpansionPanel expandedRowItem({
    required BuildContext context,
    required int page,
    required int index,
    required String matchTitle,
    required MatchModel matchModel,
  }) {
    return ExpansionPanel(
      isExpanded: ScoreManager.get(context).isClicked[page][index],
      canTapOnHeader: false,
      headerBuilder: (context, isExpanded) => InkWell(
        onTap: () {
          ScoreManager.get(context).openMatchDetail(page, index);
        },
        child: Stack(
          alignment: Alignment.centerRight,
          children: [
            ListTile(
              title: Text(matchTitle),
              subtitle: Text(matchModel.dateTime),
            ),
            Visibility(
              visible: matchModel.isFriendly!,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Friendly',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: buildMatchBody(context, matchModel),
    );
  }

  static Widget buildMatchBody(BuildContext context, MatchModel matchModel) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('Score: '),
              Text(matchModel.numberScore.toString()),
            ],
          ),
          const SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(matchModel.score![0] ?? ''),
              Text(matchModel.score![1] ?? ''),
              Text(matchModel.score![2] ?? ''),
              Text(matchModel.score![3] ?? ''),
              Text(matchModel.score![4] ?? ''),
            ],
          ),
          const SizedBox(height: 30.0),
          Text(
            matchModel.homeTeamName,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 10.0),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) => Text(
                'set${index + 1}: ${matchModel.homePositions!['set${index + 1}']}     setter: ${matchModel.homeSetter![index]}'),
            separatorBuilder: (context, index) => const SizedBox(height: 15.0),
            itemCount: matchModel.homePositions!.length,
          ),
          const SizedBox(height: 30.0),
          Text(
            matchModel.awayTeamName,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 10.0),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) => Text(
                'set${index + 1}: ${matchModel.awayPositions!['set${index + 1}']}     setter: ${matchModel.awaySetter![index]}'),
            separatorBuilder: (context, index) => const SizedBox(height: 15.0),
            itemCount: matchModel.homePositions!.length,
          ),
        ],
      ),
    );
  }
}
