import 'package:flutter/material.dart';
import '../util/utils.dart';

Widget getReturnFloating(context) {
  return FloatingActionButton(
    onPressed: () {
      showReturnFirstAlertDialog(context);
    },
    child: const Icon(
      Icons.arrow_back,
      color: Colors.white,
    ),
  );
}
