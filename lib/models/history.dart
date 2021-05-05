class History {
  const History({
    required this.dateTime,
    required this.point,
    required this.detail,
  });

  final DateTime dateTime;
  final int point;
  final String detail;
}
