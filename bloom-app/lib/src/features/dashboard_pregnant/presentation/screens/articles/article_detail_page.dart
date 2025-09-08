// lib/src/features/dashboard_pregnant/presentation/screens/articles/article_detail_page.dart

import 'package:flutter/material.dart';
import 'package:app/src/core/theme/app_colors.dart';
import 'package:app/src/features/dashboard_pregnant/domain/entities/article.dart'; // Import atualizado

/// Tela para exibir o conteúdo completo de um único artigo.
class ArticleDetailPage extends StatelessWidget {
  final Article article;
  final VoidCallback onBookmarkTap;

  const ArticleDetailPage({
    super.key,
    required this.article,
    required this.onBookmarkTap,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(article.title, style: const TextStyle(fontSize: 18)),
        actions: [
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
                  Text(
                    article.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildAuthorInfo(),
                  const SizedBox(height: 24),
                  Text(
                    article.fullContent,
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.textGray,
                      height: 1.7,
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
              style: const TextStyle(color: AppColors.textGray, fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }
}
