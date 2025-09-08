import 'package:flutter/material.dart';
import 'package:app/src/core/theme/app_theme.dart';
import 'package:app/src/core/utils/app_scroll_behavior.dart';
import 'package:app/src/features/onboarding/presentation/screens/onboarding_screen.dart';

/// O widget raiz da sua aplicação, responsável por configurar o MaterialApp.
class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bloom App',
      debugShowCheckedModeBanner: false,

      // Define o tema visual global da aplicação.
      theme: AppTheme.lightTheme,

      // Define a regra de rolagem
      scrollBehavior: AppScrollBehavior(),

      // Define a tela inicial do aplicativo.
      home: const OnboardingScreen(),
    );
  }
}
