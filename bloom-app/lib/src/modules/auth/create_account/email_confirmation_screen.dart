import 'package:flutter/material.dart';
import 'package:app/src/modules/auth/login/login_screen.dart';

// --- CONSTANTES DE CORES ---
const Color K_MAIN_PINK = Color(0xFFE91E63);
const Color K_TEXT_GRAY = Color(0xFF616161);

class EmailConfirmationScreen extends StatelessWidget {
  final String email;
  const EmailConfirmationScreen({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // --- ÍCONE PRINCIPAL ---
              const Icon(
                Icons.mark_email_read_outlined,
                size: 80,
                color: K_MAIN_PINK,
              ),
              const SizedBox(height: 32),

              // --- TEXTOS INFORMATIVOS ---
              const Text(
                'Confirme seu e-mail!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Enviámos um link de confirmação para o e-mail $email. Por favor, verifique a sua caixa de entrada e spam.',
                style: const TextStyle(
                  fontSize: 16,
                  color: K_TEXT_GRAY,
                  height: 1.5, // Melhora a legibilidade
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // --- BOTÃO DE REENVIAR ---
              ElevatedButton(
                onPressed: () {
                  // Lógica para reenviar o e-mail de confirmação.
                  print('Reenviando e-mail de confirmação...');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('E-mail de confirmação reenviado!'),
                      backgroundColor: Colors.blue,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: K_MAIN_PINK,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: const Text(
                  'Reenviar e-mail',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 16),

              // --- BOTÃO DE VOLTAR AO LOGIN ---
              TextButton(
                onPressed: () {
                  // Leva o usuário de volta para a tela de login, limpando o histórico de navegação.
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                    (Route<dynamic> route) => false,
                  );
                },
                style: TextButton.styleFrom(foregroundColor: K_TEXT_GRAY),
                child: const Text('Voltar para a tela de login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
