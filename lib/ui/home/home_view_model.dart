import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mybt/repository/history_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:mybt/models/history.dart';
import 'package:mybt/models/point.dart';

part 'home_view_model.g.dart';

@riverpod
class HomeViewModel extends _$HomeViewModel {
  @override
  Future<void> build() async {
    await ref.read(pointProvider.notifier).refresh();
    final histories = await ref.read(historyRepositoryProvider).findAll();
    ref.read(_uiStateProvider.notifier).state = _UiState(histories);
  }
}

final _uiStateProvider = StateProvider<_UiState>((_) => _UiState.empty());

class _UiState {
  _UiState(this.histories);

  factory _UiState.empty() {
    return _UiState([]);
  }

  final List<History> histories;
}

final historiesProvider = Provider((ref) => ref.watch(_uiStateProvider).histories);
