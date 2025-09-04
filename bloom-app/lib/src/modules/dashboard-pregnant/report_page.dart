import 'package:flutter/material.dart';
import 'medical_record_page.dart';

// --- CONSTANTES DE CORES ---
const Color _kPrimaryPink = Color(0xFFF55A8A);
const Color _kLightPink = Color(0xFFFFF0F5);
const Color _kTextDark = Color(0xFF333333);
const Color _kTextLight = Color(0xFF828282);
const Color _kBackground = Color(0xFFF9F9F9);

class ReportPage extends StatefulWidget {
  final List<MedicalRecord> records;

  const ReportPage({super.key, this.records = const []});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  bool _isCompleteReport = true;
  bool _isMonthlyReport = false;

  @override
  Widget build(BuildContext context) {
    final pendingItems = widget.records
        .where((record) => record.status != RecordStatus.completed)
        .toList();

    return Scaffold(
      backgroundColor: _kBackground,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: _kTextDark),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Relatório Clínico',
          style: TextStyle(color: _kTextDark),
        ),
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
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            _buildInfoCard(),
            const SizedBox(height: 24),
            _buildPendingItemsSection(pendingItems),
            const Spacer(),
            _buildCheckbox(
              title: 'Relatório completo',
              value: _isCompleteReport,
              onChanged: (value) {
                setState(() {
                  _isCompleteReport = value ?? false;
                });
              },
            ),
            _buildCheckbox(
              title: 'Relatório mensal',
              value: _isMonthlyReport,
              onChanged: (value) {
                setState(() {
                  _isMonthlyReport = value ?? false;
                });
              },
            ),
            const SizedBox(height: 24),
            _buildDownloadButton(),
          ],
        ),
      ),
    );
  }

  // --- MÉTODOS AUXILIARES ---
  // Os métodos abaixo estão DENTRO da classe _ReportPageState para que possam usar o 'context'
  // e o 'setState' corretamente.

  Widget _buildPendingItemsSection(List<MedicalRecord> pendingItems) {
    if (pendingItems.isEmpty) {
      return const Text(
        '🎉 Tudo em dia! Você não tem nenhuma pendência.',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.green,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Falta você fazer isso:',
          style: TextStyle(
            color: _kTextDark,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...pendingItems.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  color: _kPrimaryPink,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    item.name,
                    style: const TextStyle(color: _kTextDark, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _kLightPink,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.monitor_heart_outlined,
            color: _kPrimaryPink,
            size: 40,
          ),
          const SizedBox(height: 16),
          const Text(
            'O seu relatório reunirá, de forma organizada, as informações sobre:',
            textAlign: TextAlign.center,
            style: TextStyle(color: _kTextDark, fontSize: 16, height: 1.5),
          ),
          const SizedBox(height: 20),
          const Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: [
              Chip(label: Text('Exames realizados')),
              Chip(label: Text('Sua situação vacinal')),
              Chip(label: Text('Histórico das suas consultas')),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Assim, você terá tudo em mãos para acompanhar sua saúde e a do seu bebê com mais tranquilidade.',
            textAlign: TextAlign.center,
            style: TextStyle(color: _kTextLight.withOpacity(0.8)),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckbox({
    required String title,
    required bool value,
    required ValueChanged<bool?> onChanged,
  }) {
    return CheckboxListTile(
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, color: _kTextDark),
      ),
      value: value,
      onChanged: onChanged,
      activeColor: _kPrimaryPink,
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildDownloadButton() {
    return ElevatedButton(
      onPressed: () {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Gerando relatório...')));
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: _kPrimaryPink,
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: const Text(
        'Baixar Relatório',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
