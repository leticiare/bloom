import 'package:flutter/material.dart';
import 'package:app/src/core/theme/app_colors.dart';

// Enum para rastrear qual seção está ativa (expandida)
enum Persona { pregnant, doctor, none }

// Tela de formulário (apenas um placeholder)
class FormScreen extends StatelessWidget {
  final String persona;
  const FormScreen({super.key, required this.persona});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Formulário de Cadastro')),
      body: Center(
        child: Text(
          'Formulário para: $persona',
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

class PersonaScreen extends StatefulWidget {
  const PersonaScreen({super.key});

  @override
  State<PersonaScreen> createState() => _PersonaScreenState();
}

class _PersonaScreenState extends State<PersonaScreen> {
  Persona _activePersona = Persona.none;
  final double _titleHeight = 120.0; // Altura aproximada do título e padding

  void _handleTap(Persona persona) {
    if (_activePersona == persona) {
      String personaName = (persona == Persona.pregnant)
          ? 'Gestante'
          : 'Médico';
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => FormScreen(persona: personaName),
        ),
      );
    } else {
      setState(() {
        _activePersona = persona;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          AppColors.lightPink, // Cor de fundo para um bom contraste
      body: SafeArea(
        child: Column(
          children: <Widget>[
            // Título no topo da tela com a cor do texto alterada
            SizedBox(
              height: _titleHeight,
              child: const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Queremos te conhecer melhor',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.boldPink, // Cor do texto alterada aqui
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),

            // LayoutBuilder para calcular o espaço disponível para as seções
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  double availableHeight = constraints.maxHeight;

                  double pregnantSectionHeight;
                  double doctorSectionHeight;

                  // Lógica para determinar a altura de cada seção
                  if (_activePersona == Persona.pregnant) {
                    pregnantSectionHeight = availableHeight * 0.75;
                    doctorSectionHeight = availableHeight * 0.25;
                  } else if (_activePersona == Persona.doctor) {
                    pregnantSectionHeight = availableHeight * 0.25;
                    doctorSectionHeight = availableHeight * 0.75;
                  } else {
                    // Estado inicial: 50/50
                    pregnantSectionHeight = availableHeight * 0.5;
                    doctorSectionHeight = availableHeight * 0.5;
                  }

                  return Column(
                    children: [
                      // Seção da Gestante
                      _buildPersonaSection(
                        persona: Persona.pregnant,
                        title: 'Sou Gestante',
                        imagePath: 'assets/images/pregnant.png',
                        defaultColor: AppColors.mediumPink,
                        activeColor: AppColors.boldPink,
                        height: pregnantSectionHeight,
                      ),
                      // Seção do Médico
                      _buildPersonaSection(
                        persona: Persona.doctor,
                        title: 'Sou Médico',
                        imagePath: 'assets/images/doctor.png',
                        defaultColor: AppColors.darkerPink,
                        activeColor: AppColors.depperPink,
                        height: doctorSectionHeight,
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget auxiliar para construir cada seção com altura animada
  Widget _buildPersonaSection({
    required Persona persona,
    required String title,
    required String imagePath,
    required Color defaultColor,
    required Color activeColor,
    required double height,
  }) {
    final bool isActive = _activePersona == persona;
    final color = isActive ? activeColor : defaultColor;

    return GestureDetector(
      onTap: () => _handleTap(persona),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        width: double.infinity,
        height: height, // Altura é animada aqui!
        color: color,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              width: 150,
              height: 150,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: isActive ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
