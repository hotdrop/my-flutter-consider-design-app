import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mybt/models/app_setting.dart';
import 'package:mybt/repository/app_setting_repository.dart';
import 'package:mybt/repository/history_repository.dart';
import 'package:mybt/repository/point_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:mybt/models/history.dart';
import 'package:mybt/models/point.dart';

part 'home_view_model.g.dart';

@riverpod
class HomeViewModel extends _$HomeViewModel {
  @override
  Future<void> build() async {
    final appSetting = await ref.read(appSettingRepositoryProvider).find();
    final currentPoint = await ref.read(pointRepositoryProvider).find();
    final histories = await ref.read(historyRepositoryProvider).findAll();
    ref.read(_uiStateProvider.notifier).state = _UiState(appSetting, currentPoint, histories);
  }
}

final _uiStateProvider = StateProvider<_UiState>((_) => _UiState.empty());

class _UiState {
  _UiState(this.appSetting, this.currentPoint, this.histories);

  factory _UiState.empty() {
    return _UiState(AppSetting(), const Point(0), []);
  }

  final AppSetting appSetting;
  final Point currentPoint;
  final List<History> histories;

  _UiState copyWith({AppSetting? appSetting, Point? currentPoint, List<History>? histories}) {
    return _UiState(
      appSetting ?? this.appSetting,
      currentPoint ?? this.currentPoint,
      histories ?? this.histories,
    );
  }
}

final homeAppSettingProivder = Provider((ref) {
  return ref.watch(_uiStateProvider).appSetting;
});

final homeCurrentPointProvider = Provider((ref) {
  return ref.watch(_uiStateProvider).currentPoint;
});

final homeHistoriesProvider = Provider((ref) {
  return ref.watch(_uiStateProvider).histories;
});
