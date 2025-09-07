import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:app/src/core/theme/app_colors.dart';
import './data/models/mock_models.dart'; // Importa os modelos de dados
import 'forum_topic_detail_page.dart'; // Importa a página de destino

/// Widget PÚBLICO para um balão de mensagem do fórum.
class MessageBubble extends StatelessWidget {
  final ForumMessage message;
  final List<String>? tags;
  final bool showContinueReading;
  final ForumTopic? topic;

  const MessageBubble({
    super.key,
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
        ? AppColors.white
        : AppColors.textDark;
    final subtitleColor = message.isFromUser
        ? AppColors.white.withOpacity(0.9)
        : AppColors.textLight;

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
              children: tags!.map((tag) => Tag(label: tag)).toList(),
            ),
          ),
      ],
    );
  }

  /// Constrói o conteúdo do texto, agora com a lógica 100% correta.
  Widget _buildMessageContent(BuildContext context, Color textColor) {
    // Por padrão, o texto a ser exibido é a mensagem completa.
    String textToShow = message.message;
    bool needsReadMoreLink = false;

    // CONDIÇÃO CORRIGIDA: Só cortamos o texto se for para mostrar o preview
    // E o texto for realmente longo.
    if (showContinueReading && message.message.length > 120) {
      textToShow = message.message.substring(0, 120);
      needsReadMoreLink = true;
    }

    final textSpan = TextSpan(
      style: TextStyle(color: textColor, fontSize: 14, height: 1.5),
      children: [
        TextSpan(text: textToShow),
        if (needsReadMoreLink)
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

/// Widget para as tags
class Tag extends StatelessWidget {
  final String label;
  const Tag({super.key, required this.label});

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
