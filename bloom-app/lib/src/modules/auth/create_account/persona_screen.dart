import 'package:flutter/material.dart';
import 'package:app/src/modules/auth/create_account/new_doctor_screen.dart'; // Importe a tela de destino
import 'package:app/src/modules/auth/create_account/new_pregnant_screen.dart'; // Importe a tela de destino
import 'package:app/src/core/theme/app_colors.dart';

enum Persona { pregnant, doctor, none }

class PersonaScreen extends StatefulWidget {
  const PersonaScreen({super.key});

  @override
  State<PersonaScreen> createState() => _PersonaScreenState();
}

class _PersonaScreenState extends State<PersonaScreen> {
  Persona _activePersona = Persona.none;
  final double _titleHeight = 120.0;

  void _handleSingleTap(Persona persona) {
    // Altera o tamanho da seção apenas se não for a seção já ativa
    if (_activePersona != persona) {
      setState(() {
        _activePersona = persona;
      });
    }
  }

  void _handleDoubleTap(Persona persona) {
    // Redireciona para a tela de destino com base na persona
    if (persona == Persona.pregnant) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const NewPregnantScreen()),
      );
    } else if (persona == Persona.doctor) {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (context) => const NewDoctorScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightPink,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            // Título
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
                      color: AppColors.boldPink,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),

            // LayoutBuilder para o cálculo de altura
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  double availableHeight = constraints.maxHeight;

                  double pregnantSectionHeight;
                  double doctorSectionHeight;

                  if (_activePersona == Persona.pregnant) {
                    pregnantSectionHeight = availableHeight * 0.75;
                    doctorSectionHeight = availableHeight * 0.25;
                  } else if (_activePersona == Persona.doctor) {
                    pregnantSectionHeight = availableHeight * 0.25;
                    doctorSectionHeight = availableHeight * 0.75;
                  } else {
                    pregnantSectionHeight = availableHeight * 0.5;
                    doctorSectionHeight = availableHeight * 0.5;
                  }

                  return Column(
                    children: [
                      _buildPersonaSection(
                        persona: Persona.pregnant,
                        title: 'Sou Gestante',
                        imagePath: 'assets/images/pregnant.png',
                        defaultColor: AppColors.darkerPink,
                        activeColor: AppColors.darkerPink,
                        height: pregnantSectionHeight,
                        onTap: () => _handleSingleTap(Persona.pregnant),
                        onDoubleTap: () => _handleDoubleTap(Persona.pregnant),
                      ),
                      _buildPersonaSection(
                        persona: Persona.doctor,
                        title: 'Sou Médico',
                        imagePath: 'assets/images/doctor.png',
                        defaultColor: AppColors.mediumPink,
                        activeColor: AppColors.boldPink,
                        height: doctorSectionHeight,
                        onTap: () => _handleSingleTap(Persona.doctor),
                        onDoubleTap: () => _handleDoubleTap(Persona.doctor),
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

  Widget _buildPersonaSection({
    required Persona persona,
    required String title,
    required String imagePath,
    required Color defaultColor,
    required Color activeColor,
    required double height,
    required VoidCallback onTap,
    required VoidCallback onDoubleTap,
  }) {
    final bool isActive = _activePersona == persona;
    final color = isActive ? activeColor : defaultColor;

    return GestureDetector(
      onTap: onTap,
      onDoubleTap: onDoubleTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        width: double.infinity,
        height: height,
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
