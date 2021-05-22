import 'package:freezed_annotation/freezed_annotation.dart';

part 'point_response.freezed.dart';
part 'point_response.g.dart';

@freezed
abstract class PointResponse with _$PointResponse {
  factory PointResponse(int point) = _PointResponse;

  factory PointResponse.fromJson(Map<String, Object?> json) => _$PointResponseFromJson(json);

  static PointResponse mapper(Map<String, Object?> response) {
    return PointResponse.fromJson(response);
  }
}
