import 'package:flutter/material.dart';
import 'package:app/src/core/theme/app_colors.dart';

// Importa os modelos e os dados mockados
import './data/models/mock_models.dart';

// Importa as páginas de destino para navegação
import 'article_detail_page.dart';
import 'forum_topic_detail_page.dart';
import 'doctor_profile_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  void _toggleBookmark(Article article) {
    setState(() {
      final originalArticle = mockArticles.firstWhere(
        (a) => a.title == article.title,
      );
      originalArticle.isBookmarked = !originalArticle.isBookmarked;
    });
  }

  @override
  Widget build(BuildContext context) {
    final savedArticles = mockArticles.where((a) => a.isBookmarked).toList();
    final myQuestion = mockTopics.isNotEmpty ? mockTopics.first : null;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Meu Perfil',
          style: TextStyle(color: AppColors.textDark),
        ),
        centerTitle: true,
        backgroundColor: AppColors.background,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: AppColors.textDark),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            _buildProfileHeader(mockUserProfile),
            const SizedBox(height: 32),
            _buildSectionTitle('Meus Médicos Especialistas'),
            const SizedBox(height: 16),
            _buildDoctorsGrid(mockDoctors),
            const SizedBox(height: 32),
            _buildSectionTitle('Artigos Salvos'),
            const SizedBox(height: 16),
            _buildSavedArticles(savedArticles),
            const SizedBox(height: 32),
            _buildSectionTitle('Perguntas Respondidas'),
            const SizedBox(height: 16),
            if (myQuestion != null) _buildQuestionAnswerCard(myQuestion),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(UserProfile profile) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Card(
        elevation: 2,
        shadowColor: AppColors.grey.withOpacity(0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(profile.avatarUrl),
              ),
              const SizedBox(height: 12),
              Text(
                profile.name,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              Text(
                profile.pregnancyInfo,
                style: const TextStyle(color: AppColors.textLight),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _InfoColumn(
                    label: 'Tamanho do bebê',
                    value: profile.babySize,
                  ),
                  _InfoColumn(
                    label: 'Semanas restantes',
                    value: '${profile.weeksLeft} Semanas',
                  ),
                  _InfoColumn(label: 'Peso do bebê', value: profile.babyWeight),
                  _InfoColumn(
                    label: 'Dias restantes',
                    value: '${profile.daysLeft} dias',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.textDark,
        ),
      ),
    );
  }

  Widget _buildDoctorsGrid(List<Doctor> doctors) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: doctors.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.8,
        ),
        itemBuilder: (context, index) {
          final doctor = doctors[index];
          return InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DoctorProfilePage(doctor: doctor),
              ),
            ),
            borderRadius: BorderRadius.circular(12),
            child: Card(
              elevation: 2,
              shadowColor: AppColors.grey.withOpacity(0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(doctor.avatarUrl),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    doctor.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    doctor.specialty,
                    style: const TextStyle(
                      color: AppColors.primaryPink,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSavedArticles(List<Article> articles) {
    if (articles.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Text(
          'Você ainda não salvou nenhum artigo.',
          style: TextStyle(color: AppColors.textLight),
        ),
      );
    }
    return SizedBox(
      height: 220,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: articles.length,
        separatorBuilder: (context, index) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final article = articles[index];
          return SizedBox(
            width: 160,
            child: InkWell(
              onTap: () {
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
              borderRadius: BorderRadius.circular(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Image.network(
                      article.imageUrl,
                      height: 150,
                      width: 160,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    article.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuestionAnswerCard(ForumTopic topic) {
    String previewMessage = topic.answer.message;
    if (previewMessage.length > 100) {
      previewMessage = '${previewMessage.substring(0, 100)}...';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ForumTopicDetailPage(topic: topic),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Card(
          color: AppColors.lightPinkBackground.withOpacity(0.5),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sua pergunta sobre "${topic.tags.first}"',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  previewMessage,
                  style: const TextStyle(
                    color: AppColors.textLight,
                    height: 1.5,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoColumn extends StatelessWidget {
  final String label;
  final String value;
  const _InfoColumn({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(color: AppColors.textLight, fontSize: 12),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.textDark,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
