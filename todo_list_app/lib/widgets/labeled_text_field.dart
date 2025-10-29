import 'package:flutter/material.dart';

class LabeledTextField extends StatelessWidget {
  final String label;
  final bool required;
  final bool readOnly;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final VoidCallback? onTap;
  final String? helperText;
  final TextInputType? keyboardType;

  const LabeledTextField({
    super.key,
    required this.label,
    this.required = false,
    this.readOnly = false,
    this.controller,
    this.validator,
    this.onChanged,
    this.onTap,
    this.helperText,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      keyboardType: keyboardType,
      validator: validator,
      onChanged: onChanged,
      onTap: onTap,
      decoration: InputDecoration(
        label: RichText(
          text: TextSpan(
            text: label,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 16,
            ),
            children: required
                ? const [
              TextSpan(
                text: ' *',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ]
                : [],
          ),
        ),
        helperText: helperText,
        helperStyle: const TextStyle(fontSize: 10, color: Colors.grey),
        border: const OutlineInputBorder(),
      ),
    );
  }
}
