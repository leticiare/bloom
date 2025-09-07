import 'package:flutter/material.dart';
import 'package:app/src/core/theme/app_colors.dart';
import './data/models/mock_models.dart'; // Importa o modelo 'Doctor'

class DoctorProfilePage extends StatelessWidget {
  final Doctor doctor;
  const DoctorProfilePage({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          doctor.name,
          style: const TextStyle(color: AppColors.textDark),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textDark),
      ),
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
