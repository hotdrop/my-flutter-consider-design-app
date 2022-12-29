# mybt
Flutter開発する際に設計検討で使っているアプリです。  
設計検討が目的なのでこのアプリ自体は機能が不十分だったり不足があります。  
（例えば初回起動時に登録したニックネームやメアドを編集する画面がなかったりポイントの利用履歴がホーム画面に表示されているなど）  

# アプリ概要
miroで作成した画面フローのスクリーンショット  
![01_start](./screenshot/01_起動処理フロー.png)  
![02_business](./screenshot/02_ポイント獲得と利用フロー.png)

# 状態管理
`Riverpod 2.0`とannotationを利用しています。  
私の中でProviderが状態管理手法で落ち着いた後、Providerから移行し`ChangeNotifierProvider`→`StateNotifierProvider`→`Notifier`と変遷しています。  
絶賛、試行錯誤中です。

# 設計概要
View, ViewModel, Repositoryの3レイヤー構成にしています。  
- ViewModel
  - Annotationを使用した`AsyncNotifier`で実装しています。ファーストビューに非同期で取得したいデータがなければ通常の`Notifier`で良いと思います。
  - ViewModelは1業務フロー（ポイント獲得やポイント利用といった単位）1ViewModelとしています。
  - ViewModelにはロジックを持ち、画面のデータは後述する`UiState`としてまとめて`StateProvider`で持っています。（各々の値はselectでwatchする）
  - もうViewModelではないので`Provider`か`Controller`にでも名前変えた方がいいかなと思っています。
- Model
  - `StateNotifierProvider`から`Notifier`と実装を変遷してきて、2022年12月現在はModelクラスをただの箱（JavaでいうPOJO）にしています。理由は以下の通りです。
    1. 値を`Notifier`としてアプリ全体スコープとしてしまうと、ローカルやAPI経由で取得する最新データと`Notifier`で保持するデータを両方最新化し続ける必要があってこれは煩雑でバグを生みやすいと思った。
    2. キャッシュとして持つのであれば、FutureProviderやAsyncNotifierで事足りる。
    3. FutureProviderが個人的につらかった点は値をキャッシュしてしまうので最新値を取得する場合にrefresh関数などを自作する必要があった。autoDisposeがきくフローであれば良いが、アプリの基底にあるホーム画面などautoDisposeが効かない画面は辛い。が、`invalidate`というメソッドがあることを知った。
  - 一方で、Modelクラスを経由してデータのCRUDを行うのはアーキテクチャ的に全く問題ないと思っていて **ある種のデータは必ずそのProvider内でやり取りする** ということを徹底すれば元の`Notifier`実装でもいいのかなと悩んでいます。まあ、UIのデータは複数のModelクラスのデータを扱う一方で、Modelクラスは業務の意味のある単位（UIに依存しない単位）にしたいので結局今のようにしました。
- Repository
  - 通常のクラスで実装し`Provider`でアクセスします。配下のlocalパッケージとremoteパッケージのクラスも同じです。
  - ここは`riverpod_annotation`は使っていません。無駄に自動生成クラスが多くなるし引数も取らない（`family`は使わない）ためです。
  - LocalDBは`Hive`を使用しRemote通信は`dio`を使用しています。ただ、実際のAPI通信は行わず`DioClient`はfake実装しています。
  - LocalDBで使う`Entity`やRemoteの`Response`はアプリ内で主にデータのやり取りをするModelクラスとは別にし、Mapperなどを通してアプリで使いやすい形にしています。（特にAPIの仕様変更時にモデルクラスの影響を極力少なくするためです。）

# 状態管理
大きく2種類かなと思っています。  
1. アプリ設定値やログインユーザー情報などアプリ全体で使用するデータ→グローバルにアクセスする
2. ユーザーの入力値や選択値など各々の業務フローでのみ使用するデータ→ViewModelの`UiState`として定義する
これはコードでは縛れないので約束事として縛る感じになると思います。（protectedが欲しい・・）  

`UiState`というのは画面データを集約したクラスで[AndroidDeveloperサイトのUILayer](https://developer.android.com/jetpack/guide/ui-layer)を参考にしました。  

`UiState`はちょっと悩んでいます。`UiState`で持つより個々で`StateProvider`を用意する方がシンプルに書けるかなと思っており、そもそも「管理する状態数が多い、例えばユーザーの入力コンポーネントが20とかある画面はそもそもUI設計を見直せ」という話もStackOverflowでありました。  
しかし、業務でやる場合は理想論だけでは難しく、とりあえず2022年5月の改修時点では`UiState`で統一しています。  

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
