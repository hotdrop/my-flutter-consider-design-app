class AppUrl {
  AppUrl._({
    required this.api,
  });

  factory AppUrl.createCoffee() {
    return AppUrl._(
      api: 'https://fake.mybt.coffee.jp/api/v1',
    );
  }

  factory AppUrl.createTea() {
    return AppUrl._(
      // 本当はteaにすべきだが現状、レスポンスを分けたいケースがないのでcoffeeにする
      // ポイントで購入可能なアイテムを実装することになったら、コーヒー/紅茶個別でアイテムを持って来るような実装にする
      // このアプリは完成させることが目的ではないので、そういう実装をするかは疑問だが。
      api: 'https://fake.mybt.coffee.jp/api/v1',
    );
  }

  final String api;
}
