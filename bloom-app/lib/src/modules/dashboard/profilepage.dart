// report_page.dart
import 'package:flutter/material.dart';
import 'package:app/src/core/theme/app_colors.dart';

class ReportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text("Relatório", style: TextStyle(color: AppColors.black)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Image.asset("assets/images/logo.png", height: 80),
                  SizedBox(height: 16),
                  Text(
                    "O seu relatório reunirá, de forma organizada, as informações sobre:",
                    style: TextStyle(color: AppColors.grey),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  // Lista de itens do relatório
                  _buildReportItem("Exames realizados"),
                  _buildReportItem("Sua situação vacinal"),
                  _buildReportItem("Histórico das suas consultas"),
                ],
              ),
            ),
            SizedBox(height: 24),
            // Opções de relatório
            _buildReportOption("Relatório completo", true),
            _buildReportOption("Relatório mensal", false),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.darkerPink,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
              child: Text(
                "Baixar relatório",
                style: TextStyle(color: AppColors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: AppColors.darkerPink),
          SizedBox(width: 8),
          Text(text, style: TextStyle(color: AppColors.black)),
        ],
      ),
    );
  }

  Widget _buildReportOption(String text, bool isChecked) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Checkbox(
            value: isChecked,
            onChanged: (bool? value) {},
            activeColor: AppColors.darkerPink,
          ),
          SizedBox(width: 8),
          Text(text, style: TextStyle(color: AppColors.black)),
        ],
      ),
    );
  }
}
