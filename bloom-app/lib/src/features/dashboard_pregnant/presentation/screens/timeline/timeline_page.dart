import 'package:flutter/material.dart';
import 'weekly_update_detail_page.dart'; // Importa a nova página de detalhes

// --- CONSTANTES DE CORES ---
const Color _kPrimaryPink = Color(0xFFF55A8A);
const Color _kTextDark = Color(0xFF333333);
const Color _kTextLight = Color(0xFF828282);
const Color _kBackground = Color(0xFFF9F9F9);

// --------------------------------------------------------------------------
// MUDANÇA 1: Modelo de dados e lista mockada
// --------------------------------------------------------------------------

/// Modelo para representar o conteúdo de uma semana.
class WeeklyUpdate {
  final int weekNumber;
  final String title;
  final String summary;
  final String fullContent;

  WeeklyUpdate({
    required this.weekNumber,
    required this.title,
    required this.summary,
    required this.fullContent,
  });
}

/// Simula a semana atual da gestante.
const int _currentWeek = 16;

/// Lista com todos os artigos semanais (simulando um banco de dados).
final List<WeeklyUpdate> _mockWeeklyUpdates = [
  WeeklyUpdate(
    weekNumber: 12,
    title: 'O Feto Desenvolve Reflexos',
    summary:
        'Os riscos da gravidez reduzem, e os enjoos podem melhorar. O bebê mede cerca de 6 cm.',
    fullContent:
        'Na semana 12, o desenvolvimento fetal atinge um marco importante. O bebê começa a desenvolver reflexos, como o de sucção. As impressões digitais já estão formadas e os órgãos vitais estão totalmente desenvolvidos, continuando a amadurecer. Para a mãe, é um período de mais energia e menos enjoos matinais, ideal para iniciar atividades físicas leves, como caminhadas.',
  ),
  WeeklyUpdate(
    weekNumber: 13,
    title: 'Crescimento Acelerado',
    summary:
        'O bebê já está completamente formado e começa a crescer rapidamente. Você pode notar mudanças no humor.',
    fullContent:
        'A semana 13 marca o início do segundo trimestre. O bebê continua a crescer em um ritmo acelerado, e seus ossos estão começando a endurecer. O lanugo, uma fina camada de pelos, começa a cobrir o corpo do bebê para mantê-lo aquecido. A mãe pode sentir a barriga começando a aparecer mais claramente.',
  ),
  WeeklyUpdate(
    weekNumber: 14,
    title: 'Pelos Finos e Movimentos',
    summary:
        'Uma fina camada de pelos finos, chamada lanugo, cobre o bebê. Seu útero cresce.',
    fullContent:
        'Na semana 14, o bebê já pode fazer expressões faciais, como franzir a testa. O pescoço está mais definido, e a cabeça mais ereta. Para a mãe, é uma boa fase para focar em uma dieta rica em cálcio, essencial para a formação dos ossos do bebê.',
  ),
  WeeklyUpdate(
    weekNumber: 15,
    title: 'Audição em Desenvolvimento',
    summary:
        'O bebê já escuta sons abafados, como seus batimentos cardíacos. Seu apetite pode aumentar.',
    fullContent:
        'A audição do bebê está se desenvolvendo rapidamente na semana 15. Ele pode ouvir os sons do corpo da mãe, como o coração e a digestão. É um ótimo momento para começar a conversar e cantar para o bebê, fortalecendo o vínculo afetivo.',
  ),
  WeeklyUpdate(
    weekNumber: 16,
    title: 'Movimentos Mais Fortes',
    summary:
        'Os movimentos do bebê estão mais frequentes, mas ainda são sutis. Você pode notar a linha nigra.',
    fullContent:
        'Na semana 16, a gestante pode começar a sentir os primeiros movimentos do bebê, conhecidos como "fluttering". O sistema nervoso do bebê continua a se desenvolver, permitindo movimentos mais coordenados. A pele do bebê ainda é translúcida, e seus olhos já podem se mover lentamente.',
  ),
  WeeklyUpdate(
    weekNumber: 17,
    title: 'Gordura Corporal',
    summary:
        'O bebê começa a acumular gordura corporal. Sua pele fica menos translúcida.',
    fullContent:
        'A formação de gordura subcutânea começa na semana 17, o que ajudará a regular a temperatura corporal do bebê após o nascimento. O esqueleto, que era cartilaginoso, começa a se ossificar. Para a mãe, o aumento do útero pode causar dores nos ligamentos redondos, uma sensação de fisgada na parte inferior do abdômen.',
  ),
];

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
        backgroundColor: _kBackground,
        elevation: 0,
        centerTitle: true,
      ),
      // --------------------------------------------------------------------------
      // MUDANÇA 2: A tela agora usa ListView.builder para ser dinâmica
      // --------------------------------------------------------------------------
      body: ListView.builder(
        padding: const EdgeInsets.all(20.0),
        itemCount: _mockWeeklyUpdates.length,
        itemBuilder: (context, index) {
          final update = _mockWeeklyUpdates[index];
          // Lógica para determinar se a semana já passou ou é a atual
          final bool isCompleted = update.weekNumber <= _currentWeek;
          // Lógica para saber se é o último item e não desenhar a linha
          final bool isLastItem = index == _mockWeeklyUpdates.length - 1;

          return _buildTimelineItem(
            context: context,
            update: update,
            isCompleted: isCompleted,
            isLastItem: isLastItem,
          );
        },
      ),
    );
  }

  // --------------------------------------------------------------------------
  // MUDANÇA 3: O item da timeline agora é clicável e navega para os detalhes
  // --------------------------------------------------------------------------
  Widget _buildTimelineItem({
    required BuildContext context,
    required WeeklyUpdate update,
    required bool isCompleted,
    required bool isLastItem,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // A linha vertical e o círculo
          Column(
            children: [
              // Linha superior (escondida para o primeiro item)
              Container(
                width: 2,
                height: 20,
                color: update.weekNumber == _mockWeeklyUpdates.first.weekNumber
                    ? Colors.transparent
                    : isCompleted
                    ? _kPrimaryPink
                    : Colors.grey.shade300,
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
              // Linha inferior (escondida para o último item)
              Expanded(
                child: Container(
                  width: 2,
                  color: isLastItem ? Colors.transparent : Colors.grey.shade300,
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          // O conteúdo do card
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // InkWell torna a área do texto clicável
                InkWell(
                  onTap: () {
                    // Ação de navegação
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => WeeklyUpdateDetailPage(update: update),
                      ),
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Semana ${update.weekNumber}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: isCompleted ? _kPrimaryPink : _kTextDark,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        update.summary,
                        style: const TextStyle(color: _kTextLight),
                      ),
                    ],
                  ),
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
