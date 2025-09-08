import 'package:flutter/material.dart';
import 'package:app/src/core/theme/app_colors.dart';
import 'package:app/src/features/dashboard_pregnant/domain/entities/medical_record.dart';
import 'info_tag.dart'; // Importa o widget de tag

/// Card para exibir um registro médico do tipo "Medicação".
class MedicationCard extends StatelessWidget {
  final MedicalRecord record;
  const MedicationCard({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    final bool isOverdue = record.status == RecordStatus.overdue;

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
                isOverdue ? Icons.warning_amber_outlined : Icons.delete_outline,
                color: isOverdue ? AppColors.warning : AppColors.textGray,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              if (record.time != null)
                InfoTag(
                  icon: Icons.access_time_filled_outlined,
                  text: record.time!,
                ),
              if (record.time != null && record.frequency != null)
                const SizedBox(width: 8),
              if (record.frequency != null)
                InfoTag(icon: Icons.refresh_outlined, text: record.frequency!),
            ],
          ),
        ],
      ),
    );
  }
}
