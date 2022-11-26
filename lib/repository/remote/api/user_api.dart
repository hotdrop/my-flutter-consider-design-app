import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mybt/repository/remote/http_client.dart';
import 'package:mybt/repository/remote/models/post_user_request.dart';
import 'package:mybt/repository/remote/models/user_response.dart';

final userApiProvider = Provider((ref) => UserApi(ref));

class UserApi {
  const UserApi(this._ref);

  final Ref _ref;

  Future<String> create(String? nickname, String? email) async {
    final response = await _ref.read(httpClient).post(
          '/user',
          request: PostUserRequest(nickname, email),
        );

    final userResponse = UserResponse.mapper(response);

    return userResponse.userId;
  }
}
