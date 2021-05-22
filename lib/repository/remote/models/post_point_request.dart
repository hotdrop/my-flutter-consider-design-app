import 'package:mybt/repository/remote/models/request.dart';

class PostPointRequest extends Request {
  const PostPointRequest(this.userId, this.inputPoint) : super();

  final String userId;
  final int inputPoint;

  @override
  Map<String, Object?>? urlParam() {
    return {'userId': userId};
  }

  @override
  Map<String, Object?>? body() {
    return {'inputPoint': inputPoint};
  }
}
