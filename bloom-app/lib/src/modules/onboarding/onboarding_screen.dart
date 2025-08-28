import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/src/modules/auth/login/login_screen.dart';
import 'package:app/src/modules/auth/create_account/persona_screen.dart';

// --- ESTRUTURA DE DADOS ---
// Modelo para armazenar as informações de cada página do onboarding.
// Isso ajuda a manter o código organizado, separando os dados da interface.
class OnboardingPageModel {
  final String imagePath; // Caminho para a ilustração da página
  final String title; // O título principal
  final String description; // O texto descritivo
  final String
  wordToHighlight; // A palavra no título que será destacada em rosa

  OnboardingPageModel({
    required this.imagePath,
    required this.title,
    required this.description,
    required this.wordToHighlight,
  });
}

// --- CONTEÚDO DAS PÁGINAS ---
// Lista contendo os dados de todas as páginas que serão exibidas no carrossel.
final List<OnboardingPageModel> onboardingPages = [
  OnboardingPageModel(
    imagePath: 'assets/images/onb1.png',
    title: 'Bem-vindo(a)!', // Título ajustado para corresponder ao protótipo
    description:
        'Bem vindo(a) à Bloom, seu parceiro na jornada da sua gravidez.',
    wordToHighlight: '', // Não há destaque de palavra na primeira página
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
    wordToHighlight: 'Registro',
  ),
];

// --- TELA PRINCIPAL DO ONBOARDING ---
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  // Controlador para o PageView, permite navegar entre as páginas programaticamente.
  final PageController _pageController = PageController();
  // Variável que armazena o índice da página atual.
  int _currentPage = 0;

  // Método chamado quando o widget é removido da árvore de widgets.
  // É importante fazer o 'dispose' dos controladores para liberar memória.
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // Função chamada sempre que o usuário desliza para uma nova página.
  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  // --- MÉTODOS DE NAVEGAÇÃO ---
  // Navega para a tela de criação de conta (PersonaScreen).
  // Também marca o onboarding como concluído no SharedPreferences.
  Future<void> _navigateToPersona() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);
    if (mounted) {
      // Verifica se o widget ainda está na tela antes de navegar
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const PersonaScreen()),
      );
    }
  }

  // Navega para a tela de login (LoginScreen).
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
    // Verifica se a página atual é a última.
    final isLastPage = _currentPage == onboardingPages.length - 1;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        // O layout principal é uma coluna.
        child: Column(
          children: [
            // O PageView ocupa todo o espaço disponível.
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

            // O rodapé muda: se for a última página, mostra os botões de ação.
            // Senão, mostra a navegação padrão (Pular, bolinhas, Próximo).
            isLastPage ? _buildLastPageFooter() : _buildNavigationFooter(),
          ],
        ),
      ),
    );
  }

  // --- WIDGETS AUXILIARES (COMPONENTES) ---

  // Constrói o rodapé para a ÚLTIMA página.
  Widget _buildLastPageFooter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Botão principal para iniciar o cadastro.
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
          // Texto com um link clicável para a tela de login.
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
                  // O TapGestureRecognizer torna o TextSpan clicável.
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

  // Constrói o rodapé de navegação para as páginas 1 a 4.
  Widget _buildNavigationFooter() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Botão para pular o onboarding.
          TextButton(
            onPressed: _navigateToPersona,
            child: const Text('PULAR', style: TextStyle(color: Colors.grey)),
          ),

          // Indicadores de página (as bolinhas).
          Row(
            children: List.generate(onboardingPages.length, (index) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                height: 8,
                width: _currentPage == index
                    ? 24
                    : 8, // A bolinha atual é mais larga
                decoration: BoxDecoration(
                  color: _currentPage == index
                      ? const Color(0xFFE91E63) // Cor da bolinha ativa
                      : Colors.grey.shade300, // Cor da bolinha inativa
                  borderRadius: BorderRadius.circular(12),
                ),
              );
            }),
          ),

          // Botão para avançar para a próxima página.
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

  // Constrói o layout da PRIMEIRA página.
  Widget _buildFirstPage(OnboardingPageModel page) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // IMAGEM DO LOGO DA BLOOM
          Image.asset('assets/images/bloom_logo.png', height: 90),
          const SizedBox(height: 30),

          // IMAGEM DO ONBOARDING 1, ABAIXO DO LOGO
          Image.asset(page.imagePath, height: 250),
          const SizedBox(height: 40),

          // TÍTULO E DESCRIÇÃO
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
          // Usa RichText para poder colorir uma parte do texto.
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
    // Se não houver palavra para destacar, retorna o título normal.
    if (wordToHighlight.isEmpty) {
      return [TextSpan(text: fullTitle)];
    }

    final spans = <TextSpan>[];
    final parts = fullTitle.split(wordToHighlight);

    if (parts.length > 1) {
      spans.add(TextSpan(text: parts[0])); // Parte antes da palavra
      spans.add(
        TextSpan(
          text: wordToHighlight, // A palavra destacada
          style: const TextStyle(color: Color(0xFFE91E63)), // com a cor rosa
        ),
      );
      spans.add(TextSpan(text: parts[1])); // Parte depois da palavra
    } else {
      // Se a palavra não for encontrada, exibe o título normal.
      spans.add(TextSpan(text: fullTitle));
    }

    return spans;
  }
}
