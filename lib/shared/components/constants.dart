String? uId = "872";
void printFullText(String text) {
  final pattern = RegExp('.{1,800}');

  pattern.allMatches(text).forEach((match) => print(match.group));
}
