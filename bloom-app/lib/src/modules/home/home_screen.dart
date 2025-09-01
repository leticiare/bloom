import 'package:flutter/material.dart';
import 'package:app/src/modules/dashboard-pregnant/report_page.dart';

// Constantes de cores
const Color _kPrimaryPink = Color(0xFFF55A8A);
const Color _kTextDark = Color(0xFF333333);

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Lista de páginas que serão exibidas.
  // Substitua os Text widgets por suas páginas reais quando as tiver.
  static const List<Widget> _widgetOptions = <Widget>[
    Center(child: Text('Página Principal (Dashboard)')), // Ícone de grid
    ReportPage(), // Ícone de lista
    Center(child: Text('Página de Gráficos')), // Ícone de gráfico
    Center(child: Text('Página de Perfil')), // Ícone de perfil
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view_rounded),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article_outlined),
            label: 'Relatórios',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart_rounded),
            label: 'Gráficos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Perfil',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,

        // Estilização para combinar com o design
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed, // Mantém o fundo branco
        selectedItemColor: _kPrimaryPink,
        unselectedItemColor: _kTextDark,
        showSelectedLabels: false, // Esconde os rótulos
        showUnselectedLabels: false,
        elevation: 5.0, // Adiciona uma leve sombra
      ),
    );
  }
}
