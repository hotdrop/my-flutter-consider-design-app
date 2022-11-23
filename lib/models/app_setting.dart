class AppSetting {
  AppSetting({this.userId, this.nickName, this.email});

  final String? userId;
  final String? nickName;
  final String? email;

  bool isInitialized() {
    return userId != null;
  }
}
