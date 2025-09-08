import 'package:flutter/material.dart';
import 'package:app/src/core/theme/app_colors.dart';
import 'package:app/src/features/dashboard_pregnant/domain/entities/weekly_update.dart';

/// Tela para exibir o conteúdo completo de uma atualização semanal.
class WeeklyUpdateDetailPage extends StatelessWidget {
  final WeeklyUpdate update;
  const WeeklyUpdateDetailPage({super.key, required this.update});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Semana ${update.weekNumber}')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              update.imageUrl,
              height: 220,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SEMANA ${update.weekNumber}',
                    style: const TextStyle(
                      color: AppColors.primaryPink,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    update.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Seu bebê tem o tamanho aproximado de ${update.babySizeFruit}!',
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.textGray,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const Divider(height: 40),

                  _buildSectionTitle('O que está acontecendo com o bebê?'),
                  const SizedBox(height: 8),
                  Text(
                    update.fullContent,
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.textGray,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 24),

                  _buildSectionTitle('Dicas para a mamãe'),
                  ...update.momTips.map((tip) => _buildListItem(tip)).toList(),
                  const SizedBox(height: 24),

                  _buildSectionTitle('Sintomas comuns nesta fase'),
                  ...update.symptoms
                      .map((symptom) => _buildListItem(symptom))
                      .toList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.textDark,
      ),
    );
  }

  Widget _buildListItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 6.0, right: 8.0),
            child: Icon(
              Icons.check_circle,
              size: 16,
              color: AppColors.primaryPink,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16, color: AppColors.textGray),
            ),
          ),
        ],
      ),
    );
  }
}
