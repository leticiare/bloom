import 'package:flutter/material.dart';

class PinkTextField extends StatelessWidget {
  final String label;
  final String hint;
  final bool obscureText;
  final TextInputType? keyboardType;

  const PinkTextField({
    super.key,
    required this.label,
    required this.hint,
    this.obscureText = false,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.pink.withOpacity(0.25)),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.pink.shade700,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          obscureText: obscureText,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.pink.shade50,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            enabledBorder: border,
            focusedBorder: border.copyWith(
              borderSide: BorderSide(color: Colors.pink.shade300, width: 1.8),
            ),
          ),
        ),
      ],
    );
  }
}
