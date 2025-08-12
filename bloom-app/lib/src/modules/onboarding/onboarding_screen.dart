// onboarding_screen.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/src/modules/auth/login_screen.dart'; // Importe sua tela de login

class OnboardingScreen extends StatelessWidget {
  OnboardingScreen({super.key});

  final List<Widget> _pages = [
    // Tela 1
    _OnboardingPage(
      imagePath: 'assets/images/5.png',
      title: 'Bem-vindo ao App!',
      description: 'Descubra uma nova experiência.',
      backgroundColor: Colors.blue,
    ),
    // Tela 2
    _OnboardingPage(
      imagePath: 'assets/images/5.png',
      title: 'Compre o que quiser',
      description: 'Explore nossas ofertas exclusivas.',
      backgroundColor: Colors.purple,
    ),
    // Tela 3
    _OnboardingPage(
      imagePath: 'assets/images/5.png',
      title: 'Descontos incríveis',
      description: 'Aproveite promoções diárias.',
      backgroundColor: Colors.orange,
    ),
    // Tela 4
    _OnboardingPage(
      imagePath: 'assets/images/5.png',
      title: 'Pagamento seguro',
      description: 'Sua segurança é nossa prioridade.',
      backgroundColor: Colors.green,
    ),
    // Tela 5
    _OnboardingPage(
      imagePath: 'assets/images/5.png',
      title: 'Pronto para começar!',
      description: 'Vamos fazer o seu login.',
      backgroundColor: Colors.teal,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(children: _pages),
          // Botão para pular ou ir para a próxima tela
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: ElevatedButton(
                onPressed: () async {
                  // Salva a preferência de que o usuário já viu as telas
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setBool('onboarding_completed', true);

                  // Navega para a tela de login, substituindo a tela atual
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
                child: const Text('Pular ou Começar'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Widget auxiliar para cada página do carrossel
class _OnboardingPage extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;
  final Color backgroundColor;

  const _OnboardingPage({
    required this.imagePath,
    required this.title,
    required this.description,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath, // Usamos Image.asset com o caminho fornecido
              width: 200, // Defina a largura desejada para a imagem
              height: 200, // Defina a altura desejada para a imagem
              fit: BoxFit.contain, // Ajuste como a imagem se encaixa no espaço
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Text(
                description,
                style: const TextStyle(fontSize: 18, color: Colors.white70),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
