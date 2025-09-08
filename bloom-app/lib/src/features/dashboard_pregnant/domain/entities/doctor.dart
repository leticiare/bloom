/// Modelo de dados que representa um profissional de saúde.
class Doctor {
  final String name;
  final String specialty;
  final String avatarUrl;

  const Doctor({
    required this.name,
    required this.specialty,
    required this.avatarUrl,
  });
}
