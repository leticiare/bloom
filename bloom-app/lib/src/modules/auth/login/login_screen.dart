import 'package:flutter/material.dart';
import 'package:app/src/modules/home/homepage.dart';
import 'package:app/src/modules/auth/login/forgot_password_screen.dart';
import 'package:app/src/modules/auth/create_account/new_pregnant_screen.dart';
import 'package:app/src/shared/services/auth_service.dart';

// --- CONSTANTES DE CORES ---
// Definindo as cores principais para manter a consistência do design.
const Color K_MAIN_PINK = Color(0xFFE91E63);
const Color K_TEXT_GRAY = Color(0xFF616161);
const Color K_FIELD_BACKGROUND = Color(0xFFF5F5F5);

// Enum para rastrear o perfil selecionado no Switch.
enum ProfileRole { pregnant, professional }

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // --- VARIÁVEIS DE ESTADO ---
  bool _isPasswordVisible = false; // Controla a visibilidade da senha.
  bool _isLoading =
      false; // Controla o estado de carregamento do botão de login.

  // Controladores para os campos de texto.
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService(); // Serviço de autenticação.
  // Chave para validar o formulário.
  final _formKey = GlobalKey<FormState>();

  // Libera a memória dos controladores quando a tela é descartada.
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // --- MÉTODOS DE LÓGICA E NAVEGAÇÃO ---

  // Valida as credenciais e realiza o login.
  void _handleLogin() async {
    // Verifica se os campos do formulário são válidos.
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Tenta realizar o login usando o serviço de autenticação.
      final error = await _authService.login(
        _emailController.text,
        _passwordController.text,
      );

      setState(() {
        _isLoading = false;
      });

      if (error == null) {
        // Se o login for bem-sucedido, navega para a HomePage.
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else {
        // Se as credenciais forem inválidas, mostra uma mensagem de erro.
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error)));
      }
    }
  }

  // --- CONSTRUÇÃO DA INTERFACE (UI) ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white, elevation: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // --- LOGO ---
              Image.asset('assets/images/bloom_logo.png', height: 85),
              const SizedBox(height: 32),

              // --- CAMPO DE E-MAIL ---
              _buildTextField(
                controller: _emailController,
                label: 'E-mail',
                hint: 'Insira aqui...',
                keyboardType: TextInputType.emailAddress,
                suffixIcon: const Icon(
                  Icons.email_outlined,
                  color: Colors.grey,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Email obrigatório.';
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value))
                    return 'Email inválido.';
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // --- CAMPO DE SENHA ---
              _buildTextField(
                controller: _passwordController,
                label: 'Senha',
                hint: '**********',
                obscureText: !_isPasswordVisible,
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    // Alterna o estado de visibilidade da senha.
                    setState(() => _isPasswordVisible = !_isPasswordVisible);
                  },
                ),
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Senha obrigatória.';
                  return null;
                },
              ),
              const SizedBox(height: 8),

              // --- LINK DE ESQUECI A SENHA ---
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const ForgotPasswordScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'Esqueceu sua senha?',
                      style: TextStyle(color: K_MAIN_PINK),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // --- BOTÃO DE ENTRAR ---
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: K_MAIN_PINK,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        )
                      : const Text(
                          'Entrar',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 24),

              // --- RODAPÉ ---
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGETS AUXILIARES (COMPONENTES) ---

  // Widget reutilizável para criar um campo de texto padronizado.
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    Widget? suffixIcon,
    bool obscureText = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: K_TEXT_GRAY, fontSize: 14)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: K_FIELD_BACKGROUND,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: const BorderSide(color: K_MAIN_PINK, width: 2.0),
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 12,
            ),
          ),
        ),
      ],
    );
  }

  // Constrói o rodapé com link para cadastro e login social.
  Widget _buildFooter() {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            // Navega para a tela de criar conta.
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const NewPregnantScreen(),
              ),
            );
          },
          child: RichText(
            text: TextSpan(
              text: 'Não tem uma conta ainda? ',
              style: TextStyle(color: K_TEXT_GRAY, fontSize: 16),
              children: [
                TextSpan(
                  text: 'Cadastrar-se',
                  style: TextStyle(
                    color: K_MAIN_PINK,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
