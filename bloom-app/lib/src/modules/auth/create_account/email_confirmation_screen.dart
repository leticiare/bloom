// lib/email_confirmation_screen.dart
import 'package:flutter/material.dart';

class EmailConfirmationScreen extends StatelessWidget {
  final String email;
  const EmailConfirmationScreen({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirmação de Email'),
        automaticallyImplyLeading: false, // Remove a seta de voltar
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.email_outlined, size: 80, color: Colors.green),
              const SizedBox(height: 24),
              const Text(
                'Confirme seu email!',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Enviamos um link de confirmação para o email $email. Por favor, verifique sua caixa de entrada.',
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
