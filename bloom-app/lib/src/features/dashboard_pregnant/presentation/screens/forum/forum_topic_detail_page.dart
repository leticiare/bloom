import 'package:flutter/material.dart';
import 'package:app/src/features/dashboard_pregnant/domain/entities/forum_topic.dart';
import 'package:app/src/features/dashboard_pregnant/presentation/widgets/forum_message_bubble.dart';

/// Exibe a conversa completa de um único tópico do fórum.
class ForumTopicDetailPage extends StatelessWidget {
  final ForumTopic topic;

  const ForumTopicDetailPage({super.key, required this.topic});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tópico do Fórum')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Usando o widget MessageBubble para a pergunta
            MessageBubble(
              message: topic.question,
              showContinueReading:
                  false, // Garante que o texto completo seja exibido
            ),
            const SizedBox(height: 24),
            // Usando o widget MessageBubble para a resposta
            MessageBubble(
              message: topic.answer,
              showContinueReading:
                  false, // Garante que o texto completo seja exibido
            ),
          ],
        ),
      ),
    );
  }
}
