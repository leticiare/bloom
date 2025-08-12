// onboarding_screen.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/src/modules/auth/login_screen.dart';
import 'package:app/src/core/theme/app_colors.dart'; // Importe sua tela de login

class OnboardingScreen extends StatelessWidget {
  OnboardingScreen({super.key});

  final List<Widget> _pages = [
    // Tela 1
    _OnboardingPage(
      imagePath: 'assets/images/onb1.png',
      title: 'Bem-vinda ao Bloom!',
      description:
          'Bem vindo(a) à Bloom, seu parceiro na jornada da sua gravidez. ',
      backgroundColor: AppColors.lightPink,
      textColor: AppColors.mediumPink,
    ),
    // Tela 2
    _OnboardingPage(
      imagePath: 'assets/images/onb2.png',
      title: 'Acompanhamento por profissionais ',
      description:
          'Esse aplicativo vai proporcionar o apoio dos seus profssionais favoritos para te ajudar a monitorar o progresso da sua gravidez e pós parto, incluindo registro de consultas, vacinas e procedimentos realizados e não realizados.',
      backgroundColor: AppColors.mediumPink,
      textColor: AppColors.lightPink,
    ),
    // Tela 3
    _OnboardingPage(
      imagePath: 'assets/images/onb3.png',
      title: 'Recursos educacionais',
      description:
          'Esse app vai prover de recursos educacionais como forúns e artigos de profissionais para ajudar usuários a aprender sobre a saúde materna, incluindo artigos e forúns.',
      backgroundColor: AppColors.lightPink,
      textColor: AppColors.mediumPink,
    ),
    // Tela 4
    _OnboardingPage(
      imagePath: 'assets/images/onb4.png',
      title: 'Suporte da Comunidade',
      description:
          'Esse aplicativo possui um suporte da comunidade para ajudar usuários a conectar-se com profissionais da área da saúde a compartilhar informações, responder perguntas e receber suporte.',
      backgroundColor: AppColors.mediumPink,
      textColor: AppColors.lightPink,
    ),
    // Tela 5
    _OnboardingPage(
      imagePath: 'assets/images/onb5.png',
      title: 'Registro de saúde',
      description:
          'Esse aplicativo permite que usuários marquem consultas, salve informações sobre sua saúde e do seu beê, facilitando na hora da consulta sobre seu estado atual.',
      backgroundColor: AppColors.lightPink,
      textColor: AppColors.mediumPink,
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
  final Color textColor;

  const _OnboardingPage({
    required this.imagePath,
    required this.title,
    required this.description,
    required this.backgroundColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 24),
            SizedBox(
              width: 250, // Defina a largura máxima que o texto pode ter
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30.0),
              child: Image.asset(
                imagePath, // Usamos Image.asset com o caminho fornecido
                width: 200, // Defina a largura desejada para a imagem
                height: 200, // Defina a altura desejada para a imagem
                fit:
                    BoxFit.contain, // Ajuste como a imagem se encaixa no espaço
              ),
            ),

            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Text(
                description,
                style: TextStyle(fontSize: 18, color: textColor),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
