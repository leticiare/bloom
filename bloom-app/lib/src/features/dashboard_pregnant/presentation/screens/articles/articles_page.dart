// lib/src/features/dashboard_pregnant/presentation/screens/articles/articles_page.dart

import 'package:flutter/material.dart';
import 'package:app/src/core/theme/app_colors.dart';
import 'package:app/src/features/dashboard_pregnant/data/datasources/mock_dashboard_data.dart';
import 'package:app/src/features/dashboard_pregnant/domain/entities/article.dart';
import 'package:app/src/features/dashboard_pregnant/presentation/widgets/article_card.dart';
import 'article_detail_page.dart';

/// Tela que exibe uma lista de artigos para a usuária.
class ArticlesPage extends StatefulWidget {
  const ArticlesPage({super.key});

  @override
  State<ArticlesPage> createState() => _ArticlesPageState();
}

class _ArticlesPageState extends State<ArticlesPage> {
  // A lista de artigos agora é carregada da nossa fonte de dados central.
  late List<Article> _articles;

  @override
  void initState() {
    super.initState();
    // Carregamos os dados mockados aqui. Em um app real, isso poderia ser uma chamada de API.
    _articles = mockArticles;
  }

  /// Alterna o estado de "salvo" de um artigo.
  void _toggleBookmark(Article article) {
    setState(() {
      article.isBookmarked = !article.isBookmarked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Artigos'),
        actions: [
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16.0),
        itemCount: _articles.length,
        itemBuilder: (context, index) {
          final article = _articles[index];
          return ArticleCard(
            // Usando o widget extraído
            article: article,
            onBookmarkTap: () => _toggleBookmark(article),
            onCardTap: () {
              // TODO: Substituir por navegação de rota nomeada
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ArticleDetailPage(
                    article: article,
                    onBookmarkTap: () => _toggleBookmark(article),
                  ),
                ),
              );
            },
          );
        },
        separatorBuilder: (context, index) => const SizedBox(height: 16),
      ),
    );
  }
}
