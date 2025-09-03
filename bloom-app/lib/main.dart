import 'package:flutter/material.dart';
import 'package:app/main_screen.dart'; // <<< CORREÇÃO: Importando a nova tela principal
import 'package:app/src/core/theme/app_colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bloom App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primaryPink,
        scaffoldBackgroundColor: AppColors.background,
        fontFamily: 'Roboto',
      ),
      // <<< CORREÇÃO: Usando MainScreen como a página inicial do app
      home: const MainScreen(),
    );
  }
}
