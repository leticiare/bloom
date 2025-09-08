import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/src/core/theme/app_colors.dart';
import 'package:app/src/features/auth/presentation/screens/create_account/persona_screen.dart';
import 'package:app/src/features/auth/presentation/screens/login/login_screen.dart';
import 'package:app/src/features/onboarding/data/onboarding_data.dart';
import 'package:app/src/features/onboarding/domain/entities/onboarding_page_model.dart';

/// Tela que apresenta o aplicativo para o usuário pela primeira vez.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  /// Atualiza o estado da página atual quando o usuário desliza a tela.
  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  /// Marca o onboarding como concluído e navega para a tela de criação de conta.
  Future<void> _navigateToPersona() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);
    if (mounted) {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (context) => const PersonaScreen()));
    }
  }

  /// Marca o onboarding como concluído e navega para a tela de login.
  Future<void> _navigateToLogin() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLastPage = _currentPage == onboardingPages.length - 1;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: onboardingPages.length,

                // <<< A CORREÇÃO ESTÁ AQUI
                // Adiciona um efeito "elástico" ao arrastar no início ou fim da lista.
                physics: const BouncingScrollPhysics(),

                itemBuilder: (context, index) {
                  final page = onboardingPages[index];
                  return _buildOnboardingPage(page);
                },
              ),
            ),
            isLastPage ? _buildLastPageFooter() : _buildNavigationFooter(),
          ],
        ),
      ),
    );
  }

  /// Constrói o rodapé final com o botão de "Vamos começar".
  Widget _buildLastPageFooter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
            onPressed: _navigateToPersona,
            child: const Text('Vamos começar'),
          ),
          const SizedBox(height: 16),
          RichText(
            text: TextSpan(
              text: 'Já possui uma conta? ',
              style: const TextStyle(color: AppColors.textGray, fontSize: 14),
              children: [
                TextSpan(
                  text: 'Entrar',
                  style: const TextStyle(
                    color: AppColors.primaryPink,
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

  /// Constrói o rodapé de navegação com "Pular", indicadores e "Próximo".
  Widget _buildNavigationFooter() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: () {
              _pageController.animateToPage(
                onboardingPages.length - 1,
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
              );
            },
            child: const Text(
              'PULAR',
              style: TextStyle(color: AppColors.textGray),
            ),
          ),
          Row(
            children: List.generate(onboardingPages.length, (index) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                height: 8,
                width: _currentPage == index ? 24 : 8,
                decoration: BoxDecoration(
                  color: _currentPage == index
                      ? AppColors.primaryPink
                      : AppColors.lightGray,
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
                color: AppColors.primaryPink,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOnboardingPage(OnboardingPageModel page) {
    if (onboardingPages.indexOf(page) == 0) {
      return _buildFirstPage(page);
    }
    return _buildStandardPage(page);
  }

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
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            page.description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.textGray,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

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
                color: AppColors.textDark,
                height: 1.3,
              ),
              children: _buildTitleSpans(page.title, page.wordToHighlight),
            ),
          ),
          const SizedBox(height: 15),
          Text(
            page.description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textGray,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  List<TextSpan> _buildTitleSpans(String fullTitle, String wordToHighlight) {
    if (wordToHighlight.isEmpty) {
      return [TextSpan(text: fullTitle)];
    }
    final spans = <TextSpan>[];
    final parts = fullTitle.split(wordToHighlight);

    spans.add(TextSpan(text: parts[0]));
    spans.add(
      TextSpan(
        text: wordToHighlight,
        style: const TextStyle(color: AppColors.primaryPink),
      ),
    );
    if (parts.length > 1) {
      spans.add(TextSpan(text: parts[1]));
    }

    return spans;
  }
}
