import 'package:flutter/material.dart';
import 'package:app/src/core/theme/app_colors.dart';
import 'package:app/src/features/auth/presentation/screens/login/forgot_password.dart';
import 'package:app/src/features/auth/presentation/screens/create_account/persona_screen.dart';
import 'package:app/src/shared/services/auth_service.dart';
import 'package:app/src/features/dashboard_pregnant/presentation/screens/dashboard_shell.dart';

/// Tela de login onde o usuário insere suas credenciais.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Estado da UI
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  // Serviços e Controladores
  final _authService = AuthService();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Valida o formulário, chama o serviço de autenticação e trata o resultado.
  Future<void> _handleLogin() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() => _isLoading = true);

    final error = await _authService.login(
      _emailController.text,
      _passwordController.text,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (error == null) {
      // Sucesso: Navega para a tela principal do dashboard.
      // TODO: Substituir por navegação de rota nomeada (ex: AppRoutes.dashboard).
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const DashboardShell()),
      );
    } else {
      // Erro: Mostra a mensagem de erro da API.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: AppColors.error),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Image.asset('assets/images/bloom_logo.png', height: 85),
              const SizedBox(height: 32),
              _buildTextField(
                controller: _emailController,
                label: 'E-mail',
                hint: 'Insira aqui...',
                keyboardType: TextInputType.emailAddress,
                suffixIcon: const Icon(
                  Icons.email_outlined,
                  color: AppColors.textGray,
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
                    color: AppColors.textGray,
                  ),
                  onPressed: () =>
                      setState(() => _isPasswordVisible = !_isPasswordVisible),
                ),
                validator: (value) => (value == null || value.isEmpty)
                    ? 'Senha obrigatória.'
                    : null,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      // TODO: Substituir por navegação de rota nomeada.
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const ForgotPasswordScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'Esqueceu sua senha?',
                      style: TextStyle(color: AppColors.primaryPink),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _handleLogin,
                child: _isLoading
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : const Text('Entrar'),
              ),
              const SizedBox(height: 24),
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  /// Constrói o rodapé com link para a tela de cadastro.
  Widget _buildFooter() {
    return GestureDetector(
      onTap: () {
        // Navega para a tela de seleção de perfil (o início do fluxo de cadastro).
        // TODO: Substituir por navegação de rota nomeada.
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (context) => const PersonaScreen()));
      },
      child: Text.rich(
        TextSpan(
          text: 'Não tem uma conta ainda? ',
          style: const TextStyle(color: AppColors.textGray, fontSize: 16),
          children: [
            const TextSpan(
              text: 'Cadastrar-se',
              style: TextStyle(
                color: AppColors.primaryPink,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Constrói um campo de texto padronizado.
  /// TODO: Substituir este método pelo widget compartilhado CustomTextField.
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
        Text(
          label,
          style: const TextStyle(color: AppColors.textGray, fontSize: 14),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(hintText: hint, suffixIcon: suffixIcon),
        ),
      ],
    );
  }
}
