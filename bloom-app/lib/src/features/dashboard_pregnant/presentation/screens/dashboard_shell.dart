import 'package:flutter/material.dart';
import 'package:app/src/features/dashboard_pregnant/presentation/screens/home/homepage.dart';
import 'package:app/src/features/dashboard_pregnant/presentation/screens/forum/forum_page.dart';
import 'package:app/src/features/dashboard_pregnant/presentation/screens/timeline/timeline_page.dart';
import 'package:app/src/features/dashboard_pregnant/presentation/screens/profile/profile_page.dart';

/// A "casca" principal do dashboard que gerencia a navegação
/// através da BottomNavigationBar.
class DashboardShell extends StatefulWidget {
  const DashboardShell({super.key});

  @override
  State<DashboardShell> createState() => _DashboardShellState();
}

class _DashboardShellState extends State<DashboardShell> {
  /// A variável `_currentIndex` controla qual tela está visível.
  /// Ela é a chave para a funcionalidade dos botões.
  int _currentIndex = 0;

  // Lista de telas principais do dashboard.
  final List<Widget> _screens = [
    const HomePage(),
    const ForumPage(),
    const TimelinePage(), // Verifique se esta tela existe
    const ProfilePage(), // Verifique se esta tela existe
  ];

  /// Esta função é chamada quando um botão é tocado.
  /// `setState` notifica o Flutter para redesenhar a tela com o novo `_currentIndex`.
  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // O corpo da tela muda de acordo com o item selecionado na barra.
      body: _screens[_currentIndex],

      // A barra de navegação agora busca seu estilo do AppTheme.
      // As propriedades `currentIndex` e `onTap` garantem a funcionalidade.
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.apps_outlined),
            activeIcon: Icon(Icons.apps),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            activeIcon: Icon(Icons.chat_bubble),
            label: 'Fórum',
          ),
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
