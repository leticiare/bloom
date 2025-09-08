import 'package:flutter/material.dart';
import 'package:app/src/core/theme/app_colors.dart';

/// Classe que define o tema visual principal da aplicação.
///
/// Centraliza as configurações de `ThemeData`, como esquemas de cores,
/// tipografia e estilos de componentes, garantindo uma UI consistente.
class AppTheme {
  // Construtor privado para que a classe não possa ser instanciada.
  AppTheme._();

  /// Define o tema claro padrão para a aplicação.
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Roboto',
      scaffoldBackgroundColor: AppColors.background, // Fundo geral do app
      // Esquema de cores principal.
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryPink,
        primary: AppColors.primaryPink,
        background: AppColors.background,
        error: AppColors.error,
      ),

      // Tema para a AppBar.
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.textDark),
        titleTextStyle: TextStyle(
          color: AppColors.textDark,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          fontFamily: 'Roboto',
        ),
      ),

      // Tema para a Barra de Navegação Inferior.
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.background,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primaryPink,
        unselectedItemColor: AppColors.textDark,
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),

      // Tema para Botões Elevados (ElevatedButton).
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryPink,
          foregroundColor: AppColors.white,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Roboto',
          ),
        ),
      ),

      // Tema para Campos de Formulário (TextFormField).
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.fieldBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(
            color: AppColors.primaryPink,
            width: 2.0,
          ),
        ),
        hintStyle: const TextStyle(color: AppColors.textGray),
      ),
    );
  }
}
