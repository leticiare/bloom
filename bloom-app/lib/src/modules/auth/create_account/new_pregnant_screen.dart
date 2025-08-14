// lib/new_pregnant.dart
import 'package:flutter/material.dart';

class NewPregnantScreen extends StatelessWidget {
  const NewPregnantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro de Gestante')),
      body: const Center(
        child: Text(
          'Tela de cadastro para gestantes',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
