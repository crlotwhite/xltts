import 'package:flutter/material.dart';
import 'package:xltts/page/start.dart';
import 'package:xltts/page/stt.dart';
import 'package:xltts/page/tts.dart';

void returnFirst(context) {
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => const StartPage()));
}

void goToStt(context, int orgLang) {
  Navigator.pushReplacement(context,
      MaterialPageRoute(builder: (context) => STTPage(orgLang: orgLang)));
}

void goToTts(context, int orgLang) {
  Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => TTSPage(
                orgLang: orgLang,
              )));
}

void showReturnFirstAlertDialog(BuildContext context) {
  Widget okButton = TextButton(
      onPressed: () {
        returnFirst(context);
      },
      child: const Text('Ok'));
  Widget noButton = TextButton(
      onPressed: () {
        Navigator.pop(context);
      },
      child: const Text('No'));

  AlertDialog alert = AlertDialog(
      title: const Text('Alert'),
      content: const Text('Do you want to return the first page?'),
      actions: [okButton, noButton]);

  showDialog(
      context: context,
      barrierDismissible: false,
      builder: ((BuildContext context) {
        return alert;
      }));
}

void showGoToSttAlertDialog(BuildContext context, int org) {
  Widget okButton = TextButton(
      onPressed: () {
        goToStt(context, org);
      },
      child: const Text('Ok'));
  Widget noButton = TextButton(
      onPressed: () {
        Navigator.pop(context);
      },
      child: const Text('No'));

  AlertDialog alert = AlertDialog(
      title: const Text('Alert'),
      content: const Text(
          'Do you want to go Speech to Text page?\n(English is only supported.)'),
      actions: [okButton, noButton]);

  showDialog(
      context: context,
      barrierDismissible: false,
      builder: ((BuildContext context) {
        return alert;
      }));
}

void showGoToTtsAlertDialog(BuildContext context, int org) {
  Widget okButton = TextButton(
      onPressed: () {
        goToTts(context, org);
      },
      child: const Text('Ok'));
  Widget noButton = TextButton(
      onPressed: () {
        Navigator.pop(context);
      },
      child: const Text('No'));

  AlertDialog alert = AlertDialog(
      title: const Text('Alert'),
      content: const Text('Do you want to return Text to speech page?'),
      actions: [okButton, noButton]);

  showDialog(
      context: context,
      barrierDismissible: false,
      builder: ((BuildContext context) {
        return alert;
      }));
}

String getLanguageText(int langCode) {
  switch (langCode) {
    case 0:
      return 'English (US)';
    case 2:
      return 'Japanese (JP)';
    case 1:
      return 'Korean (KR)';
    default:
      return 'NaN';
  }
}

int detectLanguage(String target) {
  var english = RegExp(r'[a-zA-Z]');
  var japanese = RegExp(r'[\u3040-\u309F]');
  var korean = RegExp(r'[\uAC00-\uD7AF]');

  if (english.hasMatch(target)) {
    return 0;
  } else if (japanese.hasMatch(target)) {
    return 1;
  } else if (korean.hasMatch(target)) {
    return 2;
  } else {
    return -1;
  }
}
