import 'package:flutter/material.dart';
import 'package:app/src/core/theme/app_colors.dart';
import 'article_detail_page.dart'; // Importa a nova página de detalhes

// --- Modelo de Dados para um Artigo ---
// MUDANÇA 1: Adicionamos o campo 'fullContent'
class Article {
  final String title;
  final String summary;
  final String imageUrl;
  final String authorName;
  final String authorTitle;
  final String authorAvatarUrl;
  final String fullContent; // Novo campo para o texto completo
  bool isBookmarked;

  Article({
    required this.title,
    required this.summary,
    required this.imageUrl,
    required this.authorName,
    required this.authorTitle,
    required this.authorAvatarUrl,
    required this.fullContent,
    this.isBookmarked = false,
  });
}

class ArticlesPage extends StatefulWidget {
  const ArticlesPage({super.key});

  @override
  State<ArticlesPage> createState() => _ArticlesPageState();
}

class _ArticlesPageState extends State<ArticlesPage> {
  // MUDANÇA 2: Dados mockados atualizados com imagens válidas e texto completo
  late List<Article> _articles;

  @override
  void initState() {
    super.initState();
    _articles = [
      Article(
        title: 'Yoga para gravidez',
        summary:
            'Yoga durante a gravidez ajuda a aliviar os sintomas comuns como enjoo matinal, cãimbras, tornozelos inchados e constipação.',
        imageUrl:
            'https://images.pexels.com/photos/3094230/pexels-photo-3094230.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2', // IMAGEM CORRIGIDA
        authorName: 'Natália Maria',
        authorTitle: 'Fisioterapeuta',
        authorAvatarUrl: 'https://i.pravatar.cc/150?img=25',
        fullContent:
            'A prática de yoga pré-natal é uma abordagem multifacetada para o exercício que incentiva o alongamento, a concentração mental e a respiração focada. Pesquisas sugerem que a yoga pré-natal é segura e pode ter muitos benefícios para as gestantes e seus bebês. A yoga pode melhorar o sono, reduzir o estresse e a ansiedade, além de aumentar a força, a flexibilidade e a resistência dos músculos necessários para o parto.',
      ),
      Article(
        title: 'Por que seus tornozelos incham?',
        summary:
            'Seus tornozelos começaram a inchar durante a gravidez? Isso é muito comum, mas pode causar desconforto. Descubra como aliviar os sintomas.',
        imageUrl:
            'https://images.pexels.com/photos/1769355/pexels-photo-1769355.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2', // IMAGEM CORRIGIDA
        authorName: 'Carlos Eduardo',
        authorTitle: 'Médico CRM-SE 876234',
        authorAvatarUrl: 'https://i.pravatar.cc/150?img=3',
        isBookmarked: true,
        fullContent:
            'O inchaço, também conhecido como edema, ocorre quando o corpo retém mais líquido do que o normal. Durante a gravidez, o corpo produz aproximadamente 50% mais sangue e fluidos corporais para atender às necessidades do bebê em desenvolvimento. Para aliviar, evite ficar em pé por longos períodos, eleve os pés sempre que possível, durma do lado esquerdo e beba bastante água para ajudar o corpo a eliminar o excesso de sódio e fluidos.',
      ),
    ];
  }

  void _toggleBookmark(Article article) {
    setState(() {
      article.isBookmarked = !article.isBookmarked;
    });
  }

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
          'Artigos',
          style: TextStyle(color: AppColors.textDark),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: AppColors.textDark),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16.0),
        itemCount: _articles.length,
        itemBuilder: (context, index) {
          final article = _articles[index];
          return _ArticleCard(
            article: article,
            // Passa a função de toggle para o card
            onBookmarkTap: () => _toggleBookmark(article),
            // MUDANÇA 3: Adiciona a função de navegação ao clicar no card
            onCardTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ArticleDetailPage(
                    article: article,
                    // Passa a função para a tela de detalhes para sincronizar o 'salvar'
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

/// O componente do Card agora recebe um 'onCardTap' para a navegação.
class _ArticleCard extends StatelessWidget {
  final Article article;
  final VoidCallback onBookmarkTap;
  final VoidCallback onCardTap;

  const _ArticleCard({
    required this.article,
    required this.onBookmarkTap,
    required this.onCardTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onCardTap, // Ação de clique no card inteiro
      borderRadius: BorderRadius.circular(12),
      child: Card(
        elevation: 2,
        shadowColor: AppColors.grey.withOpacity(0.2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              article.imageUrl,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    article.summary,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textLight,
                      height: 1.5,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 8, 8),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundImage: NetworkImage(article.authorAvatarUrl),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          article.authorName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          article.authorTitle,
                          style: const TextStyle(
                            color: AppColors.textLight,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      article.isBookmarked
                          ? Icons.bookmark
                          : Icons.bookmark_border,
                      color: AppColors.primaryPink,
                    ),
                    onPressed: onBookmarkTap,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
