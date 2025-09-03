// lib/src/modules/dashboard-pregnant/homepage.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

// Importando as telas para navegação interna da HomePage
import 'medical_record_page.dart';
import 'calendar_page.dart';
import 'articles_page.dart';

// --- CONSTANTES DE CORES ---
const Color _kPrimaryPink = Color(0xFFF55A8A);
const Color _kTextDark = Color(0xFF333333);
const Color _kTextLight = Color(0xFF828282);
const Color _kBackground = Color(0xFFF9F9F9);
const Color _kLightPinkBackground = Color(0xFFFFF0F5);

// --------------------------------------------------------------------------
// MUDANÇA 1: CRIAMOS UM MODELO PARA REPRESENTAR UM COMPROMISSO
// --------------------------------------------------------------------------
/// Uma classe simples para representar um compromisso ou evento.
class Appointment {
  final String title;
  final String type; // Ex: "Consulta", "Exame", "Atividade"

  Appointment({required this.title, required this.type});
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late DateTime _selectedDate;
  final List<DateTime> _weekDays = [];

  // --------------------------------------------------------------------------
  // MUDANÇA 2: CRIAMOS UM MAPA COM DADOS DE EXEMPLO (MOCK)
  // --------------------------------------------------------------------------
  /// Um mapa que simula um banco de dados de eventos.
  /// A chave é a data (sem a hora) e o valor é uma lista de compromissos.
  final Map<DateTime, List<Appointment>> _mockEvents = {};

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('pt_BR', null);

    _selectedDate = DateTime.now();
    _generateWeekDays(_selectedDate);

    // Populamos nossos dados de exemplo ao iniciar a tela
    _populateMockEvents();
  }

  /// Popula nosso mapa de eventos com dados de exemplo baseados na data atual.
  void _populateMockEvents() {
    final today = DateTime.now();
    // Usamos DateTime.utc para garantir que a chave do mapa não tenha fuso horário ou horas.
    final todayKey = DateTime.utc(today.year, today.month, today.day);
    final tomorrowKey = DateTime.utc(today.year, today.month, today.day + 1);
    final twoDaysFromNowKey = DateTime.utc(
      today.year,
      today.month,
      today.day + 2,
    );

    _mockEvents[todayKey] = [
      Appointment(title: 'Yoga pré-natal', type: 'Atividade'),
      Appointment(title: 'Comprar vitaminas', type: 'Tarefa'),
    ];
    _mockEvents[tomorrowKey] = [
      Appointment(title: 'Nutricionista', type: 'Consulta'),
    ];
    _mockEvents[twoDaysFromNowKey] = [
      Appointment(title: 'Ultrassom', type: 'Exame'),
    ];
  }

  // --------------------------------------------------------------------------
  // MUDANÇA 3: FUNÇÕES PARA BUSCAR OS DADOS E FORMATAR A DATA
  // --------------------------------------------------------------------------

  /// Busca a lista de compromissos para um dia específico no nosso mapa.
  List<Appointment> _getEventsForDay(DateTime day) {
    // Normaliza a data para usar como chave de busca
    final dayKey = DateTime.utc(day.year, day.month, day.day);
    return _mockEvents[dayKey] ??
        []; // Retorna uma lista vazia se não encontrar nada
  }

  /// Formata a data para uma string amigável como "Hoje", "Amanhã" ou a data normal.
  String _formatRelativeDate(DateTime date) {
    final today = DateTime.now();
    if (_isSameDay(date, today)) return 'Hoje';
    if (_isSameDay(date, today.add(const Duration(days: 1)))) return 'Amanhã';

    return DateFormat('dd/MM/yyyy').format(date);
  }

  void _generateWeekDays(DateTime date) {
    _weekDays.clear();
    DateTime startOfWeek = date.subtract(Duration(days: date.weekday % 7));
    for (int i = 0; i < 7; i++) {
      _weekDays.add(startOfWeek.add(Duration(days: i)));
    }
  }

  bool _isSameDay(DateTime dateA, DateTime dateB) {
    return dateA.year == dateB.year &&
        dateA.month == dateB.month &&
        dateA.day == dateB.day;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBackground,
      appBar: AppBar(
        // ... (seu AppBar continua o mesmo)
        backgroundColor: _kBackground,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Página Inicial',
          style: TextStyle(color: _kTextDark, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                'https://placehold.co/100x100/F55A8A/white?text=J',
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Olá Júlia!',
                style: TextStyle(color: _kTextLight, fontSize: 18),
              ),
              const SizedBox(height: 8),
              const Text(
                '16ª Semana de Gravidez',
                style: TextStyle(
                  color: _kTextDark,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              _buildWeekCalendar(context),
              const SizedBox(height: 24),

              // O card de compromissos agora será construído dinamicamente
              _buildAppointmentAndBabyInfoCard(),

              const SizedBox(height: 24),
              _buildNavigationButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  // O Calendário da semana já funcionava perfeitamente para atualizar o _selectedDate
  Widget _buildWeekCalendar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: _weekDays.map((date) {
        final bool isSelected = _isSameDay(date, _selectedDate);
        final String dayName = DateFormat('E', 'pt_BR').format(date);
        final String dayNumber = DateFormat('d').format(date);

        return GestureDetector(
          onTap: () {
            // Ao tocar, o setState é chamado e a tela se reconstrói,
            // fazendo com que _buildAppointmentAndBabyInfoCard() seja chamado novamente
            // com a nova data.
            setState(() {
              _selectedDate = date;
            });
          },
          child: _buildDayWidget(dayName, dayNumber, isSelected),
        );
      }).toList(),
    );
  }

  // ... (_buildDayWidget e _buildNavButton continuam os mesmos)

  // --------------------------------------------------------------------------
  // MUDANÇA 4: O CARD DE COMPROMISSO AGORA É DINÂMICO
  // --------------------------------------------------------------------------
  /// Constrói o card de informações baseado no `_selectedDate`.
  Widget _buildAppointmentAndBabyInfoCard() {
    // Busca os eventos para o dia que está selecionado no estado.
    final eventsForSelectedDay = _getEventsForDay(_selectedDate);

    // O primeiro compromisso da lista (se houver)
    final mainAppointment = eventsForSelectedDay.isNotEmpty
        ? eventsForSelectedDay.first
        : null;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: _kLightPinkBackground,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  // Muda o ícone baseado na existência de um evento
                  mainAppointment != null
                      ? Icons.calendar_month_outlined
                      : Icons.child_friendly_outlined,
                  color: _kPrimaryPink,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      // Muda o texto baseado na existência de um evento
                      mainAppointment != null
                          ? 'Próximo compromisso:'
                          : 'Informações do bebê',
                      style: const TextStyle(color: _kTextLight, fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      // Mostra a data relativa ("Hoje", "Amanhã")
                      _formatRelativeDate(_selectedDate),
                      style: const TextStyle(
                        color: _kTextDark,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // Se tiver um evento, mostra o título. Senão, uma mensagem padrão.
                    if (mainAppointment != null)
                      Text(
                        mainAppointment.title, // Título do evento
                        style: const TextStyle(
                          color: _kTextLight,
                          fontSize: 14,
                        ),
                      )
                    else
                      const Text(
                        'Nenhum evento para hoje.',
                        style: TextStyle(color: _kTextLight, fontSize: 14),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0),
            child: Divider(height: 1),
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _InfoColumn(label: 'Altura do bebê', value: '17 cm'),
              _InfoColumn(label: 'Peso do bebê', value: '110 gr'),
              _InfoColumn(label: 'Dias até o parto', value: '168 days'),
            ],
          ),
        ],
      ),
    );
  }

  // O restante do seu código pode continuar igual
  Widget _buildDayWidget(String day, String date, bool isSelected) {
    return Container(
      width: 48, // Um pouco mais de espaço
      height: 70,
      decoration: BoxDecoration(
        color: isSelected ? _kPrimaryPink : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: isSelected ? null : Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            day,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : _kTextLight,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            date,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : _kTextDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        _buildNavButton(
          context,
          Icons.star_border_rounded,
          'Meu histórico',
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const MedicalRecordPage()),
          ),
        ),
        _buildNavButton(
          context,
          Icons.calendar_today_outlined,
          'Calendário',
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CalendarPage()),
          ),
        ),
        _buildNavButton(
          context,
          Icons.article_outlined,
          'Artigos',
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ArticlesPage()),
          ),
        ),
      ],
    );
  }

  Widget _buildNavButton(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onTap,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final buttonSize = (constraints.maxWidth - 16) / 2;
        final isFullWidth = label == 'Artigos';

        return InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: isFullWidth ? constraints.maxWidth : buttonSize,
            height: 150,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 10,
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: _kPrimaryPink, size: 40),
                const SizedBox(height: 12),
                Text(
                  label,
                  style: const TextStyle(
                    color: _kTextDark,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _InfoColumn extends StatelessWidget {
  final String label;
  final String value;
  const _InfoColumn({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: _kTextLight, fontSize: 12)),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: _kTextDark,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
