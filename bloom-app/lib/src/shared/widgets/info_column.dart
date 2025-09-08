import 'package:flutter/material.dart';
import 'package:app/src/core/theme/app_colors.dart';

/// Um widget que exibe uma informação em formato de coluna (rótulo e valor).
class InfoColumn extends StatelessWidget {
  final String label;
  final String value;

  const InfoColumn({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(color: AppColors.textGray, fontSize: 12),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.textDark,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
