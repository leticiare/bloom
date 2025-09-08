// lib/src/modules/dashboard-pregnant/homepage.dart

import 'package:app/src/shared/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

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

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _storage = const FlutterSecureStorage();
  final AuthService _authService = AuthService();

  late DateTime _selectedDate;
  final List<DateTime> _weekDays = [];

  // Variáveis para dados da API
  bool _isLoading = true;
  String? _errorMessage;
  Map<String, dynamic>? _gestantePerfil;
  List<dynamic> _scheduledExams = [];

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('pt_BR', null);
    _selectedDate = DateTime.now();
    _generateWeekDays(_selectedDate);
    _fetchData();
  }

  Future<void> _fetchData() async {
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

      // 1. Buscando dados do perfil da gestante
      final urlPerfil = Uri.parse('http://127.0.0.1:8000/api/auth/perfil');
      final responsePerfil = await http.get(urlPerfil, headers: headers);
      if (responsePerfil.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(responsePerfil.body);
        _gestantePerfil = data['dados']['Response'];
      } else {
        throw Exception('Erro ao carregar o perfil.');
      }

      // 2. Buscando exames agendados
      final urlExames = Uri.parse(
        'http://127.0.0.1:8000/api/gestante/exames/agendados',
      );
      final responseExames = await http.get(urlExames, headers: headers);
      if (responseExames.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(responseExames.body);
        _scheduledExams = data['dados'];
      } else {
        throw Exception('Erro ao carregar exames agendados.');
      }
    } catch (e) {
      _errorMessage = 'Erro ao carregar dados: ${e.toString()}';
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _generateWeekDays(DateTime date) {
    _weekDays.clear();
    DateTime startOfWeek = date.subtract(Duration(days: date.weekday % 7));
    for (int i = 0; i < 7; i++) {
      _weekDays.add(startOfWeek.add(Duration(days: i)));
    }
  }

  void _goToPreviousWeek() {
    setState(() {
      _selectedDate = _selectedDate.subtract(const Duration(days: 7));
      _generateWeekDays(_selectedDate);
    });
  }

  void _goToNextWeek() {
    setState(() {
      _selectedDate = _selectedDate.add(const Duration(days: 7));
      _generateWeekDays(_selectedDate);
    });
  }

  // Novo método para encontrar o próximo exame agendado
  Map<String, dynamic>? _getNextScheduledExam() {
    if (_scheduledExams.isEmpty) return null;

    final sortedExams = List.from(_scheduledExams)
      ..sort(
        (a, b) => DateTime.parse(
          a['data_agendamento'],
        ).compareTo(DateTime.parse(b['data_agendamento'])),
      );

    for (var exam in sortedExams) {
      final examDate = DateTime.parse(exam['data_agendamento']);
      if (examDate.isAfter(DateTime.now())) {
        return exam;
      }
    }
    return null;
  }

  // Lógica para obter exames agendados de um dia específico
  List<dynamic> _getExamsForDay(DateTime day) {
    return _scheduledExams.where((exam) {
      final examDate = DateTime.parse(exam['data_agendamento']).toLocal();
      return examDate.year == day.year &&
          examDate.month == day.month &&
          examDate.day == day.day;
    }).toList();
  }

  String _formatRelativeDate(DateTime date) {
    final today = DateTime.now();
    if (_isSameDay(date, today)) return 'Hoje';
    if (_isSameDay(date, today.add(const Duration(days: 1)))) return 'Amanhã';
    return DateFormat('dd/MM/yyyy').format(date);
  }

  bool _isSameDay(DateTime dateA, DateTime dateB) {
    return dateA.year == dateB.year &&
        dateA.month == dateB.month &&
        dateA.day == dateB.day;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: _kBackground,
        body: Center(child: CircularProgressIndicator(color: _kPrimaryPink)),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        backgroundColor: _kBackground,
        body: Center(child: Text(_errorMessage!)),
      );
    }

    final String nome = _gestantePerfil?['nome']?.split(' ').first ?? 'Usuária';
    final String dumString = _gestantePerfil?['dum'] ?? '';
    final String dppString = _gestantePerfil?['dpp'] ?? '';

    // Cálculo da semana de gravidez
    int weekOfPregnancy = 0;
    if (dumString.isNotEmpty) {
      final dum = DateTime.parse(dumString);
      final today = DateTime.now();
      weekOfPregnancy = (today.difference(dum).inDays / 7).floor();
    }

    // Cálculo dos dias até o parto
    int daysUntilDelivery = 0;
    if (dppString.isNotEmpty) {
      final dpp = DateTime.parse(dppString);
      final today = DateTime.now();
      daysUntilDelivery = dpp.difference(today).inDays;
    }

    return Scaffold(
      backgroundColor: _kBackground,
      appBar: AppBar(
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
              Text(
                'Olá $nome!',
                style: const TextStyle(color: _kTextLight, fontSize: 18),
              ),
              const SizedBox(height: 8),
              Text(
                '${weekOfPregnancy}ª Semana de Gravidez',
                style: const TextStyle(
                  color: _kTextDark,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),

              _buildWeekCalendar(context),

              const SizedBox(height: 24),
              _buildAppointmentAndBabyInfoCard(daysUntilDelivery),
              const SizedBox(height: 24),
              _buildNavigationButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeekCalendar(BuildContext context) {
    String headerText = DateFormat('MMMM yyyy', 'pt_BR').format(_selectedDate);
    headerText = '${headerText[0].toUpperCase()}${headerText.substring(1)}';

    return Column(
      children: [
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CalendarPage()),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  color: _kTextLight,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  headerText,
                  style: const TextStyle(
                    color: _kTextDark,
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
                size: 16,
                color: _kTextLight,
              ),
              onPressed: _goToPreviousWeek,
            ),

            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: _weekDays.map((date) {
                  final bool isSelected = _isSameDay(date, _selectedDate);
                  final String dayName = DateFormat('E', 'pt_BR').format(date);
                  final String dayNumber = DateFormat('d').format(date);

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedDate = date;
                      });
                    },
                    child: _buildDayWidget(dayName, dayNumber, isSelected),
                  );
                }).toList(),
              ),
            ),

            IconButton(
              icon: const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: _kTextLight,
              ),
              onPressed: _goToNextWeek,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDayWidget(String day, String date, bool isSelected) {
    return Container(
      width: 40,
      height: 65,
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
          const SizedBox(height: 4),
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

  // Agora recebe os dias até o parto
  Widget _buildAppointmentAndBabyInfoCard(int daysUntilDelivery) {
    final eventsForSelectedDay = _getExamsForDay(_selectedDate);
    final nextScheduledExam = _getNextScheduledExam();

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
                  nextScheduledExam != null
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
                      nextScheduledExam != null
                          ? 'Próximo compromisso:'
                          : 'Informações do bebê',
                      style: const TextStyle(color: _kTextLight, fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatRelativeDate(_selectedDate),
                      style: const TextStyle(
                        color: _kTextDark,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (nextScheduledExam != null)
                      Text(
                        nextScheduledExam['nome'],
                        style: const TextStyle(
                          color: _kTextLight,
                          fontSize: 14,
                        ),
                      )
                    else
                      const Text(
                        'Nenhum exame agendado para este dia.',
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Removido peso e altura, pois não temos dados da API para eles
              _InfoColumn(
                label: 'Dias até o parto',
                value: '$daysUntilDelivery dias',
              ),
            ],
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
