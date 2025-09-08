import 'package:app/src/features/dashboard_pregnant/domain/entities/user_profile.dart';
import 'package:app/src/shared/services/profile_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:app/src/core/theme/app_colors.dart';
import 'package:app/src/features/dashboard_pregnant/presentation/screens/medical_record/medical_record_page.dart';
import 'package:app/src/features/dashboard_pregnant/presentation/screens/calendar/calendar_page.dart';
import 'package:app/src/features/dashboard_pregnant/presentation/screens/articles/articles_page.dart';

/// Modelo de dados para um compromisso na agenda.
class Appointment {
  final String title;
  final String type;
  Appointment({required this.title, required this.type});
}

/// A tela principal do dashboard para a gestante.
///
/// Exibe um resumo da semana de gravidez, calendário semanal,
/// informações do bebê e atalhos para outras seções do app.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late DateTime _selectedDate;
  final List<DateTime> _weekDays = [];
  final Map<DateTime, List<Appointment>> _mockEvents = {};

  UserProfile? _userProfile;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('pt_BR', null);
    _selectedDate = DateTime.now();
    _generateWeekDays(_selectedDate);
    _populateMockEvents();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final profile = await ProfileService().getUser();
    setState(() {
      _userProfile = profile;
    });
  }

  /// Popula eventos de exemplo para o calendário.
  void _populateMockEvents() {
    final today = DateTime.now();
    final tomorrow = today.add(const Duration(days: 1));

    _mockEvents[DateTime.utc(today.year, today.month, today.day)] = [
      Appointment(title: 'Yoga pré-natal', type: 'Atividade'),
      Appointment(title: 'Comprar vitaminas', type: 'Tarefa'),
    ];
    _mockEvents[DateTime.utc(tomorrow.year, tomorrow.month, tomorrow.day)] = [
      Appointment(title: 'Nutricionista', type: 'Consulta'),
    ];
  }

  /// Gera a lista de 7 dias da semana com base na data selecionada.
  void _generateWeekDays(DateTime date) {
    _weekDays.clear();
    DateTime startOfWeek = date.subtract(Duration(days: date.weekday % 7));
    for (int i = 0; i < 7; i++) {
      _weekDays.add(startOfWeek.add(Duration(days: i)));
    }
  }

  /// Navega para a semana anterior.
  void _goToPreviousWeek() {
    setState(() {
      _selectedDate = _selectedDate.subtract(const Duration(days: 7));
      _generateWeekDays(_selectedDate);
    });
  }

  /// Navega para a próxima semana.
  void _goToNextWeek() {
    setState(() {
      _selectedDate = _selectedDate.add(const Duration(days: 7));
      _generateWeekDays(_selectedDate);
    });
  }

  /// Retorna os eventos para um dia específico.
  List<Appointment> _getEventsForDay(DateTime day) {
    final dayKey = DateTime.utc(day.year, day.month, day.day);
    return _mockEvents[dayKey] ?? [];
  }

  /// Verifica se duas datas são o mesmo dia.
  bool _isSameDay(DateTime dateA, DateTime dateB) {
    return dateA.year == dateB.year &&
        dateA.month == dateB.month &&
        dateA.day == dateB.day;
  }

  /// Formata uma data para 'Hoje' ou 'Amanhã' se aplicável.
  String _formatRelativeDate(DateTime date) {
    final today = DateTime.now();
    if (_isSameDay(date, today)) return 'Hoje';
    if (_isSameDay(date, today.add(const Duration(days: 1)))) return 'Amanhã';
    return DateFormat('dd/MM/yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Página Inicial'),
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
              Text(
                'Olá ${_userProfile?.name ?? ""}!',
                style: const TextStyle(color: AppColors.textGray, fontSize: 18),
              ),
              const SizedBox(height: 8),
              const Text(
                '16ª Semana de Gravidez',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 24),
              _buildWeekCalendar(context),
              const SizedBox(height: 24),
              _buildAppointmentAndBabyInfoCard(),
              const SizedBox(height: 24),
              _buildNavigationButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  /// Constrói a seção do calendário semanal.
  Widget _buildWeekCalendar(BuildContext context) {
    String headerText = DateFormat('MMMM yyyy', 'pt_BR').format(_selectedDate);
    headerText = '${headerText[0].toUpperCase()}${headerText.substring(1)}';

    return Column(
      children: [
        InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CalendarPage()),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  color: AppColors.textGray,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  headerText,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
                size: 16,
                color: AppColors.textGray,
              ),
              onPressed: _goToPreviousWeek,
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: _weekDays.map((date) {
                  final isSelected = _isSameDay(date, _selectedDate);
                  return GestureDetector(
                    onTap: () => setState(() => _selectedDate = date),
                    child: _buildDayWidget(
                      DateFormat('E', 'pt_BR').format(date).substring(0, 3),
                      DateFormat('d').format(date),
                      isSelected,
                    ),
                  );
                }).toList(),
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppColors.textGray,
              ),
              onPressed: _goToNextWeek,
            ),
          ],
        ),
      ],
    );
  }

  /// Constrói o widget de um único dia no calendário.
  Widget _buildDayWidget(String day, String date, bool isSelected) {
    return Container(
      width: 40,
      height: 65,
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primaryPink : AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: isSelected ? null : Border.all(color: AppColors.lightGray),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            day,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isSelected ? AppColors.white : AppColors.textGray,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            date,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isSelected ? AppColors.white : AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }

  /// Constrói o cartão de informações sobre compromissos e o bebê.
  Widget _buildAppointmentAndBabyInfoCard() {
    final eventsForSelectedDay = _getEventsForDay(_selectedDate);
    final mainAppointment = eventsForSelectedDay.isNotEmpty
        ? eventsForSelectedDay.first
        : null;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.textGray.withOpacity(0.1),
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
                  color: AppColors.lightGray,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  mainAppointment != null
                      ? Icons.calendar_month_outlined
                      : Icons.child_friendly_outlined,
                  color: AppColors.primaryPink,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mainAppointment != null
                          ? 'Próximo compromisso:'
                          : 'Informações do bebê',
                      style: const TextStyle(
                        color: AppColors.textGray,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      mainAppointment != null
                          ? _formatRelativeDate(_selectedDate)
                          : 'Sua bebê está crescendo!',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    if (mainAppointment != null)
                      Text(
                        mainAppointment.title,
                        style: const TextStyle(
                          color: AppColors.textGray,
                          fontSize: 14,
                        ),
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

  /// Constrói os botões de navegação rápida abaixo do card principal.
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

  /// Constrói um único botão de navegação.
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
              color: AppColors.background,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.textGray.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 10,
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: AppColors.primaryPink, size: 40),
                const SizedBox(height: 12),
                Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.textDark,
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

/// Widget auxiliar para exibir um par de rótulo e valor.
class _InfoColumn extends StatelessWidget {
  final String label;
  final String value;
  const _InfoColumn({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(color: AppColors.textGray, fontSize: 12),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.textDark,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
