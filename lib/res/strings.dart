import 'common_strings.dart';

class Strings extends CommonStrings {
  Strings._({required this.splashOverview});

  factory Strings.createCoffee() {
    return Strings._(splashOverview: 'コーヒータイプのアプリです。');
  }

  factory Strings.createTea() {
    return Strings._(splashOverview: '紅茶タイプのアプリです。');
  }

  final String splashOverview;
}
