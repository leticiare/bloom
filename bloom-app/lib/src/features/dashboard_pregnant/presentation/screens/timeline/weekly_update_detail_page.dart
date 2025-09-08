import 'package:flutter/material.dart';
import 'timeline_page.dart'; // Importa o modelo 'WeeklyUpdate'
import 'package:app/src/core/theme/app_colors.dart'; // Ajuste o import se necessário

/// Tela para exibir o conteúdo completo de um único artigo da semana.
class WeeklyUpdateDetailPage extends StatelessWidget {
  final WeeklyUpdate update;

  const WeeklyUpdateDetailPage({super.key, required this.update});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          update.title,
          style: const TextStyle(color: AppColors.textDark, fontSize: 18),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagem genérica para o topo do artigo
            Image.network(
              'https://images.pexels.com/photos/1796603/pexels-photo-1796603.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
              height: 220,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título
                  Text(
                    'Semana ${update.weekNumber}: ${update.title}',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Conteúdo completo do artigo
                  Text(
                    update.fullContent,
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.textLight,
                      height:
                          1.7, // Espaçamento entre linhas para melhor leitura
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
