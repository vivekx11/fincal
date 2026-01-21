import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/app_theme.dart';

class CustomInputField extends StatelessWidget {
  final String label;
  final String? hint;
  final IconData? prefixIcon;
  final String? suffix;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;

  const CustomInputField({
    super.key,
    required this.label,
    this.hint,
    this.prefixIcon,
    this.suffix,
    this.controller,
    this.keyboardType = TextInputType.number,
    this.inputFormatters,
    this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters ?? [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
      ],
      style: AppTheme.bodyLarge,
      onChanged: onChanged,
      validator: validator,
      decoration: AppTheme.inputDecoration(
        label: label,
        hint: hint,
        prefixIcon: prefixIcon,
        suffix: suffix,
      ),
    );
  }
}
