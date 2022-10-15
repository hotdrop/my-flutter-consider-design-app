import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_response.freezed.dart';
part 'user_response.g.dart';

@freezed
class UserResponse with _$UserResponse {
  factory UserResponse(String userId) = _UserResponse;

  factory UserResponse.fromJson(Map<String, Object?> json) => _$UserResponseFromJson(json);

  static UserResponse mapper(Map<String, Object?> response) {
    return UserResponse.fromJson(response);
  }
}
