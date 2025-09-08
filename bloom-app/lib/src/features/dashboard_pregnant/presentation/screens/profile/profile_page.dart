import 'package:flutter/material.dart';
import 'package:app/src/core/theme/app_colors.dart';
import 'package:app/src/features/dashboard_pregnant/domain/entities/user_profile.dart';
import 'package:app/src/features/dashboard_pregnant/domain/entities/doctor.dart';
import 'package:app/src/features/dashboard_pregnant/domain/entities/article.dart';
import 'package:app/src/features/dashboard_pregnant/domain/entities/forum_topic.dart';
import 'package:app/src/features/dashboard_pregnant/data/datasources/mock_dashboard_data.dart';
import 'package:app/src/shared/widgets/info_column.dart';
import '../articles/article_detail_page.dart';
import '../forum/forum_topic_detail_page.dart';
import '../doctor_profile/doctor_profile_page.dart';

/// Tela de perfil do usuário, exibindo um resumo de suas informações e atividades.
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Dados gerenciados localmente pela tela
  late UserProfile _userProfile;
  late List<Doctor> _doctors;
  late List<Article> _allArticles;
  late List<ForumTopic> _myTopics;

  @override
  void initState() {
    super.initState();
    // Carrega os dados da fonte central quando a tela é iniciada.
    _userProfile = mockUserProfile;
    _doctors = mockDoctors;
    _allArticles = mockArticles;
    _myTopics = mockTopics;
  }

  /// Alterna o estado de "salvo" de um artigo localmente.
  void _toggleBookmark(Article article) {
    setState(() {
      final articleInList = _allArticles.firstWhere(
        (a) => a.title == article.title,
      );
      articleInList.isBookmarked = !articleInList.isBookmarked;
    });
  }

  @override
  Widget build(BuildContext context) {
    final savedArticles = _allArticles.where((a) => a.isBookmarked).toList();
    final myQuestion = _myTopics.isNotEmpty ? _myTopics.first : null;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Meu Perfil'),
        actions: [
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            _buildProfileHeader(_userProfile),
            const SizedBox(height: 32),
            _buildSectionTitle('Meus Médicos Especialistas'),
            const SizedBox(height: 16),
            _buildDoctorsGrid(_doctors),
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
        shadowColor: AppColors.textGray.withOpacity(0.1),
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
                style: const TextStyle(color: AppColors.textGray),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InfoColumn(label: 'Tamanho do bebê', value: profile.babySize),
                  InfoColumn(
                    label: 'Semanas restantes',
                    value: '${profile.weeksLeft} Semanas',
                  ),
                  InfoColumn(label: 'Peso do bebê', value: profile.babyWeight),
                  InfoColumn(
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
              shadowColor: AppColors.textGray.withOpacity(0.1),
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
          style: TextStyle(color: AppColors.textGray),
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
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ArticleDetailPage(
                    article: article,
                    onBookmarkTap: () => _toggleBookmark(article),
                  ),
                ),
              ),
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
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ForumTopicDetailPage(topic: topic)),
        ),
        borderRadius: BorderRadius.circular(12),
        child: Card(
          color: AppColors.lightGray.withOpacity(0.5),
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
                    color: AppColors.textGray,
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
