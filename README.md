# mybt
Flutterの設計検証を行うリポジトリ。  
設計検証なので不完全なアプリとなっている。例えば初回起動時に登録したニックネームやメアドを編集する画面がなかったりポイントの利用履歴がホーム画面に表示されている。一応、コード内のコメントにも記載。

# 設計概要
View, ViewModel, Repositoryの3層構成とする。  
- ViewModel
  - `ChangeNotifier`で実装し`ChangeNotifierProvder`でアクセスする。各業務フローでViewModelを共有し、そのフローが何らかの形で終了した場合は破棄したいのでautoDisposeをつける。
- Model
  - アプリ全体を通して使うもののみ`StateNotifier`で実装し、`StateNotifierProvider`でアクセスする。それ以外は通常のクラスで実装する。
- Repository
  - 通常のクラスとして実装し`Provider`でアクセスする。配下のlocalパッケージとremoteパッケージのクラスも同じ。
  - LocalDBはHiveを使用しRemote通信はdioを使用する。ただ、実際のAPI通信は行わずDioClientはfake実装している。
  - LocalDBで使うEntityやRemoteのResponseはアプリ内で主にデータのやり取りをするModelクラスとは別にし、Mapperなどを通してアプリで使いやすい形にする。（特にAPIの仕様変更時にモデルクラスの影響を極力少なくするため）

# ViewModelについて
`StateNotifier`を使っていないのは画面に複数の状態を持ち、かつ入力値をmutableで持っても良いかなと思ったため。  
カウンターアプリなど単純な状態管理なら`StateNotifier`で良いが、商用プロダクトでは色々な入力フィールドが相互に絡み合うようなケースが多い。  
単に複数の状態を持つならUIModelのような画面データを集約したモデルクラスを作って`StateNotifier`でやりとりすれば良いが、頻繁に変更される入力フィールドやチェックボックスが多くある場合、StateNotifierにしてしまうとこんな設計になってしまうと思う。
  1. `StateNotifier`のStateに画面の初期ロードデータを持ち、フィールドに入力データをもつ（mutableとimmutableの混在）
  2. 意地でもStateに全て持つ

自分は`StateNotifier`を使うなら2を採用するが、これで実装してみたらcopyWithメソッドの嵐になったのでちょっと立ち止まって検討することにした。  
全画面が複雑なデータを持っているわけはなく（そういうアプリは多分UIを再検討すべき）ほとんどが簡易な画面なので、ならばViewModelによって`ChangeNotifierProvider`と`StateNotifierProvider`を分けるという選択肢もどうかなと思った。  
しかし、この2つは結構使い勝手が違うので統一感がなくなって実装者が混乱してしまうと思い、じゃあどちらかに統一するならmutableを許容して`ChangeNotifierProvider`で行こうと考えた。  

# 各画面のUIステータス
その業務フローに入るメインの画面は必ずViewModelをもち、BaseViewModelを継承することにした。  
（業務フローに入るメインの画面、というのは例えばAndroidでActivity＋複数Fragmentで画面フローを作る場合のActivityのこと）  

BaseViewModelは`OnLoading, OnSuccess, OnError`の3つの状態をもち、View側でこれらの状態に応じたWidgetを生成する。  
初期状態は`OnLoading`になっているので、ViewModelは必ずinit処理を実装し`OnSuccess`か`OnError`に状態をうつす。  
ただ、この実装はとてもモヤモヤしている。  
freezedで状態クラスを生成しているから作成自体は楽だが、状態の変更に`notifyListeners()`を呼ぶ必要があるので忘れないよう`BaseViewModel`で各状態へ遷移するメソッドを用意している。  
protectedスコープがないため、Viewからもこれらのメソッドを呼べてしまうしViewModelの処理内でもstateが見えてしまう。書き換えは出来ないのだが可読性が下がる様な気がしなくもない。悪あがきで`state`という変数名はやめてuiをつけている。  
また、これらは画面起動時にしか呼ばず、メインの処理を実行する際はユーザーが画面に何らかのインプットをした後なので、これらの状態を使ってしまうとWidgetの再描画が行われて変な感じになる。（ProgressDialogの様なものを表示して画面は見えていた方がいいと思う）  
そう考えると`FutureBuilder`の方が良いのか、もしくは`ChangeNotifierProvider`から見直す必要があるが`AsyncValue`を使った方がいいのか・・

# その他
## import文について
EffectiveDartには相対パスが望ましいかもと記載があるが強く推奨しているわけではない。  
個人的に相対パスは紛らわしいことと、拡張機能で自動importするとpackage記載になるので一貫性を保つため全てpackage記載にしている。  
参考: https://stackoverflow.com/questions/59693195/flutter-imports-relative-path-or-package  
## ローカル変数について
どれにするか迷った。
1. final [型] argName;
2. [型] argName;
3. var argName;
4. final argName;

本当は1がいいのだろうが、長いので右辺で型が明確な場合はせっかく推論機能もあるし3か4が良いと思う。  
kotlinのvalが採用されていれば迷いなくこれだったのだが、ローカルかつスコープが短ければ可読性に全振りして3でも良いのかなと思った。
ただ、個人的にいつもの癖があるのでこのアプリでは4で行くことにした。（型が完全に不明で可読性に問題があると判断した場合は1も使う）

## 自動生成クラス
freezedやhive,mockitoのテストクラス自動生成のため、最初の1回は必ずrunnerのbuildコマンドを実行する。  
このリポジトリの大きさでも微妙に時間がかかっているのでプロダクトだと工夫しないと辛そうである。
そもそも自動生成はAndroidのdatabindingのように別ディレクトリに生成されると良いのだが・・
`pub run build_runner build`

## flutter_flavorizr
Flavorの検証もしたかったので`flutter_flavorizr`ライブラリを使ってコーヒーアプリ環境と紅茶アプリ環境をそれぞれ作成した。
実行コマンドはそれぞれ以下の通り。
- flutter run --flavor coffee -t lib/main-coffee.dart
- flutter run --flavor tea -t lib/main-tea.dart

## テストについて
このリポジトリではサンプルしかないが、本当はViewModel/Repositoryパッケージ/Modelパッケージでビジネスロジックを持っているクラスは全部テスト書いた方が良いと思う。  
RepositoryクラスでAPI経由で取得したデータをそのまま返すメソッドとか、ViewModelでRepositoryのメソッドを実行するだけとかそういうメソッドはテスト不要だと思う。（前者はAPIクラスがあるはずなのでそのテストを、後者はRepositoryの該当メソッドをテストすれば良いので。）  
ただ、その後の機能追加/改修案件をやるときに、既存のメソッドに変なコードを追加していないか検証する目的なら全てのメソッドのテストを書いた方が安心感が増すと思う。どこまで書くかはプロジェクトによって相談か。  
あと、WidgetテストとIntegrationテストはどこまで実装するのがいいのだろうか・・。特にWidgetテストで、まだ自分が有用性を見出せていないので要学習。  