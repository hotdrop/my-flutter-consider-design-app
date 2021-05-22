import 'package:mybt/repository/remote/models/request.dart';

class GetPointRequest extends Request {
  const GetPointRequest(this.userId) : super();

  final String userId;

  @override
  Map<String, Object?>? urlParam() {
    return <String, Object?>{'userId': userId};
  }

  @override
  Map<String, Object?>? body() {
    return null;
  }
}
