import 'package:flutter/material.dart';

// Constantes de cores
const Color _kPrimaryPink = Color(0xFFF55A8A);
const Color _kTextDark = Color(0xFF333333);
const Color _kBackground = Color(0xFFF9F9F9);

class ArticlesPage extends StatelessWidget {
  const ArticlesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBackground,
      appBar: AppBar(
        title: const Text('Artigos', style: TextStyle(color: _kTextDark)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: _kTextDark),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Cards de artigo
          _buildArticleCard(
            'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=400',
            'Yoga para grávidas',
            'Descubra os benefícios da yoga durante a gestação para você e seu bebê.',
          ),
          const SizedBox(height: 16),
          _buildArticleCard(
            'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=400',
            'Por que seus tornozelos incham?',
            'Entenda as causas do inchaço e como aliviar o desconforto.',
          ),
        ],
      ),
    );
  }

  // Widget para construir cada card de artigo
  Widget _buildArticleCard(String imageUrl, String title, String subtitle) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias, // Para cortar a imagem
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            imageUrl,
            height: 150,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _kTextDark,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        'LER MAIS',
                        style: TextStyle(color: _kPrimaryPink),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
