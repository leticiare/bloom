import 'package:flutter/material.dart';
import 'package:app/src/core/theme/app_colors.dart';
import 'package:app/src/features/dashboard_pregnant/domain/entities/medical_record.dart';
import 'info_tag.dart';

/// Card para exibir um registro médico do tipo "Vacina".
class VaccineCard extends StatelessWidget {
  final MedicalRecord record;
  final VoidCallback onStatusChange;
  final VoidCallback onDelete;

  const VaccineCard({
    super.key,
    required this.record,
    required this.onStatusChange,
    required this.onDelete,
  });

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
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      record.name,
                      style: const TextStyle(
                        color: AppColors.textDark,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    if (record.recommendedDate != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Recomendado: ${record.recommendedDate}',
                        style: const TextStyle(
                          color: AppColors.textGray,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'delete') onDelete();
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'delete',
                    child: Text('Excluir'),
                  ),
                ],
                icon: const Icon(Icons.more_vert, color: AppColors.textGray),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  if (record.time != null)
                    InfoTag(
                      icon: Icons.access_time_filled_outlined,
                      text: record.time!,
                    ),
                  if (record.time != null && record.date != null)
                    const SizedBox(width: 8),
                  if (record.date != null)
                    InfoTag(
                      icon: Icons.calendar_today_outlined,
                      text: record.date!,
                    ),
                ],
              ),
              InkWell(
                onTap: onStatusChange,
                borderRadius: BorderRadius.circular(20),
                child: Icon(
                  isCompleted
                      ? Icons.check_box_outlined
                      : Icons.check_box_outline_blank,
                  color: isCompleted
                      ? AppColors.primaryPink
                      : AppColors.textGray,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
