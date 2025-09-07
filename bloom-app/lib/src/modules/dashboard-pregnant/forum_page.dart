import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:app/src/core/theme/app_colors.dart'; // Ajuste o import para o seu projeto
import 'forum_topic_detail_page.dart';
import 'add_topic_page.dart';
import './data/models/mock_models.dart'; // MUDANÇA: Importa os modelos do arquivo central

// --- MODELOS DE DADOS PARA O FÓRUM ---
// --- WIDGET PRINCIPAL DA PÁGINA ---
class ForumPage extends StatefulWidget {
  const ForumPage({super.key});

  @override
  State<ForumPage> createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {
  // A lista de tópicos agora é uma variável de estado dentro da classe
  final List<ForumTopic> _topics = [
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
            'Olá! Cólicas leves podem ser normais nesta fase da gravidez, pois seu útero está crescendo e os ligamentos se esticando para acomodar o bebê. No entanto, se a dor for intensa, constante ou vier acompanhada de sangramento, procure seu médico imediatamente. Para aliviar o desconforto, tente descansar, beber bastante água e evitar ficar muito tempo em pé. A prática de exercícios leves como caminhada também pode ajudar.',
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

  // --- MÉTODOS DE LÓGICA (DENTRO DA CLASSE STATE) ---

  /// Adiciona um novo tópico à lista e atualiza a tela.
  void _addTopic(String questionText) {
    final newTopic = ForumTopic(
      question: ForumMessage(
        authorName: 'Júlia', // Dados do usuário logado (exemplo)
        authorTitle: 'primeira vez grávida',
        avatarUrl: 'https://i.pravatar.cc/150?img=1',
        message: questionText,
        isFromUser: true,
      ),
      answer: ForumMessage(
        authorName: 'Especialista',
        authorTitle: 'Aguardando resposta',
        avatarUrl: 'https://i.pravatar.cc/150?img=10',
        message: 'Sua pergunta foi enviada e será respondida em breve.',
      ),
      tags: ['Nova Pergunta'],
    );

    // setState notifica o Flutter que o estado mudou e a tela precisa ser reconstruída
    setState(() {
      _topics.insert(0, newTopic);
    });
  }

  /// Navega para a tela de adicionar tópico e aguarda o resultado.
  void _navigateAndAddTopic() async {
    final newQuestionText = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => const AddTopicPage()),
    );

    if (newQuestionText != null && newQuestionText.isNotEmpty) {
      _addTopic(newQuestionText);
    }
  }

  // --- MÉTODOS DE CONSTRUÇÃO DA UI (DENTRO DA CLASSE STATE) ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Fórum', style: TextStyle(color: AppColors.textDark)),
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: AppColors.textDark),
            onPressed: _navigateAndAddTopic,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16.0),
              itemCount: _topics.length,
              itemBuilder: (context, index) {
                final topic = _topics[index];
                return Column(
                  children: [
                    _MessageBubble(message: topic.question),
                    const SizedBox(height: 12),
                    _MessageBubble(
                      message: topic.answer,
                      tags: topic.tags,
                      showContinueReading: true,
                      topic: topic,
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

// --- WIDGETS AUXILIARES (COMPONENTES) ---
// Estes são stateless e podem ficar fora da classe principal para organização.

class _MessageBubble extends StatelessWidget {
  final ForumMessage message;
  final List<String>? tags;
  final bool showContinueReading;
  final ForumTopic? topic;

  const _MessageBubble({
    required this.message,
    this.tags,
    this.showContinueReading = false,
    this.topic,
  });

  @override
  Widget build(BuildContext context) {
    final alignment = message.isFromUser
        ? CrossAxisAlignment.start
        : CrossAxisAlignment.end;
    final bubbleColor = message.isFromUser
        ? AppColors.primaryPink
        : AppColors.white;
    final textColor = message.isFromUser ? AppColors.white : AppColors.textDark;
    final titleColor = message.isFromUser
        ? AppColors.textDark
        : AppColors.textLight;
    final subtitleColor = message.isFromUser
        ? AppColors.textLight
        : AppColors.textDark;

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
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: bubbleColor,
            borderRadius: borderRadius,
          ),
          child: _buildMessageContent(context, textColor),
        ),
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

  Widget _buildMessageContent(BuildContext context, Color textColor) {
    String previewMessage = message.message;
    bool needsTruncation = false;

    if (showContinueReading && message.message.length > 120) {
      previewMessage = message.message.substring(0, 120);
      needsTruncation = true;
    }

    final textSpan = TextSpan(
      style: TextStyle(color: textColor, fontSize: 14, height: 1.5),
      children: [
        TextSpan(text: previewMessage),
        if (needsTruncation)
          TextSpan(
            text: '... continuar lendo',
            style: const TextStyle(
              color: AppColors.primaryPink,
              fontWeight: FontWeight.bold,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                if (topic != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ForumTopicDetailPage(topic: topic!),
                    ),
                  );
                }
              },
          ),
      ],
    );
    return RichText(text: textSpan);
  }
}

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
