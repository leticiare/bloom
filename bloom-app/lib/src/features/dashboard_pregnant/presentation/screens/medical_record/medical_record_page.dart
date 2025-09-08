import 'package:flutter/material.dart';
import 'package:app/src/core/theme/app_colors.dart';
import 'package:app/src/features/dashboard_pregnant/data/datasources/mock_dashboard_data.dart';
import 'package:app/src/features/dashboard_pregnant/domain/entities/medical_record.dart';
import 'package:app/src/features/dashboard_pregnant/presentation/widgets/exam_card.dart';
import 'package:app/src/features/dashboard_pregnant/presentation/widgets/vaccine_card.dart';
import 'package:app/src/features/dashboard_pregnant/presentation/widgets/medication_card.dart';
import 'report_page.dart';

/// Exibe o histórico médico completo da gestante.
class MedicalRecordPage extends StatelessWidget {
  const MedicalRecordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Histórico'),
        actions: [
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            const Text(
              'Exames, vacinas e prescrições',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.only(bottom: 16),
                itemCount: mockHistory.length,
                itemBuilder: (context, index) {
                  final record = mockHistory[index];
                  switch (record.type) {
                    case RecordType.exam:
                      return ExamCard(record: record);
                    case RecordType.vaccine:
                      return VaccineCard(record: record);
                    case RecordType.medication:
                      return MedicationCard(record: record);
                  }
                },
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 16),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ReportPage(records: mockHistory),
                  ),
                );
              },
              child: const Text('Gerar Relatório Clínico'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () {
                /* Lógica de download pode ser adicionada aqui se necessário */
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primaryPink,
                side: const BorderSide(
                  color: AppColors.primaryPink,
                  width: 1.5,
                ),
              ),
              child: const Text('Baixar Histórico (PDF)'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
