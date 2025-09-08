import 'package:flutter/material.dart';
import 'package:app/src/core/theme/app_colors.dart';
import 'package:app/src/features/dashboard_pregnant/domain/entities/doctor.dart'; // <<< MUDANÇA AQUI

/// Tela que exibe as informações de perfil de um profissional de saúde.
class DoctorProfilePage extends StatelessWidget {
  /// O objeto Doctor contendo os dados a serem exibidos.
  final Doctor doctor;

  const DoctorProfilePage({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(doctor.name)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(doctor.avatarUrl),
            ),
            const SizedBox(height: 16),
            Text(
              doctor.name,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            Text(
              doctor.specialty,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.primaryPink,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
