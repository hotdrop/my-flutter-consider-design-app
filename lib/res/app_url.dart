class AppUrl {
  AppUrl._({
    required this.api,
  });

  factory AppUrl.createCoffee() {
    return AppUrl._(
      api: 'https://fake.mybt.coffee.jp/api/v1',
    );
  }

  final String api;
}
