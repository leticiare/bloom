import 'package:flutter/material.dart';
import 'package:app/src/core/theme/app_colors.dart';

/// Um widget de tag para exibir informações curtas com um ícone.
class InfoTag extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color textColor;
  final Color backgroundColor;

  const InfoTag({
    super.key,
    required this.icon,
    required this.text,
    this.textColor = AppColors.textGray,
    this.backgroundColor = AppColors.lightGray,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min, // Para que a tag não se estique
        children: [
          Icon(icon, color: textColor, size: 16),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
