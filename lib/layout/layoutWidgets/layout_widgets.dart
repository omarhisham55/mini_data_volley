import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:mini_data_volley/models/teams_model.dart';
import 'package:mini_data_volley/modules/Scores/scoreCubit/score_cubit.dart';
import '../../shared/constants.dart';
import '../layoutCubit/layout_cubit.dart';
import '../layoutCubit/layout_states.dart';

class LayoutWidgets {
  static Widget startContainer(
          {required BuildContext context,
          required String text,
          required Function() onTap}) =>
      InkWell(
        onTap: onTap,
        child: Container(
          width: width(context, 1),
          height: height(context, .35),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(width: 1, color: Colors.white),
          ),
          child: Center(
              child:
                  Text(text, style: Theme.of(context).textTheme.displaySmall)),
        ),
      );

  static DropdownMenuItem<String> dropDownItem(String text) =>
      DropdownMenuItem<String>(
        value: text,
        child: Text(text),
      );

  static Widget dropDownMenu({
    required BuildContext context,
    required String labelText,
    required Function(String?) onChanged,
    required List<String> items,
  }) =>
      DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: labelText,
        ),
        items: List.generate(
          items.length,
          (index) => dropDownItem(items[index]),
        ),
        value: items[0],
        onChanged: onChanged,
      );

  static String level = '15';

  static Widget scaffoldCreateTeamBottomSheet({
    required BuildContext context,
    required String text,
    required TextEditingController controller,
    required LayoutStates state,
  }) =>
      Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: LayoutManager.get(context).createTeamKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: width(context, .85),
                    child: TextFormField(
                      controller: controller,
                      decoration: InputDecoration(
                        labelText: text,
                        contentPadding: const EdgeInsets.only(left: 15.0),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'No Team Name';
                        }
                        return null;
                      },
                      onFieldSubmitted: (value) {
                        if (LayoutManager.get(context)
                            .createTeamKey
                            .currentState!
                            .validate()) {
                          LayoutManager.get(context)
                              .createTeam(level: level, context: context);
                        }
                      },
                    ),
                  ),
                  colorButtonPalette(context),
                ],
              ),
              dropDownMenu(
                context: context,
                labelText: 'Level',
                onChanged: (value) {
                  level = value!;
                },
                items: ['15', '17', '19', 'First'],
              ),
              bigButton(
                context: context,
                text: 'save',
                onPressed: () {
                  if (LayoutManager.get(context)
                      .createTeamKey
                      .currentState!
                      .validate()) {
                    LayoutManager.get(context)
                        .createTeam(level: level, context: context);
                  }
                },
              ),
            ],
          ),
        ),
      );

  static void openBottomSheet({
    required BuildContext context,
    required GlobalKey<ScaffoldState> key,
    required manager,
    required state,
    bool? create,
    TeamModel? teamModel,
  }) {
    if (manager.isBottomSheetOpened) {
      Navigator.pop(context);
      manager.isBottomSheetOpened = false;
    } else {
      manager.isBottomSheetOpened = true;
      key.currentState!
          .showBottomSheet((context) {
            return create ?? true
                ? LayoutWidgets.scaffoldCreateTeamBottomSheet(
                    context: context,
                    text: 'Team Name',
                    controller: manager.newTeam,
                    state: state,
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      bigButton(
                        context: context,
                        text: 'Edit',
                        onPressed: () {},
                      ),
                      bigButton(
                          context: context,
                          text: 'Delete',
                          onPressed: () {
                            manager.deleteTeam(teamModel!.id, teamModel.level);
                          },
                          color: Colors.red),
                    ],
                  );
          })
          .closed
          .then((value) {
            manager.isBottomSheetOpened = false;
          });
    }
  }

  static Widget colorButtonPalette(context) => InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Pick a color!'),
              content: SingleChildScrollView(
                child: ColorPicker(
                  pickerColor: LayoutManager.get(context).color,
                  onColorChanged: (color) {
                    LayoutManager.get(context).currentColor(color);
                  },
                ),
                // Use Material color picker:
                //
                // child: MaterialPicker(
                //   pickerColor: pickerColor,
                //   onColorChanged: changeColor,
                //   showLabel: true, // only on portrait mode
                // ),
                //
                // Use Block color picker:
                //
                // child: BlockPicker(
                //   pickerColor: currentColor,
                //   onColorChanged: changeColor,
                // ),
                //
                // child: MultipleChoiceBlockPicker(
                //   pickerColors: currentColors,
                //   onColorsChanged: changeColors,
                // ),
              ),
              actions: <Widget>[
                ElevatedButton(
                  child: const Text('Got it'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        },
        child: Container(
          width: 20,
          height: 20,
          color: LayoutManager.get(context).color,
        ),
      );
}
