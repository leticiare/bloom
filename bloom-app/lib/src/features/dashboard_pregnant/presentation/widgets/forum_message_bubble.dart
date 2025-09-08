import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:app/src/core/theme/app_colors.dart';
import 'package:app/src/features/dashboard_pregnant/domain/entities/forum_message.dart';
import 'package:app/src/features/dashboard_pregnant/domain/entities/forum_topic.dart';
import 'package:app/src/features/dashboard_pregnant/presentation/screens/forum/forum_topic_detail_page.dart';

/// Widget reutilizável para um balão de mensagem do fórum.
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
    // Lógica de estilo baseada em quem enviou a mensagem
    final bool isUserMessage = message.isFromUser;
    final alignment = isUserMessage
        ? CrossAxisAlignment.start
        : CrossAxisAlignment.end;

    final bubbleColor = isUserMessage
        ? AppColors.primaryPink
        : AppColors.background;

    final textColor = isUserMessage ? AppColors.white : AppColors.textDark;
    final authorNameColor = isUserMessage
        ? AppColors.textGray
        : AppColors.textDark;
    final authorTitleColor = isUserMessage
        ? AppColors.textGray.withOpacity(0.8)
        : AppColors.textGray;

    final borderRadius = isUserMessage
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
          mainAxisAlignment: isUserMessage
              ? MainAxisAlignment.start
              : MainAxisAlignment.end,
          children: [
            if (isUserMessage)
              CircleAvatar(
                radius: 16,
                backgroundImage: NetworkImage(message.avatarUrl),
              ),
            if (isUserMessage) const SizedBox(width: 8),
            Column(
              crossAxisAlignment: alignment,
              children: [
                Text(
                  message.authorName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: authorNameColor,
                  ),
                ),
                Text(
                  message.authorTitle,
                  style: TextStyle(fontSize: 12, color: authorTitleColor),
                ),
              ],
            ),
            if (!isUserMessage) const SizedBox(width: 8),
            if (!isUserMessage)
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

  /// Constrói o conteúdo do texto, com a lógica de "continuar lendo".
  Widget _buildMessageContent(BuildContext context, Color textColor) {
    String textToShow = message.message;
    bool needsReadMoreLink = false;

    // A lógica de cortar o texto e mostrar o link "continuar lendo"
    if (showContinueReading && message.message.length > 120) {
      textToShow = '${message.message.substring(0, 120)}';
      needsReadMoreLink = true;
    }

    return RichText(
      text: TextSpan(
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
      ),
    );
  }
}

/// Widget para as tags coloridas.
class Tag extends StatelessWidget {
  final String label;
  const Tag({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.lightGray,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(color: AppColors.primaryPink, fontSize: 12),
      ),
    );
  }
}
