# mybt
Flutter開発する際に設計検討で使っているアプリです。  
設計検討が目的なのでこのアプリ自体は機能が不十分だったり不足があります。  
（例えば初回起動時に登録したニックネームやメアドを編集する画面がなかったりポイントの利用履歴がホーム画面に表示されているなど）  

# アプリ概要
miroで作成した画面フローのスクリーンショット  
![01_start](./screenshot/01_起動処理フロー.png)  
![02_business](./screenshot/02_ポイント獲得と利用フロー.png)

# 設計概要
View, ViewModel, Repositoryの3層構成にしています。  
- ViewModel
  - `StateNotifierProvder`で実装しています。1つの業務フロー（ポイント獲得やポイント利用といった単位）で1つのViewModelを作り、フロー終了とともにautoDisposeで破棄されるようにしています。
- Model
  - アプリ全体を通して使うものは`Notifier`で実装するようにしており、それ以外は通常のクラスとなります。
  - <追記> 
     - Riverpod2.0対応で`StateNotifierProvider`を`Notifier`に変更したらだいぶコードがスッキリしました。ただModelクラスのNotifierクラスの名称をどうするか悩んでいます。Widget側からアクセスする場合はNotifierクラスになるので、できれば「モデルクラス＋Provider」という名前でアクセスしたいです。
     - 現在は仕方ないので`Notifier`クラスは`Notifier`というプレフィックスをつけています。
- Repository
  - 通常のクラスで実装し`Provider`でアクセスします。配下のlocalパッケージとremoteパッケージのクラスも同じです。
  - ここは`riverpod_annotation`を使うと、無駄に自動生成クラスが多くなるし引数も取らない（familyは使わない）のでそのままにしています。
  - LocalDBはHiveを使用しRemote通信はdioを使用しています。ただ、実際のAPI通信は行わずDioClientはfake実装しています。
  - LocalDBで使うEntityやRemoteのResponseはアプリ内で主にデータのやり取りをするModelクラスとは別にし、Mapperなどを通してアプリで使いやすい形にしています。（特にAPIの仕様変更時にモデルクラスの影響を極力少なくするためです。）

# 状態管理
`Riverpod`を使っています。  
カウンターアプリなど単純な状態管理なら`StateProvider`で良いのですが、商用プロダクトでは色々な入力フィールドが相互に絡み合うようなケースが多いです。  

そのため、複数の状態を持つならUIModelのような画面データを集約したモデルクラスを作って`StateNotifier`でやりとりするのが良いかなと思っています。
[AndroidDeveloperサイトのUILayer](https://developer.android.com/jetpack/guide/ui-layer)にも記載されたとおりUIStateとして定義されました。

ただ、当然画面によって管理する状態数は異なるので、`UiState`として分けるより`StateProvider`で管理した方が圧倒的に楽なケースもあります。
そもそも、管理する状態数が多い、ユーザーの入力コンポーネントが20とかある画面はそもそもUI設計を見直せという話もありますが業務でやる場合は理想論だけでは難しいです。

とはいえ画面によって作りを変えると「じゃあ状態管理が何個までなら`StateProvider`でやっていいんだ？となりますので設計は少なくとも1アプリ内では統一した方がいいと思っています。

とりあえず2022年5月の改修時点では`UiState`で統一しています。

# ViewModelの作成単位
その業務フローに入るメインの画面は必ずViewModelを持つようにしました。  
（業務フローに入るメインの画面、というのは例えばAndroidでActivity＋複数Fragmentで画面フローを作る場合のActivityのこと）  

# import文
EffectiveDartには相対パスが望ましいかもと記載があるが強く推奨しているわけではないようです。  
個人的に相対パスは紛らわしいことと、拡張機能で自動importするとpackage記載になるので一貫性を保つため全てpackage記載にしています。  
参考: https://stackoverflow.com/questions/59693195/flutter-imports-relative-path-or-package  

# テスト
このリポジトリではサンプルしかありませんが、本当はViewModel/Repositoryパッケージ/Modelパッケージでビジネスロジックを持っているクラスは全部テスト書いた方が良いと思います。  

RepositoryクラスでAPI経由で取得したデータをそのまま返すメソッドとか、ViewModelでRepositoryのメソッドを実行するだけとかそういうメソッドはテスト不要だと思います。  
（前者はAPIクラスがあるはずなのでそのテストを、後者はRepositoryの該当メソッドをテストすれば良いので。）  

ただ、その後の機能追加/改修案件をやるときに既存のメソッドに変なコードを追加していないか検証する目的なら全てのメソッドのテストを書いた方が安心感が増します。  
どこまで書くかはコストとスケジュール次第なのでプロジェクトによって相談だと思います。  

あと、WidgetテストとIntegrationテストはどこまで実装するのがいいかは未解決です。特にWidgetテストで、まだ自分が有用性を見出せていないので要学習。  

## パフォーマンス測定
私はvscodeで開発しているため、profileでビルドし`Dart DevTools`を使ってパフォーマンスモニターをしています。  
```
flutter run --flavor coffee -t lib/main_coffee.dart --profile --cache-sksl --purge-persistent-cache
```