extension StringExtension on String {
  String embedded(List<dynamic> args) {
    int index = 1;
    String result = this;
    args.whereType<int>().forEach((i) {
      result = result.replaceFirst('%d$index', '$i');
      index++;
    });
    index = 1;
    args.whereType<String>().forEach((s) {
      result = result.replaceFirst('%s$index', s);
      index++;
    });
    return result;
  }
}
