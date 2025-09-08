import 'package:flutter/material.dart';
import 'package:app/src/core/theme/app_colors.dart';
import 'package:app/src/features/auth/presentation/screens/create_account/persona_screen.dart';
import 'package:app/src/features/auth/presentation/screens/login/login_screen.dart';

/// Tela para o usuário solicitar um link de recuperação de senha.
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  /// Valida o e-mail e simula o envio do link de recuperação.
  void _sendRecoveryLink() {
    if (_formKey.currentState?.validate() ?? false) {
      final email = _emailController.text;

      // TODO: Implementar a chamada real à API para enviar o e-mail.
      debugPrint('Enviando link de recuperação para: $email');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Se uma conta existir para $email, um link será enviado.',
          ),
          backgroundColor: AppColors.success,
        ),
      );

      // Navega de volta para a tela de login.
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset('assets/images/bloom_logo.png', height: 85),
              const SizedBox(height: 32),
              const Icon(
                Icons.lock_outline,
                color: AppColors.primaryPink,
                size: 40,
              ),
              const SizedBox(height: 16),
              const Text(
                'Recuperação de senha',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Insira seu e-mail e enviaremos um link para você voltar a acessar sua conta.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: AppColors.textGray),
              ),
              const SizedBox(height: 40),
              _buildTextField(
                controller: _emailController,
                label: 'E-mail',
                hint: 'Insira seu e-mail de cadastro',
                keyboardType: TextInputType.emailAddress,
                suffixIcon: const Icon(
                  Icons.email_outlined,
                  color: AppColors.textGray,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Por favor, insira um e-mail.';
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value))
                    return 'E-mail inválido.';
                  return null;
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _sendRecoveryLink,
                child: const Text('Enviar link'),
              ),
              const SizedBox(height: 24),
              const Row(
                children: [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      'OU',
                      style: TextStyle(color: AppColors.textGray),
                    ),
                  ),
                  Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 24),
              OutlinedButton(
                onPressed: () {
                  // Navega para a tela de criar conta.
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const PersonaScreen(),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.textGray),
                ),
                child: const Text(
                  'Criar nova conta',
                  style: TextStyle(
                    color: AppColors.textGray,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
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
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(hintText: hint, suffixIcon: suffixIcon),
        ),
      ],
    );
  }
}
