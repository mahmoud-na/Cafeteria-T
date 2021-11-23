import 'package:flutter/cupertino.dart';

String? uId;
const int timeLimitAllowed = 16;
const int delayTime = 6;
const int errorTempTime=10;
late final Widget? qrImage;

void printFullText(String text) {
  final pattern = RegExp('.{1,800}');

  pattern.allMatches(text).forEach((match) => print(match.group));
}
