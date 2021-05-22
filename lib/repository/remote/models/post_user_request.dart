import 'package:mybt/repository/remote/models/request.dart';

class PostUserRequest extends Request {
  const PostUserRequest(this.nickname, this.email);

  final String? nickname;
  final String? email;

  @override
  Map<String, Object?>? body() {
    return {'nickname': nickname, 'email': email};
  }

  @override
  Map<String, Object?>? urlParam() {
    return null;
  }
}
