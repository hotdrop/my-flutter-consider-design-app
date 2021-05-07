enum Flavor { coffee, tea }

class F {
  static Flavor? appFlavor;

  static String get title {
    switch (appFlavor) {
      case Flavor.coffee:
        return 'コーヒー';
      case Flavor.tea:
        return '紅茶';
      default:
        return 'コーヒー';
    }
  }
}
