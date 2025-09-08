// lib/src/features/dashboard_pregnant/presentation/widgets/vaccine_card.dart

import 'package:flutter/material.dart';
import 'package:app/src/core/theme/app_colors.dart';
import 'package:app/src/features/dashboard_pregnant/domain/entities/medical_record.dart';

/// Card para exibir um registro médico do tipo "Vacina".
class VaccineCard extends StatelessWidget {
  final MedicalRecord record;
  final void Function(RecordStatus) onStatusChange;
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
                      record.title,
                      style: const TextStyle(
                        color: AppColors.textDark,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    if (record.date != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Agendado para: ${record.date}',
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
                  if (value == 'delete') {
                    onDelete();
                  }
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
          ElevatedButton.icon(
            onPressed: () {
              final newStatus = isCompleted
                  ? RecordStatus.scheduled
                  : RecordStatus.completed;
              onStatusChange(newStatus);
            },
            icon: Icon(
              isCompleted ? Icons.undo : Icons.check,
              size: 18,
              color: isCompleted ? AppColors.textGray : AppColors.primaryPink,
            ),
            label: Text(
              isCompleted ? 'Marcar como pendente' : 'Marcar como aplicado',
              style: TextStyle(
                color: isCompleted ? AppColors.textGray : AppColors.primaryPink,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.background,
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }
}
