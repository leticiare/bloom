enum RecordType { exam, vaccine, medication }

enum RecordStatus { pending, completed, overdue }

/// Modelo de dados para um item do histórico médico.
class MedicalRecord {
  final RecordType type;
  final String name;
  final RecordStatus status;
  final String? time;
  final String? date;
  final String? frequency;

  MedicalRecord({
    required this.type,
    required this.name,
    required this.status,
    this.time,
    this.date,
    this.frequency,
  });
}
