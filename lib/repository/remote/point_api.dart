import 'package:mybt/models/point.dart';

class PointApi {
  const PointApi._();

  factory PointApi.create() {
    return PointApi._();
  }

  Future<List<Point>> find(String accountNo) async {
    // TODO APIでポイントを持ってくる
    return <Point>[
      Point(balance: 320, name: 'コーヒーポイント'),
      Point(balance: 250, name: 'モカポイント'),
    ];
  }
}
