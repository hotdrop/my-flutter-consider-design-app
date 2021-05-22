import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mybt/models/user.dart';
import 'package:mybt/repository/remote/http_client.dart';
import 'package:mybt/repository/remote/models/post_user_request.dart';
import 'package:mybt/repository/remote/models/user_response.dart';

final userApiProvider = Provider((ref) => UserApi(ref.read));

class UserApi {
  const UserApi(this._read);

  final Reader _read;

  Future<User> create(String? nickname, String? email) async {
    final response = await _read(httpClient).post(
      '/user',
      request: PostUserRequest(nickname, email),
    );

    final userResponse = UserResponse.mapper(response);

    return User(userResponse.userId);
  }
}
