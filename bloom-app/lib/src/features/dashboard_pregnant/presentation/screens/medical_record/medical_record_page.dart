import 'package:flutter/material.dart';
import 'package:app/src/core/theme/app_colors.dart';
import 'package:app/src/features/dashboard_pregnant/data/datasources/mock_dashboard_data.dart';
import 'package:app/src/features/dashboard_pregnant/domain/entities/medical_record.dart';
import 'package:app/src/features/dashboard_pregnant/presentation/widgets/exam_card.dart';
import 'package:app/src/features/dashboard_pregnant/presentation/widgets/vaccine_card.dart';
import 'package:app/src/features/dashboard_pregnant/presentation/widgets/medication_card.dart';
import 'report_page.dart';

/// Exibe e gerencia o histórico médico completo da gestante.
class MedicalRecordPage extends StatefulWidget {
  const MedicalRecordPage({super.key});

  @override
  State<MedicalRecordPage> createState() => _MedicalRecordPageState();
}

class _MedicalRecordPageState extends State<MedicalRecordPage> {
  // A lista de registros agora é uma variável de estado.
  late List<MedicalRecord> _records;

  @override
  void initState() {
    super.initState();
    // Carregamos uma cópia da lista mock para poder modificá-la.
    _records = List.from(mockHistory);
  }

  /// Altera o status de um registro (feito/pendente).
  void _toggleRecordStatus(MedicalRecord record) {
    setState(() {
      if (record.status == RecordStatus.completed) {
        record.status = RecordStatus.pending;
      } else {
        record.status = RecordStatus.completed;
      }
    });
  }

  /// Remove um registro da lista.
  void _deleteRecord(MedicalRecord record) {
    setState(() {
      _records.removeWhere((item) => item.id == record.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meu Histórico')),
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
                itemCount: _records.length,
                itemBuilder: (context, index) {
                  final record = _records[index];
                  // Passamos as funções de callback para os cards
                  switch (record.type) {
                    case RecordType.exam:
                      return ExamCard(
                        record: record,
                        onStatusChange: () => _toggleRecordStatus(record),
                        onDelete: () => _deleteRecord(record),
                      );
                    case RecordType.vaccine:
                      // Crie o VaccineCard com os mesmos callbacks
                      return VaccineCard(
                        record: record,
                        onStatusChange: () => _toggleRecordStatus(record),
                        onDelete: () => _deleteRecord(record),
                      );
                    case RecordType.medication:
                      // Crie o MedicationCard com os mesmos callbacks
                      return MedicationCard(
                        record: record,
                        onStatusChange: () => _toggleRecordStatus(record),
                        onDelete: () => _deleteRecord(record),
                      );
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
                    builder: (_) => ReportPage(records: _records),
                  ),
                );
              },
              child: const Text('Gerar Relatório Clínico'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
