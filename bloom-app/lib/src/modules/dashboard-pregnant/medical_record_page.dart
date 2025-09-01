import 'package:flutter/material.dart';
import 'report_page.dart'; // <-- CORREÇÃO: Import adicionado

// Constantes de cores
const Color _kPrimaryPink = Color(0xFFF55A8A);
const Color _kTextDark = Color(0xFF333333);
const Color _kBackground = Color(0xFFF9F9F9);

class MedicalRecordPage extends StatelessWidget {
  const MedicalRecordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBackground,
      appBar: AppBar(
        title: const Text('Meu Histórico', style: TextStyle(color: _kTextDark)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: _kTextDark),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Exames, vacinas e prescrições',
              style: TextStyle(
                color: _kTextDark,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            // Lista de exames/registros
            _buildRecordItem(
              'Análise Hemática',
              Icons.biotech_outlined,
              '12/08',
            ),
            const SizedBox(height: 12),
            _buildRecordItem(
              'Análise Trimestral',
              Icons.science_outlined,
              '05/09',
            ),
            const SizedBox(height: 12),
            _buildRecordItem(
              '15:00',
              Icons.vaccines_outlined,
              'Vac. de Influenza',
            ),
            const SizedBox(height: 12),
            _buildRecordItem(
              '18:00',
              Icons.medication_outlined,
              'Ácido Fólico (2 comp.)',
            ),
            const Spacer(), // Ocupa o espaço restante
            // Botão para gerar relatório
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // Navega para a tela de relatório
                  Navigator.push(
                    context,
                    // CORREÇÃO: Adicionado 'const' para melhor performance
                    MaterialPageRoute(builder: (_) => const ReportPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _kPrimaryPink,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Gerar Relatório Clínico',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Widget para construir cada item da lista de histórico
  Widget _buildRecordItem(String title, IconData icon, String subtitle) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(icon, color: _kPrimaryPink),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: _kTextDark,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
            ],
          ),
          const Spacer(),
          const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
        ],
      ),
    );
  }
}
