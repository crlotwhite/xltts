import 'package:flutter/material.dart';

void showWaitDiagramWithMessage(BuildContext context, String message) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        elevation: 3.0,
        child: Container(
          height: 300.0,
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Transform.scale(
                  scale: 1.5,
                  child: const CircularProgressIndicator(),
                ),
              ),
              const Padding(padding: EdgeInsets.all(20.0)),
              Text(
                message,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 24.0),
              ),
            ],
          ),
        ),
      );
    },
  );
}
