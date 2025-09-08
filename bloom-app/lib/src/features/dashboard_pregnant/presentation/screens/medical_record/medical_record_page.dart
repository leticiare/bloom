// lib/src/features/dashboard_pregnant/presentation/screens/medical_record/medical_record_page.dart

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:app/src/core/theme/app_colors.dart';

import 'package:app/src/features/dashboard_pregnant/domain/entities/medical_record.dart';
import 'report_page.dart';
import 'package:app/src/features/dashboard_pregnant/presentation/widgets/exam_card.dart';
import 'package:app/src/features/dashboard_pregnant/presentation/widgets/vaccine_card.dart';
import 'package:app/src/features/dashboard_pregnant/presentation/widgets/medication_card.dart';

RecordType getRecordTypeFromString(String type) {
  switch (type) {
    case 'exame':
      return RecordType.exam;
    case 'vacina':
      return RecordType.vaccine;
    case 'consulta':
      return RecordType.consultation;
    case 'medicacao':
      return RecordType.medication;
    default:
      return RecordType.consultation;
  }
}

MedicalRecord fromJson(Map<String, dynamic> json, RecordType type) {
  return MedicalRecord(
    id: json['id'] as String,
    type: type,
    title: json['nome'] as String,
    description: json['descricao'] as String,
    status: json['status'] == 'agendado'
        ? RecordStatus.scheduled
        : (json['status'] == 'realizado' || json['status'] == 'aplicado'
              ? RecordStatus.completed
              : RecordStatus.canceled),
    date: json['data_agendamento'] as String?,
  );
}

class MedicalRecordPage extends StatefulWidget {
  const MedicalRecordPage({super.key});

  @override
  State<MedicalRecordPage> createState() => _MedicalRecordPageState();
}

class _MedicalRecordPageState extends State<MedicalRecordPage> {
  final _storage = const FlutterSecureStorage();
  List<MedicalRecord> _records = [];
  bool _isLoading = true;
  String? _errorMessage;
  final Map<String, RecordStatus> _changes = {};

  @override
  void initState() {
    super.initState();
    _fetchRecords();
  }

  Future<void> _fetchRecords() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final String? token = await _storage.read(key: 'access_token');
      if (token == null)
        throw Exception('Token de autenticação não encontrado.');

      final headers = {'Authorization': 'Bearer $token'};
      final List<MedicalRecord> fetchedRecords = [];

      final urls = {
        'exame': 'http://127.0.0.1:8000/api/gestante/exames/agendados',
        'consulta': 'http://127.0.0.1:8000/api/gestante/consultas/agendados',
        'vacina': 'http://127.0.0.1:8000/api/gestante/vacinas/agendadas',
      };

      for (var entry in urls.entries) {
        final response = await http.get(
          Uri.parse(entry.value),
          headers: headers,
        );
        if (response.statusCode == 200) {
          final List<dynamic> data = json.decode(response.body)['dados'];
          for (var item in data) {
            final recordType = getRecordTypeFromString(entry.key);
            fetchedRecords.add(fromJson(item, recordType));
          }
        } else {
          throw Exception(
            'Erro ao carregar dados de ${entry.key}: ${response.statusCode}',
          );
        }
      }

      fetchedRecords.sort((a, b) {
        if (a.date == null || b.date == null) return 0;
        return DateTime.parse(b.date!).compareTo(DateTime.parse(a.date!));
      });

      setState(() {
        _records = fetchedRecords;
        _isLoading = false;
        _changes.clear();
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Erro ao carregar o histórico: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  void _toggleRecordStatus(MedicalRecord record, RecordStatus newStatus) {
    setState(() {
      record.status = newStatus;
      _changes[record.id] = newStatus;
    });
  }

  Future<void> _saveChanges() async {
    if (_changes.isEmpty) return;

    try {
      final String? token = await _storage.read(key: 'access_token');
      if (token == null)
        throw Exception('Token de autenticação não encontrado.');
      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      for (var change in _changes.entries) {
        final record = _records.firstWhere((item) => item.id == change.key);
        final newStatus = change.value;
        final String endpoint;

        if (newStatus == RecordStatus.completed) {
          endpoint = record.type == RecordType.exam
              ? 'exames/realizar'
              : record.type == RecordType.consultation
              ? 'consultas/realizar'
              : 'vacinas/aplicar';
        } else {
          endpoint = record.type == RecordType.exam
              ? 'exames/cancelar'
              : record.type == RecordType.consultation
              ? 'consultas/cancelar'
              : 'vacinas/cancelar';
        }

        final url = Uri.parse('http://127.0.0.1:8000/api/gestante/$endpoint');
        final response = await http.put(
          url,
          headers: headers,
          body: json.encode({'id': record.id}),
        );

        if (response.statusCode != 200) {
          throw Exception(
            'Erro ao salvar alteração para o registro ${record.id}',
          );
        }
      }

      _fetchRecords();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Alterações salvas com sucesso!')),
      );
    } catch (e) {
      setState(() {
        _errorMessage = 'Erro ao salvar as alterações: ${e.toString()}';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao salvar as alterações: ${e.toString()}'),
        ),
      );
    }
  }

  void _deleteRecord(MedicalRecord record) {
    setState(() {
      _records.removeWhere((item) => item.id == record.id);
      _changes.remove(record.id);
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
            if (_isLoading)
              const Expanded(child: Center(child: CircularProgressIndicator()))
            else if (_errorMessage != null)
              Expanded(child: Center(child: Text(_errorMessage!)))
            else if (_records.isEmpty)
              const Expanded(
                child: Center(child: Text('Nenhum registro encontrado.')),
              )
            else
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.only(bottom: 16),
                  itemCount: _records.length,
                  itemBuilder: (context, index) {
                    final record = _records[index];

                    Widget card;
                    switch (record.type) {
                      case RecordType.exam:
                        card = ExamCard(
                          record: record,
                          onStatusChange: (status) =>
                              _toggleRecordStatus(record, status),
                          onDelete: () => _deleteRecord(record),
                        );
                        break;
                      case RecordType.vaccine:
                        card = VaccineCard(
                          record: record,
                          onStatusChange: (status) =>
                              _toggleRecordStatus(record, status),
                          onDelete: () => _deleteRecord(record),
                        );
                        break;
                      case RecordType.consultation:
                        card = MedicationCard(
                          record: record,
                          onStatusChange: (status) =>
                              _toggleRecordStatus(record, status),
                          onDelete: () => _deleteRecord(record),
                        );
                        break;
                      default:
                        card = const SizedBox.shrink();
                    }
                    return card;
                  },
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 16),
                ),
              ),
            ElevatedButton(
              onPressed: _changes.isNotEmpty ? _saveChanges : null,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: _changes.isNotEmpty
                    ? AppColors.primaryPink
                    : Colors.grey,
              ),
              child: const Text('Salvar Alterações'),
            ),
            const SizedBox(height: 10),
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
