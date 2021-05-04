# mybt
Flutterの設計検証を行うリポジトリ。

# 設計概要
View, ViewModel, Repositoryの3層構成とする。  
- ViewModel
  - `ChangeNotifierProvider`で実装。autoDisposeをつけ、参照が切れたら破棄する
- Model
  - アプリ全体を通して使うもののみ`StateNotifier`で実装
- Repository
  - `Provider`で実装。コンストラクタにconstをつける（ミュータブルなフィールドを持たない）

# ViewModelについて
`StateNotifier`を使っていないのは画面に複数の状態を持ちたかったため。  
カウンターアプリなど1種類の状態しかない場合は`StateNotifier`で良いが、商用プロダクトでは色々な入力フィールドが相互に絡み合うようなケースが多い。  
ViewModelによって`ChangeNotifierProvider`と`StateNotifierProvider`を分けると統一感がなくなって混乱するし、画面の状態を全部持つUIModel的なクラスを作成するのも微妙だと思って`ChangeNotifierProvider`を採用した。
# 各画面のUIステータス
その業務フローに入るメインの画面は必ずViewModelをもち、BaseViewModelを継承することにした。  
（業務フローに入るメインの画面、というのは例えばAndroidでActivity＋複数Fragmentで画面フローを作る場合のActivityのこと）  
BaseViewModelは`OnLoading,OnSuccess,OnError`の3つの状態をもち、View側でこれらの状態に応じたWidgetを生成する。  
初期状態は`OnLoading`になっているので、ViewModelは必ずinit処理を実装し`OnSuccess`か`OnError`に状態をうつす。  
## 迷っていること
freezedで状態クラスを生成しているが、状態の変更に`notifyListeners()`を呼ぶ必要があるのでBaseViewModelで各状態へ遷移するメソッドを用意している。protectedスコープがないのでViewからもこれらのメソッドを呼べてしまうのがモヤモヤしている。  
`FutureBuilder`を使うことも検討したが、画面によっては特殊なことをしたいので各状態をViewModel側で制御できた方が都合が良いなと思った。
`AsyncValue`を使ってもよかったが、画面起動処理に複数データが必要な場合はそれらをまとめたModelクラスを別途作る必要があるのがモヤモヤして採用は見送った。（ひょっとしたらこっちの方がいいかもしれない。）
