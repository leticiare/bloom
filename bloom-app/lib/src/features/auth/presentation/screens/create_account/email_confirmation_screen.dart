import 'package:flutter/material.dart';
import 'package:app/src/core/theme/app_colors.dart';
import 'package:app/src/features/auth/presentation/screens/login/login_screen.dart';

/// Tela que confirma o envio de um e-mail de verificação para o usuário.
class EmailConfirmationScreen extends StatelessWidget {
  final String email;

  const EmailConfirmationScreen({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(
                Icons.mark_email_read_outlined,
                size: 80,
                color: AppColors.primaryPink,
              ),
              const SizedBox(height: 32),

              const Text(
                'Confirme seu e-mail!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              Text(
                'Enviámos um link de confirmação para o e-mail $email. Por favor, verifique a sua caixa de entrada e spam.',
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.textGray,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('E-mail de confirmação reenviado!'),
                      backgroundColor: AppColors.info,
                    ),
                  );
                },
                child: const Text('Reenviar e-mail'),
              ),
              const SizedBox(height: 16),

              TextButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                    (Route<dynamic> route) => false,
                  );
                },
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.textGray,
                ),
                child: const Text('Voltar para a tela de login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
