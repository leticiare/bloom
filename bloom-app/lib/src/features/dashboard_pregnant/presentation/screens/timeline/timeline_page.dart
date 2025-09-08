import 'package:app/src/features/dashboard_pregnant/domain/entities/user_profile.dart';
import 'package:app/src/shared/services/profile_service.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:app/src/core/theme/app_colors.dart';
import 'package:app/src/features/dashboard_pregnant/data/datasources/mock_dashboard_data.dart';
import 'package:app/src/features/dashboard_pregnant/domain/entities/weekly_update.dart';
import 'weekly_update_detail_page.dart';

/// Tela que exibe a linha do tempo com as atualizações semanais da gravidez.
class TimelinePage extends StatefulWidget {
  const TimelinePage({super.key});

  @override
  State<TimelinePage> createState() => _TimelinePageState();
}

class _TimelinePageState extends State<TimelinePage> {
  late List<WeeklyUpdate> _displayedUpdates;
  late int _currentUserWeek;
  UserProfile? _userProfile;

  @override
  void initState() {
    super.initState();
    // O filtro não é mais chamado aqui.
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final user = await ProfileService().getUser();
    setState(() {
      _userProfile = user;
      // Agora, o filtro é chamado AQUI, APÓS o _userProfile ter um valor.
      if (_userProfile != null) {
        _filterWeeklyUpdates();
      }
    });
  }

  /// Filtra as atualizações para mostrar até a semana atual + 1.
  void _filterWeeklyUpdates() {
    _currentUserWeek = _userProfile!.currentWeek;

    _displayedUpdates = mockWeeklyUpdates
        .where((update) => update.weekNumber <= _currentUserWeek + 1)
        .toList()
        .reversed // Inverte para mostrar a mais recente primeiro
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Artigos das Semanas'),
        actions: [
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        itemCount: _displayedUpdates.length,
        itemBuilder: (context, index) {
          final update = _displayedUpdates[index];
          final bool isCurrentWeek = update.weekNumber == _currentUserWeek;
          // Nova variável para identificar a semana futura
          final bool isFutureWeek = update.weekNumber > _currentUserWeek;

          return _buildTimelineItem(
            context: context,
            update: update,
            isCurrentWeek: isCurrentWeek,
            isFutureWeek: isFutureWeek, // Passa a informação para o widget
            isFirstItem: index == 0,
            isLastItem: index == _displayedUpdates.length - 1,
          );
        },
      ),
    );
  }

  /// Constrói um item completo da linha do tempo.
  Widget _buildTimelineItem({
    required BuildContext context,
    required WeeklyUpdate update,
    required bool isCurrentWeek,
    required bool isFutureWeek, // Recebe a informação
    required bool isFirstItem,
    required bool isLastItem,
  }) {
    // Aplica opacidade se for uma semana futura
    return Opacity(
      opacity: isFutureWeek ? 0.5 : 1.0,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTimelineGraphic(
              isCurrentWeek: isCurrentWeek,
              isFutureWeek: isFutureWeek, // Passa a informação para o gráfico
              isFirstItem: isFirstItem,
              isLastItem: isLastItem,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildTimelineContent(context, update, isFutureWeek),
            ),
          ],
        ),
      ),
    );
  }

  /// Constrói a parte gráfica da timeline.
  Widget _buildTimelineGraphic({
    required bool isCurrentWeek,
    required bool isFutureWeek,
    required bool isFirstItem,
    required bool isLastItem,
  }) {
    return Column(
      children: [
        Expanded(
          child: Container(
            width: 2,
            color: isFirstItem
                ? Colors.transparent
                : AppColors.primaryPink.withOpacity(0.2),
          ),
        ),
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            // O círculo da semana futura é apenas um contorno cinza.
            color: isCurrentWeek
                ? AppColors.primaryPink
                : (isFutureWeek
                      ? AppColors.background
                      : AppColors.primaryPink.withOpacity(0.2)),
            border: isFutureWeek
                ? Border.all(
                    color: AppColors.textGray.withOpacity(0.5),
                    width: 2,
                  )
                : null,
          ),
        ),
        Expanded(
          child: Container(
            width: 2,
            color: isLastItem
                ? Colors.transparent
                : AppColors.primaryPink.withOpacity(0.2),
          ),
        ),
      ],
    );
  }

  /// Constrói o conteúdo de texto da timeline.
  Widget _buildTimelineContent(
    BuildContext context,
    WeeklyUpdate update,
    bool isFutureWeek,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Semana ${update.weekNumber}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 15,
                color: AppColors.textGray,
                height: 1.5,
                fontFamily: 'Roboto',
              ),
              children: [
                TextSpan(text: update.summary),
                const TextSpan(text: ' '),
                if (!isFutureWeek) // Mostra o link apenas se NÃO for uma semana futura
                  TextSpan(
                    text: 'Clique aqui para ler o artigo dessa semana',
                    style: const TextStyle(
                      color: AppColors.primaryPink,
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                WeeklyUpdateDetailPage(update: update),
                          ),
                        );
                      },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
