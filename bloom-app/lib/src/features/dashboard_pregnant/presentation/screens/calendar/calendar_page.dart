import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:app/src/core/theme/app_colors.dart';
import 'package:app/src/features/dashboard_pregnant/domain/entities/event.dart';
import 'package:app/src/features/dashboard_pregnant/data/services/calendar_service.dart';

/// Tela de calendário que exibe e gerencia os eventos da gestante.
class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageSate();
}

class _CalendarPageSate extends State<CalendarPage> {
  final _calendarService = CalendarService();
  late final ValueNotifier<List<Event>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<Event>> _events = {};

  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('pt_BR', null);
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier([]);
    _fetchEvents();
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  /// Busca os eventos da API usando o serviço e atualiza a UI.
  Future<void> _fetchEvents() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final newEvents = await _calendarService.fetchEvents();
      if (!mounted) return;
      setState(() {
        _events = newEvents;
        _selectedEvents.value = _getEventsForDay(_selectedDay!);
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = 'Erro ao carregar dados: ${e.toString()}';
      });
    }
  }

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

  /// Exibe um diálogo para o usuário agendar um novo evento.
  void _showAddEventDialog() {
    String? selectedType;
    List<dynamic> availableItems = [];
    bool isFetching = false;
    String? fetchError;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            Future<void> fetchItems(String type) async {
              setDialogState(() {
                isFetching = true;
                fetchError = null;
                availableItems = [];
              });
              try {
                final items = await _calendarService.fetchAvailableItems(type);
                setDialogState(() => availableItems = items);
              } catch (e) {
                setDialogState(() => fetchError = e.toString());
              } finally {
                setDialogState(() => isFetching = false);
              }
            }

            return AlertDialog(
              title: const Text('Agendar Novo Evento'),
              content: SizedBox(
                width: double.maxFinite,
                height: 300,
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
                        if (value != null) {
                          setDialogState(() => selectedType = value);
                          fetchItems(value);
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: isFetching
                          ? const Center(child: CircularProgressIndicator())
                          : fetchError != null
                          ? Center(
                              child: Text(
                                'Erro: $fetchError',
                                style: const TextStyle(color: AppColors.error),
                              ),
                            )
                          : availableItems.isEmpty && selectedType != null
                          ? const Center(
                              child: Text(
                                'Nenhum item disponível para agendar.',
                              ),
                            )
                          : ListView.builder(
                              itemCount: availableItems.length,
                              itemBuilder: (ctx, index) {
                                final item = availableItems[index];
                                return Card(
                                  child: ListTile(
                                    title: Text(
                                      item['nome'] ?? 'Item sem nome',
                                    ),
                                    onTap: () async {
                                      final pickedDate = await showDatePicker(
                                        context: context,
                                        initialDate:
                                            _selectedDay ?? DateTime.now(),
                                        firstDate: DateTime(2020),
                                        lastDate: DateTime(2030),
                                      );
                                      if (pickedDate != null &&
                                          selectedType != null) {
                                        try {
                                          await _calendarService.addEvent(
                                            selectedType!,
                                            item['id'],
                                            pickedDate,
                                          );
                                          Navigator.of(
                                            dialogContext,
                                          ).pop(); // Fecha o diálogo
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text('Evento agendado!'),
                                              backgroundColor:
                                                  AppColors.success,
                                            ),
                                          );
                                          _fetchEvents(); // Atualiza a lista principal
                                        } catch (e) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'Erro ao agendar: ${e.toString()}',
                                              ),
                                              backgroundColor: AppColors.error,
                                            ),
                                          );
                                        }
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
                  onPressed: () => Navigator.of(dialogContext).pop(),
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
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Calendário'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddEventDialog,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: AppColors.error),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  _buildCalendar(),
                  const SizedBox(height: 24.0),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Agenda do Dia',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
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

  Widget _buildCalendar() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.background,
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
          if (_calendarFormat != format)
            setState(() => _calendarFormat = format);
        },
        onPageChanged: (focusedDay) => _focusedDay = focusedDay,
        headerStyle: HeaderStyle(
          titleCentered: true,
          formatButtonVisible: false,
          titleTextStyle: const TextStyle(
            color: AppColors.primaryPink,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          leftChevronIcon: const Icon(
            Icons.chevron_left,
            color: AppColors.textDark,
          ),
          rightChevronIcon: const Icon(
            Icons.chevron_right,
            color: AppColors.textDark,
          ),
          titleTextFormatter: (date, locale) =>
              DateFormat.yMMMM(locale).format(date).toUpperCase(),
        ),
        calendarStyle: const CalendarStyle(
          todayDecoration: BoxDecoration(
            color: Color(0xFFF5C3D5),
            shape: BoxShape.circle,
          ),
          selectedDecoration: BoxDecoration(
            color: AppColors.primaryPink,
            shape: BoxShape.circle,
          ),
          markerDecoration: BoxDecoration(
            color: AppColors.primaryPink,
            shape: BoxShape.circle,
          ),
          todayTextStyle: TextStyle(color: AppColors.textDark),
          selectedTextStyle: TextStyle(color: AppColors.white),
        ),
      ),
    );
  }

  Widget _buildEventList() {
    return ValueListenableBuilder<List<Event>>(
      valueListenable: _selectedEvents,
      builder: (context, value, _) {
        if (value.isEmpty) {
          return const Center(
            child: Text(
              'Nenhum evento para este dia.',
              style: TextStyle(color: AppColors.textGray, fontSize: 16),
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
                    color: AppColors.textDark,
                  ),
                ),
                subtitle: Text(
                  event.description,
                  style: const TextStyle(color: AppColors.textGray),
                ),
                trailing: const Icon(
                  Icons.more_horiz,
                  color: AppColors.textGray,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
