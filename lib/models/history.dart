import 'package:intl/intl.dart';

class History {
  const History({
    required this.dateTime,
    required this.point,
    required this.detail,
  });

  final DateTime dateTime;
  final int point;
  final String detail;

  String toStringDateTime() {
    return DateFormat('yyyy/MM/dd HH:mm').format(dateTime);
  }
}
