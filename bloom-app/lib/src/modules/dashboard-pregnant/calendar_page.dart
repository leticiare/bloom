import 'package:flutter/material.dart';

// Constantes de cores
const Color _kPrimaryPink = Color(0xFFF55A8A);
const Color _kTextDark = Color(0xFF333333);
const Color _kBackground = Color(0xFFF9F9F9);

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Esta é uma implementação visual simples baseada no protótipo.
    // Para um calendário funcional, seria necessário usar um pacote como `table_calendar`.
    return Scaffold(
      backgroundColor: _kBackground,
      appBar: AppBar(
        title: const Text('Calendário', style: TextStyle(color: _kTextDark)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: _kTextDark),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: _kTextDark),
            onPressed: () {
              // Ação para adicionar novo evento
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabeçalho com o mês e navegação
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: _kTextDark),
                  onPressed: () {},
                ),
                const Text(
                  'Fevereiro 2025',
                  style: TextStyle(
                    color: _kTextDark,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios, color: _kTextDark),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Placeholder para a grade do calendário
            Image.network(
              'https://i.imgur.com/8O1f8cR.png',
            ), // Imagem do protótipo
            const SizedBox(height: 30),
            const Text(
              'Agenda',
              style: TextStyle(
                color: _kTextDark,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            // Lista de eventos
            _buildAgendaItem(
              '10:00',
              'Nutricionista',
              Colors.blue,
              'Confirmado',
            ),
            const SizedBox(height: 12),
            _buildAgendaItem('12:00', 'Ultrassom', Colors.green, 'Confirmado'),
          ],
        ),
      ),
    );
  }

  // Widget para construir item da agenda
  Widget _buildAgendaItem(
    String time,
    String title,
    Color color,
    String status,
  ) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Container(width: 4, height: 40, color: color),
          const SizedBox(width: 12),
          Text(
            time,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: _kTextDark,
            ),
          ),
          const SizedBox(width: 12),
          Text(title, style: const TextStyle(color: _kTextDark)),
          const Spacer(),
          Text(
            status,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.more_vert, color: Colors.grey),
        ],
      ),
    );
  }
}
