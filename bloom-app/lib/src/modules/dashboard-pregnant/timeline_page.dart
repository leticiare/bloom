import 'package:flutter/material.dart';

// Constantes de cores
const Color _kPrimaryPink = Color(0xFFF55A8A);
const Color _kTextDark = Color(0xFF333333);
const Color _kBackground = Color(0xFFF9F9F9);

class TimelinePage extends StatelessWidget {
  const TimelinePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBackground,
      appBar: AppBar(
        title: const Text(
          'Artigos das Semanas',
          style: TextStyle(color: _kTextDark),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: _kTextDark),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          // Itens da timeline
          _buildTimelineItem('Semana 12', true),
          _buildTimelineItem('Semana 13', true),
          _buildTimelineItem('Semana 14', true),
          _buildTimelineItem('Semana 15', true),
          _buildTimelineItem('Semana 16', true),
          _buildTimelineItem('Semana 17', false), // Semana futura
        ],
      ),
    );
  }

  // Widget para construir cada item da timeline
  Widget _buildTimelineItem(String title, bool isCompleted) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // A linha vertical e o círculo
          Column(
            children: [
              Container(
                width: 2,
                height: 20,
                color: isCompleted ? _kPrimaryPink : Colors.grey.shade300,
              ),
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isCompleted ? _kPrimaryPink : Colors.white,
                  border: Border.all(
                    color: isCompleted ? _kPrimaryPink : Colors.grey.shade300,
                    width: 2,
                  ),
                ),
                child: isCompleted
                    ? const Icon(Icons.check, color: Colors.white, size: 14)
                    : null,
              ),
              Expanded(child: Container(width: 2, color: Colors.grey.shade300)),
            ],
          ),
          const SizedBox(width: 16),
          // O conteúdo do card
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: isCompleted ? _kPrimaryPink : _kTextDark,
                  ),
                ),
                Text(
                  'Aqui vai uma breve descrição do que esperar e ler sobre esta semana...',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                const SizedBox(height: 40), // Espaço até o próximo item
              ],
            ),
          ),
        ],
      ),
    );
  }
}
