import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:app/src/core/theme/app_colors.dart';
import 'package:app/src/features/dashboard_pregnant/domain/entities/event.dart';

/// Serviço responsável por gerenciar eventos do calendário via API.
class CalendarService {
  final _storage = const FlutterSecureStorage();
  final String _baseUrl = 'http://127.0.0.1:8000/api/gestante';
  static const String _gestanteId = '123e4567-e89b-12d3-a456-426614174000';

  /// Busca todos os eventos (consultas, exames, vacinas) da API.
  Future<Map<DateTime, List<Event>>> fetchEvents() async {
    final String? token = await _storage.read(key: 'access_token');
    if (token == null) {
      throw Exception('Token de autenticação não encontrado.');
    }

    final headers = {'Authorization': 'Bearer $token'};
    final allEvents = <Map<String, dynamic>>[];

    try {
      final responseConsultas = await http.get(
        Uri.parse('$_baseUrl/consultas'),
        headers: headers,
      );
      if (responseConsultas.statusCode == 200) {
        final data = json.decode(responseConsultas.body);
        allEvents.addAll(List<Map<String, dynamic>>.from(data['dados']));
      }

      final responseExames = await http.get(
        Uri.parse('$_baseUrl/exames'),
        headers: headers,
      );
      if (responseExames.statusCode == 200) {
        final data = json.decode(responseExames.body);
        allEvents.addAll(List<Map<String, dynamic>>.from(data['dados']));
      }

      final responseVacinas = await http.get(
        Uri.parse('$_baseUrl/vacinas'),
        headers: headers,
      );
      if (responseVacinas.statusCode == 200) {
        final data = json.decode(responseVacinas.body);
        allEvents.addAll(List<Map<String, dynamic>>.from(data['dados']));
      }

      final newEvents = <DateTime, List<Event>>{};
      for (var item in allEvents) {
        final String? dataAgendamentoStr = item['data_agendamento'];
        if (dataAgendamentoStr == null) continue;

        final eventDate = DateTime.parse(dataAgendamentoStr).toUtc();
        final eventColor = _getEventColor(item['tipo']);

        final event = Event(
          title: item['nome'] ?? 'Evento',
          description: item['descricao'] ?? '',
          color: eventColor,
        );

        final dayKey = DateTime.utc(
          eventDate.year,
          eventDate.month,
          eventDate.day,
        );
        newEvents.putIfAbsent(dayKey, () => []).add(event);
      }
      return newEvents;
    } catch (e) {
      debugPrint('Erro no CalendarService.fetchEvents: $e');
      rethrow;
    }
  }

  /// Adiciona um novo evento na API.
  Future<void> addEvent(String type, String id, DateTime date) async {
    final String? token = await _storage.read(key: 'access_token');
    if (token == null) {
      throw Exception('Token de autenticação não encontrado.');
    }

    final url = Uri.parse('$_baseUrl/$type/agendar');
    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'id': id,
        'data_agendamento': date.toIso8601String(),
        'gestante_id': _gestanteId,
      }),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return;
    } else {
      final error =
          json.decode(response.body)['detail'] ?? 'Erro desconhecido.';
      throw Exception(error);
    }
  }

  /// Busca itens disponíveis para agendamento (consultas, exames, etc.).
  Future<List<dynamic>> fetchAvailableItems(String type) async {
    final String? token = await _storage.read(key: 'access_token');
    if (token == null) throw Exception('Token não encontrado.');

    final url = Uri.parse('$_baseUrl/$type');
    final headers = {'Authorization': 'Bearer $token'};
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      // Filtramos para retornar apenas itens que AINDA NÃO foram agendados.
      return List<dynamic>.from(
        data['dados'],
      ).where((item) => item['data_agendamento'] == null).toList();
    } else {
      throw Exception('Erro ao carregar itens disponíveis.');
    }
  }

  Color _getEventColor(String? eventType) {
    switch (eventType) {
      case 'consulta':
        return AppColors.info;
      case 'exame':
        return AppColors.success;
      case 'vacina':
        return AppColors.warning;
      default:
        return AppColors.primaryPink;
    }
  }
}
