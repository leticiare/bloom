import 'package:flutter/material.dart';
import 'package:app/src/core/theme/app_colors.dart';
import 'forum_page.dart'; // Importa os modelos
import 'forum_message_bubble.dart'; // MUDANÇA: Importa o novo widget

class ForumTopicDetailPage extends StatelessWidget {
  final ForumTopic topic;

  const ForumTopicDetailPage({super.key, required this.topic});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        // ... (seu AppBar continua o mesmo)
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // MUDANÇA: Usando o widget público MessageBubble
          MessageBubble(message: topic.question),
          const SizedBox(height: 12),
          MessageBubble(
            message: topic.answer,
            tags: topic.tags,
            showContinueReading: false,
          ),
        ],
      ),
    );
  }
}
