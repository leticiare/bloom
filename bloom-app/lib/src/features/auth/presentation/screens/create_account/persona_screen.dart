import 'package:flutter/material.dart';
import 'package:app/src/core/theme/app_colors.dart';
import 'package:app/src/core/utils/constants.dart';
import 'package:app/src/features/auth/presentation/screens/create_account/new_doctor_screen.dart';
import 'package:app/src/features/auth/presentation/screens/create_account/new_pregnant_screen.dart';

/// Tela inicial do fluxo de cadastro, onde o usuário seleciona seu perfil.
class PersonaScreen extends StatefulWidget {
  const PersonaScreen({super.key});

  @override
  State<PersonaScreen> createState() => _PersonaScreenState();
}

class _PersonaScreenState extends State<PersonaScreen> {
  Persona _selectedPersona = Persona.none;

  /// Navega para a tela de cadastro correspondente ao perfil selecionado.
  void _navigateToNextScreen() {
    // TODO: Substituir por navegação de rota nomeada.
    if (_selectedPersona == Persona.pregnant) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const NewPregnantScreen()),
      );
    } else if (_selectedPersona == Persona.doctor) {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (context) => const NewDoctorScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isPersonaSelected = _selectedPersona != Persona.none;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Text(
                'Queremos te conhecer melhor',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'Selecione o perfil que mais se encaixa com você.',
                style: TextStyle(fontSize: 16, color: AppColors.textGray),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              _buildPersonaCard(
                persona: Persona.pregnant,
                title: 'Sou Gestante',
                imagePath: 'assets/images/pregnant.png',
              ),
              const SizedBox(height: 20),
              _buildPersonaCard(
                persona: Persona.doctor,
                title: 'Sou Médico(a)',
                imagePath: 'assets/images/doctor.png',
              ),

              const Spacer(),

              ElevatedButton(
                onPressed: isPersonaSelected ? _navigateToNextScreen : null,
                child: const Text('Continuar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPersonaCard({
    required Persona persona,
    required String title,
    required String imagePath,
  }) {
    final bool isSelected = _selectedPersona == persona;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPersona = persona;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryPink.withOpacity(0.1)
              : AppColors.lightGray,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primaryPink : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Image.asset(imagePath, width: 80, height: 80, fit: BoxFit.contain),
            const SizedBox(width: 20),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isSelected ? AppColors.primaryPink : AppColors.textDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
