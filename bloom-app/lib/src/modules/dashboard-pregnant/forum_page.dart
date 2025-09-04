import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:app/src/core/theme/app_colors.dart';

// --------------------------------------------------------------------------
// MUDANÇA 1: MODELOS DE DADOS PARA O FÓRUM
// --------------------------------------------------------------------------

/// Representa uma única mensagem no fórum.
class ForumMessage {
  final String authorName;
  final String authorTitle;
  final String avatarUrl;
  final String message;
  final bool isFromUser; // Determina o estilo (rosa/esquerda ou branco/direita)

  ForumMessage({
    required this.authorName,
    required this.authorTitle,
    required this.avatarUrl,
    required this.message,
    this.isFromUser = false,
  });
}

/// Representa um tópico completo do fórum, com a pergunta e a resposta.
class ForumTopic {
  final ForumMessage question;
  final ForumMessage answer;
  final List<String> tags;

  ForumTopic({
    required this.question,
    required this.answer,
    required this.tags,
  });
}

// --------------------------------------------------------------------------
// MUDANÇA 2: DADOS MOCKADOS PARA POPULAR A TELA
// --------------------------------------------------------------------------
final List<ForumTopic> _mockTopics = [
  ForumTopic(
    question: ForumMessage(
      authorName: 'Júlia',
      authorTitle: 'primeira vez grávida',
      avatarUrl: 'https://i.pravatar.cc/150?img=1',
      message:
          'Oi! Estou de 16 semanas na minha primeira gravidez e tenho sentido umas cólicas leves de vez em quando. Não são fortes, mas fico preocupada. Isso é normal ou devo falar com meu médico?',
      isFromUser: true,
    ),
    answer: ForumMessage(
      authorName: 'Carlos Eduardo',
      authorTitle: 'Obstetra',
      avatarUrl: 'https://i.pravatar.cc/150?img=3',
      message:
          'Olá! Cólicas leves podem ser normais nesta fase da gravidez, pois seu útero está crescendo e os ligamentos se esticando para acomodar o bebê. No entanto, se a dor for intensa, constante ou vier acompanhada de sangramento, procure seu médico imediatamente. Para aliviar o desconforto, tente descansar, beber bastante água e evitar ficar...',
    ),
    tags: ['Cólicas', '16 semanas'],
  ),
  ForumTopic(
    question: ForumMessage(
      authorName: 'Mariana',
      authorTitle: 'segunda gravidez',
      avatarUrl: 'https://i.pravatar.cc/150?img=5',
      message:
          'É seguro continuar a fazer exercícios de baixo impacto durante o segundo trimestre? Gosto de caminhar e nadar.',
      isFromUser: true,
    ),
    answer: ForumMessage(
      authorName: 'Dr. Ricardo Mendes',
      authorTitle: 'Ginecologista',
      avatarUrl: 'https://i.pravatar.cc/150?img=8',
      message:
          'Sim, Mariana! Exercícios de baixo impacto como caminhada e natação são altamente recomendados, desde que não haja contraindicações do seu médico. Eles ajudam na circulação e no controle do peso. Sempre ouça seu corpo e evite a exaustão.',
    ),
    tags: ['Exercícios', '2º Trimestre'],
  ),
];

class ForumPage extends StatelessWidget {
  const ForumPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false, // Remove o botão de voltar padrão
        leading: IconButton(
          icon: const Icon(Icons.menu, color: AppColors.textDark),
          onPressed: () {
            /* Ação para abrir menu lateral */
          },
        ),
        title: const Text('Fórum', style: TextStyle(color: AppColors.textDark)),
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: AppColors.textDark),
            onPressed: () {
              /* Ação para adicionar novo tópico */
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16.0),
              itemCount: _mockTopics.length,
              itemBuilder: (context, index) {
                final topic = _mockTopics[index];
                // MUDANÇA 3: Construímos uma coluna de balões, não mais um Card.
                return Column(
                  children: [
                    _MessageBubble(message: topic.question),
                    const SizedBox(height: 12),
                    _MessageBubble(
                      message: topic.answer,
                      tags: topic.tags,
                      showContinueReading: true,
                    ),
                  ],
                );
              },
              separatorBuilder: (context, index) => const SizedBox(height: 24),
            ),
          ),
        ],
      ),
    );
  }

  /// Constrói a barra de pesquisa.
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Pesquisar Tópicos',
          prefixIcon: const Icon(Icons.search, color: AppColors.textLight),
          filled: true,
          fillColor: AppColors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
        ),
      ),
    );
  }
}

// --------------------------------------------------------------------------
// MUDANÇA 4: O WIDGET DE BALÃO DE MENSAGEM REUTILIZÁVEL
// --------------------------------------------------------------------------
class _MessageBubble extends StatelessWidget {
  final ForumMessage message;
  final List<String>? tags;
  final bool showContinueReading;

  const _MessageBubble({
    required this.message,
    this.tags,
    this.showContinueReading = false,
  });

  @override
  Widget build(BuildContext context) {
    // Determina o alinhamento e as cores com base em quem enviou a mensagem
    final alignment = message.isFromUser
        ? CrossAxisAlignment.start
        : CrossAxisAlignment.end;
    final bubbleColor = message.isFromUser
        ? AppColors.primaryPink
        : AppColors.white;
    final textColor = message.isFromUser ? AppColors.white : AppColors.textDark;
    final titleColor = message.isFromUser
        ? AppColors.white.withOpacity(0.9)
        : AppColors.textDark;
    final subtitleColor = message.isFromUser
        ? AppColors.white.withOpacity(0.8)
        : AppColors.textLight;

    // Define o formato do balão para criar a "cauda"
    final borderRadius = message.isFromUser
        ? const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomRight: Radius.circular(16),
            bottomLeft: Radius.circular(4),
          )
        : const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(4),
          );

    return Column(
      crossAxisAlignment: alignment,
      children: [
        // Informações do autor (Avatar, Nome, Título)
        Row(
          mainAxisAlignment: message.isFromUser
              ? MainAxisAlignment.start
              : MainAxisAlignment.end,
          children: [
            if (message.isFromUser)
              CircleAvatar(
                radius: 16,
                backgroundImage: NetworkImage(message.avatarUrl),
              ),
            if (message.isFromUser) const SizedBox(width: 8),
            Column(
              crossAxisAlignment: alignment,
              children: [
                Text(
                  message.authorName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: titleColor,
                  ),
                ),
                Text(
                  message.authorTitle,
                  style: TextStyle(fontSize: 12, color: subtitleColor),
                ),
              ],
            ),
            if (!message.isFromUser) const SizedBox(width: 8),
            if (!message.isFromUser)
              CircleAvatar(
                radius: 16,
                backgroundImage: NetworkImage(message.avatarUrl),
              ),
          ],
        ),
        const SizedBox(height: 8),

        // O balão de mensagem
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: bubbleColor,
            borderRadius: borderRadius,
          ),
          child: _buildMessageContent(textColor),
        ),

        // As tags (só aparecem na resposta do médico)
        if (tags != null && tags!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: tags!.map((tag) => _Tag(label: tag)).toList(),
            ),
          ),
      ],
    );
  }

  /// Constrói o texto da mensagem, com a opção "continuar lendo".
  Widget _buildMessageContent(Color textColor) {
    final textSpan = TextSpan(
      style: TextStyle(color: textColor, fontSize: 14, height: 1.5),
      children: [
        TextSpan(text: message.message),
        if (showContinueReading)
          TextSpan(
            text: '... continuar lendo',
            style: const TextStyle(
              color: AppColors.primaryPink,
              fontWeight: FontWeight.bold,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                /* Ação para ver o resto da mensagem */
              },
          ),
      ],
    );
    return RichText(text: textSpan);
  }
}

/// Widget para as tags ('Cólicas', '16 semanas').
class _Tag extends StatelessWidget {
  final String label;
  const _Tag({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.lightPinkBackground,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(color: AppColors.primaryPink, fontSize: 12),
      ),
    );
  }
}
