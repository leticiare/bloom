enum RecordType { exam, vaccine, medication, consultation }

enum RecordStatus { scheduled, completed, canceled }

class MedicalRecord {
  final String id;
  final RecordType type;
  final String title;
  final String description;
  RecordStatus status;
  final String? date;

  MedicalRecord({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.status,
    required this.date,
  });
}
