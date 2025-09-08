import 'package:flutter/material.dart';
import 'package:app/src/core/theme/app_colors.dart';
import 'package:app/src/core/utils/constants.dart';

/// Um seletor de perfil (Gestante/Profissional) em formato de switch.
class RoleSelectorSwitch extends StatelessWidget {
  final Persona currentRole;
  final VoidCallback onSwitchedToDoctor;
  final VoidCallback onSwitchedToPregnant;

  const RoleSelectorSwitch({
    super.key,
    required this.currentRole,
    required this.onSwitchedToDoctor,
    required this.onSwitchedToPregnant,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Gestante',
          style: TextStyle(
            color: currentRole == Persona.pregnant
                ? AppColors.primaryPink
                : AppColors.textGray,
            fontWeight: FontWeight.bold,
          ),
        ),
        Switch(
          value: currentRole == Persona.doctor,
          onChanged: (value) {
            if (value) {
              onSwitchedToDoctor();
            } else {
              onSwitchedToPregnant();
            }
          },
          activeColor: AppColors.primaryPink,
          inactiveThumbColor: AppColors.primaryPink,
          inactiveTrackColor: AppColors.primaryPink.withOpacity(0.3),
        ),
        Text(
          'Profissional',
          style: TextStyle(
            color: currentRole == Persona.doctor
                ? AppColors.primaryPink
                : AppColors.textGray,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
