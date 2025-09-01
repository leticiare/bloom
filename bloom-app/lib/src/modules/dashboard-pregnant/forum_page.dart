import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

// Constantes de cores
const Color _kPrimaryPink = Color(0xFFF55A8A);
const Color _kTextDark = Color(0xFF333333);
const Color _kBackground = Color(0xFFF9F9F9);
const Color _kLightPinkBackground = Color(0xFFFFF0F5);

class ForumPage extends StatelessWidget {
  const ForumPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBackground,
      appBar: AppBar(
        // CORREÇÃO: Botão de menu (leading) foi removido.
        automaticallyImplyLeading: false,
        title: const Text('Fórum', style: TextStyle(color: _kTextDark)),
        backgroundColor: _kBackground,
        elevation: 0,
        iconTheme: const IconThemeData(color: _kTextDark),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: _kTextDark),
            onPressed: () {
              // Ação para criar novo tópico
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Barra de pesquisa
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Pesquisar Tópicos',
                prefixIcon: Icon(Icons.search, color: Colors.grey.shade500),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),
          // Lista de tópicos
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                _buildTopicCard(context),
                const SizedBox(height: 16),
                _buildTopicCard(context), // Tópico duplicado para exemplo
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget para construir o card de um tópico inteiro
  Widget _buildTopicCard(BuildContext context) {
    return Card(
      elevation: 2,
      shadowColor: Colors.grey.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // Mensagem principal (a pergunta)
            _buildMessage(
              avatarUrl: 'https://i.pravatar.cc/150?img=1',
              sender: 'Júlia, primeira vez grávida',
              message:
                  'Oi! Estou de 16 semanas na minha primeira gravidez e tenho sentido umas cólicas leves de vez em quando. Não são fortes, mas fico preocupada. Isso é normal ou devo falar com meu médico?',
            ),
            const Divider(height: 24),
            // Resposta do especialista
            _buildMessage(
              avatarUrl: 'https://i.pravatar.cc/150?img=3',
              sender: 'Carlos Eduardo, Obstetra',
              message:
                  'Olá! Cólicas leves podem ser normais nesta fase da gravidez, pois seu útero está crescendo e os ligamentos se esticando para acomodar o bebê. No entanto, se a dor for intensa...',
              showContinueReading: true,
            ),
            const SizedBox(height: 12),
            // Tags do tópico
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

  // Widget para construir cada balão de mensagem dentro do card
  Widget _buildMessage({
    required String avatarUrl,
    required String sender,
    required String message,
    bool showContinueReading = false,
  }) {
    final textSpan = TextSpan(
      style: TextStyle(color: Colors.grey.shade700, fontSize: 14, height: 1.5),
      children: [
        TextSpan(text: message),
        if (showContinueReading)
          TextSpan(
            text: ' continuar lendo',
            style: const TextStyle(color: _kPrimaryPink),
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
                  color: _kTextDark,
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

  // Widget para construir as tags
  Widget _buildTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _kLightPinkBackground,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(color: _kPrimaryPink, fontSize: 12),
      ),
    );
  }
}
