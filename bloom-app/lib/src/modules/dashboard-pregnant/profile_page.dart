import 'package:flutter/material.dart';
import 'package:app/src/core/theme/app_colors.dart'; // Ajuste o import

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          '16ª Semana',
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
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileHeader(),
            const SizedBox(height: 24),
            _buildSectionTitle('Meus Médicos Especialistas'),
            const SizedBox(height: 16),
            _buildDoctorsGrid(),
            const SizedBox(height: 24),
            _buildSectionTitle('Artigos Salvos'),
            const SizedBox(height: 16),
            _buildSavedArticles(),
            const SizedBox(height: 24),
            _buildSectionTitle('Perguntas Respondidas'),
            const SizedBox(height: 16),
            _buildQuestionAnswerCard(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Center(
      child: Column(
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=1'),
          ),
          const SizedBox(height: 12),
          const Text(
            'Júlia Oliveira',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const Text(
            'Primeira gestação',
            style: TextStyle(color: AppColors.textLight),
          ),
          const SizedBox(height: 20),
          const IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _InfoColumn(label: 'Tamanho do bebê', value: '17 cm'),
                VerticalDivider(),
                _InfoColumn(label: 'Semanas restantes', value: '30 Semanas'),
                VerticalDivider(),
                _InfoColumn(label: 'Peso do bebê', value: '110 gr'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.textDark,
      ),
    );
  }

  Widget _buildDoctorsGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5, // Exemplo
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      itemBuilder: (context, index) {
        return _buildDoctorCard();
      },
    );
  }

  Widget _buildDoctorCard() {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 25,
            backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=3'),
          ),
          const SizedBox(height: 8),
          const Text(
            'José Ricardo',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            textAlign: TextAlign.center,
          ),
          const Text(
            'Obstetra',
            style: TextStyle(color: AppColors.primaryPink, fontSize: 10),
          ),
        ],
      ),
    );
  }

  Widget _buildSavedArticles() {
    return SizedBox(
      height: 180,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 2,
        separatorBuilder: (context, index) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          return SizedBox(
            width: 150,
            child: Card(
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Image.network(
                'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=400',
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuestionAnswerCard() {
    return Card(
      color: AppColors.lightPinkBackground,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: const Padding(
        padding: EdgeInsets.all(12.0),
        child: Text(
          'Oi! Cólicas leves podem ser normais nesta fase da gravidez, pois seu útero está crescendo... Mantenha o descanso, tente beber bastante água e evite ficar...',
          style: TextStyle(color: AppColors.textDark, height: 1.5),
        ),
      ),
    );
  }
}

// Widget auxiliar para as colunas de informação (reutilizado e adaptado)
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
