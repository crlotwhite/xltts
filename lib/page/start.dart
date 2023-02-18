import 'package:flutter/material.dart';

import 'package:xltts/page/selectlaguage.dart';
import 'package:xltts/widget/text.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Colors.blue,
            Colors.red,
          ],
        )),
        child: Center(
          child: ConstrainedBox(
            constraints:
                const BoxConstraints.tightFor(width: 500.0, height: null),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                createHeadline('XL-TTS DEMO'),
                createSubline(
                    'Hello, this is XL-TTS: Cross-lingual Text to Speech Demo!'),
                const Padding(padding: EdgeInsets.all(20.0)),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      elevation: 3, minimumSize: const Size(300.0, 90.0)),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => const SelectLanguage())));
                  },
                  child: const Text(
                    "Start",
                    style: TextStyle(
                      fontSize: 36.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
