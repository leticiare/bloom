// lib/new_doctor.dart
import 'package:flutter/material.dart';

class NewDoctorScreen extends StatelessWidget {
  const NewDoctorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro de Médico')),
      body: const Center(
        child: Text(
          'Tela de cadastro para médicos',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
