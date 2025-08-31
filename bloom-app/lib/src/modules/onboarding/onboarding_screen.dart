// lib/onboarding/onboarding_screen.dart

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/src/modules/auth/login/login_screen.dart';
import 'package:app/src/modules/auth/create_account/persona_screen.dart';

// --- ESTRUTURA DE DADOS ---
// A classe OnboardingPageModel serve como um "molde" para os dados de cada tela.
// Usar um modelo de dados como este torna o código mais limpo e organizado.
class OnboardingPageModel {
  final String imagePath;
  final String title;
  final String description;
  final String wordToHighlight;

  OnboardingPageModel({
    required this.imagePath,
    required this.title,
    required this.description,
    required this.wordToHighlight,
  });
}

// --- CONTEÚDO DAS PÁGINAS ---
// Esta é a lista que armazena os dados de todas as telas do onboarding.
// Se precisarmos adicionar, remover ou alterar uma tela, mexemos apenas aqui.
final List<OnboardingPageModel> onboardingPages = [
  OnboardingPageModel(
    imagePath: 'assets/images/onb1.png',
    title: 'Bem-vindo(a)',
    description:
        'Bem vindo(a) à Bloom, seu parceiro na jornada da sua gravidez.',
    wordToHighlight: '',
  ),
  OnboardingPageModel(
    imagePath: 'assets/images/onb2.png',
    title: 'Acompanhamento por profissionais',
    description:
        'Esse aplicativo vai proporcionar o apoio dos seus profissionais favoritos para te ajudar a monitorar o progresso da sua gravidez e pós parto, incluindo registro de consultas, vacinas e procedimentos realizados e não realizados.',
    wordToHighlight: 'profissionais',
  ),
  OnboardingPageModel(
    imagePath: 'assets/images/onb3.png',
    title: 'Recursos educacionais',
    description:
        'Esse app vai prover de recursos educacionais como fóruns e artigos de profissionais para ajudar usuários a aprender sobre a saúde materna, incluindo artigos e fóruns.',
    wordToHighlight: 'educacionais',
  ),
  OnboardingPageModel(
    imagePath: 'assets/images/onb4.png',
    title: 'Suporte da comunidade',
    description:
        'Esse aplicativo possui um suporte da comunidade para ajudar usuários a conectar-se com profissionais da área da saúde a compartilhar informações, responder perguntas e receber suporte.',
    wordToHighlight: 'comunidade',
  ),
  OnboardingPageModel(
    imagePath: 'assets/images/onb5.png',
    title: 'Registro de saúde',
    description:
        'Esse aplicativo permite que usuários marquem consultas, salve informações sobre sua saúde e do seu bebê, facilitando na hora da consulta sobre seu estado atual.',
    wordToHighlight: 'saúde',
  ),
];

// --- TELA PRINCIPAL DO ONBOARDING ---
// StatefulWidget é usado porque o conteúdo da tela (a página atual) muda.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  // Controlador do PageView, permite controlar a rolagem das páginas via código.
  final PageController _pageController = PageController();
  // Variável de estado para saber qual é a página atual (começa na página 0).
  int _currentPage = 0;

  // O método dispose é chamado quando a tela é removida da árvore de widgets.
  // É crucial para liberar a memória usada pelos controladores.
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // Esta função é chamada pelo PageView sempre que o usuário muda de página.
  void _onPageChanged(int page) {
    // setState notifica o Flutter que o estado mudou, fazendo a tela ser redesenhada.
    setState(() {
      _currentPage = page;
    });
  }

  // --- MÉTODOS DE NAVEGAÇÃO ---

  // Navega para a tela de seleção de persona (grávida ou médico).
  Future<void> _navigateToPersona() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);
    if (mounted) {
      // Usamos 'push' para que o usuário possa voltar para o onboarding.
      // 'pushReplacement' removeria a tela de onboarding do histórico, causando a tela preta.
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (context) => const PersonaScreen()));
    }
  }

  // Navega para a tela de login.
  Future<void> _navigateToLogin() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  // --- CONSTRUÇÃO DA INTERFACE (UI) ---
  @override
  Widget build(BuildContext context) {
    // Variável para verificar se estamos na última página.
    final isLastPage = _currentPage == onboardingPages.length - 1;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        // A estrutura principal é uma Coluna: PageView em cima, rodapé embaixo.
        child: Column(
          children: [
            // Expanded faz o PageView ocupar todo o espaço vertical disponível.
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: onboardingPages.length,
                itemBuilder: (context, index) {
                  final page = onboardingPages[index];
                  // Constrói o conteúdo de cada página.
                  return _buildOnboardingPage(page);
                },
              ),
            ),
            // Operador ternário: se for a última página, mostra o rodapé final.
            // Senão, mostra o rodapé de navegação.
            isLastPage ? _buildLastPageFooter() : _buildNavigationFooter(),
          ],
        ),
      ),
    );
  }

  // --- WIDGETS AUXILIARES (COMPONENTES) ---

  // Constrói o rodapé que aparece apenas na última página.
  Widget _buildLastPageFooter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
            onPressed: _navigateToPersona,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE91E63),
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Vamos começar',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
          const SizedBox(height: 16),
          RichText(
            text: TextSpan(
              text: 'Já possui uma conta? ',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
              children: [
                TextSpan(
                  text: 'Entrar',
                  style: const TextStyle(
                    color: Color(0xFFE91E63),
                    fontWeight: FontWeight.bold,
                  ),
                  recognizer: TapGestureRecognizer()..onTap = _navigateToLogin,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  // Constrói o rodapé de navegação (Pular, bolinhas, Próximo).
  Widget _buildNavigationFooter() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            //  O botão "PULAR" leva para a última página.
            onPressed: () {
              _pageController.animateToPage(
                onboardingPages.length - 1,
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
              );
            },
            child: const Text('PULAR', style: TextStyle(color: Colors.grey)),
          ),
          // Gera as "bolinhas" indicadoras de página dinamicamente.
          Row(
            children: List.generate(onboardingPages.length, (index) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                height: 8,
                width: _currentPage == index ? 24 : 8,
                decoration: BoxDecoration(
                  color: _currentPage == index
                      ? const Color(0xFFE91E63)
                      : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(12),
                ),
              );
            }),
          ),
          TextButton(
            onPressed: () {
              _pageController.nextPage(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
              );
            },
            child: const Text(
              'PRÓXIMO',
              style: TextStyle(
                color: Color(0xFFE91E63),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Decide qual layout de página construir (a primeira é diferente das outras).
  Widget _buildOnboardingPage(OnboardingPageModel page) {
    if (onboardingPages.indexOf(page) == 0) {
      return _buildFirstPage(page);
    }
    return _buildStandardPage(page);
  }

  // Constrói o layout específico da PRIMEIRA página.
  Widget _buildFirstPage(OnboardingPageModel page) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/bloom_logo.png', height: 90),
          const SizedBox(height: 30),
          Image.asset(page.imagePath, height: 250),
          const SizedBox(height: 40),
          Text(
            page.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            page.description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // Constrói o layout PADRÃO para as páginas 2 a 5.
  Widget _buildStandardPage(OnboardingPageModel page) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(page.imagePath, height: 250),
          const SizedBox(height: 60),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                height: 1.3,
              ),
              children: _buildTitleSpans(page.title, page.wordToHighlight),
            ),
          ),
          const SizedBox(height: 15),
          Text(
            page.description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // Função que divide o título e colore a palavra de destaque.
  List<TextSpan> _buildTitleSpans(String fullTitle, String wordToHighlight) {
    if (wordToHighlight.isEmpty) {
      return [TextSpan(text: fullTitle)];
    }
    final spans = <TextSpan>[];
    final parts = fullTitle.split(wordToHighlight);
    if (parts.length > 1) {
      spans.add(TextSpan(text: parts[0]));
      spans.add(
        TextSpan(
          text: wordToHighlight,
          style: const TextStyle(color: Color(0xFFE91E63)),
        ),
      );
      spans.add(TextSpan(text: parts[1]));
    } else {
      spans.add(TextSpan(text: fullTitle));
    }
    return spans;
  }
}
