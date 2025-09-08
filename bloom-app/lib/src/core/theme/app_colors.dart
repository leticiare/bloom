import 'package:flutter/material.dart';

/// Classe abstrata que centraliza todas as cores utilizadas no aplicativo.
///
/// Isso garante consistência visual e facilita a manutenção do tema.
/// As cores são estáticas e constantes para serem acessadas de qualquer lugar
/// de forma simples, ex: `AppColors.primaryPink`.
abstract class AppColors {
  // Cores Primárias e de Destaque
  static const Color primaryPink = Color(0xFFE91E63);
  static const Color white = Color(0xFEFEFEFE);

  // Cores de Texto
  static const Color textDark = Color(0xFF333333);
  static const Color textGray = Color(0xFF616161);
  static const Color textLight = Color(0xFFFFFFFF);

  // Cores de Fundo
  static const Color background = Color(0xFFFFFFFF);
  static const Color fieldBackground = Color(0xFFF5F5F5);
  static const Color lightGray = Color(0xFFF2F2F2);

  // Cores de Feedback
  static const Color success = Colors.green;
  static const Color error = Colors.red;
  static const Color warning = Colors.orange;
  static const Color info = Colors.blue;
}
