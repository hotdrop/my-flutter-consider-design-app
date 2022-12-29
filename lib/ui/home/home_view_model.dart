import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    final currentPoint = await ref.read(pointRepositoryProvider).find();
    final histories = await ref.read(historyRepositoryProvider).findAll();
    ref.read(_uiStateProvider.notifier).state = _UiState(currentPoint, histories);
  }
}

final _uiStateProvider = StateProvider<_UiState>((_) => _UiState.empty());

class _UiState {
  _UiState(this.currentPoint, this.histories);

  factory _UiState.empty() {
    return _UiState(const Point(0), []);
  }

  final Point currentPoint;
  final List<History> histories;
}

final homeCurrentPointProvider = Provider((ref) {
  return ref.watch(_uiStateProvider.select((value) => value.currentPoint));
});

final homeHistoriesProvider = Provider((ref) {
  return ref.watch(_uiStateProvider).histories;
});
