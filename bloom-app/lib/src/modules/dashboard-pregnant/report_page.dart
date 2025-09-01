import 'package:flutter/material.dart';

// Constantes de cores
const Color _kPrimaryPink = Color(0xFFF55A8A);
const Color _kTextDark = Color(0xFF333333);
const Color _kBackground = Color(0xFFF9F9F9);
const Color _kLightPinkBackground = Color(0xFFFFF0F5);

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  // Variável para controlar qual relatório está selecionado
  String _selectedReportType = 'completo';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBackground,
      appBar: AppBar(
        title: const Text(
          'Relatório Clínico',
          style: TextStyle(color: _kTextDark),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: _kTextDark),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: _kLightPinkBackground,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'O seu relatório reunirá, de forma segura, todas as informações da sua gestação.',
                textAlign: TextAlign.center,
                style: TextStyle(color: _kPrimaryPink, fontSize: 14),
              ),
            ),
            const SizedBox(height: 30),
            // Opções de tipo de relatório
            _buildRadioOption('Relatório completo', 'completo'),
            const SizedBox(height: 12),
            _buildRadioOption('Relatório manual', 'manual'),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // Lógica para baixar o relatório
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: _kPrimaryPink,
                  side: const BorderSide(color: _kPrimaryPink),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Baixar relatório',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Widget para construir as opções de rádio
  Widget _buildRadioOption(String title, String value) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedReportType = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _selectedReportType == value
                ? _kPrimaryPink
                : Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Radio<String>(
              value: value,
              groupValue: _selectedReportType,
              onChanged: (newValue) {
                setState(() {
                  _selectedReportType = newValue!;
                });
              },
              activeColor: _kPrimaryPink,
            ),
            Text(title, style: const TextStyle(color: _kTextDark)),
          ],
        ),
      ),
    );
  }
}
