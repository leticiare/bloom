// lib/email_confirmation_screen.dart

import 'package:flutter/material.dart';
import 'package:app/src/core/theme/app_colors.dart';
import 'package:app/src/modules/auth/login/login_screen.dart';

class EmailConfirmationScreen extends StatelessWidget {
  final String email;
  const EmailConfirmationScreen({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFE4F0), Color(0xFFFFC6E1)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Ícone com a cor da sua paleta
                const Icon(
                  Icons.email_outlined,
                  size: 80,
                  color: AppColors.mediumPink,
                ),
                const SizedBox(height: 24),
                // Título com a cor da sua paleta
                const Text(
                  'Confirme seu email!',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.depperPink,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                // Descrição com a cor da sua paleta
                Text(
                  'Enviamos um link de confirmação para o email $email. Por favor, verifique sua caixa de entrada.',
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.depperPink,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    // Lógica para reenviar o email
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.mediumPink,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: Text('Reenviar email'),
                  ),
                ),
                const SizedBox(height: 12),
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
                    foregroundColor: AppColors.depperPink,
                  ),
                  child: const Text('Voltar para a tela de login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
