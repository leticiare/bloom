// main_screen.dart
import 'package:app/src/modules/calendar/calendar_page.dart';
import 'package:app/src/modules/dashboard-pregnant/articles_page.dart';
import 'package:app/src/modules/dashboard-pregnant/profile_page.dart';
import 'package:app/src/modules/dashboard-pregnant/report_page.dart';
import 'package:flutter/material.dart';
import 'package:app/src/modules/dashboard-pregnant/homepage.dart';
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
    const CalendarPage(),
    const ArticlesPage(),
    const ReportPage(),
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
        backgroundColor: AppColors.background,
        unselectedItemColor: AppColors.black,
        selectedItemColor: AppColors.boldPink,
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.apps_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article_outlined),
            label: 'Calendário',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Artigos'),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outlined),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
