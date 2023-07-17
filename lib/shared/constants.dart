import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

double width(context, size) => MediaQuery.sizeOf(context).width * size;
double height(context, size) => MediaQuery.sizeOf(context).height * size;

navigateTo(context, page) =>
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));

void replacePage(context, page) {
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => page));
}

Widget fallBackIndicator() => const Center(child: CircularProgressIndicator());

Widget bigButton({
  required BuildContext context,
  required String text,
  required Function() onPressed,
  Color? color,
}) =>
    Padding(
      padding: const EdgeInsets.all(10.0),
      child: MaterialButton(
          color: color ?? Colors.blue,
          minWidth: width(context, 1),
          onPressed: onPressed,
          child: Text(text.toUpperCase())),
    );

Widget smallButton({
  required String text,
  required Function() onPressed,
  Color? color,
}) =>
    ElevatedButton(
      style: ButtonStyle(
          backgroundColor:
              MaterialStateColor.resolveWith((states) => color ?? Colors.blue)),
      onPressed: onPressed,
      child: Text(text),
    );

enum ToastStates { success, warning, error }

Color toastColor(ToastStates state) {
  Color color;
  switch (state) {
    case ToastStates.success:
      color = Colors.green;
      break;
    case ToastStates.warning:
      color = Colors.amber;
      break;
    case ToastStates.error:
      color = Colors.red;
      break;
  }
  return color;
}

void volleyToast({
  required String message,
  required ToastStates state,
}) =>
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: toastColor(state),
      textColor: Colors.white,
      fontSize: 16.0,
    );
