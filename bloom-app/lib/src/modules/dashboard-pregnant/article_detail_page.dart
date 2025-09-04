import 'package:flutter/material.dart';
import 'articles_page.dart'; // Importa o modelo 'Article'
import 'package:app/src/core/theme/app_colors.dart';

/// Tela para exibir o conteúdo completo de um único artigo.
class ArticleDetailPage extends StatelessWidget {
  final Article article;
  final VoidCallback onBookmarkTap; // Função para sincronizar o 'salvar'

  const ArticleDetailPage({
    super.key,
    required this.article,
    required this.onBookmarkTap,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          article.title,
          style: const TextStyle(color: AppColors.textDark, fontSize: 18),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        actions: [
          // Botão de salvar sincronizado
          IconButton(
            icon: Icon(
              article.isBookmarked ? Icons.bookmark : Icons.bookmark_border,
              color: AppColors.primaryPink,
            ),
            onPressed: onBookmarkTap,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagem principal
            Image.network(
              article.imageUrl,
              height: 220,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título
                  Text(
                    article.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Informações do autor
                  _buildAuthorInfo(),

                  const SizedBox(height: 24),

                  // Conteúdo completo do artigo
                  Text(
                    article
                        .fullContent, // Usando o novo campo de texto completo
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.textLight,
                      height:
                          1.7, // Espaçamento entre linhas para melhor leitura
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Constrói a seção com a foto e nome do autor.
  Widget _buildAuthorInfo() {
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundImage: NetworkImage(article.authorAvatarUrl),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              article.authorName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
                fontSize: 14,
              ),
            ),
            Text(
              article.authorTitle,
              style: const TextStyle(color: AppColors.textLight, fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }
}
