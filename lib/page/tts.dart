import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:translator/translator.dart';

import 'package:xltts/util/utils.dart';
import 'package:xltts/widget/text.dart';
import 'package:xltts/widget/wait_diagram.dart';

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
  final translator = GoogleTranslator();

  var speakers = [
    "LJSpeech",
  ];
  
  String curruntSpeaker = 'LJSpeech';

  void synthesis(String isKorean) async {
    if (_textController.text.isEmpty) {
      return;
    }

    if (isKorean == "1") {
      showWaitDiagramWithMessage(context, "Translating...");
      var translation =
          await translator.translate(_textController.text, to: 'ko');
      _textController.text = translation.toString();
      Navigator.pop(context);
    }

    var client = http.Client();
    showWaitDiagramWithMessage(context, "Wait a minute...");
    try {
      var response = await client.get(Uri.http(
          hostUrl, "tts", {'text': _textController.text, 'is_kor': isKorean}));
      var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
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
                    Column(
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              elevation: 3,
                              minimumSize: const Size(200.0, 70.0)),
                          onPressed: () {
                            synthesis("0");
                          },
                          child: const Text(
                            "Synthesis in English",
                            style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                        const Padding(padding: EdgeInsets.all(10.0)),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              elevation: 3,
                              minimumSize: const Size(200.0, 70.0)),
                          onPressed: () {
                            synthesis("1");
                          },
                          child: const Text(
                            "Synthesis in Korean",
                            style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        )
                      ],
                    ),
                    const Padding(padding: EdgeInsets.all(10.0)),
                    Column(
                      children: [
                        const Text(
                          "Speaker: ",
                          style: TextStyle(color: Colors.white, fontSize: 22.0),
                        ),
                        const Padding(padding: EdgeInsets.all(15.0)),
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
                    )
                  ],
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
