# mybt
Flutterの設計検証を行うリポジトリ。

# design
View,ViewModel,Repositoryの3層構成とする。  
ViewModelは`ChangeNotifierProvider`で実装し、Modelでアプリ全体を通して使うものは`StateNotifier`で実装する。  

