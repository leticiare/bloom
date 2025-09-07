// lib/src/modules/dashboard-pregnant/calendar_page.dart

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:uuid/uuid.dart';

// --- CONSTANTES DE CORES ---
const Color _kPrimaryPink = Color(0xFFF55A8A);
const Color _kTextDark = Color(0xFF333333);
const Color _kTextLight = Color(0xFF828282);
const Color _kBackground = Color(0xFFF9F9F9);

// --- CLASSE SIMPLES PARA REPRESENTAR UM EVENTO ---
class Event {
  final String title;
  final String description;
  final Color color;

  Event({required this.title, required this.description, required this.color});

  @override
  String toString() => title;
}

// --- PÁGINA DO CALENDÁRIO ---
class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageSate();
}

class _CalendarPageSate extends State<CalendarPage> {
  final _storage = const FlutterSecureStorage();
  late final ValueNotifier<List<Event>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  Map<DateTime, List<Event>> _events = {};

  bool _isLoading = true;
  String? _errorMessage;

  static const String _gestanteId = '123e4567-e89b-12d3-a456-426614174000';

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier([]);
    _fetchEvents();
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  // Função para buscar os eventos da API
  Future<void> _fetchEvents() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final String? token = await _storage.read(key: 'access_token');
      if (token == null) {
        throw Exception('Token de autenticação não encontrado.');
      }

      final headers = {'Authorization': 'Bearer $token'};

      final urlConsultas = Uri.parse(
        'http://127.0.0.1:8000/api/gestante/consultas',
      );
      final responseConsultas = await http.get(urlConsultas, headers: headers);

      final urlExames = Uri.parse('http://127.0.0.1:8000/api/gestante/exames');
      final responseExames = await http.get(urlExames, headers: headers);

      final urlVacinas = Uri.parse(
        'http://127.0.0.1:8000/api/gestante/vacinas',
      );
      final responseVacinas = await http.get(urlVacinas, headers: headers);

      final allEvents = <Map<String, dynamic>>[];

      if (responseConsultas.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(responseConsultas.body);
        allEvents.addAll(List<Map<String, dynamic>>.from(data['dados']));
      }
      if (responseExames.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(responseExames.body);
        allEvents.addAll(List<Map<String, dynamic>>.from(data['dados']));
      }
      if (responseVacinas.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(responseVacinas.body);
        allEvents.addAll(List<Map<String, dynamic>>.from(data['dados']));
      }

      final newEvents = <DateTime, List<Event>>{};
      for (var item in allEvents) {
        final String? dataAgendamentoStr = item['data_agendamento'];
        final String? dataSemanaInicioStr = item['data_semana_inicio'];
        final String? tipo = item['tipo'];

        DateTime? eventDate;
        if (dataAgendamentoStr != null) {
          eventDate = DateTime.parse(dataAgendamentoStr).toUtc();
        } else if (dataSemanaInicioStr != null) {
          eventDate = DateTime.parse(dataSemanaInicioStr).toUtc();
        }

        if (eventDate != null) {
          final Color eventColor;
          switch (tipo) {
            case 'consulta':
              eventColor = Colors.blue.shade300;
              break;
            case 'exame':
              eventColor = Colors.green.shade300;
              break;
            case 'vacina':
              eventColor = Colors.yellow.shade400;
              break;
            default:
              eventColor = _kPrimaryPink;
          }
          final event = Event(
            title: item['nome'] ?? 'Evento',
            description: item['descricao'] ?? '',
            color: eventColor,
          );

          if (newEvents[eventDate] == null) {
            newEvents[eventDate] = [];
          }
          newEvents[eventDate]?.add(event);
        }
      }

      setState(() {
        _events = newEvents;
        _selectedEvents.value = _getEventsForDay(_selectedDay!);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Erro ao carregar dados: ${e.toString()}';
      });
    }
  }

  // Função para adicionar um novo evento via API
  Future<void> _addEvent(String type, String id, DateTime date) async {
    try {
      final String? token = await _storage.read(key: 'access_token');
      if (token == null) {
        throw Exception('Token de autenticação não encontrado.');
      }

      final url = Uri.parse('http://127.0.0.1:8000/api/gestante/$type/agendar');

      final response = await http.put(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'id': id,
          'data_agendamento': date.toIso8601String(),
          'gestante_id': _gestanteId,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Evento adicionado com sucesso!')),
        );
        _fetchEvents();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao adicionar evento: ${response.statusCode}'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro: ${e.toString()}')));
    }
  }

  // Função para obter os eventos de um dia específico
  List<Event> _getEventsForDay(DateTime day) {
    return _events[DateTime.utc(day.year, day.month, day.day)] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });
      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  // Diálogo para adicionar novo evento (lógica alterada)
  void _showAddEventDialog() async {
    String? selectedType;
    List<dynamic> availableItems = [];
    bool isFetching = false;
    String? fetchError;

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            // Função interna para buscar os itens disponíveis
            Future<void> _fetchAvailableItems(String type) async {
              setState(() {
                isFetching = true;
                fetchError = null;
                availableItems = [];
              });
              try {
                final String? token = await _storage.read(key: 'access_token');
                if (token == null) throw Exception('Token não encontrado.');

                final url = Uri.parse(
                  'http://127.0.0.1:8000/api/gestante/$type',
                );
                final headers = {'Authorization': 'Bearer $token'};
                final response = await http.get(url, headers: headers);

                if (response.statusCode == 200) {
                  final Map<String, dynamic> data = json.decode(response.body);
                  availableItems = List<dynamic>.from(data['dados']);
                } else {
                  throw Exception('Erro ao carregar itens.');
                }
              } catch (e) {
                fetchError = e.toString();
              } finally {
                setState(() {
                  isFetching = false;
                });
              }
            }

            return AlertDialog(
              title: const Text('Adicionar Evento'),
              content: SizedBox(
                // Usando SizedBox para dar uma altura máxima ao conteúdo
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.5,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Tipo de Evento',
                      ),
                      value: selectedType,
                      items: const [
                        DropdownMenuItem(
                          value: 'consultas',
                          child: Text('Consulta'),
                        ),
                        DropdownMenuItem(value: 'exames', child: Text('Exame')),
                        DropdownMenuItem(
                          value: 'vacinas',
                          child: Text('Vacina'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedType = value;
                          _fetchAvailableItems(value!);
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    if (isFetching)
                      const Expanded(
                        child: Center(child: CircularProgressIndicator()),
                      )
                    else if (fetchError != null)
                      Expanded(child: Center(child: Text('Erro: $fetchError')))
                    else if (availableItems.isEmpty && selectedType != null)
                      const Expanded(
                        child: Center(
                          child: Text('Nenhum item disponível para agendar.'),
                        ),
                      )
                    else if (selectedType != null)
                      Expanded(
                        child: ListView.builder(
                          itemCount: availableItems.length,
                          itemBuilder: (context, index) {
                            final item = availableItems[index];
                            return Card(
                              child: ListTile(
                                title: Text(item['nome'] ?? 'Item sem nome'),
                                subtitle: Text(item['descricao'] ?? ''),
                                onTap: () async {
                                  final pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: _selectedDay ?? DateTime.now(),
                                    firstDate: DateTime(2020),
                                    lastDate: DateTime(2030),
                                  );
                                  if (pickedDate != null) {
                                    await _addEvent(
                                      selectedType!,
                                      item['id'],
                                      pickedDate,
                                    );
                                    Navigator.of(context).pop();
                                  }
                                },
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancelar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBackground,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: _kTextDark),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Calendário', style: TextStyle(color: _kTextDark)),
        backgroundColor: _kBackground,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: _kTextDark),
            onPressed: _showAddEventDialog,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? Center(child: Text(_errorMessage!))
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  _buildCalendar(),
                  const SizedBox(height: 24.0),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Agenda',
                      style: TextStyle(
                        color: _kTextDark,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Expanded(child: _buildEventList()),
                ],
              ),
            ),
    );
  }

  // Widget que constrói o calendário
  Widget _buildCalendar() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: TableCalendar<Event>(
        locale: 'pt_BR',
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: _focusedDay,
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        calendarFormat: _calendarFormat,
        startingDayOfWeek: StartingDayOfWeek.sunday,
        eventLoader: _getEventsForDay,
        onDaySelected: _onDaySelected,
        onFormatChanged: (format) {
          if (_calendarFormat != format) {
            setState(() {
              _calendarFormat = format;
            });
          }
        },
        onPageChanged: (focusedDay) {
          _focusedDay = focusedDay;
        },
        // --- ESTILIZAÇÃO PARA FICAR PARECIDO COM O SEU DESIGN ---
        headerStyle: HeaderStyle(
          titleCentered: true,
          formatButtonVisible: false,
          titleTextStyle: const TextStyle(
            color: _kPrimaryPink,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          leftChevronIcon: const Icon(Icons.chevron_left, color: _kTextDark),
          rightChevronIcon: const Icon(Icons.chevron_right, color: _kTextDark),
          titleTextFormatter: (date, locale) =>
              DateFormat.yMMMM(locale).format(date).toUpperCase(),
        ),
        calendarStyle: const CalendarStyle(
          todayDecoration: BoxDecoration(
            color: Color(0xFFF5C3D5), // Rosa mais claro para o dia de hoje
            shape: BoxShape.circle,
          ),
          selectedDecoration: BoxDecoration(
            color: _kPrimaryPink, // Rosa principal para o dia selecionado
            shape: BoxShape.circle,
          ),
          markerDecoration: BoxDecoration(
            color: _kPrimaryPink, // Cor do pontinho do evento
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }

  // Widget que constrói a lista de eventos para o dia selecionado
  Widget _buildEventList() {
    return ValueListenableBuilder<List<Event>>(
      valueListenable: _selectedEvents,
      builder: (context, value, _) {
        if (value.isEmpty) {
          return const Center(
            child: Text(
              'Nenhum evento para este dia.',
              style: TextStyle(color: _kTextLight, fontSize: 16),
            ),
          );
        }
        return ListView.builder(
          itemCount: value.length,
          itemBuilder: (context, index) {
            final event = value[index];
            return Card(
              elevation: 0.5,
              margin: const EdgeInsets.symmetric(vertical: 6.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: Container(width: 5, height: 50, color: event.color),
                title: Text(
                  event.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _kTextDark,
                  ),
                ),
                subtitle: Text(
                  event.description,
                  style: const TextStyle(color: _kTextLight),
                ),
                trailing: const Icon(Icons.more_horiz, color: _kTextLight),
              ),
            );
          },
        );
      },
    );
  }
}
