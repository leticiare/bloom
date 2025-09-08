import 'package:flutter/material.dart';
import 'package:app/src/core/theme/app_colors.dart';
import 'package:app/src/features/dashboard_pregnant/domain/entities/medical_record.dart';
import 'package:app/src/features/dashboard_pregnant/data/services/report_service.dart';

/// Tela para gerar e baixar o relatório clínico da gestante.
class ReportPage extends StatefulWidget {
  final List<MedicalRecord> records;
  const ReportPage({super.key, this.records = const []});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  final _reportService = ReportService();
  bool _isCompleteReport = true;
  bool _isMonthlyReport = false;
  bool _isLoading = false;

  /// Chama o serviço para baixar o relatório e exibe o feedback na tela.
  Future<void> _downloadReport() async {
    setState(() => _isLoading = true);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Gerando e baixando relatório...')),
    );

    try {
      final reportType = _isCompleteReport ? 'completo' : 'mensal';
      final filePath = await _reportService.downloadReport(
        reportType: reportType,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Relatório salvo em: $filePath'),
          backgroundColor: AppColors.success,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao baixar relatório: ${e.toString()}'),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final pendingItems = widget.records
        .where((record) => record.status != RecordStatus.completed)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Relatório Clínico'),
        actions: [
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
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
                  if (_isCompleteReport) _isMonthlyReport = false;
                });
              },
            ),
            _buildCheckbox(
              title: 'Relatório mensal',
              value: _isMonthlyReport,
              onChanged: (value) {
                setState(() {
                  _isMonthlyReport = value ?? false;
                  if (_isMonthlyReport) _isCompleteReport = false;
                });
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _downloadReport,
              child: _isLoading
                  ? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                  : const Text('Baixar Relatório'),
            ),
          ],
        ),
      ),
    );
  }

  /// Constrói a seção que lista os itens pendentes.
  Widget _buildPendingItemsSection(List<MedicalRecord> pendingItems) {
    if (pendingItems.isEmpty) {
      return const Text(
        '🎉 Tudo em dia! Você não tem nenhuma pendência.',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: AppColors.success,
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
            color: AppColors.textDark,
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
                  color: AppColors.primaryPink,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    item.name,
                    style: const TextStyle(
                      color: AppColors.textDark,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Constrói o card informativo no topo da tela.
  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.lightGray,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.monitor_heart_outlined,
            color: AppColors.primaryPink,
            size: 40,
          ),
          const SizedBox(height: 16),
          const Text(
            'O seu relatório reunirá, de forma organizada, as informações sobre:',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textDark,
              fontSize: 16,
              height: 1.5,
            ),
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
            style: TextStyle(color: AppColors.textGray.withOpacity(0.8)),
          ),
        ],
      ),
    );
  }

  /// Constrói um item de checkbox.
  Widget _buildCheckbox({
    required String title,
    required bool value,
    required ValueChanged<bool?> onChanged,
  }) {
    return CheckboxListTile(
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: AppColors.textDark,
        ),
      ),
      value: value,
      onChanged: onChanged,
      activeColor: AppColors.primaryPink,
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: EdgeInsets.zero,
    );
  }
}
