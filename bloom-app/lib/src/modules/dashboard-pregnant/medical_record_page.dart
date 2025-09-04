import 'package:flutter/material.dart';
import 'report_page.dart';

// --- CONSTANTES DE CORES ---
const Color _kPrimaryPink = Color(0xFFF55A8A);
const Color _kLightPink = Color(0xFFFFF0F5);
const Color _kTextDark = Color(0xFF333333);
const Color _kTextLight = Color(0xFF828282);
const Color _kBackground = Color(0xFFF9F9F9);
const Color _kGreyTag = Color(0xFFF2F2F2);
const Color _kOverdue = Color(0xFFE2B452);

// --- MODELOS DE DADOS ---
enum RecordType { exam, vaccine, medication }

enum RecordStatus { pending, completed, overdue }

class MedicalRecord {
  final RecordType type;
  final String name;
  final RecordStatus status;
  final String? time;
  final String? date;
  final String? frequency;

  MedicalRecord({
    required this.type,
    required this.name,
    required this.status,
    this.time,
    this.date,
    this.frequency,
  });
}

// --- LISTA DE DADOS MOCKADOS ---
final List<MedicalRecord> _mockHistory = [
  MedicalRecord(
    type: RecordType.exam,
    name: 'Ultrassom Morfológico',
    status: RecordStatus.completed,
  ),
  MedicalRecord(
    type: RecordType.exam,
    name: 'Exame de Glicemia',
    status: RecordStatus.pending,
  ),
  MedicalRecord(
    type: RecordType.vaccine,
    name: 'Vacina dTpa',
    status: RecordStatus.pending,
    time: '14:00',
    date: '24 de Fevereiro',
  ),
  MedicalRecord(
    type: RecordType.medication,
    name: 'Ácido Fólico',
    status: RecordStatus.completed,
    time: '08:00',
    frequency: 'A cada 12 horas',
  ),
  MedicalRecord(
    type: RecordType.medication,
    name: 'Ferritina',
    status: RecordStatus.overdue,
    time: '20:00',
    frequency: 'A cada 24 horas',
  ),
  MedicalRecord(
    type: RecordType.exam,
    name: 'Exame de Urina',
    status: RecordStatus.completed,
  ),
  MedicalRecord(
    type: RecordType.vaccine,
    name: 'Vacina contra Hepatite B',
    status: RecordStatus.pending,
    time: '10:00',
    date: '20 de Março',
  ),
];

// --- WIDGET PRINCIPAL DA PÁGINA ---
class MedicalRecordPage extends StatelessWidget {
  const MedicalRecordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBackground,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: _kTextDark),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Meu Histórico', style: TextStyle(color: _kTextDark)),
        backgroundColor: _kBackground,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: _kTextDark),
            onPressed: () {},
          ),
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
                color: _kTextDark,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.only(bottom: 16),
                itemCount: _mockHistory.length,
                itemBuilder: (context, index) {
                  final record = _mockHistory[index];
                  switch (record.type) {
                    case RecordType.exam:
                      return _ExamCard(record: record);
                    case RecordType.vaccine:
                      return _VaccineCard(record: record);
                    case RecordType.medication:
                      return _MedicationCard(record: record);
                  }
                },
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 16),
              ),
            ),
            _buildGenerateReportButton(context),
            const SizedBox(height: 12),
            _buildDownloadButton(context),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // --- MÉTODOS AUXILIARES ---
  // Estes métodos foram movidos para DENTRO da classe para que possam usar 'context'.

  Widget _buildGenerateReportButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ReportPage(records: _mockHistory)),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: _kPrimaryPink,
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
      ),
      child: const Text(
        'Gerar Relatório Clínico',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildDownloadButton(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Lógica de download de PDF será implementada!'),
          ),
        );
      },
      style: OutlinedButton.styleFrom(
        foregroundColor: _kPrimaryPink,
        side: const BorderSide(color: _kPrimaryPink, width: 2),
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: const Text(
        'Baixar Histórico (PDF)',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}

// --- WIDGETS DE CARD ---
// Estes widgets não precisam de 'context' para navegação ou snakbars, então
// podem ser definidos fora da classe principal para manter o código limpo.

class _InfoTag extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color textColor;
  final Color backgroundColor;

  const _InfoTag({
    required this.icon,
    required this.text,
    this.textColor = _kTextLight,
    this.backgroundColor = _kGreyTag,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: textColor, size: 16),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

class _ExamCard extends StatelessWidget {
  final MedicalRecord record;
  const _ExamCard({required this.record});

  @override
  Widget build(BuildContext context) {
    final bool isCompleted = record.status == RecordStatus.completed;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _kLightPink.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                record.name,
                style: const TextStyle(
                  color: _kTextDark,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Icon(
                isCompleted
                    ? Icons.check_box_outlined
                    : Icons.check_box_outline_blank,
                color: isCompleted ? _kPrimaryPink : _kTextLight,
              ),
            ],
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(
              Icons.add_circle_outline,
              size: 18,
              color: _kPrimaryPink,
            ),
            label: const Text(
              'Anexar Resultado',
              style: TextStyle(
                color: _kPrimaryPink,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _VaccineCard extends StatelessWidget {
  final MedicalRecord record;
  const _VaccineCard({required this.record});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _kLightPink.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                record.name,
                style: const TextStyle(
                  color: _kTextDark,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const Icon(Icons.check_box_outline_blank, color: _kTextLight),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              if (record.time != null)
                _InfoTag(
                  icon: Icons.access_time_filled_outlined,
                  text: record.time!,
                ),
              if (record.time != null && record.date != null)
                const SizedBox(width: 8),
              if (record.date != null)
                _InfoTag(
                  icon: Icons.calendar_today_outlined,
                  text: record.date!,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MedicationCard extends StatelessWidget {
  final MedicalRecord record;
  const _MedicationCard({required this.record});

  @override
  Widget build(BuildContext context) {
    final bool isOverdue = record.status == RecordStatus.overdue;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _kLightPink.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                record.name,
                style: const TextStyle(
                  color: _kTextDark,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Icon(
                isOverdue ? Icons.warning_amber_outlined : Icons.delete_outline,
                color: isOverdue ? _kOverdue : _kTextLight,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              if (record.time != null)
                _InfoTag(
                  icon: Icons.access_time_filled_outlined,
                  text: record.time!,
                ),
              if (record.time != null && record.frequency != null)
                const SizedBox(width: 8),
              if (record.frequency != null)
                _InfoTag(icon: Icons.refresh_outlined, text: record.frequency!),
            ],
          ),
        ],
      ),
    );
  }
}
