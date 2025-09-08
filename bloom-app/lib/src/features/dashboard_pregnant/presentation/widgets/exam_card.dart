import 'package:flutter/material.dart';
import 'package:app/src/core/theme/app_colors.dart';
import 'package:app/src/features/dashboard_pregnant/domain/entities/medical_record.dart';

/// Card para exibir um registro médico do tipo "Exame".
class ExamCard extends StatelessWidget {
  final MedicalRecord record;
  const ExamCard({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    final bool isCompleted = record.status == RecordStatus.completed;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.lightGray.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                record.name,
                style: const TextStyle(
                  color: AppColors.textDark,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Icon(
                isCompleted
                    ? Icons.check_box_outlined
                    : Icons.check_box_outline_blank,
                color: isCompleted ? AppColors.primaryPink : AppColors.textGray,
              ),
            ],
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () {
              // TODO: Implementar lógica para anexar arquivo
            },
            icon: const Icon(
              Icons.add_circle_outline,
              size: 18,
              color: AppColors.primaryPink,
            ),
            label: const Text(
              'Anexar Resultado',
              style: TextStyle(
                color: AppColors.primaryPink,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.background,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
