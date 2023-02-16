import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';

import 'package:xltts/util/utils.dart';
import 'package:xltts/widget/text.dart';

class TTSPage extends StatefulWidget {
  final int orgLang;

  const TTSPage({Key? key, required this.orgLang}) : super(key: key);

  @override
  _TTSPage createState() => _TTSPage();
}

class _TTSPage extends State<TTSPage> with WidgetsBindingObserver {
  final TextEditingController _textController = TextEditingController();
  String audioKey = "";

  late AudioPlayer player;

  bool indicatorVisible = false;
  final hostUrl = "127.0.0.1:8000";

  var languages = ["English", "Korean"];
  var speakers = [
    "LJSpeech",
  ];

  String curruntLanguage = 'English';
  String curruntSpeaker = 'LJSpeech';

  String get isKorean {
    if (curruntLanguage == 'Korean') {
      return "1";
    } else {
      return "0";
    }
  }

  void synthesis() async {
    if (_textController.text.isEmpty) {
      return;
    }

    // print('start');
    // print(_textController.text);

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
      var response = await client.get(Uri.http(
          hostUrl, "tts", {'text': _textController.text, 'is_kor': isKorean}));
      var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
      // print(decodedResponse['key']);
      setState(() {
        audioKey = decodedResponse['key'];
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
    // print(widget.orgLang);
    // print(widget.xlLang);
    super.initState();
    player = AudioPlayer();
  }

  @override
  void dispose() {
    _textController.dispose();
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
                createHeadline2(
                    'Current Language: ${getLanguageText(widget.orgLang)}'),
                createSubline('Input text and click button!'),
                const Padding(padding: EdgeInsets.all(20.0)),
                Container(
                  padding: const EdgeInsets.all(20.0),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 300.0),
                    child: TextField(
                      controller: _textController,
                      minLines: 3,
                      maxLines: null,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Langauge: ",
                      style: TextStyle(color: Colors.white, fontSize: 18.0),
                    ),
                    const Padding(
                        padding: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0)),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: DropdownButton<String>(
                        value: curruntLanguage,
                        onChanged: (String? newValue) =>
                            setState(() => curruntLanguage = newValue!),
                        items: languages
                            .map<DropdownMenuItem<String>>(
                                (String value) => DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    ))
                            .toList(),
                        icon: const Icon(Icons.arrow_drop_down),
                        iconSize: 42,
                        underline: const SizedBox(),
                      ),
                    ),
                    const Padding(padding: EdgeInsets.all(10.0)),
                    const Text(
                      "Speaker: ",
                      style: TextStyle(color: Colors.white, fontSize: 18.0),
                    ),
                    const Padding(
                        padding: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0)),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: DropdownButton<String>(
                        value: curruntSpeaker,
                        onChanged: (String? newValue) =>
                            setState(() => curruntSpeaker = newValue!),
                        items: speakers
                            .map<DropdownMenuItem<String>>(
                                (String value) => DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    ))
                            .toList(),
                        icon: const Icon(Icons.arrow_drop_down),
                        iconSize: 42,
                        underline: const SizedBox(),
                      ),
                    ),
                  ],
                ),
                const Padding(padding: EdgeInsets.all(20.0)),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      elevation: 3, minimumSize: const Size(300.0, 90.0)),
                  onPressed: () {
                    synthesis();
                  },
                  child: const Text(
                    "Synthesis",
                    style: TextStyle(
                        fontSize: 36.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                const Padding(padding: EdgeInsets.all(20.0)),
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
        childrenOffset: const Offset(6.5, 0),
        children: [
          FloatingActionButton.small(
            heroTag: null,
            child: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              showReturnFirstAlertDialog(context);
            },
          ),
          FloatingActionButton.small(
            heroTag: null,
            child: const Icon(Icons.mic, color: Colors.white),
            onPressed: () {
              showGoToSttAlertDialog(context, widget.orgLang);
            },
          ),
        ],
      ),
    );
  }
}
