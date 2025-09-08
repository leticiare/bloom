import 'package:flutter/material.dart';

/// TODO: Implementar a navegação por rotas nomeadas.
///
/// Este arquivo será o mapa central de todas as telas do aplicativo,
/// permitindo uma navegação limpa e desacoplada.
class AppRoutes {
  // --- Nomes das Rotas (Exemplos) ---
  // static const String onboarding = '/';
  // static const String login = '/login';
  // static const String dashboard = '/dashboard';

  /// TODO: Criar a função generateRoute para construir as telas
  /// com base nos nomes das rotas.
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // A lógica do switch-case para cada rota virá aqui.

    // Rota de erro padrão
    return MaterialPageRoute(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: const Text('Erro')),
          body: const Center(child: Text('Sistema de rotas não implementado.')),
        );
      },
    );
  }
}
