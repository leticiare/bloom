import 'package:flutter/material.dart';
import 'package:app/src/core/theme/app_colors.dart';

class HistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text("Meu histórico", style: TextStyle(color: AppColors.black)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Botões de filtro de semana (101, 102, etc)
              // ...
              SizedBox(height: 16),
              _buildRecordSection("Exames, vacinas e prescrições"),
              SizedBox(height: 16),
              // Lista de registros
              _buildRecordCard("Nome do exame", "Anexar Resultado"),
              _buildRecordCard("Nome da vacina", "Anexar Resultado"),
              _buildRecordCard("Nome do exame", "24 de Fevereiro"),
              _buildRecordCard("Nome da vacina", "A cada 12 horas"),
              SizedBox(height: 24),
              _buildGenerateReportButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecordSection(String title) {
    return Text(
      title,
      style: TextStyle(
        color: AppColors.black,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildRecordCard(String title, String subtitle) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: AppColors.grey)),
                SizedBox(height: 4),
                Text(subtitle, style: TextStyle(color: AppColors.boldPink)),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.delete, color: AppColors.grey),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildGenerateReportButton() {
    return ElevatedButton(
      onPressed: () {
        // Navegar para a tela de relatório
      },
      style: ElevatedButton.styleFrom(
        backgroundColor:
            AppColors.background, // Substitua 'primary' por 'backgroundColor'
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      ),
      child: Text(
        "Gerar Relatório Clínico",
        style: TextStyle(color: AppColors.white),
      ),
    );
  }
}
