import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:avatar_glow/avatar_glow.dart';

import 'package:xltts/util/utils.dart';
import 'package:xltts/widget/text.dart';

class STTPage extends StatefulWidget {
  final int orgLang;

  const STTPage({Key? key, required this.orgLang}) : super(key: key);

  @override
  _STTPage createState() => _STTPage();
}

class _STTPage extends State<STTPage> with WidgetsBindingObserver {
  final hostUrl = "127.0.0.1:8000";

  late AudioPlayer player;
  late stt.SpeechToText speech;

  bool isListening = false;
  bool indicatorVisible = false;
  String audioKey = "";
  String input = "";
  String output = "";
  double confidence = 1.0;

  void listen() async {
    if (!isListening) {
      bool available = await speech.initialize(
          onStatus: (val) => print('onStatus: $val'),
          onError: (val) => print('onError: $val'));

      if (available) {
        setState(() => isListening = true);
        speech.listen(
            onResult: (val) => setState(() {
                  input = val.recognizedWords;
                  if (val.hasConfidenceRating && val.confidence > 0) {
                    confidence = val.confidence;
                  }
                }));
      }
    } else {
      setState(() => isListening = false);
      synthesis();
      speech.stop();
    }
  }

  void synthesis() async {
    print('start');

    var client = http.Client();
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
                const Text(
                  "Wait a minute...",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
                ),
              ],
            ),
          ),
        );
      },
    );
    try {
      var response =
          await client.get(Uri.http(hostUrl, "stt", {'text': input}));
      var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;

      print(decodedResponse['key']);
      print(decodedResponse['text']);

      setState(() {
        audioKey = decodedResponse['key']; // audio key
        output = decodedResponse['text']; // generated text
      });
      await player.play(UrlSource(
          "http://${hostUrl}/output/result/LJSpeech/${decodedResponse['key']}.wav"));
    } finally {
      Navigator.pop(context);
      client.close();
    }
  }

  @override
  void initState() {
    super.initState();
    player = AudioPlayer();
    speech = stt.SpeechToText();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Colors.blue, Colors.red],
        )),
        child: Center(
          child: ConstrainedBox(
            constraints:
                const BoxConstraints.tightFor(width: 500.0, height: null),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                createHeadline('Let\'s Demo!'),
                createHeadline2('This is XLTTS Demo\nwith Speech to Text '),
                createSubline('Click mic button and Speak!'),
                const Padding(padding: EdgeInsets.all(10.0)),
                createSubline('Input Text'),
                SingleChildScrollView(
                    reverse: true,
                    child: Container(
                      padding:
                          const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 40.0),
                      child: Text(input),
                    )),
                createSubline('Output Text'),
                SingleChildScrollView(
                    reverse: true,
                    child: Container(
                      padding:
                          const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 40.0),
                      child: Text(output),
                    )),
                const Padding(padding: EdgeInsets.all(10.0)),
                AvatarGlow(
                    animate: isListening,
                    glowColor: Theme.of(context).primaryColor,
                    endRadius: 75.0,
                    duration: const Duration(milliseconds: 2000),
                    repeatPauseDuration: const Duration(milliseconds: 100),
                    repeat: true,
                    child: FloatingActionButton(
                      onPressed: listen,
                      child: Icon(
                        isListening ? Icons.mic : Icons.mic_none,
                        color: Colors.white,
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: ExpandableFab(
        overlayStyle: ExpandableFabOverlayStyle(blur: 5),
        type: ExpandableFabType.up,
        distance: 65.0,
        openButtonHeroTag: null,
        closeButtonHeroTag: null,
        child: const Icon(Icons.menu, color: Colors.white),
        closeButtonStyle: const ExpandableFabCloseButtonStyle(
            child: Icon(Icons.close, color: Colors.white)),
        childrenOffset: const Offset(7, 0),
        children: [
          FloatingActionButton.small(
            onPressed: () {
              showReturnFirstAlertDialog(context);
            },
            heroTag: null,
            child: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          FloatingActionButton.small(
            onPressed: () {
              showGoToTtsAlertDialog(context, widget.orgLang);
            },
            heroTag: null,
            child: const Icon(Icons.mic_off, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
