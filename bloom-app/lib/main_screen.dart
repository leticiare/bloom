// main_screen.dart
import 'package:flutter/material.dart';
import 'package:app/src/modules/dashboard-pregnant/homepage.dart'; // Adapte o caminho
import 'package:app/src/modules/dashboard-pregnant/calendar_page.dart'; // Adapte o caminho
import 'package:app/src/modules/dashboard-pregnant/profilepage.dart'; // Adapte o caminho

// Certifique-se de que o seu arquivo de cores está disponível
import 'package:app/src/core/theme/app_colors.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // Lista de telas que serão mostradas na BottomNavigationBar
  final List<Widget> _screens = [HomePage(), CalendarPage(), ReportPage()];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.background, // Cor de fundo da barra
        unselectedItemColor:
            AppColors.lightPink, // Cor dos ícones/texto inativos
        selectedItemColor: AppColors.darkerPink, // Cor dos ícones/texto ativos
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.apps_outlined),
            label: 'Home', // Adicione um label para o texto
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article_outlined),
            label: 'Artigos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart_outlined),
            label: 'Histórico',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outlined),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
