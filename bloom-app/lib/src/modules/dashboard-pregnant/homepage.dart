import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // IMPORTAÇÃO: Pacote para formatação de data
import 'package:intl/date_symbol_data_local.dart'; // IMPORTAÇÃO: Para usar localização (pt_BR)

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

// ATUALIZAÇÃO: Convertido para StatefulWidget para gerenciar o estado do calendário
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // ATUALIZAÇÃO: Variável de estado para guardar a data selecionada.
  // Inicia com a data e hora de hoje.
  late DateTime _selectedDate;

  // Lista para guardar os 7 dias da semana atual
  List<DateTime> _weekDays = [];

  @override
  void initState() {
    super.initState();
    // Inicializa o formatador de datas para o português do Brasil
    initializeDateFormatting('pt_BR', null);

    _selectedDate = DateTime.now();
    _generateWeekDays(_selectedDate);
  }

  // Função para gerar os 7 dias da semana baseados em uma data
  void _generateWeekDays(DateTime date) {
    _weekDays = [];
    // Encontra o domingo da semana atual
    DateTime startOfWeek = date.subtract(Duration(days: date.weekday % 7));
    for (int i = 0; i < 7; i++) {
      _weekDays.add(startOfWeek.add(Duration(days: i)));
    }
  }

  // ATUALIZAÇÃO: Função auxiliar para verificar se duas datas são o mesmo dia
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
              _buildAppointmentAndBabyInfoCard(),
              const SizedBox(height: 24),
              _buildNavigationButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGETS DE CONSTRUÇÃO DA UI ---

  // ATUALIZAÇÃO: Calendário agora é construído dinamicamente
  Widget _buildWeekCalendar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      // Gera os 7 widgets de dia dinamicamente a partir da lista _weekDays
      children: _weekDays.map((date) {
        // Verifica se a data do loop é a data selecionada
        final bool isSelected = _isSameDay(date, _selectedDate);
        // Formata o nome do dia (ex: 'Seg') e o número do dia (ex: '17')
        final String dayName = DateFormat('E', 'pt_BR').format(date);
        final String dayNumber = DateFormat('d').format(date);

        return GestureDetector(
          onTap: () {
            // ATUALIZAÇÃO: Adiciona interatividade ao tocar no dia
            setState(() {
              _selectedDate = date;
            });
          },
          child: _buildDayWidget(dayName, dayNumber, isSelected),
        );
      }).toList(),
    );
  }

  // NENHUMA MUDANÇA AQUI - Este widget já era reutilizável
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

  // O restante do seu código permanece igual, pois já estava bem estruturado.
  // ... (Cole o resto dos seus métodos _buildAppointmentAndBabyInfoCard, _buildNavigationButtons, etc. aqui)

  Widget _buildAppointmentAndBabyInfoCard() {
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
                child: const Icon(
                  Icons.child_friendly_outlined,
                  color: _kPrimaryPink,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Próxima consulta:',
                      style: TextStyle(color: _kTextLight, fontSize: 14),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Amanhã',
                      style: TextStyle(
                        color: _kTextDark,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Nutricionista',
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
