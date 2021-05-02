import 'common_strings.dart';

class Strings extends CommonStrings {
  Strings._({required this.splashOverview});

  factory Strings.createCoffee() {
    return Strings._(splashOverview: 'コーヒータイプのアプリです。');
  }

  final String splashOverview;
}
