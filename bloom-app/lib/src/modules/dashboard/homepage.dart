// home_page.dart
import 'package:flutter/material.dart';
import 'package:app/src/core/theme/app_colors.dart'; // Importe o arquivo de cores

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          "Olá, Julia!",
          style: TextStyle(color: AppColors.depperPink),
        ),
        actions: [
          IconButton(
            icon: CircleAvatar(
              backgroundImage: NetworkImage("URL_DA_SUA_IMAGEM"),
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "16ª Semana de Gravidez",
                style: TextStyle(
                  color: AppColors.depperPink,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              // Cartão de informações da semana
              Container(
                decoration: BoxDecoration(
                  color: AppColors.lightPink,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Calendário da semana
                    // ...
                  ],
                ),
              ),
              SizedBox(height: 16),
              // Card da próxima consulta
              Container(
                decoration: BoxDecoration(
                  color: AppColors.mediumPink,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.calendar_today, color: AppColors.depperPink),
                    SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Próxima consulta:",
                          style: TextStyle(color: AppColors.depperPink),
                        ),
                        Text(
                          "Amanhã - Ultrassom",
                          style: TextStyle(color: AppColors.depperPink),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              // Cards de informações (altura, peso, etc)
              // ...
              SizedBox(height: 16),
              // Botões de navegação
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildButton(Icons.star, "Meu histórico"),
                  _buildButton(Icons.calendar_month, "Calendário"),
                ],
              ),
              SizedBox(height: 16),
              _buildButton(Icons.article, "Artigos"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton(IconData icon, String text) {
    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        color: AppColors.lightPink,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppColors.lightPink, size: 40),
          SizedBox(height: 8),
          Text(text, style: TextStyle(color: AppColors.depperPink)),
        ],
      ),
    );
  }
}
