// lib/src/modules/dashboard-pregnant/calendar_page.dart

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

// --- CONSTANTES DE CORES (copiadas da sua HomePage para consistência) ---
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
// Convertido para StatefulWidget para gerenciar o estado do calendário
class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageSate();
}

class _CalendarPageSate extends State<CalendarPage> {
  // Variáveis de estado para controlar o calendário
  late final ValueNotifier<List<Event>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  // Mapa para guardar nossos eventos. A chave é o dia, o valor é uma lista de eventos.
  late final Map<DateTime, List<Event>> _events;

  @override
  void initState() {
    super.initState();

    _selectedDay = _focusedDay;

    // DADOS DE EXEMPLO (simulando os eventos da sua imagem)
    _events = {
      DateTime.utc(2025, 9, 19): [
        Event(
          title: 'Nutricionista',
          description: 'Comer mais fibras e beber muita água.',
          color: Colors.blue.shade300,
        ),
      ],
      DateTime.utc(2025, 9, 27): [
        Event(
          title: 'Ultrassom',
          description: 'Morfológico do segundo trimestre.',
          color: Colors.green.shade300,
        ),
      ],
      DateTime.utc(2025, 9, 30): [
        Event(
          title: 'Ginecologista',
          description: 'Consulta de rotina.',
          color: Colors.yellow.shade400,
        ),
      ],
    };

    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  // Função para obter os eventos de um dia específico
  List<Event> _getEventsForDay(DateTime day) {
    // A implementação do table_calendar usa UTC para as chaves do mapa
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
            onPressed: () {
              // TODO: Ação para adicionar novo evento
            },
          ),
        ],
      ),
      body: Padding(
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
                leading: Container(
                  width: 5,
                  height: 50, // Altura do ListTile
                  color: event.color,
                ),
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
