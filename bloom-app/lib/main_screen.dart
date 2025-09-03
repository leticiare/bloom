import 'package:flutter/material.dart';
import 'package:app/src/modules/dashboard-pregnant/homepage.dart';
import 'package:app/src/modules/dashboard-pregnant/forum_page.dart';
import 'package:app/src/modules/dashboard-pregnant/timeline_page.dart';
import 'package:app/src/modules/dashboard-pregnant/profile_page.dart';
import 'package:app/src/core/theme/app_colors.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomePage(),
    const ForumPage(),
    const TimelinePage(),
    const ProfilePage(),
  ];

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
        backgroundColor: AppColors.white,
        unselectedItemColor: AppColors.textDark.withOpacity(0.6),
        selectedItemColor: AppColors.primaryPink,
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        // <<< ALTERAÇÃO: Os ícones e a ordem foram atualizados.
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.apps_outlined),
            activeIcon: Icon(Icons.apps),
            label: 'Home',
          ),
          // Ícone para o Fórum
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            activeIcon: Icon(Icons.chat_bubble),
            label: 'Fórum',
          ),
          // Ícone para a Timeline/Semanas
          BottomNavigationBarItem(
            icon: Icon(Icons.timeline_outlined),
            activeIcon: Icon(Icons.timeline),
            label: 'Semanas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outlined),
            activeIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
