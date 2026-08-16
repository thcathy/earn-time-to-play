import 'package:flutter/material.dart';
import '../utils/minutes_input.dart';

/// Number field that applies the shared minutes input constraints.
class MinutesTextField extends StatelessWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final InputDecoration? decoration;
  final TextAlign textAlign;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;

  const MinutesTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.decoration,
    this.textAlign = TextAlign.start,
    this.textInputAction,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: TextInputType.number,
      textAlign: textAlign,
      textInputAction: textInputAction,
      inputFormatters: MinutesInput.formatters,
      decoration: decoration,
      onSubmitted: onSubmitted,
    );
  }
}
