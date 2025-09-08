enum RecordType { exam, vaccine, medication }

enum RecordStatus { pending, completed, overdue }

/// Modelo de dados para um item do histórico médico.
class MedicalRecord {
  final String id;
  final RecordType type;
  final String name;
  RecordStatus status;
  final String? time;
  final String? date;
  final String? frequency;
  final String? recommendedDate;

  MedicalRecord({
    required this.id,
    required this.type,
    required this.name,
    required this.status,
    this.time,
    this.date,
    this.frequency,
    this.recommendedDate,
  });
}
