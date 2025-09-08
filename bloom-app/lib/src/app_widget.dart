// lib/src/app_widget.dart

import 'package:flutter/material.dart';
import 'package:app/src/core/theme/app_theme.dart';
import 'package:app/src/core/utils/app_scroll_behavior.dart';

// 1. REMOVA O IMPORT DO ONBOARDING
// import 'package:app/src/features/onboarding/presentation/screens/onboarding_screen.dart';

// 2. ADICIONE O IMPORT DO DASHBOARD SHELL
import 'package:app/src/features/dashboard_pregnant/presentation/screens/dashboard_shell.dart';

/// O widget raiz da sua aplicação, responsável por configurar o MaterialApp.
class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bloom App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      scrollBehavior: AppScrollBehavior(),

      // 3. TROQUE A TELA INICIAL AQUI
      // De: home: const OnboardingScreen(),
      // Para:
      home: const DashboardShell(),
    );
  }
}
