# mybt
Flutterの設計検証を行うリポジトリ。

# 設計概要
View, ViewModel, Repositoryの3層構成とする。  
- ViewModel: `ChangeNotifierProvider`で実装
  - autoDisposeで参照が切れたら破棄させる
- Model
  - アプリ全体を通して使うもののみ`StateNotifier`で実装
- Repository: 普通にクラスを実装し、`Provider`で購読
  - コンストラクタにconstをつける（ミュータブルなフィールドを持たない）

# 迷っていること
# appSettingsの仕様
アプリ起動時に必要な初期処理をどこでやろうか迷っている。
mainやappで直接HiveやSharedPreferencesの初期化を行いたくなかったため以下の案を検討した。
- アプリ初期起動ページのViewModelを作る
- アプリ設定のようなModelクラスを作る
いつも前者で実装していたが、このアプリではRiverpodを使っていることもあり後者で実装してみることにした。

# Repositoryのlocalパッケージについて
Hiveを初期化してそれぞれBoxを作るため、DaoをLocalDataSourceクラス（singleton）に持ってしまっている。
本当は使わないDaoはインスタンス化したくないので呼び出すたびにクラスを生成した方が良いと思う。
本当はDagger2の`@Reusable`のような動きにしたいのだが・・

