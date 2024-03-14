import 'package:flutter/material.dart';
import 'package:p2pbookshare/core/extensions/color_extension.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {super.key,
      required this.controller,
      this.labelText,
      required this.isMultiline,
      this.maxLines,
      this.isReadOnly});

  final TextEditingController controller;
  final String? labelText;
  final bool isMultiline;
  final bool? isReadOnly;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return TextField(
          textCapitalization: TextCapitalization.words,
          controller: controller,
          readOnly: isReadOnly ?? false,
          decoration: InputDecoration(
            labelText: labelText,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: BorderSide(
                color: context.outline,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: BorderSide(
                color: context.outlineVariant,
              ),
            ),
          ),
          maxLines: isMultiline ? null : maxLines,
        );
      },
    );
  }
}
