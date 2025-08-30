import 'package:flutter/material.dart';
import 'package:app/src/modules/auth/create_account/new_pregnant_screen.dart';
import 'package:app/src/modules/auth/login/login_screen.dart';

// --- CONSTANTES DE CORES ---
const Color K_MAIN_PINK = Color(0xFFE91E63);
const Color K_TEXT_GRAY = Color(0xFF616161);
const Color K_FIELD_BACKGROUND = Color(0xFFF5F5F5);

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  // Controlador para o campo de e-mail.
  final _emailController = TextEditingController();
  // Chave para validar o formulário.
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  // --- MÉTODOS DE LÓGICA ---

  // Função chamada ao clicar em "Enviar link".
  void _sendRecoveryLink() {
    // Valida se o e-mail foi preenchido corretamente.
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text;
      print('Enviando link de recuperação para: $email');

      // Em um app real, aqui você chamaria sua API para enviar o e-mail.

      // Mostra uma mensagem de sucesso para o usuário.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Link de recuperação enviado para $email!'),
          backgroundColor: Colors.green,
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),

              // --- LOGO E CABEÇALHO ---
              Image.asset('assets/images/bloom_logo.png', height: 60),
              const SizedBox(height: 32),
              const Icon(Icons.lock_outline, color: K_MAIN_PINK, size: 40),
              const SizedBox(height: 16),
              const Text(
                'Recuperação de senha',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: K_MAIN_PINK,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Insira seu e-mail e enviaremos um link para você voltar a acessar sua conta.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: K_TEXT_GRAY),
              ),
              const SizedBox(height: 40),

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
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira um e-mail.';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'E-mail inválido.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),

              // --- BOTÃO PRINCIPAL ---
              ElevatedButton(
                onPressed: _sendRecoveryLink,
                style: ElevatedButton.styleFrom(
                  backgroundColor: K_MAIN_PINK,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: const Text(
                  'Enviar link',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 24),

              // --- DIVISOR "OU" ---
              const Row(
                children: [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text('OU', style: TextStyle(color: K_TEXT_GRAY)),
                  ),
                  Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 24),

              // --- BOTÃO SECUNDÁRIO ---
              OutlinedButton(
                onPressed: () {
                  // Navega para a tela de criar conta.
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const NewPregnantScreen(),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: K_TEXT_GRAY,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  side: const BorderSide(color: Colors.grey),
                ),
                child: const Text(
                  'Criar nova conta',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGET AUXILIAR PARA CAMPOS DE TEXTO ---
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
        Text(label, style: const TextStyle(color: K_TEXT_GRAY, fontSize: 14)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
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
}
