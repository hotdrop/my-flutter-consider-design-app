import 'package:flutter/material.dart';
import 'package:mybt/res/res.dart';

class AppDialog {
  const AppDialog(
    this._message, {
    this.onOk,
  });

  final String _message;
  final Function? onOk;

  void show(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (_) {
        return _createDialog(context);
      },
    );
  }

  AlertDialog _createDialog(BuildContext context) {
    return AlertDialog(
      content: Text(_message),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            onOk?.call();
            Navigator.pop(context);
          },
          child: Text(R.res.strings.dialogOk),
        ),
      ],
    );
  }
}

class ConfirmDialog {
  const ConfirmDialog(
    this._message, {
    required this.onOk,
    this.onCancel,
  });

  final String _message;
  final Function onOk;
  final Function? onCancel;

  void show(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (_) {
        return _createDialog(context);
      },
    );
  }

  AlertDialog _createDialog(BuildContext context) {
    return AlertDialog(
      content: Text(_message),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            onCancel?.call();
            Navigator.pop(context);
          },
          child: Text(R.res.strings.dialogCancel),
        ),
        TextButton(
          onPressed: () {
            onOk.call();
            Navigator.pop(context);
          },
          child: Text(R.res.strings.dialogOk),
        ),
      ],
    );
  }
}
