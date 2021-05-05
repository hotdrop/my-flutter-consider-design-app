import 'package:flutter_test/flutter_test.dart';
import 'package:mybt/common/app_extension.dart';

void main() {
  test('埋め込み文字に数値が指定できる', () {
    final str = 'アイウエオ%d1';
    final result = str.embedded(<int>[100]);
    expect(result, 'アイウエオ100');
  });
  test('埋め込み文字に文字列が指定できる', () {
    final str = 'テスト%s1';
    final result = str.embedded(<String>['アイウエオ']);
    expect(result, 'テストアイウエオ');
  });
  test('埋め込み文字に数値が複数指定できる', () {
    final str = '私の戦闘力は%d1です。フロストは%d2です。';
    final result = str.embedded(<int>[530000, 200]);
    expect(result, '私の戦闘力は530000です。フロストは200です。');
  });
  test('埋め込み文字に文字列が複数指定できる', () {
    final str = '%s1は%s2が使える。';
    final result = str.embedded(<String>['ヒット', '時飛ばし']);
    expect(result, 'ヒットは時飛ばしが使える。');
  });
  test('埋め込み文字に数値と文字列が複数指定できる', () {
    final str = '%s1は%d1円、%s2は%d2円';
    final result = str.embedded(<dynamic>['パン', 100, 'おにぎり', 300]);
    expect(result, 'パンは100円、おにぎりは300円');
  });
}
