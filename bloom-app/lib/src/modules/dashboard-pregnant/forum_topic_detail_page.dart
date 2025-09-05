import 'package:flutter/material.dart';
import 'package:app/src/core/theme/app_colors.dart';
import './data/models/mock_models.dart';

class ForumTopicDetailPage extends StatelessWidget {
  final ForumTopic topic;

  const ForumTopicDetailPage({super.key, required this.topic});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Tópico do Fórum',
          style: TextStyle(color: AppColors.textDark),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Bloco da Pergunta
            _buildMessageBlock(message: topic.question, isFromUser: true),
            const SizedBox(height: 24),
            // Bloco da Resposta
            _buildMessageBlock(message: topic.answer, isFromUser: false),
          ],
        ),
      ),
    );
  }

  /// Widget auxiliar SIMPLES para construir cada balão de mensagem.
  /// Ele não tem lógica de cortar texto, sempre mostra a mensagem completa.
  Widget _buildMessageBlock({
    required ForumMessage message,
    required bool isFromUser,
  }) {
    final bubbleColor = isFromUser ? AppColors.primaryPink : AppColors.white;
    final textColor = isFromUser ? AppColors.white : AppColors.textDark;
    final titleColor = isFromUser ? AppColors.white : AppColors.textDark;
    final subtitleColor = isFromUser
        ? AppColors.white.withOpacity(0.9)
        : AppColors.textLight;

    final borderRadius = isFromUser
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
      crossAxisAlignment: isFromUser
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: isFromUser
              ? MainAxisAlignment.start
              : MainAxisAlignment.end,
          children: [
            if (isFromUser)
              CircleAvatar(
                radius: 16,
                backgroundImage: NetworkImage(message.avatarUrl),
              ),
            if (isFromUser) const SizedBox(width: 8),
            Column(
              crossAxisAlignment: isFromUser
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.end,
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
            if (!isFromUser) const SizedBox(width: 8),
            if (!isFromUser)
              CircleAvatar(
                radius: 16,
                backgroundImage: NetworkImage(message.avatarUrl),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: bubbleColor,
            borderRadius: borderRadius,
          ),
          child: Text(
            message.message, // <-- Exibe o texto COMPLETO, sem cortar.
            style: TextStyle(color: textColor, fontSize: 15, height: 1.6),
          ),
        ),
      ],
    );
  }
}
