import 'package:flutter/material.dart';

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

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBackground,
      appBar: AppBar(
        // ATUALIZAÇÃO: Fundo transparente para combinar com o design
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
              // ATUALIZAÇÃO: Card de consulta e infos do bebê foram unificados
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

  // Constrói o calendário resumido da semana
  Widget _buildWeekCalendar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildDayWidget('Dom', '16', false),
        _buildDayWidget('Ter', '17', false),
        _buildDayWidget('Qua', '18', true),
        _buildDayWidget('Qui', '19', false),
        _buildDayWidget('Sex', '20', false),
        _buildDayWidget('Sab', '21', false),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CalendarPage()),
            );
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: 45,
            height: 65,
            decoration: BoxDecoration(
              color: _kLightPinkBackground,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.add, color: _kPrimaryPink, size: 28),
          ),
        ),
      ],
    );
  }

  // Constrói cada dia individual do calendário da semana
  Widget _buildDayWidget(String day, String date, bool isSelected) {
    return Container(
      width: 45,
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

  // ATUALIZAÇÃO: Este widget agora combina as informações da consulta e do bebê
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
                // ATUALIZAÇÃO: Ícone mais apropriado
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
                    // ATUALIZAÇÃO: Subtítulo adicionado
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

  // Constrói os botões de navegação grandes (Meu histórico, Calendário, Artigos)
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

  // Widget auxiliar para criar cada um dos botões de navegação
  Widget _buildNavButton(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onTap,
  ) {
    // LayoutBuilder permite que os botões se ajustem ao tamanho da tela
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calcula o tamanho para que dois botões caibam lado a lado com um espaçamento
        final buttonSize = (constraints.maxWidth - 16) / 2;
        // O botão 'Artigos' ocupará a largura total
        final isFullWidth = label == 'Artigos';

        return InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: isFullWidth ? constraints.maxWidth : buttonSize,
            height: 150, // Altura fixa para consistência
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

// Widget auxiliar para as colunas de informação (Altura, Peso, Dias)
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
