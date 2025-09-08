import 'package:flutter/material.dart';
import 'package:app/src/core/theme/app_colors.dart';
import 'package:app/src/features/dashboard_pregnant/domain/entities/forum_topic.dart';
import 'package:app/src/features/dashboard_pregnant/domain/entities/forum_message.dart';
import 'package:app/src/features/dashboard_pregnant/data/datasources/mock_dashboard_data.dart';
import 'package:app/src/features/dashboard_pregnant/presentation/widgets/forum_message_bubble.dart';
import 'add_topic_page.dart';

/// Tela principal do Fórum, exibindo uma lista de tópicos.
class ForumPage extends StatefulWidget {
  const ForumPage({super.key});

  @override
  State<ForumPage> createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {
  late List<ForumTopic> _topics;

  @override
  void initState() {
    super.initState();
    // Carrega a lista de tópicos da nossa fonte de dados central.
    _topics = List.from(mockTopics);
  }

  /// Adiciona um novo tópico à lista e atualiza a tela.
  void _addTopic(String questionText) {
    final newTopic = ForumTopic(
      question: ForumMessage(
        authorName: 'Júlia',
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
    setState(() => _topics.insert(0, newTopic));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Fórum'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
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
                    // Usando o widget público MessageBubble
                    MessageBubble(message: topic.question),
                    const SizedBox(height: 12),
                    MessageBubble(
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

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Pesquisar Tópicos',
          prefixIcon: const Icon(Icons.search, color: AppColors.textGray),
        ),
      ),
    );
  }
}
