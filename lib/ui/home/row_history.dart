import 'package:flutter/material.dart';
import 'package:mybt/models/history.dart';
import 'package:mybt/res/res.dart';
import 'package:mybt/ui/widgets/app_text.dart';

class RowHistory extends StatelessWidget {
  const RowHistory({super.key, required this.history});

  final History history;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      child: ListTile(
        title: Text(history.toStringDateTime()),
        subtitle: AppText.normal(history.detail),
        trailing: AppText.large('${history.point} ${R.res.strings.pointUnit}'),
      ),
    );
  }
}
