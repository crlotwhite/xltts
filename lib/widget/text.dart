import 'package:flutter/material.dart';

Widget createHeadline(String text) {
  return Padding(
    padding: const EdgeInsets.all(10),
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 85.0,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
  );
}

Widget createSubline(String text) {
  return Padding(
    padding: const EdgeInsets.all(10),
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 24.0,
        fontWeight: FontWeight.normal,
        color: Colors.white,
      ),
    ),
  );
}

Widget createHeadline2(String text) {
  return Text(
    text,
    style: const TextStyle(
      fontSize: 32.0,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
  );
}
