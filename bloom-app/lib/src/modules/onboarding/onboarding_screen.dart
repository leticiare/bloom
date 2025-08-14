import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/src/modules/auth/login/login_screen.dart';
import 'package:app/src/core/theme/app_colors.dart';
import 'package:app/src/shared/widgets/primary_button.dart';
import 'package:app/src/modules/auth/create_account/persona_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  late final PageController _pageController;
  late final AnimationController _animationController;
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat(reverse: true);

    _pageController.addListener(() {
      setState(() {
        _currentPageIndex = _pageController.page!.round();
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  // O método build será implementado no próximo passo
  @override
  Widget build(BuildContext context) {
    // A sua lista de telas de onboarding
    final List<Widget> pages = [
      // ... (suas 5 telas _OnboardingPage com imagePath, title, etc) ...
      // Exemplo:
      _OnboardingPage(
        imagePath: 'assets/images/onb1.png',
        title: 'Bem-vinda ao Bloom!',
        description:
            'Bem vindo(a) à Bloom, seu parceiro na jornada da sua gravidez. ',
        backgroundColor: AppColors.lightPink,
        textColor: AppColors.mediumPink,
      ),
      _OnboardingPage(
        imagePath: 'assets/images/onb2.png',
        title: 'Acompanhamento por profissionais',
        description:
            'Esse aplicativo vai proporcionar o apoio dos seus profssionais favoritos para te ajudar a monitorar o progresso da sua gravidez e pós parto, incluindo registro de consultas, vacinas e procedimentos realizados e não realizados.',
        backgroundColor: AppColors.mediumPink,
        textColor: AppColors.lightPink,
      ),
      _OnboardingPage(
        imagePath: 'assets/images/onb3.png',
        title: 'Recursos educacionais',
        description:
            'Esse app vai prover de recursos educacionais como forúns e artigos de profissionais para ajudar usuários a aprender sobre a saúde materna, incluindo artigos e forúns.',
        backgroundColor: AppColors.lightPink,
        textColor: AppColors.mediumPink,
      ),
      _OnboardingPage(
        imagePath: 'assets/images/onb4.png',
        title: 'Suporte da comunidade',
        description:
            'Esse aplicativo possui um suporte da comunidade para ajudar usuários a conectar-se com profissionais da área da saúde a compartilhar informações, responder perguntas e receber suporte.',
        backgroundColor: AppColors.mediumPink,
        textColor: AppColors.lightPink,
      ),
      _OnboardingPage(
        imagePath: 'assets/images/onb5.png',
        title: 'Registro de saúde',
        description:
            'Esse aplicativo permite que usuários marquem consultas, salve informações sobre sua saúde e do seu beê, facilitando na hora da consulta sobre seu estado atual.',
        backgroundColor: AppColors.lightPink,
        textColor: AppColors.mediumPink,
      ),
      // ... As outras 3 telas
    ];

    final bool _isLastPage = _currentPageIndex == pages.length - 1;

    return Scaffold(
      body: Stack(
        children: [
          // O carrossel de páginas
          PageView(controller: _pageController, children: pages),

          // Animação de arrastar: aparece SOMENTE na primeira tela
          if (_currentPageIndex == 0)
            Positioned(
              bottom: 120, // Posição abaixo do meio da tela
              right: 40,
              child: FadeTransition(
                opacity: _animationController,
                child: SlideTransition(
                  position:
                      Tween<Offset>(
                        begin: Offset.zero,
                        end: const Offset(
                          0.3,
                          0,
                        ), // Move o ícone para a direita
                      ).animate(
                        CurvedAnimation(
                          parent: _animationController,
                          curve: Curves.easeIn,
                        ),
                      ),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 40,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ),
            ),

          // O botão: aparece SOMENTE na última tela
          if (_isLastPage)
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Column(
                  children: [
                    // Botão para ir para a tela de Cadastro
                    PrimaryButton(
                      text: 'Começar',
                      onPressed: () async {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setBool('onboarding_completed', true);

                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const PersonaScreen(),
                          ), // Redireciona para o cadastro
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    // Texto com link clicável
                    RichText(
                      text: TextSpan(
                        text: 'Já tem uma conta? ',
                        style: TextStyle(
                          color: AppColors.mediumPink,
                          fontSize: 16,
                        ),
                        children: [
                          TextSpan(
                            text: 'Entrar',
                            style: const TextStyle(
                              color: AppColors.depperPink,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration
                                  .underline, // Adiciona sublinhado
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                final prefs =
                                    await SharedPreferences.getInstance();
                                await prefs.setBool(
                                  'onboarding_completed',
                                  true,
                                );

                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) => const LoginScreen(),
                                  ),
                                );
                              },
                          ),
                        ],
                      ),
                    ),
                  ],
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
