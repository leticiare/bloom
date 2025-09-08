import 'package:flutter/material.dart';
import 'package:app/src/features/onboarding/presentation/screens/onboarding_screen.dart';

/// Classe central para gerenciar as rotas nomeadas da aplicação.
class AppRoutes {
  // Nomes das rotas (constantes para evitar erros de digitação).
  static const String onboarding =
      '/'; // A rota '/' é a rota inicial por padrão.
  static const String login = '/login';
  // Adicione outras rotas aqui conforme seu app cresce
  // static const String home = '/home';

  /// Mapeamento estático que associa os nomes das rotas aos widgets (telas) correspondentes.
  static Map<String, WidgetBuilder> get routes {
    return {
      onboarding: (context) => const OnboardingScreen(),
      // login: (context) => const LoginScreen(), // Exemplo: descomente quando tiver a tela
      // home: (context) => const HomeScreen(),
    };
  }
}
