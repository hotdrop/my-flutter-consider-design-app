import 'package:flutter/material.dart';

class AppTextFormField extends StatefulWidget {
  const AppTextFormField({
    required this.keyboardType,
    required this.label,
    this.hint,
    this.textSize = 16,
    this.maxLength,
    required this.validator,
    required this.onChanged,
  });

  final TextInputType keyboardType;
  final String label;
  final String? hint;
  final double textSize;
  final int? maxLength;
  final String? Function(String? inputVal) validator;
  final void Function(String inputVal, bool isValidate) onChanged;

  @override
  State<StatefulWidget> createState() => _AppTextFormFieldState();
}

class _AppTextFormFieldState extends State<AppTextFormField> {
  String? _errorMsg;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _textFormField(context),
        _textError(context),
      ],
    );
  }

  Widget _textFormField(BuildContext context) {
    return TextFormField(
      keyboardType: widget.keyboardType,
      decoration: InputDecoration(labelText: widget.label, hintText: widget.hint),
      style: TextStyle(fontSize: widget.textSize),
      maxLength: widget.maxLength,
      onChanged: (String? v) {
        final validateError = widget.validator(v);
        setState(() {
          _errorMsg = validateError;
        });
        widget.onChanged(v ?? '', (validateError == null));
      },
    );
  }

  Widget _textError(BuildContext context) {
    if (_errorMsg != null) {
      return Text(_errorMsg!, style: TextStyle(color: Colors.red));
    } else {
      // TODO Opacityで対応した方が良さそう
      return SizedBox(height: 16);
    }
  }
}
