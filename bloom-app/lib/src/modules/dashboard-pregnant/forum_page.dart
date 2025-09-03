import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:app/src/core/theme/app_colors.dart'; // Ajuste o import

class ForumPage extends StatelessWidget {
  const ForumPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Fórum', style: TextStyle(color: AppColors.textDark)),
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textDark),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: AppColors.textDark),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Pesquisar Tópicos',
                prefixIcon: Icon(Icons.search, color: AppColors.grey),
                filled: true,
                fillColor: AppColors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                _buildTopicCard(context),
                const SizedBox(height: 16),
                _buildTopicCard(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopicCard(BuildContext context) {
    return Card(
      elevation: 2,
      shadowColor: AppColors.grey.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: AppColors.white,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            _buildMessage(
              avatarUrl: 'https://i.pravatar.cc/150?img=1',
              sender: 'Júlia, primeira vez grávida',
              message:
                  'Oi! Estou de 16 semanas na minha primeira gravidez e tenho sentido umas cólicas leves de vez em quando. Não são fortes, mas fico preocupada. Isso é normal ou devo falar com meu médico?',
            ),
            const Divider(height: 24),
            _buildMessage(
              avatarUrl: 'https://i.pravatar.cc/150?img=3',
              sender: 'Carlos Eduardo, Obstetra',
              message:
                  'Olá! Cólicas leves podem ser normais nesta fase da gravidez, pois seu útero está crescendo e os ligamentos se esticando para acomodar o bebê. No entanto, se a dor for intensa...',
              showContinueReading: true,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildTag('Cólicas'),
                const SizedBox(width: 8),
                _buildTag('16 semanas'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessage({
    required String avatarUrl,
    required String sender,
    required String message,
    bool showContinueReading = false,
  }) {
    final textSpan = TextSpan(
      style: TextStyle(color: AppColors.grey, fontSize: 14, height: 1.5),
      children: [
        TextSpan(text: message),
        if (showContinueReading)
          TextSpan(
            text: ' continuar lendo',
            style: const TextStyle(color: AppColors.primaryPink),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                // Ação para ver o resto da mensagem
              },
          ),
      ],
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(radius: 20, backgroundImage: NetworkImage(avatarUrl)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                sender,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 4),
              RichText(text: textSpan),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTag(String label) {
    return Container(
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
