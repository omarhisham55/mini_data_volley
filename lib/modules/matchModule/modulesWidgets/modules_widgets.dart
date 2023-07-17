import 'package:flutter/material.dart';

import '../../../shared/constants.dart';

class MatchWidgets {
  static Widget buildTeamNumberCards({
    required BuildContext context,
    required String teamName,
    required List<TextEditingController> positionControllers,
    required TextEditingController setterController,
    MainAxisAlignment? sixBlocksAlignment,
    AlignmentDirectional? setterAlignment,
    double? setterPadding,
    Function(String)? onChanged,
  }) =>
      SizedBox(
        height: height(context, .31),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: sixBlocksAlignment ?? MainAxisAlignment.start,
              children: [
                Text(teamName),
                const SizedBox(height: 10.0),
                Wrap(
                  spacing: 10.0,
                  runSpacing: 10.0,
                  children: List.generate(
                    6,
                    (index) => squareTextField(
                      context: context,
                      textFieldController: positionControllers[index],
                      onChanged: (value) {
                        if (value.length == 2) {
                          FocusScope.of(context).nextFocus();
                        }
                        if (value.isEmpty) {
                          FocusScope.of(context).previousFocus();
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
            Align(
              alignment: setterAlignment ?? AlignmentDirectional.bottomEnd,
              child: Padding(
                padding: EdgeInsets.all(setterPadding ?? 0.0),
                child: CircleAvatar(
                  backgroundColor: Colors.amber,
                  radius: 35.0,
                  child: TextFormField(
                    controller: setterController,
                    maxLength: 2,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 35.0),
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: 'S',
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      contentPadding: EdgeInsets.only(top: 30.0),
                    ),
                    onChanged: onChanged,
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  static Widget squareTextField({
    required BuildContext context,
    required TextEditingController textFieldController,
    Color? color,
    Color? textColor,
    Function(String)? onChanged,
  }) =>
      Container(
        width: width(context, .3),
        height: 80,
        color: color ?? const Color.fromARGB(255, 0, 0, 0),
        child: TextFormField(
          controller: textFieldController,
          maxLength: 2,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 35.0, color: textColor),
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
              hintText: '0',
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 15.0)),
          onChanged: onChanged,
        ),
      );

  static Future<void> friendlyDialog({
    required BuildContext context,
    required Function() yesFunction,
    required Function() noFunction,
  }) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Is it friendly match??'),
          content: const Text('This action can be changed later.'),
          actions: [
            TextButton(
              onPressed: yesFunction,
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: noFunction,
              child: const Text('No'),
            ),
          ],
        );
      },
    );
  }
}
